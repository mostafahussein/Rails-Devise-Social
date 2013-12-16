require 'spec_helper'

describe Admin::EventsController do
  include Devise::TestHelpers
  render_views
  
  it "should open index page" do
    user = FactoryGirl.create(:user, admin: true)
    user.confirm!
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    
    get 'index'
    
    response.should be_success
    request.should render_template 'index'
  end

  it "should redirect to home page" do
    user = FactoryGirl.create(:user)
    user.confirm!
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    
    get 'index'
    
    response.should_not be_success
    request.should redirect_to root_url
  end

  it "should redirect to login page" do
    get 'index'
    response.should_not be_success
    request.should redirect_to '/users/sign_in'
  end
end
