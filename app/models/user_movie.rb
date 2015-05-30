class UserMovie < ActiveRecord::Base
	belongs_to :movie
	belongs_to :user

	validates :star, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
