require 'mechanize'
require 'nokogiri'
require 'openssl'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

MAKALE_DOSYASI = "D:/Sobiad/makaleAdresleri.txt"
DOSYALANAN_MAKALE_SAYISI_DOSYASI = "D:/Sobiad/dosyalanan_makale_sayisi.txt"
PDF_ADRESLERI_DOSYASI = "D:/Sobiad/pdfadresleri.txt"
uribaslangic = "https://atif.sobiad.com/index.jsp"

mechanize = Mechanize.new{|a| a.log = Logger.new(STDERR) }
page = mechanize.get (uribaslangic + '?modul=giris-yap')
form = page.forms[2]
form.email = ''
form.password = ''
page = mechanize.submit form

line_num=0
text=File.open(MAKALE_DOSYASI).read
text.gsub!(/\r\n?/, "\n")

makaleBilgileri = ""
yazarBilgileri = ""
keywordBilgileri = ""
anahtarBilgileri = ""
kaynakBilgileri = ""
yazarDetayBilgileri = ""

text.each_line do |line|

  line_num += 1

  next if line_num < 52401

  if line_num % 20 == 0
    sleep(4)
  end

  begin
    page = mechanize.get(line)
  rescue Mechanize::ResponseCodeError
    puts ("hata response code error: " + line_num.to_s)
    next
  rescue SocketError
    puts ("hata socket error: " + line_num.to_s)
    next
  end

  makaleBilgileri += "<makale>"

  #sıra numarası
  makaleBilgileri += "<sira>" + line_num.to_s + "</sira>"

  #başlık
  page.xpath('
  //div[contains(@class, "yayin-sayfasi")]
  //div[contains(@class, "container-fluid")]
  //div[contains(@class, "outher")]
  //div[contains(@class, "container")]
  //div[contains(@class, "row")]
  //div[contains(@class, "col-md-9 col-sm-6 right")]
  //div[contains(@class, "information")]
  //div[contains(@class, "title")]
  ').each do |vv|
    makaleBilgileri += "<baslik>" + vv.text.strip + "</baslik>"
  end

  #yil
  page.xpath('
  //div[contains(@class, "yayin-sayfasi")]
  //div[contains(@class, "container-fluid")]
  //div[contains(@class, "outher")]
  //div[contains(@class, "container")]
  //div[contains(@class, "row")]
  //div[contains(@class, "col-md-9 col-sm-6 right")]
  //div[contains(@class, "information")]
  //p[1]
  //i
  //strong
  ').each do |vv|
    makaleBilgileri += "<yil>" + vv + "</yil>"
  end

  #yazar adi
  page.xpath('
  //div[contains(@class, "yayin-sayfasi")]
  //div[contains(@class, "container-fluid")]
  //div[contains(@class, "outher")]
  //div[contains(@class, "container")]
  //div[contains(@class, "row")]
  //div[contains(@class, "col-md-9 col-sm-6 right")]
  //div[contains(@class, "information")]
  //p[1]
  //i/text()[2]
  ').each do |vv|

    makaleBilgileri += "<yazarbilgileri>"
    vv.text.split(",").each do |y|
      makaleBilgileri += "<yazaradi>" + y.strip.gsub(/[^0-9a-z iüğşöçÜİĞŞÇÖ]/i, '').strip + "</yazaradi>"
    end
    makaleBilgileri += "</yazarbilgileri>"
  end

  #doi
  page.xpath('
  //div[contains(@class, "yayin-sayfasi")]
  //div[contains(@class, "container-fluid")]
  //div[contains(@class, "outher")]
  //div[contains(@class, "container")]
  //div[contains(@class, "row")]
  //div[contains(@class, "col-md-9 col-sm-6 right")]
  //div[contains(@class, "information")]
  //p[1]
  //i
  //a
  ').each do |vv|
    makaleBilgileri += "<doi>" + vv.text.strip + "</doi>"
  end

  #ozet
  page.xpath('
  //div[contains(@class, "yayin-sayfasi")]
  //div[contains(@class, "container-fluid")]
  //div[contains(@class, "outher")]
  //div[contains(@class, "container")]
  //div[contains(@class, "row")]
  //div[contains(@class, "col-md-9 col-sm-6 right")]
  //div[contains(@class, "information")]
  //p[2]/text()[1]
  ').each do |vv|
    makaleBilgileri += "<ozet>" + vv.text.strip + "</ozet>"
  end

  #anahtar kelime
  page.xpath('
  //div[contains(@class, "yayin-sayfasi")]
  //div[contains(@class, "container-fluid")]
  //div[contains(@class, "outher")]
  //div[contains(@class, "container")]
  //div[contains(@class, "row")]
  //div[contains(@class, "col-md-9 col-sm-6 right")]
  //div[contains(@class, "information")]
  //p[3]/text()[1]
  ').each do |vv|
    makaleBilgileri += "<anahtarbilgileri>"
    vv.text.split(",").each do |ak|
      makaleBilgileri += "<anahtar>" + ak.strip + "</anahtar>"
    end
    makaleBilgileri += "</anahtarbilgileri>"
  end
  makaleBilgileri += "</makale>\n"

  #pdf
  page.xpath('
  //div[contains(@class, "yayin-sayfasi")]
  //div[contains(@class, "container-fluid")]
  //div[contains(@class, "outher")]
  //div[contains(@class, "container")]
  //div[contains(@class, "row")]
  //div[contains(@class, "col-md-3 col-sm-6 no-print")]
  //div[contains(@class, "list-group")]
  //div[contains(@class, "list-group-item")]
  //div[contains(@class, "mr-auto p-1")]
  //a
  ').each do |vv|
    if vv.text == 'PDF İndir'
      File.open(PDF_ADRESLERI_DOSYASI, "a") { |f|
        f.puts line_num.to_s + '_' + uribaslangic + vv['href']
      }
    end
  end

  if line_num > 0 and line_num % 52449 == 0
    makaleDetayDosyasi = "D:/Sobiad/makaleDetayDosyasi263.txt"
    File.open(makaleDetayDosyasi, "w") do |f|
      f.write(makaleBilgileri)
    end
    makaleBilgileri = ""
  end

  puts "#{line_num}"
end

