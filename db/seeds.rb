# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

5.times do |i|

  u = User.create!(user_name: "James#{i}")

  p = Poll.create!(author_id: u.id, title: "Poll#{i}")

end

Poll.all.each do |poll|

  q1 = Question.create!(text: "What's your favorite color?", poll_id: poll.id)
  q2 = Question.create!(text: "What's your favorite snack?", poll_id: poll.id)
  q3 = Question.create!(text: "How tall are you?", poll_id: poll.id)

end
