# == Schema Information
#
# Table name: cars
#
#  id         :integer          not null, primary key
#  brand_id   :integer
#  sub_barnd  :string(255)
#  price      :string(255)
#  remark     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Car < ApplicationRecord
end
