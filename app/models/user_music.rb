class UserMusic < ApplicationRecord
  belongs_to :user
  belongs_to :music, optional: true
end
