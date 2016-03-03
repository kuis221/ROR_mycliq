module UsersHelper
	def action_buttons(user)
		case current_user.friendship_status(user) when "friends"
			"Remove Friendship"
		    link_to "Cancel Friendship", friendship_path(current_user.friendship_relation(user)), method: :delete
		when "pending"
			"Cancel Request"
		    link_to "Cancel Request", friendship_path(current_user.friendship_relation(user)), method: :delete
		when "requested"
			"Accept or Deny"
		when "not_friends"
		    "Add as a Friend"
            link_to "Add as Friend", friendships_path(user_id: user.id), method: :post
		end
	end
end