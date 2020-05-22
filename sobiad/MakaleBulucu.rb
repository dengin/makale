require 'mechanize'
require 'nokogiri'
require 'logger'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
I_KNOW_THAT_OPENSSL_VERIFY_PEER_EQUALS_VERIFY_NONE_IS_WRONG = nil

uri='https://atif.sobiad.com/index.jsp?yil=2010&yil=2020&searchword=bir&secenekler=text&alan=fen&modul=arama-sonuclari&sayfaid='

MAKALE_DOSYASI2 = "D:/Kisisel/Dersler/Ozyegin/TezCalismasi/RubyProjesi/Sobiad/makaleAdresleri.txt"
DOSYALANAN_MAKALE_SAYISI_DOSYASI2 = "D:/Kisisel/Dersler/Ozyegin/TezCalismasi/RubyProjesi/Sobiad/dosyalanan_makale_sayisi.txt"


def makaleleriBul(page)

  urlStart = "https://atif.sobiad.com/"
  makale_sayisi = File.read(DOSYALANAN_MAKALE_SAYISI_DOSYASI2).to_i

  page.xpath('//div[@id="sonucListe"]
  //ul[contains(@class, "list")]
  //li//h6//a').each do |vv|
    open((MAKALE_DOSYASI2), "a") { |dosya|
      dosya.puts urlStart + vv['href']
    }
    makale_sayisi += 1
  end



  File.write(DOSYALANAN_MAKALE_SAYISI_DOSYASI2, makale_sayisi)
=begin

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
=end
end

#yıl aralığındaki makaleleri bulma
#while makaleYili <= icindeBulundugumuzYil
#  page = mechanize.get(uri)
#  makaleleriBul(page)
#  makaleYili += 1
#end


# tarama yapacağımız web sayfası öncelikle login olmamızı gerektiriyorsa, login olup cookie bilgisini saklamamız gerekiyor
# bunun için öncelikle aşağıdaki gibi giriş sayfasını buluyoruz. sayfda birden fazla form olabilir.
# login için gerekli olan formu buluyoruz. Aşağıdaki örnekte forms[2] ile ilgili formu bulduk
# sonrasında formdaki name değerlerine göre kullanıcı adı ve şifre bilgisini veriyoruz.
# submit ile formu gönderiyoruz ve login olmuş oluyoruz. mechanize bu bilgileri agent içerisinde saklı tutuyor.
# bundan sonra ilgili sunucudaki başka sayfaları istediğimizde login bilgimiz de birlikte gönderilmiş oluyor.
agent = Mechanize.new{|a| a.log = Logger.new(STDERR) }
page = agent.get 'https://atif.sobiad.com/index.jsp?modul=giris-yap'
form = page.forms[2]
form.email = ''
form.password = ''
page = agent.submit form


# toplam 400 sayfa var. her birisinden makaleleri alacağız
for sayfaid in 0..399 do

  # login olduktan sonra tarama yapacağımız sayfayı açıyoruz
  page = agent.get(uri + sayfaid.to_s)

  # sayfadaki makaleleri bulmak için ilgili metodu çağırıyoruz.
  makaleleriBul(page)

end
