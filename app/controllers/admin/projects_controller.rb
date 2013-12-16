class Admin::ProjectsController < Admin::AdminController
  skip_load_and_authorize_resource
  set_tab :projects
  def index
    @projects = current_user.projects.order("created_at desc").page(params[:page]).per(10)
  end
end
