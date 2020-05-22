#require 'mechanize'
#require 'nokogiri'

MAKALE_DOSYASI_BASLANGIC = "D:/Kisisel/Dersler/Ozyegin/TezCalismasi/RubyProjesi/makaleDetayDosyasi"
DOSYALANAN_MAKALE_SAYISI_DOSYASI = "D:/Kisisel/Dersler/Ozyegin/TezCalismasi/RubyProjesi/dosyalanan_makale_sayisi.txt"
makaleSirasi = 0
PDF_DOSYASI_BASLANGIC = "C:/pdf/txt/"

def indices_of_matches(str, target)
  sz = target.size
  (0..str.size-sz).select { |i| str[i,sz] == target }
end

for sayfaid in 1..50 do

  index = 0
  yeniMakale = ''

  makaleDosyasi = MAKALE_DOSYASI_BASLANGIC + sayfaid.to_s() + ".txt"

  text=File.open(makaleDosyasi).read

  indices_of_matches(text, '<sira>').each do |vv|

    indices_of_matches(text[vv..(vv+15)], '</sira').each do |vv2|
      makaleSirasi = text[(vv+6)..(vv+vv2-1)]
      if makaleSirasi != ''

        yeniMakale += text[index..vv+vv2+6]
        #puts yeniMakale
        index = vv+vv2+7

        pdfDosyasi = PDF_DOSYASI_BASLANGIC + makaleSirasi.to_s() + '.txt'
        pdfText=File.open(pdfDosyasi).read
        if pdfText != ''
          yeniMakale += '<pdf>' + pdfText + '</pdf>'
        end
      end
    end

  end

  yeniMakale += text[index..text.size]

  File.open(makaleDosyasi, "w") do |f|
    f.write(yeniMakale)
  end

end

