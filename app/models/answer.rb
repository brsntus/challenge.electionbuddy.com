class Answer < ApplicationRecord
  include Auditable

  belongs_to :question
end
