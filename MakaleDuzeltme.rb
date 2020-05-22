#require 'mechanize'
#require 'nokogiri'
#
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

MAKALE_DOSYASI_BASLANGIC = "D:/Kisisel/Dersler/Ozyegin/TezCalismasi/RubyProjesi/makaleDetayDosyasi"
DOSYALANAN_MAKALE_SAYISI_DOSYASI = "D:/Kisisel/Dersler/Ozyegin/TezCalismasi/RubyProjesi/dosyalanan_makale_sayisi.txt"

for sayfaid in 3..50 do
  makaleDosyasi = MAKALE_DOSYASI_BASLANGIC + sayfaid.to_s() + ".txt"
  #makaleDosyasi = MAKALE_DOSYASI_BASLANGIC + "_hepsi.txt"

  text=File.open(makaleDosyasi).read
  myString = text.gsub("/konular><birincildil", "/konular><bolum")
  myString = myString.gsub("</birincildil><yazarlar>", "</bolum><yazarlar>")

  myString = myString.gsub("</birincildil><birincildil>", "</birincildil><bolum>")

  myString = myString.gsub("goruntulenmeSayisi>", "goruntulenmesayisi>")
  myString = myString.gsub("indirilmeSayisi>", "indirilmesayisi>")
  myString = myString.gsub("ozet>", "ozetbilgisi>")
  myString = myString.gsub("abstract>", "abstractbilgisi>")
  myString = myString.gsub("yazarlar>", "yazardetaylari>")
  myString = myString.gsub("yazar>", "yazardetay>")

  myString = myString.gsub("yazardetay>", "yazaradi>")

  myString = myString.gsub("yazaradi>", "yazarbilgisi>")

  myString = myString.gsub("</yazarorcid><yazarbilgisi>", "</yazarorcid><yazaradi>")
  myString = myString.gsub("</yazarbilgisi><kurumadi>", "</yazaradi><kurumadi>")

  myString = myString.gsub("<yazardetaylari><yazarbilgisi>", "<yazardetaylari><yazardetay>")
  myString = myString.gsub("<yazarbilgisi><yazarorcid>", "<yazardetay><yazarorcid>")
  myString = myString.gsub("<yazarbilgisi><yazaradi>", "<yazardetay><yazaradi>")
  myString = myString.gsub("<yazarbilgisi><kurumadi>", "<yazardetay><kurumadi>")
  myString = myString.gsub("<yazarbilgisi><ulke>", "<yazardetay><ulke>")
  myString = myString.gsub("</ulke></yazarbilgisi>", "</ulke></yazardetay>")
  myString = myString.gsub("</kurumadi></yazarbilgisi>", "</kurumadi></yazardetay>")
  myString = myString.gsub("</yazaradi></yazarbilgisi>", "</yazaradi></yazardetay>")
  myString = myString.gsub("</yazarorcid></yazarbilgisi>", "</yazarorcid></yazardetay>")
  myString = myString.gsub("</yazaradi></yazaradi>", "</yazaradi></yazardetay>")
  myString = myString.gsub("</yazardetay><yazaradi>", "</yazardetay><yazardetay>")
  myString = myString.gsub("</yazarbilgisi></yazardetaylari>", "</yazardetay></yazardetaylari>")
  myString = myString.gsub("</yazarbilgisi></yazardetaylari>", "</yazardetay></yazardetaylari>")

  myString = myString.gsub("<yazarbilgisi>", "<yazaradi>")
  myString = myString.gsub("</yazarbilgisi>", "</yazaradi>")
  myString = myString.gsub("</yazaradi><yazardetay>", "</yazardetay><yazardetay>")
  myString = myString.gsub("<yazaradi><yazaradi>", "<yazardetay><yazaradi>")

  myString = myString.gsub("&", "&amp;")

  myString = myString.gsub("<?", "<003C")
  myString = myString.gsub("<0", "003C003C")
  myString = myString.gsub("< ", "003C ")

  myString = myString.gsub("<http", "http")

  myString = myString.gsub("<makale><makale>", "<makale>")

  myString = myString.gsub("<0", "0")

  myString = myString.gsub("<1", "1")
  myString = myString.gsub("<2", "2")
  myString = myString.gsub("<3", "3")
  myString = myString.gsub("<4", "4")
  myString = myString.gsub("<5", "5")
  myString = myString.gsub("<6", "6")
  myString = myString.gsub("<7", "7")
  myString = myString.gsub("<8", "8")
  myString = myString.gsub("<9", "9")
  myString = myString.gsub("<seed", "seed")
  myString = myString.gsub("<.", ".")
  myString = myString.gsub("<blog", "blog")
  myString = myString.gsub("<www", "www")
  myString = myString.gsub("de>", "de")
  myString = myString.gsub("<,", ",")
  myString = myString.gsub("Makaleler</birincildil></makale>", "Makaleler</bolum></makale>")
  myString = myString.gsub("Diğer</birincildil></makale>", "Diğer</bolum></makale>")
  myString = myString.gsub("Dizin</birincildil></makale>", "Dizin</bolum></makale>")
  myString = myString.gsub("Makale</birincildil></makale>", "Makale</bolum></makale>")
  myString = myString.gsub("<%", "%")
  myString = myString.gsub("<<", "")
  myString = myString.gsub(">>", "")

  myString = myString.gsub("<ansari", "ansari")
  myString = myString.gsub("<Einc", "Einc")
  myString = myString.gsub("<FC", " FC")
  myString = myString.gsub("<TK", " TK")
  myString = myString.gsub("<-", " -")
  myString = myString.gsub("<IR", " IR")
  myString = myString.gsub("<H", " H")
  myString = myString.gsub("<K", " K")
  myString = myString.gsub("<RL", " RL")
  myString = myString.gsub("<ER", " ER")
  myString = myString.gsub("<E", " E")
  myString = myString.gsub("<M", " M")
  myString = myString.gsub("<N", " N")
  myString = myString.gsub("<file", " file")
  myString = myString.gsub("<(", " (")
  myString = myString.gsub("<q", " q")
  myString = myString.gsub("<p0", " p0")
  myString = myString.gsub("<p1", " p1")
  myString = myString.gsub("<p2", " p2")
  myString = myString.gsub("<p3", " p3")
  myString = myString.gsub("<p4", " p4")
  myString = myString.gsub("<p5", " p5")
  myString = myString.gsub("<p6", " p6")
  myString = myString.gsub("<p7", " p7")
  myString = myString.gsub("<p8", " p8")
  myString = myString.gsub("<p9", " p9")
  myString = myString.gsub("<om", " om")
  myString = myString.gsub("< ", "&lt; ")
  myString = myString.gsub("<)", "&lt;)")
  myString = myString.gsub("<'", "&lt;'")
  myString = myString.gsub("<∞", "&lt;∞")
  myString = myString.gsub("<t ", "&lt;t ")
  myString = myString.gsub("<=", "&lt;=")
  myString = myString.gsub("<!", "&lt;!")
  myString = myString.gsub(">!", "&gt;!")
  myString = myString.gsub("<>", "&lt;&gt;")
  myString = myString.gsub("<G", "&lt;G")
  myString = myString.gsub("<&", "&lt;&")
  myString = myString.gsub("<F", "&lt;F")
  myString = myString.gsub("<I", "&lt;I")
  myString = myString.gsub("<D", "&lt;D")
  myString = myString.gsub("<$", "&lt;$")
  myString = myString.gsub("<#", "&lt;#")
  myString = myString.gsub("<@", "&lt;@")
  myString = myString.gsub("<T", "&lt;T")
  myString = myString.gsub("<B", "&lt;B")
  myString = myString.gsub("<A", "&lt;A")
  myString = myString.gsub("<R", "&lt;R")
  myString = myString.gsub("<r0", "&lt;r0")
  myString = myString.gsub("<y2", "&lt;y2")
  myString = myString.gsub("<y1", "&lt;y1")
  myString = myString.gsub("<Y", "&lt;Y")
  myString = myString.gsub("<P", "&lt;P")

  File.open(makaleDosyasi, "w") do |f|
    f.write(myString)
  end
end
