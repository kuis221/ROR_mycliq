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

FactoryGirl.define do
  factory :event_invitation do
    
  end
end
