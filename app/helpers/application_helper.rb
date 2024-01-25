module ApplicationHelper
  def grade_and_class_options
    grades = ['1年', '2年', '3年']
    classes = (1..10).to_a.map { |n| "#{n}組" }
                
    grades.product(classes).map { |grade, klass| ["#{grade.strip} #{klass.strip}", "#{grade.strip} #{klass.strip}"] }
  end

  def page_title(page_title = '', admin = false)
    base_title = if admin
                  'Test Score Rivals(管理画面)'
                else
                  'Test Score Rivals'
                end

    page_title.empty? ? base_title : page_title + ' | ' + base_title
  end
end
