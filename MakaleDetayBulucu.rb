require 'mechanize'
require 'nokogiri'
require 'openssl'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

MAKALE_DOSYASI = "D:/Kisisel/Dersler/Ozyegin/TezCalismasi/RubyProjesi/makaleAdresleri.txt"
DOSYALANAN_MAKALE_SAYISI_DOSYASI = "D:/Kisisel/Dersler/Ozyegin/TezCalismasi/RubyProjesi/dosyalanan_makale_sayisi.txt"

mechanize = Mechanize.new
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
  if line_num % 20 == 0
    sleep(5)
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
  page.xpath('//div[contains(@class, "panel-body")]
  //div[@id="articleTitle"]
  //h2[contains(@class, "title")]
  //div[contains(@class, "tab-content")]//div').each do |vv|

    if "#{vv.attributes['id']}" == 'title-en'
      makaleBilgileri += "<title>" + vv.text.strip + "</title>"
    else
      makaleBilgileri += "<baslik>" + vv.text.strip + "</baslik>"
    end
  end

  #yazar bilgileri
  page.xpath('//div[contains(@class, "panel-body")]
  //div[@id="articleTitle"]
  //h4
  //small
  //span[contains(@class, "author")]').each do |vv|
    yazarBilgileri += "<yazaradi>" + vv.text.strip + "</yazaradi>"
  end
  if yazarBilgileri != ""
    makaleBilgileri += "<yazarbilgileri>" + yazarBilgileri + "</yazarbilgileri>"
    yazarBilgileri = ""
  end

  #görüntülenme sayısı
  page.xpath('//meta[contains(@id, "meta_stats_total_article_view")]').each do |vv|
    makaleBilgileri += "<goruntulenmesayisi>" + vv['content'] + "</goruntulenmesayisi>"
  end

  #indirilme sayısı
  page.xpath('//meta[contains(@id, "meta_stats_total_article_download")]').each do |vv|
    makaleBilgileri += "<indirilmesayisi>" + vv['content'] + "</indirilmesayisi>"
  end

  #doi
  page.xpath('//div[contains(@class, "panel-body")]
  //div[@id="doiInfo"]
  //p[contains(@class, "text-success")]//a').each do |vv|
    makaleBilgileri += "<doi>" + vv.text.strip + "</doi>"
  end

  #ozet
  page.xpath('//div[contains(@class, "panel-body")]
  //div[@id="articleAbstract"]
  //div[@id="abstract-tab-content"]//div').each do |vv|

      if "#{vv.attributes['id']}" == 'abstract-en'
        makaleBilgileri += "<abstractbilgisi>" + vv.text.strip + "</abstractbilgisi>"
      else
        makaleBilgileri += "<ozetbilgisi>" + vv.text.strip + "</ozetbilgisi>"
      end
  end

  #anahtar kelimeler
  page.xpath('//div[contains(@class, "panel-body")]
  //div[@id="articleKeywords"]
  //div[@id="keywords-tab-content"]//div').each do |vv|

    if "#{vv.attributes['id']}" == 'keywords-en'
      keywordBilgileri = vv.text.strip
    else
      anahtarBilgileri = vv.text.strip
    end
  end
  if keywordBilgileri != ""
    makaleBilgileri += "<keywordbilgileri>"
    keywordBilgileri.split(",").each do |vv|
      makaleBilgileri += "<keyword>" + vv + "</keyword>"
    end
    makaleBilgileri += "</keywordbilgileri>"
    keywordBilgileri = ""
  end
  if anahtarBilgileri != ""
    makaleBilgileri += "<anahtarbilgileri>"
    anahtarBilgileri.split(",").each do |vv|
      makaleBilgileri += "<anahtar>" + vv + "</anahtar>"
    end
    makaleBilgileri += "</anahtarbilgileri>"
    anahtarBilgileri = ""
  end

  #kaynakca
  page.xpath('//div[contains(@class, "panel-body")]
  //div[@id="articleCitations"]
  //div//ul//li').each do |vv|
    kaynakBilgileri += "<kaynak>" + vv.text.strip + "</kaynak>"
  end
  if kaynakBilgileri != ""
    makaleBilgileri += "<kaynakbilgileri>" + kaynakBilgileri + "</kaynakbilgileri>"
    kaynakBilgileri = ""
  end


  #ayrintilar
  page.xpath('//div[contains(@class, "panel-body")]
  //div[@id="article_meta"]
  //table[contains(@class, "record_properties")]
  //tr').each do |vv|
    thId = vv.css('th').text.strip
    if thId == "Birincil Dil"
      makaleBilgileri += "<birincildil>" + vv.css('td').text.strip + "</birincildil>"
    elsif thId == "Konular"
      makaleBilgileri += "<konular>" + vv.css('td').text.strip + "</konular>"
    elsif thId == "Bölüm"
      makaleBilgileri += "<bolum>" + vv.css('td').text.strip + "</bolum>"
    elsif thId == "Yazarlar"
      vv.css('td').css('p').each do |yy|

        yazarDetayBilgileri += "<yazardetay>"
        yy = yy.text.strip
        #orcid
        if yy.include?("Orcid")
          yy = yy[(yy.index("Orcid:") + 7)..-1]
          yazarDetayBilgileri += "<yazarorcid>" + yy[0..18].strip + "</yazarorcid>"
          yy = yy[19..-1]
        end
        #yazar adi
        if yy.include?("Yazar")
          yy = yy[(yy.index("Yazar:") + 7)..-1]
          sonIndex = yy.index("Kurum")
          if sonIndex.nil?
            sonIndex = yy.index("Ülke")
          end
          if sonIndex.nil?
            sonIndex = -1
          end
          yazarDetayBilgileri += "<yazaradi>" + yy[0..sonIndex - 1].strip + "</yazaradi>"
          yy = yy[sonIndex..-1]
          sonIndex = -1
        end
        #kurum
        if yy.include?("Kurum")
          yy = yy[(yy.index("Kurum:") + 7)..-1]
          sonIndex = yy.index("Ülke")
          if sonIndex.nil?
            sonIndex = -1
          end
          yazarDetayBilgileri += "<kurumadi>" + yy[0..sonIndex - 1].strip + "</kurumadi>"
          yy = yy[sonIndex..-1]
          sonIndex = -1
        end
        #ulke
        if yy.include?("Ülke")
          yy = yy[(yy.index("Ülke:") + 6)..-1]
          sonIndex = -1
          yazarDetayBilgileri += "<ulke>" + yy[0..sonIndex].strip + "</ulke>"
        end

        yazarDetayBilgileri += "</yazardetay>"
      end
      if yazarDetayBilgileri != ""
        makaleBilgileri += "<yazardetaylari>" + yazarDetayBilgileri + "</yazardetaylari>"
        yazarDetayBilgileri = ""
      end


    end
  end


  makaleBilgileri += "</makale>\n"

  if line_num > 0 and line_num % 200 == 0
    makaleDetayDosyasi = "D:/Kisisel/Dersler/Ozyegin/TezCalismasi/RubyProjesi/makaleDetayDosyasi" + (line_num / 200).to_s + ".txt"
    File.open(makaleDetayDosyasi, "w") do |f|
      f.write(makaleBilgileri)
    end
    makaleBilgileri = ""
  end

  puts "#{line_num}"
end

