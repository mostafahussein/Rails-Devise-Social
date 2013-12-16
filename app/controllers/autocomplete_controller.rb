class AutocompleteController < ApplicationController

  def company_tag_article
    articles = article_names
    companies =  company_names
    tags = tag_names
    result  = [articles, companies, tags].compact.reduce([],:|)
    render :json => result
  end

  def company_specialties
    tags = Tag.autocomplete :name, search_pattern
    result  = [tags].compact.reduce([],:|)
    render :json => result
  end

  def company_tag
    companies =  Company.autocomplete :name, search_pattern
    tags = Tag.autocomplete :name, search_pattern
    result  = [companies, tags].compact.reduce([],:|)
    render :json => result
  end

  def region_city
    regions =  Region.autocomplete :name, search_pattern
    cities = City.autocomplete :name, search_pattern
    result  = [regions, cities].compact.reduce([],:|)
    render :json => result
  end

  def category_subcategory_synonym  
    categories = category_names 
    subcategories = subcategory_names
    synonyms = synonym_names 
    result  = [categories, subcategories, synonyms].compact.reduce([],:|)
    render :json => result
  end



private

  def search_pattern
    params[:term]
  end


  def company_names
    Company.autocomplete_clickable :name, search_pattern do |company|
      url_for :controller=>:company, :action=>:index,  :name=>company.name 
    end
  end

  def tag_names
    Tag.autocomplete_clickable :name, search_pattern do |tag|
      url_for :controller=>:company, :action=>:index, :tag=>tag.name

    end
  end

  def article_names
    Article.autocomplete_clickable :title, search_pattern do |article|
      url_for :controller => :article, :action => :show, :path=> article.path
    end
  end
  
  def category_names
    Category.autocomplete :name, search_pattern
  end
  
  def subcategory_names
    Subcategory.autocomplete :name, search_pattern
  end
  
  def synonym_names
    Synonym.autocomplete :name, search_pattern
  end
end
