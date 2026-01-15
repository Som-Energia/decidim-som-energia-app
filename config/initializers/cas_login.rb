# frozen_string_literal: true

if ENV["CAS_HOST"].present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    # {"user"=>"1234ZX", "username"=>"1234X", "first_name"=>"Name", "last_name"=>"Last names", "email"=>"em@il", "soci"=>"1234", "locale"=>"ca"}
    provider :cas, setup: proc { |env|
                            request = Rack::Request.new(env)
                            organization = Decidim::Organization.find_by(host: request.host)
                            env["omniauth.strategy"].options["host"] = ENV.fetch("CAS_HOST", nil)
                            env["omniauth.strategy"].options["organization"] = organization
                            ENV["CAS_LOGOUT_URL"] = "https://#{ENV.fetch("CAS_HOST", nil)}/logout" if ENV["CAS_LOGOUT_URL"].blank?
                          },
                   nickname_key: "nickname",
                   fetch_raw_info: proc { |_strategy, opts, _ticket, user_info, rawxml|
                                     return {} if user_info.empty? || rawxml.nil? # Auth failed

                                     name = %(#{user_info["first_name"]} #{user_info["last_name"]})
                                     user_info.merge!(
                                       {
                                         "name" => name,
                                         "nickname" => Decidim::UserBaseEntity.nicknamize(name,
                                                                                          organization: opts["organization"]),
                                         "extended_data" => { "soci" => user_info["soci"],
                                                              "username" => user_info["username"],
                                                              "locale" => user_info["locale"] }
                                       }
                                     )
                                     user_info
                                   }
  end
  # Force Decidim to look at this provider if not defined in secrets.yml
  # Rails.application.secrets[:omniauth][:cas] = {
  #   enabled: true,
  #   icon_path: "media/images/#{ENV.fetch("ICON", "somenergia-icon-sea.png")}",
  #   host: ENV.fetch("CAS_HOST", nil)
  # }
  # Generic verification method for users logged with CAS
  Decidim::Verifications.register_workflow(:cas_member) do |workflow|
    workflow.form = "SomEnergia::CasMember"
    workflow.action_authorizer = "SomEnergia::CasMemberActionAuthorizer"
    workflow.options do |options|
      options.attribute :member_type, type: :select, choices: %w(any member user), default: "any", required: false
    end
  end
end

# Override Decidim::OmniauthRegistration to use send and event when login and not only on registration
Rails.application.config.to_prepare do
  Decidim::CreateOmniauthRegistration.include(SomEnergia::CreateOmniauthRegistrationOverride)
  Decidim::Devise::SessionsController.include(SomEnergia::Devise::SessionsControllerOverride)
  Decidim::AuthorizationModalCell.include(SomEnergia::AuthorizationModalCellOverride)
  Decidim::Verifications::ApplicationHelper.include(SomEnergia::VerificationsApplicationHelperOverride)
end

# Update user's extended_data when login
ActiveSupport::Notifications.subscribe "decidim.user.omniauth_registration" do |_name, data|
  user = Decidim::User.find_by(id: data[:user_id])
  extended_data = data.dig(:raw_data, :extra, "extended_data") || {}
  if user.present?
    user.update(extended_data:)
    # Accept TOS if date before 2021-01-01
    auto_accept_tos = ENV["AUTO_ACCEPT_TOS_BEFORE"].presence
    if auto_accept_tos.present?
      begin
        user.update(accepted_tos_version: user.organization.tos_version) if user.created_at < Date.parse(auto_accept_tos)
      rescue Date::Error => e
        Rails.logger.error "Error parsing AUTO_ACCEPT_TOS_BEFORE: #{e.message}"
      end
    end
    # Change the email if it is different
    if user.email != data[:email]
      previous_email = user.email
      user.email = data[:email]
      user.skip_reconfirmation!
      if user.save
        Rails.logger.info "Email updated from #{previous_email} to #{data[:email]} for user #{user.id}"
      else
        Rails.logger.error "Error updating email from #{previous_email} to #{data[:email]} for user #{user.id}: #{user.errors.full_messages}"
      end
    end
    # if user.email != data[:raw_data][:info][:email]
    #   user
    #   user.update(email: data[:raw_data][:info][:email])
    # end
    # Verify if the user is a Som Energia member
    handler = Decidim::AuthorizationHandler.handler_for("cas_member", user:, extended_data:)

    if handler
      Decidim::Verifications::AuthorizeUser.call(handler, user.organization) do
        on(:ok) do
          Rails.logger.info "User #{user.id} verified as Som Energia member as #{handler.unique_id}"
        end

        on(:invalid) do
          Rails.logger.error "User #{user.id} not verified as Som Energia member"
        end
      end
    end
  end
end
