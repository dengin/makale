require 'mechanize'
require 'nokogiri'
require 'open-uri'
#require 'open_uri_redirections'

MAKALE_DOSYASI = "D:/Kisisel/Dersler/Ozyegin/TezCalismasi/RubyProjesi/makaleAdresleri.txt"


mechanize = Mechanize.new
line_num=1
text=File.open(MAKALE_DOSYASI).read
text.gsub!(/\r\n?/, "\n")

pdfAdresi = ""

text.each_line do |line|

  if line_num < 4033
    line_num += 1
    next
  end
  if line_num % 40 == 0
    sleep(10)
  end

  begin
    page = mechanize.get(line)
  rescue
    line_num += 1
    next
  end

  page.xpath('//div[contains(@class, "panel-body")]
  //div[@id="articleTitle"]
  //a[contains(@class, "btn-link")]').each do |vv|
    pdfAdresi = "https://dergipark.org.tr#{vv.attributes['href']}"
  end

  begin
    File.open(('C:/pdf/' + line_num.to_s + '.pdf'), "wb") do |file|
      file.write open(pdfAdresi).read
    end
  rescue
    puts "adres hatalı: " + pdfAdresi
  end

  line_num += 1
end


