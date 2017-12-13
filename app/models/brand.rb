# == Schema Information
#
# Table name: brands
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  english_name :string(255)
#  abbr         :string(255)
#  logo         :string(255)
#  remark       :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Brand < ApplicationRecord
  validates :name, presence: true, uniqueness: true


end
