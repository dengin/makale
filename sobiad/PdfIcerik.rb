require 'mechanize'
require 'nokogiri'
require 'openssl'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

PDF_ADRESLERI_DOSYASI = "D:/Sobiad/pdfadresleri.txt"
PDF_ADRESLERI_DOSYASI2 = "D:/Sobiad/pdfadresleri2.txt"
urlbaslangic = 'https://atif.sobiad.com/'

line_num=0
text=File.open(PDF_ADRESLERI_DOSYASI).read
text.gsub!(/\r\n?/, "\n")

mechanize = Mechanize.new


text.each_line do |line|

  line_num += 1

  i = line[0..(line.index('_') - 1)]
  puts i
  url = line[line.index('_') + 1..line.size]

  if line_num % 50 == 0
    sleep(3)
  end

  begin
    page = mechanize.get(url)
  rescue Mechanize::ResponseCodeError
    puts ("hata response code error: " + i.to_s)
    next
  rescue SocketError
    puts ("hata socket error: " + i.to_s)
    next
  end

  page.xpath('
  //embed
  ').each do |vv|
    url = urlbaslangic + vv['src']

    File.open(PDF_ADRESLERI_DOSYASI2, "a") do |f|
      f.puts i.to_s + "_" + url
    end

  end


end

# pdf adresleri PDF_ADRESLERI_DOSYASI2 dosyasına eklendikten sonra java programıyla (D:\Dev\thesis2\source\src\main\java\DownloadPdfFromUrl.java)
# bu adreslerdeki pdf dosyaları indirilip text formatına çevrildikten sonra makale numarası ile birlikte txt dosyalarına dönüştürüldü.

