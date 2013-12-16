require 'breadcrumbs_on_rails'
class BreadcrumbsCustomBuilder < BreadcrumbsOnRails::Breadcrumbs::SimpleBuilder
  def render_element(element)
    #log = Logger.new('log.log.log')
    
    #log.info @element
    #log.info @context
    
    #log.info compute_name(element)
    #log.info compute_path(element)
    
    content = @context.link_to(compute_name(element), compute_path(element), element.options)
    if @options[:tag]
      @context.content_tag(@options[:tag], content)
    elsif compute_path(element).blank?
      compute_name(element)
    else
      content
    end
  end
end
