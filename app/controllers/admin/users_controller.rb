module Admin
  class UsersController < BaseController
    before_action :require_hq_admin
    before_action :set_user, only: %i[edit update]

    def index
      @users = User.order(:name)
    end

    def new
      @user = User.new(locale: I18n.locale, role: "warehouse_staff")
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: t(".created")
      else
        render :new, status: :unprocessable_content
      end
    end

    def edit; end

    def update
      attrs = user_params
      attrs = attrs.except(:password, :password_confirmation) if attrs[:password].blank?

      if @user == Current.user && (attrs[:role] != "hq_admin" || attrs[:active] == "0")
        return redirect_to(edit_admin_user_path(@user), alert: t(".cannot_change_self"))
      end

      if @user.update(attrs)
        @user.sessions.destroy_all unless @user.active?
        redirect_to admin_users_path, notice: t(".updated")
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.expect(user: [ :name, :email_address, :role, :locale, :active, :password, :password_confirmation ])
    end
  end
end
