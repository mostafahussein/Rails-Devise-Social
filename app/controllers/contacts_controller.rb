class ContactsController < ApplicationController
  set_tab :contact_us
  
  add_breadcrumb I18n.t(:home), nil
  add_breadcrumb "Kontakt", "/kontakt"
  
  before_filter :newest_infos
  
  def new
  end
  
  def create
    message = EmailMessage.new(params[:message])

    if message.valid?
      ContactsMailer.contact_mail(message).deliver
      redirect_to root_url, :notice => t(:wewerecontacted)
    else
      flash[:error] = message.errors.full_messages[0]
      render :action => :new
    end
  end
end
