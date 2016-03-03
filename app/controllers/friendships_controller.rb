	def accept
		@friendship.accept_friendship
		respond_to do |format|
			format.html {redirect_to users_path, notice: "Friendship Accepted"}
		end
	end