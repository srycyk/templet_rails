
class Answer < ApplicationRecord
  belongs_to :question

  after_initialize { self.active = true if active.nil? }

  validates :reply, presence: true

  def to_s
    reply
  end
end
