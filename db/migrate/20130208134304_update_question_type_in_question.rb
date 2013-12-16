class UpdateQuestionTypeInQuestion < ActiveRecord::Migration
  def up
    Question.all.each do |q|
      case q.question_type
        when "one"
          q.update_attributes(:question_type => "select")
        when "many"
          q.update_attributes(:question_type => "checkbox")
        when "custom"
          q.update_attributes(:question_type => "textarea")
      end
    end
   end

  def down
    #Question.all.each do |q|
    #  case q.question_type
    #    when "select"
    #      q.update_attributes(:question_type => "one")
    #    when "checkbox"
    #      q.update_attributes(:question_type => "many")
    #    when "textarea"
    #      q.update_attributes(:question_type => "custom")
    #  end
    #end
  end
end
