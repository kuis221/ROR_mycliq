# == Schema Information
#
# Table name: friendships
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  friend_id   :integer
#  state       :string           default("pending")
#  friended_at :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class Friendship < ActiveRecord::Base
include PublicActivity::Model		

		belongs_to :user
	belongs_to :friend, class_name: "User"

		def accept_friendship
		self.update_attributes(state: "active", friended_at: Time.now)
	end

	def deny_friendship
		self.destroy
	end

	def cancel_friendship
		self.destroy
	end
end
