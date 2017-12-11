
class Crawler
  # WEB_INDEX = 'http://ent.qq.com/c/all_star.shtml'
  # page = Nokogiri::HTML(open(WEB_INDEX))

  HTML_FILE = "#{Rails.root}/autohome.html"

  PAGE = File.open(HTML_FILE) { |f| Nokogiri::HTML(f) }

  def start_run
    # sign = "A"
    PAGE.search("//div[@class='uibox']").each do |brand|
      brand.search("dl>dt").each do |d|
        # p d.search(">div").name
        p d.search(">div").size
        p d.search(">div").children
        p "name: #{d.search(">div").children.text}"
        # p d.search(">div").children.attributes
        # p sign
        # p star.text
        # p star.text
        # if star.attributes['href'].text.size > 27
        #   # p star.attributes['href'].text
        #   single_url = star.attributes['href'].text
        #   # read_person_info(single_url)

        # sign  = sign.succ
        end
    end
  end

end
