module ApplicationHelper
  def grade_and_class_options
    grades = ['1年', '2年', '3年']
    classes = (1..10).to_a.map { |n| "#{n}組" }
                
    grades.product(classes).map { |grade, klass| ["#{grade.strip} #{klass.strip}", "#{grade.strip} #{klass.strip}"] }
  end
end
