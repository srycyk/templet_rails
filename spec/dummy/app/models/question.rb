
class Question < ApplicationRecord
  belongs_to :category

  has_many :answers, dependent: :destroy

  after_initialize { self.active = true if active.nil? }

  validates :query, :category, presence: true

  def to_s
    query
  end
end

