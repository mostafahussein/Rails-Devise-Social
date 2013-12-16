class Admin::EventsController < Admin::AdminController
  skip_load_and_authorize_resource
  set_tab :events
  def index
    authorize! :read, :admin_area
    @messages = current_user.messages.order("created_at desc").page(params[:page]).per(10)
  end
end
