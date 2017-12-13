
require 'nokogiri'
require 'open-uri'

require 'net/http'
require 'uri'

class Crawler
  # WEB_INDEX = 'http://ent.qq.com/c/all_star.shtml'
  # page = Nokogiri::HTML(open(WEB_INDEX))

  HTML_FILE = "#{Rails.root}/autohome.html"
  PAGE = File.open(HTML_FILE) { |f| Nokogiri::HTML(f) }

  # Crawler.new.read_car_info
  def read_car_info
    PAGE.search("//div[@class='uibox']").each do |brand|

      # abbr = brand.search("//div/span[@class='font-letter']").first.text # A/B/C 识别有问题
      brand.search("dl").each do |list|
        logo_path = "#{Rails.root}/tmp/autohome#{list.search("dt>a>img").first.attributes["src"].value.gsub('./','/')}"  #"img path"
        name = list.search("dt>div>a").first.text  rescue ''#"奥迪"
        remark = list.search("dt>div>a").first.first[1] rescue ''#"https://car.autohome.com.cn/pic/brand-33.html"
        brand = Brand.create(
          name: name,
          logo: logo_path,
          remark: remark,) rescue ''
        list.search("dd>ul>li").each do |car|
          car_name = car.search("h4>a").text #"艾康尼克七系"
          car_url = car.search("h4>a").first.attributes["href"].value rescue ''#"url"
          car_price = car.search("div/a").first.text rescue '暂无'
          car_price = car_price.to_i > 0 ? car_price:"未知"
          # p "brand: #{name} --- #{car_name} --- #{car_price}"
          Car.create!(
            brand_id: brand.id,
            price: car_price,
            remark: car_url,
            name: car_name,) rescue "=================#{car_name}: #{car_url}"
        end if brand.id.present?
      end

      # brand.search("dl>dd>ul>li")

      # a=PAGE.search("//div[@class='uibox']")
      # b=a.first
      # cc=b.search("dl>dd>ul>li>h4>a").first.text
      # cc=b.search("dl>dd>ul>li>h4>a").first.first[1]

      # brand.search("dd>ul>li>h4>a").first.text
      # => "奥迪A3"

      # brand.search("dl>dd>ul>li>h4>a").first.first[1]
      # => "https://www.autohome.com.cn/3170/#levelsource=000000000_0&pvareaid=101594"


      # brand.search("dl>dt").each do |d|
      #   # p d.search(">div").children.last.attributes['href'].value
      #   # p "name: #{d.search(">div").children.text}"


      #   # p d.search(">div").children.attributes
      #   # p sign
      #   # p star.text
      #   # p star.text
      #   # if star.attributes['href'].text.size > 27
      #   #   # p star.attributes['href'].text
      #   #   single_url = star.attributes['href'].text
      #   #   # read_person_info(single_url)

      #   # sign  = sign.succ
      #   end
    end
  end

  def html_abs_path(car)
    [
      "#{Rails.root}/tmp/html/#{car.id}/#{car.series_id}-1-p1.html.html",
      "#{Rails.root}/tmp/html/#{car.id}/t-#{car.series_id}-1-p1.html",
    ]
  end


  # test_first
  def test_first
    car = Car.first
    file = html_abs_path(car)[1]
    p file
    page = File.open(file) { |f| Nokogiri::HTML(f) }
    page.search("ul/li").first
    # pic.children.first.attributes["href"]
    # url = "https://car.autohome.com.cn#{pic.children.first.attributes["href"]}"
    # image =    "http:#{children.children.first.attributes["src"].value}"
    # => "//car3.autoimg.cn/cardfs/product/g12/M0A/F3/5B/t_autohomecar__wKgH01epqIaAQdctAAmsi037fVQ238.jpg"

    # https://car.autohome.com.cn//photo/series/7673/1/694155.html
  end

  def parse_file(id, file)

    page = File.open(file) { |f| Nokogiri::HTML(f) }
    content = page.search("ul/li")
    content.each do |pic|
      url = "https://car.autohome.com.cn#{pic.children.first.attributes["href"]}" rescue'-1'
      image = "http:#{pic.children.children.first.attributes["src"].value}"  rescue'-1'
      Photo.create(
        car_id:id,
        image:image,
        remark:url
        )
    end if content.present?
  end

  def  parse_html
    Car.all.each do |car|
      html_abs_path(car).each do |file|
        parse_file(car.id, file)
      end
    end
  end

  def down_photo_html
    down_path = "#{Rails.root}/tmp/photos"
    Photo.find_in_batches(batch_size: 1000) do |group|
        group.each do |photo|
          file_path = "#{down_path}/#{photo.id}"
          FileUtils.mkdir_p(file_path)
          filename = "#{file_path}/1.html"
          url = photo.remark
          DownloadHtmlWorker.perform_async(url, filename)
          # DownloadFileWorker.perform_async(photo.id)
          p "#{photo.id} -- doing ..... "

        end
      end
  end

  def photo_html_abs_path(photo)
    "#{Rails.root}/tmp/photos/#{photo.id}/1.html"
  end

  def parse_photo_html
    Photo.find_in_batches(batch_size: 1000) do |group|
      group.each do |photo|
        filename = photo_html_abs_path(photo)
        # deal_photo_file(photo.id, file)
        ParsePhotoHtmlWorker.perform_async(photo.id, filename)
      end
    end
  end

  def deal_photo_file(id, filename)
    data = parse_photo_info(filename)
    if data[:photo]!=""
      photo = Photo.find(id)
      photo.update(data)
      p "."
    else
      p file
    end
  end

  def parse_photo_info(filename)

    photo_page = Nokogiri::HTML(open(filename))
    photo = "http:#{photo_page.search("//img").last.attributes["src"].value}" rescue ''  #<!-- 图片展示 开始 -->
    name = "#{photo_page.search("//p[@class='tip-text']").last.children.text}" rescue '' #<!-- 当前车型提示 -->
    color =  photo_page.search("//span[@class='color-text-tip']").first.children.text.split("(").first rescue ''#颜色

    {
      name: name,
      photo: photo,
      color: color,
    }
  end

  def test_parse_photo
    url = Photo.last.remark

    # res = Net::HTTP.get_response(url).body
    filename = "#{Rails.root}/tmp/test_2.html"
    # Car.new.down_file(url, filename)

    photo_page = Nokogiri::HTML(open(filename))

    # photo_page#.search("//a[@class='photo-btn']")
    photo = "http:#{photo_page.search("//img").last.attributes["src"].value}" #<!-- 图片展示 开始 -->
    name = "#{photo_page.search("//p[@class='tip-text']").last.children.text}" rescue '' #<!-- 当前车型提示 -->
    color =  photo_page.search("//span[@class='color-text-tip']").first.children.text.split("(").first rescue ''#颜色

    p "#{photo}  : #{name}   : #{color}"
  end


  def test_a
    # file = "https://car.autohome.com.cn/pic/series-t/3170-1-p1.html"
    file = "/Users/chenwei/workspace/project/autohome/tmp/html/990/3676-1-p1.html.html"
    # file = "/Users/chenwei/workspace/project/autohome/tmp/html/992/a.html"
    file = "/Users/chenwei/workspace/project/autohome/tmp/html/992/a.html"
    # file = "/Users/chenwei/workspace/project/autohome/tmp/d1.htm"
    file = "/Users/chenwei/workspace/project/autohome/tmp/html/100/t-2148-1-p1.html"

    page = File.open(file) { |f| Nokogiri::HTML(f) }

    # mm = File.open(file)
    # page = Nokogiri::HTML(mm)
    # page = Nokogiri::HTML(open(file))
    page
  end

  def test_b
    url = "https://car.autohome.com.cn/pic/series/3170-1.html#pvareaid=2042222"
    page = Nokogiri::HTML(open(url))
    page
  end


  def test_del
    file = "/Users/chenwei/workspace/project/autohome/tmp/html/992/a.html"
    f = File.new(file, 'r+')
    f.each do |line|
      if should_be_deleted(line)
        # seek back to the beginning of the line.
        f.seek(-line.length, IO::SEEK_CUR)
        # overwrite line with spaces and add a newline char
        f.write(' ' * (line.length - 1))
        f.write("\n")
      end
    end
    f.close
    File.new(filename).each {|line| p line }
  end


end
