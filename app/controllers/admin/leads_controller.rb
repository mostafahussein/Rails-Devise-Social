class Admin::LeadsController < Admin::AdminController
	skip_load_and_authorize_resource
  set_tab :leads
  def index
    authorize! :read, :admin_area
    authorize! :show, :leads
    @projects = current_user.company.projects.opened.page(params[:page]).per(10)
  end
end
