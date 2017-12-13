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
#  name       :string(255)
#

class Car < ApplicationRecord
  validates :name, uniqueness: { scope: :brand_id }

  has_many :photos
  belongs_to :brand

  def series_id
    self.remark.split('/')[3]
  end

  def url_list(id)
    [
      {url: "https://car.autohome.com.cn/pic/series-t/#{id}-1-p1.html",name: "t-#{id}-1-p1.html"},
      {url: "https://car.autohome.com.cn/pic/series/#{id}-1-p1.html",name: "#{id}-1-p1.html"},
    ]
  end

  # Car.new.down_file(url, filename)
  def down_file(url, filename)
    url = URI.parse("#{url}")
    res = Net::HTTP.get_response(url)
    File.open("#{filename}", "w:UTF-8") {|f|
        f.write res.body.force_encoding("UTF-8")
    }
  end

  def download_html_page
    Car.all.each do |car|
      down_path = "#{Rails.root}/tmp/html/#{car.id}"
      FileUtils.mkdir_p(down_path)
      p car.series_id
      url_list(car.series_id).each do |arr|
        # p arr[:url]
        # p "#{down_path}/#{arr[:name]}"åå
        # down_file(arr[:url], "#{down_path}/#{arr[:name]}")
        DownloadHtmlWorker.perform_async(arr[:url], "#{down_path}/#{arr[:name]}")
      end
    end
  end

  # def html_abs_path(car)
  #   [
  #     "#{Rails.root}/tmp/html/#{car.id}/#{car.series_id}-1-p1.html.html",
  #     "#{Rails.root}/tmp/html/#{car.id}/t-#{car.series_id}-1-p1.html",
  #   ]
  # end
  # # test_first
  # def test_first
  #   car = Car.first
  #   f = html_abs_path(car)[0]
  #   p f
  #   page = File.open(HTML_FILE) { |f| Nokogiri::HTML(f) }
  #   page
  # end

  def test_a
    f = "/Users/chenwei/workspace/project/autohome/tmp/html/12/t-3170-1-p1.html"
    page = File.open(HTML_FILE) { |f| Nokogiri::HTML(f) }
    page
  end
end
