require 'mechanize'
require 'nokogiri'

mechanize = Mechanize.new
makaleYili=2010
icindeBulundugumuzYil=2010
#uri='https://dergipark.org.tr/tr/search?q=pubyear%3A' + makaleYili.to_s
uri='https://dergipark.org.tr/tr/search?q=&section=articles'


MAKALE_DOSYASI = "D:/Kisisel/Dersler/Ozyegin/TezCalismasi/RubyProjesi/makaleAdresleri.txt"
DOSYALANAN_MAKALE_SAYISI_DOSYASI = "D:/Kisisel/Dersler/Ozyegin/TezCalismasi/RubyProjesi//dosyalanan_makale_sayisi.txt"


def makaleleriBul(page)
  urlStart = "https://dergipark.org.tr"
  makale_sayisi = File.read(DOSYALANAN_MAKALE_SAYISI_DOSYASI).to_i
  page.xpath('//h5[contains(@class, "card-title")]/a[not(contains(@class, "fw-500"))]').each do |hh|
    #puts hh['href']
    open((MAKALE_DOSYASI), "a") { |dosya|
      dosya.puts hh['href']
    }
    makale_sayisi += 1
  end
  File.write(DOSYALANAN_MAKALE_SAYISI_DOSYASI, makale_sayisi)

  yeni_sayfa = ""
  page.xpath('//div[contains(@class, "kt-pagination") and contains(@class, "kt-pagination--circle") and contains(@class, "kt-pagination--brand")]
  //li[contains(@class, "kt-pagination__link--next")]
  //a').each do |ne|
    yeni_sayfa = urlStart + ne['href']
  end
  if yeni_sayfa != "" then
    mechanize = Mechanize.new
    page = mechanize.get(yeni_sayfa)
    makaleleriBul(page)
  end
end

#yıl aralığındaki makaleleri bulma
#while makaleYili <= icindeBulundugumuzYil
#  page = mechanize.get(uri)
#  makaleleriBul(page)
#  makaleYili += 1
#end

page = mechanize.get(uri)
makaleleriBul(page)






=begin
begin
page.xpath('//h5[contains(@class, "card-title")]/a[not(contains(@class, "fw-500"))]').each do |hh|
  puts hh['href']
end

#son sayfa numarası bulunuyor
lastPageNumber = 1
page.xpath('//div[contains(@class, "kt-pagination") and contains(@class, "kt-pagination--circle") and contains(@class, "kt-pagination--brand")]
//li[not(contains(@class, "kt-pagination__link--next"))]
//a').each do |ne|
  lastPageNumber = ne.text
end
puts lastPageNumber
end



page.xpath('//div[contains(@class, "kt-pagination") and contains(@class, "kt-pagination--circle") and contains(@class, "kt-pagination--brand")]
//li[contains(@class, "kt-pagination__link--next")]
//a').each do |ne|
  puts urlStart + ne['href']
end
=end