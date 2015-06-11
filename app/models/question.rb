class Question < ActiveRecord::Base
  validates :poll_id, :text, presence: true

  belongs_to(
    :poll,
    class_name: 'Poll',
    foreign_key: :poll_id,
    primary_key: :id
  )

  has_many(
    :answer_choices,
    class_name: 'AnswerChoice',
    foreign_key: :question_id,
    primary_key: :id
  )

  has_many(
    :responses,
    through: :answer_choices,
    source: :responses
  )

  def results_old_way
    start = Time.now
    results = Hash.new(0)
    answer_choices.each do |answer_choice|
      results[answer_choice.text] = answer_choice.responses.count
    end
    puts Time.now - start
    results
  end

  def results
    start = Time.now
    answers = self.answer_choices.includes(:responses)

    results = {}

    answers.each do |answer|
      results[answer.text] = answer.responses.length
    end
    puts Time.now - start
    results
  end

  def results_hard
    start = Time.now
    results = Hash.new(0)

    select_sql = 'text, COUNT(responses.answer_choice_id) AS votes'
    joins_sql = <<-SQL
      LEFT OUTER JOIN
        responses
      ON
        answer_choices.id = responses.answer_choice_id
    SQL

    answer_choices
      .select(select_sql)
      .joins(joins_sql)
      .group("answer_choices.id")
      .each do |choice|
        results[choice.text] = choice.votes
      end
    puts Time.now - start
    results

  end

      # SELECT
      #   answer_choices.text,
      #   COUNT(responses.answer_choice_id)
      # FROM
      #   answer_choices
      # LEFT OUTER JOIN
      #   responses ON answer_choices.id = responses.answer_choice_id
      # WHERE
      #   answer_choices.question_id = ?
      # GROUP BY
      #   answer_choices.id;


end
