class Voter < ApplicationRecord
  include Auditable

  belongs_to :election
end
