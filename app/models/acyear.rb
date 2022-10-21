class Acyear < ApplicationRecord
  belongs_to :activity, optional: true
  belongs_to :course, optional: true
  has_many :stays, dependent: :destroy
  has_many :students, through: :stays

  has_many :visits, dependent: :destroy
  has_many :guests, through: :visits

end
