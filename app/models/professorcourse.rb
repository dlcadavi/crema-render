class Professorcourse < ApplicationRecord
  belongs_to :professor
  belongs_to :course
end
