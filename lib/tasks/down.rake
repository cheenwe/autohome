namespace :down do
  desc "down car html"
  task car_html: :environment  do
    Car.new.download_html_page
  end



  desc "down photo html"
  task photo_html: :environment  do
    Crawler.new.down_photo_html
  end

  desc "parse photo html"
  task parse_photo_html: :environment  do
    Crawler.new.parse_photo_html
  end





  desc "down"
  task :one => :environment do
    url = "https://car.autohome.com.cn/pic/series-t/3170-1-p1.html"
    filename = "#{Rails.root}/tmp/s1.html"
    Car.new.down_file(url, filename)
    url = "https://car.autohome.com.cn/pic/series/3170-1-p1.html"
    filename = "#{Rails.root}/tmp/s2.html"
    Car.new.down_file(url, filename)
  end



end
