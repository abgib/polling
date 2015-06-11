class Response < ActiveRecord::Base
  validates :responder_id, :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question,
    :respondent_is_not_author


  belongs_to(
    :responder,
    class_name: 'User',
    foreign_key: :responder_id,
    primary_key: :id
  )

  belongs_to(
    :answer_choice,
    class_name: 'AnswerChoice',
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

  has_one(
    :question,
    through: :answer_choice,
    source: :question
  )

  def sibling_responses
    question.responses.where(<<-SQL, self_id: self.id)
      :self_id IS NULL OR responses.id != :self_id
    SQL
  end

  def author_id
    question.poll.author.id
  end

  private
    def respondent_has_not_already_answered_question
      if sibling_responses.any? { |response| response.responder_id == self.responder_id }
        errors[:already_answered] << "by user"
      end
    end

    def respondent_is_not_author
      if author_id == self.responder_id
        errors[:author] << "cannot answer own questions"
      end
    end
end
