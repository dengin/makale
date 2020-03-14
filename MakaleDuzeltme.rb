#require 'mechanize'
#require 'nokogiri'

MAKALE_DOSYASI_BASLANGIC = "D:/Kisisel/Dersler/Ozyegin/TezCalismasi/RubyProjesi/makaleDetayDosyasi"
DOSYALANAN_MAKALE_SAYISI_DOSYASI = "D:/Kisisel/Dersler/Ozyegin/TezCalismasi/RubyProjesi//dosyalanan_makale_sayisi.txt"

i = 0
loop do
  i += 1

  makaleDosyasi = MAKALE_DOSYASI_BASLANGIC + i.to_s() + ".txt"

  text=File.open(makaleDosyasi).read
  #myString = text.gsub("/konular><birincildil", "/konular><bolum")
  #myString = myString.gsub("</birincildil><yazarlar>", "</bolum><yazarlar>")

  #myString = text.gsub("goruntulenmeSayisi>", "goruntulenmesayisi>")
  #myString = myString.gsub("indirilmeSayisi>", "indirilmesayisi>")
  #myString = myString.gsub("ozet>", "ozetbilgisi>")
  #myString = myString.gsub("abstract>", "abstractbilgisi>")
  #myString = myString.gsub("yazarlar>", "yazardetaylari>")
  #myString = myString.gsub("yazar>", "yazardetay>")

  #myString = text.gsub("yazardetay>", "yazaradi>")

  #myString = text.gsub("yazaradi>", "yazarbilgisi>")

  #myString = text.gsub("</yazarorcid><yazarbilgisi>", "</yazarorcid><yazaradi>")
  #myString = myString.gsub("</yazarbilgisi><kurumadi>", "</yazaradi><kurumadi>")

  #myString = text.gsub("<yazardetaylari><yazarbilgisi>", "<yazardetaylari><yazardetay>")
  #myString = myString.gsub("<yazarbilgisi><yazarorcid>", "<yazardetay><yazarorcid>")
  #myString = myString.gsub("<yazarbilgisi><yazaradi>", "<yazardetay><yazaradi>")
  #myString = myString.gsub("<yazarbilgisi><kurumadi>", "<yazardetay><kurumadi>")
  #myString = myString.gsub("<yazarbilgisi><ulke>", "<yazardetay><ulke>")
  #myString = myString.gsub("</ulke></yazarbilgisi>", "</ulke></yazardetay>")
  #myString = myString.gsub("</kurumadi></yazarbilgisi>", "</kurumadi></yazardetay>")
  #myString = myString.gsub("</yazaradi></yazarbilgisi>", "</yazaradi></yazardetay>")
  #myString = myString.gsub("</yazarorcid></yazarbilgisi>", "</yazarorcid></yazardetay>")
  #myString = myString.gsub("</yazarbilgisi></yazardetaylari>", "</yazardetay></yazardetaylari>")
  #myString = myString.gsub("</yazarbilgisi></yazardetaylari>", "</yazardetay></yazardetaylari>")

  myString = text.gsub("<yazarbilgisi>", "<yazaradi>")
  myString = myString.gsub("</yazarbilgisi>", "</yazaradi>")


  File.open(makaleDosyasi, "w") do |f|
    f.write(myString)
  end

  if i == 50
    break
  end
end
