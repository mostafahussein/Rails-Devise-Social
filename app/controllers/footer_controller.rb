class FooterController < ApplicationController
  add_breadcrumb I18n.t(:home), nil
  add_breadcrumb I18n.t(:aboutus), "/about" 
  before_filter :newest_infos
end
