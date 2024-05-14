
﻿<div align="center">
# DressMe
| [İnglizce](/README.md) | [Türkçe](./README_TR.md) |
</div>

DressMe, kullanıcıların giysilerini uygun kombinler oluşturmalarına yardımcı olmak için tasarlanmış bir mobil uygulamadır. Uygulama, kullanıcıların dolaplarındaki giysi öğelerinin renk ve desen bilgilerini fotoğraflayarak analiz eder ve hava koşullarına göre kişiselleştirilmiş kıyafet önerileri sunar. Ayrıca, kullanıcıların dolaplarına eklemeleri gereken öğeleri 'eksik parçalar' olarak kategorize eder ve öneriler sunar.

Giysi Tüyoları sayfasında, kullanıcılar giysilerini daha iyi nasıl düzenleyecekleri, yeni giysiler satın alırken nelere dikkat etmeleri gerektiği, mevcut sezonun trend parçaları ve daha iyi giyinme ipuçları hakkında bilgilendirici içerik bulacaklar. Bu şekilde, kullanıcılar yalnızca kombinler oluşturmazlar, aynı zamanda giysiler hakkında genel bilgi edinirler.

## Proje Özellikleri

- __Firebase Auth__ : 
Kullanıcının kimliğini değiştirmek için kullanıldı.
- __Cloud Firestore__ : 
Uygulama verilerini depolamak ve senkronize etmek için kullanılan Firebase'in bulut tabanlı NoSQL veritabanıdır.
- __Firebase Storage__ : 
Firebase bulut depolama hizmetini kullanarak dosyaları depolamak için kullanıldı.
- __Firebase App Check__ : Bu yazılım, uygulamanın güvenliğini artırmak için kullanıldı. Otomatik olarak cihazları doğrular ve güvenilir kabul eder.
- __Lottie__ : 
It was used to add animations to Flutter applications.
- __Image Picker__ : 
Flutter uygulamalarına animasyonlar eklemek için kullanıldı.
- __Flutter Staggered Grid View__ : 
Düzenleme seçenekleri sunan ızgara görünümü için kullanıldı.
- __Fluttertoast__ : Uygulamada mesajları göstermek için toast kullanıldı.

- __Font Awesome Flutter__ : Flutter uygulamalarında simgeleri kullanmak için kullanıldı.
- __Palette Generator__ : Görüntülerden renk paleti oluşturarak, tasarım uyumluluğunu sağlamak için kullanıldı.
- __Permission Handler__ : 
Android ve iOS'ta izinleri yönetmek için kullanıldı.
- __Geolocator__ : Cihazın konumunu almak ve yönetmek için kullanıldı.
- __Image__ : Görüntü işleme ve gösterimi için kullanıldı.
- __Provider__ : 
Flutter uygulamalarında durum yönetimi ve veri akışı kontrolü için kullanıldı.
- __Shared Preference__ : Basit veri depolama için kullanıldı.
- __Geocoding__ : 
Adres ve konum bilgilerini almak ve işlemek için kullanıldı.

## Screens

<div align="center">
  <table>
  <tr>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">Splash Ekranı</div>
        <img src="./screen.jpg" width="200"/>
      </td>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">Giriş Ekranı</div>
        <img src="./login.jpg" width="200"/>
      </td>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">Kayıt Ekranı</div>
        <img src="./signup.jpg" width="200"/>
      </td>
      </tr>
      <tr>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">Anasayfa</div>
        <img src="./anasayfa.jpg" width="200"/>
      </td>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">Anasayfa 2</div>
        <img src="./anasayfa2.jpg" width="200"/>
      </td>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">Dolap Ekranı</div>
        <img src="./dolap.jpg" width="200"/>
      </td>
      </tr>
      <tr>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">Yeni Kategori Ekle</div>
        <img src="./yenikategoriekle.jpg" width="200"/>
      </td>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">Kategori Resmi Seç</div>
        <img src="./kategoriresmi.jpg" width="200"/>
      </td>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">Parça Ekranı</div>
        <img src="./pantalon.jpg" width="200"/>
      </td>
            </tr>
            <tr>
            <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">Yeni Parça Ekle</div>
        <img src="./yeniparcaekle.jpg" width="200"/>
      </td>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">Parça Resmi Seç</div>
        <img src="./urunresimekle.jpg" width="200"/>
      </td>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">Parça Özellikleri Seç</div>
        <img src="./urunekle.jpg" width="200"/>
      </td>
      </tr>
      <tr>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">İpucu Ekranı</div>
        <img src="./ipucu2.jpg" width="200"/>
      </td>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">İpucu Ekranı 2</div>
        <img src="./ipucu.jpg" width="200"/>
      </td>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">Profil Ekranı</div>
        <img src="./profil.jpg" width="200"/>
      </td>
      </tr>
      <tr>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">Şifre Değiştirme Ekranı</div>
        <img src="./sifredegistir.jpg" width="200"/>
      </td>
      <td style="border: 1px solid #ccc; text-align: center;">
        <div style="solid #ccc; margin-bottom: 5px; padding: 5px;">Çıkış Yap Ekranı</div>
        <img src="./cikisyap.jpg" width="200"/>
      </td>
      </tr>      
  </table>
</div>