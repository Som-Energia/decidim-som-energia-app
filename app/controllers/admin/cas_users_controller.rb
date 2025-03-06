# frozen_string_literal: true

module Admin
  class CasUsersController < Decidim::Admin::ApplicationController
    layout "decidim/admin/users"

    def new
      enforce_permission_to :read, :admin_dashboard
      @user = Decidim::User.new(name: "")
    end

    def create
      enforce_permission_to :read, :admin_dashboard

      errors = validate_data
      if errors.present?
        flash.now[:alert] = errors
        @user = Decidim::User.new(data)
        render :new
        return
      end
      @user = Decidim::User.new(data)
      @user.skip_invitation
      @user.skip_confirmation!
      if @user.save(validate: false)
        flash[:notice] = I18n.t("admin.cas_users_controller.user_created_successfully")
      else
        flash[:alert] = I18n.t("admin.cas_users_controller.user_creation_failed", error: @user.errors.full_messages.join(", "))
      end

      redirect_to new_admin_cas_user_path
    end

    private

    def validate_data
      return I18n.t("admin.cas_users_controller.name_required") if data[:name].blank?

      return I18n.t("admin.cas_users_controller.email_required") if data[:email].blank? || !Devise.email_regexp.match?(data[:email])

      return I18n.t("admin.cas_users_controller.membership_number_required") if data[:extended_data][:soci].blank?

      return I18n.t("admin.cas_users_controller.dni_required") if data[:extended_data][:username].blank?

      return I18n.t("admin.cas_users_controller.email_already_registered") if Decidim::User.exists?(email: data[:email], organization: current_organization)

      if Decidim::User.where(organization: current_organization)
                      .where(%(extended_data @> '{"soci": "#{data[:extended_data][:soci]}"}')).any?
        return I18n.t("admin.cas_users_controller.membership_number_already_registered")
      end

      if Decidim::User.where(organization: current_organization)
                      .where(%(extended_data @> '{"username": "#{data[:extended_data][:username]}"}')).any?
        I18n.t("admin.cas_users_controller.dni_already_registered")
      end
    end

    def data
      {
        name: params[:user][:name],
        email: params[:user][:email],
        nickname: Decidim::User.nicknamize(params[:user][:name], organization: current_organization),
        organization: current_organization,
        extended_data: {
          username: params[:dni],
          soci: params[:soci]
        }
      }
    end
  end
end
