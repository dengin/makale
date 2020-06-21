require 'mechanize'
require 'nokogiri'
require 'openssl'

#OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

DOSYALANAN_MAKALE_SAYISI_DOSYASI = "D:/Sobiad/makaleDetayDosyasi_hepsi.txt"


text=File.open(DOSYALANAN_MAKALE_SAYISI_DOSYASI).read

text.gsub(/[^0-9a-z iüğşöçÜİĞŞÇÖ]/i, '').strip

File.open("D:/Sobiad/makaleDetayDosyasi_hepsi2.txt", "w") do |f|
  f.write(text)
end