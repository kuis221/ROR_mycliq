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

require 'rails_helper'

RSpec.describe EventInvitation, type: :model do
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:event_id) }
end
