
class Answer < ApplicationRecord
  belongs_to :question

  after_initialize { self.active = true if active.nil? }

  validates :reply, presence: true

=begin
  validates_with Concerns::NastyCharValidator

  scope :activated, -> (is_active=true) { where active: is_active }

  scope :in_order, -> { order :reply }
=end

  def to_s
    reply
  end
end
