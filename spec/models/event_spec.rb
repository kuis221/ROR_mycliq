# == Schema Information
#
# Table name: events
#
#  id                            :integer          not null, primary key
#  user_id                       :integer
#  description                   :text
#  description_html              :text
#  title                         :string
#  location                      :string
#  background_image_file_name    :string
#  background_image_content_type :string
#  background_image_file_size    :integer
#  background_image_updated_at   :datetime
#  start_at                      :datetime
#  end_at                        :datetime
#  private                       :boolean          default("f"), not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  latitude                      :float
#  longitude                     :float
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:title) }

  it { is_expected.to have_attached_file(:background_image) }
  it { is_expected.to validate_attachment_content_type(:background_image).
    allowing('image/png', 'image/gif').
    rejecting('text/plain', 'text/xml') }
  it { is_expected.to validate_attachment_size(:background_image).less_than(2.megabytes) }
end
