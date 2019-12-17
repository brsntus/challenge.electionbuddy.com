class Question < ApplicationRecord
  include Auditable

  belongs_to :election
  has_many :answers
end
