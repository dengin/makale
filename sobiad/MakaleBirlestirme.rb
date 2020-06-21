#require 'mechanize'
#require 'nokogiri'

MAKALE_DOSYASI_BASLANGIC = "D:/makaleDetayDosyasi"

yeniMakale = '<makaleler>'

for sayfaid in 1..263 do
  makaleDosyasi = MAKALE_DOSYASI_BASLANGIC + sayfaid.to_s() + ".txt"

  text=File.open(makaleDosyasi).read

  yeniMakale += text

end

yeniMakale += "</makaleler>"

File.open(MAKALE_DOSYASI_BASLANGIC + "_hepsi.txt", "w") do |f|
  f.write(yeniMakale)
end

# bütün makaleler birleştiriliyor.