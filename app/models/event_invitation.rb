# == Schema Information
#
# Table name: event_invitations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  event_id   :integer
#  invitee_id :integer
#  status     :string           default("sent")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EventInvitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :invitee, class_name: "User"
  belongs_to :event

  validates_presence_of :user_id
  validates_presence_of :event_id

  def self.accepted(event)
    where(event_id: event.id, status: "accepted")
  end
end
