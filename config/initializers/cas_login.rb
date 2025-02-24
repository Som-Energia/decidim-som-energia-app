if ENV["CAS_HOST"].present?
  Rails.application.config.middleware.use OmniAuth::Builder do
    # {"user"=>"1234ZX", "username"=>"1234X", "first_name"=>"Name", "last_name"=>"Last names", "email"=>"em@il", "soci"=>"1234", "locale"=>"ca"}
    provider :cas, setup: proc { |env|
                            request = Rack::Request.new(env)
                            organization = Decidim::Organization.find_by(host: request.host)
                            env["omniauth.strategy"].options["host"] = ENV.fetch("CAS_HOST", nil)
                            env["omniauth.strategy"].options["organization"] = organization
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
  Rails.application.secrets[:omniauth][:cas] = {
    enabled: true,
    icon_path: "media/images/somenergia-icon.png",
    host: ENV.fetch("CAS_HOST", nil)
  }
end

# Override Decidim::OmniauthRegistration to use send and event when login and not only on registration
Rails.application.config.to_prepare do
  Decidim::CreateOmniauthRegistration.include(SomEnergia::CreateOmniauthRegistrationOverride)
end

# Update user's extended_data when login
ActiveSupport::Notifications.subscribe "decidim.user.omniauth_registration" do |_name, data|
  user = Decidim::User.find_by(id: data[:user_id])
  extended_data = data.dig(:raw_data, :extra, "extended_data")
  user.update(extended_data: extended_data) if user.present?
end
