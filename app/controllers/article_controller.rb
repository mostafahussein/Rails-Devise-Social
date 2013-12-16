class ArticleController < ApplicationController
  set_tab :article
  
  add_breadcrumb I18n.t(:home), nil
  add_breadcrumb "Informationen", "/infos"
  
  before_filter :newest_infos, :only => [:overview, :show]
  
	def overview
    @articles = Article.order("id").page(params[:page]).per(3)
	end

  def show
    @article = Article.find_by_path(params[:path])
    redirect_to :action => :overview if @article.nil?
    add_breadcrumb "#{@article.title}", params[:path]
  end
end
