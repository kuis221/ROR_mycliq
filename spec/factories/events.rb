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

FactoryGirl.define do
  factory :event do
    
  end
end
