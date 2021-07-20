class Admin::RegistrationAdminsController < Admin::AdminController
  def index
    @admins = Admin.all
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      redirect_to admin_registration_admins_path, notice: t('.success')
    else
      render :new
    end
  end

  private

  def admin_params
    params.require(:admin).permit(:email)
  end
end
