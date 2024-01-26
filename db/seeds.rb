def grade_and_class_options
  grades = ['1年', '2年', '3年']
  classes = (1..10).to_a.map { |n| "#{n}組" }
      
  grades.product(classes).map { |grade, klass| ["#{grade.strip} #{klass.strip}", "#{grade.strip} #{klass.strip}"] }
end
  
10.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    nickname: Faker::Internet.user_name,
    grade_and_class: grade_and_class_options.sample[1],
    email: Faker::Internet.email,
    password: '12345678',
    password_confirmation: '12345678',
    introduction: Faker::Lorem.sentence,
  )
end
    
20.times do |index|
  TestResult.create!(
    user: User.offset(rand(User.count)).first,
    test_name: Faker::Educator.course_name,
    score: rand(100),
    max_score: 100, # Assuming the maximum score is 100
  )
end
  