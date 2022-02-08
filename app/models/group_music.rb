class GroupMusic < ApplicationRecord
  belongs_to :group
  belongs_to :music, optional: true
  belongs_to :user
end
