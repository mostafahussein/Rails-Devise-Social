class SessionsController < Devise::SessionsController

  before_filter :newest_infos

  def new
    super
  end

  # force_ssl
  def create
    resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    
    path = current_user.admin? ? admin_events_path : root_path
    # uncommented first and commented second when when site will
    # work under 80 port
    # redirect_to path protocol: "https://"
    redirect_to "https://comparendo.ch/#{path}"
    # redirect_to "http://localhost:3000/#{path}"
  end

  # force_http
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_navigational_format?

    # TODO remove port
    redirect_to root_path, protocol: "http://", port: "3000" and return
  end
end