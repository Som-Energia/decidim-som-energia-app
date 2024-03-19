# frozen_string_literal: true

module Admin
  class CasUsersController < Decidim::Admin::ApplicationController
    layout "decidim/admin/users"

    def new
      enforce_permission_to :read, :admin_dashboard
      @user = Decidim::User.new
    end

    def create
      enforce_permission_to :read, :admin_dashboard

      if data[:name].blank?
        flash[:alert] = I18n.t("admin.cas_users_controller.name_required")
        return redirect_to new_admin_cas_user_path
      end

      if data[:email].blank?
        flash[:alert] = I18n.t("admin.cas_users_controller.email_required")
        return redirect_to new_admin_cas_user_path
      end

      if data[:extra_attributes][:soci].blank?
        flash[:alert] = I18n.t("admin.cas_users_controller.membership_number_required")
        return redirect_to new_admin_cas_user_path
      end

      if data[:username].blank?
        flash[:alert] = I18n.t("admin.cas_users_controller.dni_required")
        return redirect_to new_admin_cas_user_path
      end

      # if Decidim::User.exists?(organization: current_organization, email: data[:email])
      #   flash[:alert] = "L'email ja existeix!"
      #   return redirect_to new_admin_cas_user_path
      # end

      if Decidim::User.exists?(organization: current_organization, username: data[:username])
        flash[:alert] = I18n.t("admin.cas_users_controller.dni_already_registered")
        return redirect_to new_admin_cas_user_path
      end

      if Decidim::User.where(organization: current_organization)
                      .where(%(extra_attributes @> '{"soci": "#{data[:extra_attributes][:soci].to_i}"}')).any?
        flash[:alert] = I18n.t("admin.cas_users_controller.membership_number_already_registered")
        return redirect_to new_admin_cas_user_path
      end

      @user = Decidim::User.new(data)
      @user.skip_invitation
      @user.skip_confirmation!
      @user.accepted_tos_version = Time.current
      @user.confirmed_at = Time.current
      if @user.save(validate: false)
        flash[:notice] = I18n.t("admin.cas_users_controller.user_created_successfully")
      else
        flash[:alert] = I18n.t("admin.cas_users_controller.user_creation_failed")
      end

      redirect_to new_admin_cas_user_path
    end

    private

    def data
      {
        name: params[:user][:name],
        email: params[:user][:email],
        nickname: Decidim::User.nicknamize(params[:user][:name], organization: current_organization),
        organization: current_organization,
        username: params[:dni],
        extra_attributes: {
          username: params[:dni],
          soci: params[:soci]
        }
      }
    end
  end
end
