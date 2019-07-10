
class Category < ApplicationRecord
  has_many :questions, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def to_s
    name
  end
end

