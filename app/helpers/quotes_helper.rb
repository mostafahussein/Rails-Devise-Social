module QuotesHelper
  def build_project_option_field p, q, answered=[]
    if q.checkbox?
      return build_checkboxes_field(q,answered, p)
    end

    if q.select?
      return build_select_field(q,answered, p)
    end

    if q.custom?
      return build_text_field(q,answered, p)
    end
  end

  def build_checkboxes_field q, answered=[], p
    res = []
    q.answers.each do |a|
      indx = project_option_indx
      checked = !answered.empty? && answered.include?(a)
      f = check_box_tag("project[project_options_attributes][#{indx}][answer_id]", a.id, checked)
      f += label_tag("project_project_options_attributes_#{indx}_answer_id", a.description, style: "display: inline;")

      po = ProjectOption.where(project_id: p.id, answer_id: a.id).first
      # if p not new record add additional field
      f += hidden_field_tag( "project[project_options_attributes][#{indx}][id]", po.id) if po

      res << content_tag(:fieldset, f)
    end
    res.join("").html_safe
  end

  def build_select_field q, answered=[], p
  	indx = project_option_indx
    res = "<select name='project[project_options_attributes][#{indx}][answer_id]'>"
    res += "<option>Bitte Auswahl treffen</option>" if q.is_mandatory?
    po = nil
    q.answers.each do |a|
      selected = !answered.empty? && answered.include?(a)
    	if selected
	      res += "<option value='#{a.id}' selected='selected'>#{a.description}</option>"
	      po = ProjectOption.where(project_id: p.id, answer_id: a.id).first
	    else
	      res += "<option value='#{a.id}'>#{a.description}</option>"
	    end
    end
	  res += "</select>"
		
    res += hidden_field_tag("project[project_options_attributes][#{indx}][id]", po.id) if po

	  res.html_safe
	end

  def build_text_field q, answered=[], p
		indx = project_option_indx
		content = nil
		unless answered.empty?
			content = answered.first.description
			po = ProjectOption.where(project_id: p.id, answer_id: answered.first.id).first
		end
    res = text_area_tag "options[#{indx}][answer][description]", content, cols: 40, rows: 5, class: 'custom_question'
    res += hidden_field_tag "options[#{indx}][answer][question_id]", q.id
    
    res += hidden_field_tag("project[project_options_attributes][#{indx}][id]", po.id) if po

    res.html_safe
  end

  def project_option_indx  
    "#{SecureRandom.hex(3)}#{Time.now.to_i}"
  end
end
