# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  car_id     :integer
#  name       :string(255)
#  image      :string(255)
#  photo      :string(255)
#  color      :string(255)
#  background :string(255)
#  price      :string(255)
#  remark     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Photo < ApplicationRecord
  belongs_to :car

end
