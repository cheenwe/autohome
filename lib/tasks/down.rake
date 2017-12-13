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

  DOWN_ROOT_PATH = "/tmp/autohome/"
  desc "down photo"
  task :test_photo => :environment do
    car  = Car.first
    photos = car.photos

    directory = DOWN_ROOT_PATH + car.brand.name + "/" +  car.name + "/"
    FileUtils.mkdir_p(directory)

    photos.each do |photo|
      filename = photo.color + "-" + photo.name + "-" + photo.id.to_s + ".jpg"
      DownloadFileWorker.perform_async(photo.photo, directory,  filename)
      # Crawler.download_file(photo.photo, directory, filename)
    end

    # directory = "#{Rails.root}/tmp/"
    # filename = "1.jpg"
    # DownloadFileWorker.perform_async(url, directory, filename)
  end

  desc "down photo"
  task :photo => :environment do

    Car.all.each do |car|
      photos = car.photos

      directory = DOWN_ROOT_PATH + car.brand.name + "/" +  car.name + "/"
      FileUtils.mkdir_p(directory)

      p car.id

      photos.each do |photo|
        filename = photo.color + "-" + photo.name + "-" + photo.id.to_s + ".jpg"
        DownloadFileWorker.perform_async(photo.photo, directory,  filename)
      end
    end
  end

end
