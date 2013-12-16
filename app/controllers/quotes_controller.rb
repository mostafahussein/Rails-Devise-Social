# encoding: utf-8
class QuotesController < ApplicationController
	before_filter :check_params, only: [:new]
	add_breadcrumb I18n.t(:home), nil
  add_breadcrumb I18n.t(:requestoffer), '/offerte-anfordern'

  def edit
    add_breadcrumb I18n.t(:add_project_info), request.fullpath
    @project = Project.find_by_id params[:id]
    redirect_to new_offer_path and return if @project.nil?

    @region = @project.region
    unless @project.options.empty?
      @subcategory = @project.options.first.question.subcategory
    end

    @category = @subcategory.category
    render :new
  end

  def new
    add_breadcrumb I18n.t(:add_project_info), request.fullpath
  	@project = Project.new
  end

  def create
    @subcategory = Subcategory.find params[:project].delete(:subcategory_id)
    @region = Region.find_by_id(params[:project][:region_id])

    specialties_attr = params[:project].delete(:specialties)
    attrs = params[:project].merge({subcategory: @subcategory})
    @project = Project.new attrs

    # answers for textarea
    unless params[:options].blank?
      params[:options].values.each do |opt|
        answ = Answer.create(opt[:answer])
        @project.project_options << ProjectOption.new(option: answ)
      end
    end

    @project.tags << prepare_specialties(specialties_attr)
    @project.region = @region
    if @project.save
      flash[:notice] = "Das Projekt wurde erfolgreich erstellt"
      render :show
    else
      flash[:error] = "Projekt nicht erstellt."
      render :new
    end

  end

  def update
    @subcategory = Subcategory.find params[:project].delete(:subcategory_id)
    @region = Region.find_by_id(params[:project][:region_id])

    specialties_attr = params[:project].delete(:specialties)
    attrs = params[:project].merge({subcategory: @subcategory})
    
    @project = Project.find_by_id params[:id]
    @project.tags << prepare_specialties(specialties_attr)
    if @project.update_attributes attrs
      flash[:notice] = "Das Projekt wurde erfolgreich erstellt"
      render :show
    else
      flash[:error] = "Projekt nicht erstellt."
      render :new
    end
  end

  def show
  	@project = Project.find params[:id]
  end

  private
    def check_params
      redirect_to new_offer_path and return if params[:subcategory_id].blank?

      @subcategory = Subcategory.find params[:subcategory_id]
      redirect_to new_offer_path and return if @subcategory.nil?

      @category = @subcategory.category
      @region = Region.find_by_id(params[:region_id]) unless params[:region_id].blank?
    end

    def prepare_specialties str_specialties
      current_specialties = @project.tags
      new_specialties = []
      for_destroy = []
      for_create = []

      unless str_specialties.blank?
        str_specialties.split(",").uniq.each do |name|
          new_specialties << Tag.find_or_create_by_name(name: name)
        end
        new_specialties.uniq! unless new_specialties.empty?
      end

      for_destroy = current_specialties - new_specialties
      for_create = new_specialties - current_specialties

      for_destroy.each do |s|
        scp = Tagging.of_tag(s)
        scp = scp.of_taggable(@project)
        scp.destroy_all
      end
      for_create
    end
end
