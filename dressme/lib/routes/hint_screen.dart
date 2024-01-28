import 'package:flutter/material.dart';

class HintListScreen extends StatelessWidget {
  final List<HintItem> hints = [
    HintItem(
        title: '2024 Moda Trendlerinde Hangi Parçalar Öne Çıkacak?',
        content: 'Payetli Her Şey: 2024 moda trendlerinde payetli parçalar, stilinize ışıltı ve gösteriş katmanın harika bir yolu olacak. '
            'Payetler, gece kombinlerinden günlük şıklığa kadar birçok kombinde şıklığınızı öne çıkaracak. Payetli parti elbiseleri, '
            'payetli etek, payetli bluz ve daha birçok payetli giyim parçaları bu yıl gardırobunuzda bulundurabilirsiniz.\n\n'
            'Puantiye Desenler: Puantiye desenler, 2024 yılında da popülerliğini koruyacak. Elbiselerde, bluzlarda, eteklerde ve aksesuarlarda '
            'puantiyeli desenler göreceğiz. Siz de görünümünüze zarafet katmak istiyorsanız puantiye desenli giyim parçalarını hemen alabilirsiniz.\n\n'
            'Kırmızı Çekiciliği: Kırmızı, 2024 modasında çekici ve dikkat çekici bir renk olarak ön planda olacak. Kırmızı elbiseler, '
            'ceketler, pantolonlar ve aksesuarlar, cesur ve güçlü bir tarzı ifade etmek isteyenler için ideal seçenekler arasında yer alacak. '
            'Bu enerjik renk, her türlü giyim parçasına canlılık katarken, özellikle kırmızı elbiselerin özel günlerde ve etkinliklerde tercih edilmesi '
            'moda dünyasında sıkça görülecek.\n\n'
            'Kısa Topuklu Ayakkabılar: 2024 modasında, rahatlığın ve şıklığın birleştiği kısa topuklu ayakkabılar ön planda olacak. '
            'Günlük giyimden özel gün kombinlerine kadar geniş bir kullanım sunduğu için her kombinde kullanabileceksiniz. Hem feminen hem de '
            'pratik olan bu ayakkabılar, şıklığı ve konforu aynı anda sunarak her tarza da uyum sağlayacak.\n\n'
            'Büyük Çantalar: 2024\'te fonksiyonellik ve şıklığı bir araya getiren büyük çantalar, modanın önemli bir parçası olacak. Hem günlük '
            'kullanım hem de seyahatler için ideal olan geniş ve şık çantalar, içerisine birçok eşyayı sığdırabilme özelliğiyle öne çıkacak. '
            'Farklı renklerde ve tasarımlarda bulunan büyük çantalar hem pratik hem de şık bir aksesuar olarak kullanılacak.\n\n'
            'Triko Parçalar: Triko parçalar, 2024 modasında özellikle kış ve sonbahar aylarında sıkça karşınıza çıkacak. '
            'Triko kazaklar, hırkalar ve elbiseler, sıcak tutmalarının yanı sıra şıklık ve konforu bir araya getirecek. '
            'Oversize triko kazaklar, geniş ve rahat kesimleriyle öne çıkarken, triko elbiseler ise şıklığı ve sıcaklığı bir arada sunacak. '
            'Renkli ve desenli trikolar da kombinlerinize enerji katacak ve soğuk günlerde stilinizi tamamlayacak.\n\n'
            'Metalik Renkli Parçalar: 2024 modasında metalik renkler, parlaklık ve modernlik arayanların tercihi olacak. Metalik renkli parçalar, '
            'giyimde ve aksesuarlarda şıklığı ön plana çıkaracak. Daha cesur ve dikkat çekici kombinler yapmak istiyorsanız bu yıl metalik renkli '
            'parçaları tercih edebilirsiniz.',
        imageUrl: 'assets/images/moda.jpg'),
    HintItem(
        title: 'Cilt Tonunuza Göre Kıyafet Seçimi Nasıl Yapmalısınız?',
        content: 'Cilt tonunuza uygun kıyafetler seçebilmek için cilt alt tonunuz ile uyumlu renkleri tercih etmeniz gerekir. '
            'Kendi kişisel tarzınıza uygun modelleri, kesimleri ve tasarımları tercih ederken cilt alt tonlarıyla uyum yakalayan '
            'renklerde olmasına özen göstermeniz faydalı olur. Farklı cilt alt tonlarına uygun olacak renkler şunlardır:\n\n'
            '1 – Soğuk Cilt Alt Tonuna Uygun Renkler: Mavinin Farklı Tonları, Pembe – Bordo – Gülkurusu, Morun Büyüsü, '
            'Kahverengi ve Yeşil Tonları\n\n'
            '2 – Sıcak Cilt Alt Tonuna Uygun Renkler Gardırobunuzu zenginleştirmek ve cildinizi en iyi şekilde ortaya çıkarmak için '
            'aşağıdaki renkleri tercih edebilirsiniz: Altın ve Kırmızı Tonlar, Toprak Tonları, Turuncu ve Hardal Sarısı.\n\n'
            '3 – Nötr Cilt Alt Tonuna Uygun Renkler, Nötr Renkler, Pastel Tonlar, Kontrastlı Renkler',
        imageUrl: 'assets/images/cilttonu.jpg'),
    HintItem(
        title: 'Yazlık-Kışlık Giysiler Nasıl Kaldırılır, Saklanır?',
        content: 'Kazak, hırka, kaban gibi kaba kıyafetlerin vakumlanması tercih edilmelidir. '
            'Vakumlu poşetler kıyafetleri ince bir hale getirir hatta poşetler, '
            'kıyafetler içerisindeyken rulo haline bile getirilebilir. Bu da alandan kazanım sağlar. '
            'Bununla birlikte gömlek ve pantolonlar için de aynı yöntem uygulanabilir.\n\n'
            'Ancak vakumlama ve katlama işlemlerinde sıkıntı oluşturan kıyafetler de bulunur. '
            'Bu tarz kıyafetler, askılanarak saklanmalıdır. Özellikle bu tarz sıkıntıların en çok yaşandığı '
            'gömlek ve kazaklar için, bu yöntem ideal olacaktır.',
        imageUrl: 'assets/images/kiyafet-saklama-yontemleri.jpg'),
    HintItem(
        title: 'Bavul Hazırlama Konusunda Mutlaka Bilmeniz Gerekenler',
        content: 'Kazak, hırka, kaban gibi kaba kıyafetlerin vakumlanması tercih edilmelidir. '
            'Vakumlu poşetler kıyafetleri ince bir hale getirir hatta poşetler, '
            'kıyafetler içerisindeyken rulo haline bile getirilebilir. Bu da alandan kazanım sağlar. '
            'Bununla birlikte gömlek ve pantolonlar için de aynı yöntem uygulanabilir.\n\n'
            'Ancak vakumlama ve katlama işlemlerinde sıkıntı oluşturan kıyafetler de bulunur. '
            'Bu tarz kıyafetler, askılanarak saklanmalıdır. Özellikle bu tarz sıkıntıların en çok yaşandığı '
            'gömlek ve kazaklar için, bu yöntem ideal olacaktır.',
        imageUrl: 'assets/images/bavul.jpg'),
    HintItem(
        title: 'Uyumlu Kombin Nasıl Yapılır?',
        content: 'Kadın giyim modasında şık bir görünüm elde etmek, alt ve üst giyim unsurları arasında doğru bir denge kurmaktan geçer. '
            'Bu nedenle, üst ve alt giyim parçalarının birbirini tamamladığı kıyafetler oluşturman önemlidir. Limon rengi, büzgü detaylı '
            'bluz veya çiçek desenli bol bir gömleği, altına giyeceğin dar pantolonlarla eşleştirmeyi deneyebilirsin. Geniş paçalı, renkli '
            've desenli pamuklu bir pantolon veya ribana detaylı keten etek giyiyorsan kombinini bedenine oturan veya kısa bir üstle tamamlamayı '
            'düşünebilirsin.\n\n'
            'Seni harika gösteren çok sayıda kıyafete sahip olmak için kıyafet alışverişini stratejik olarak yapman gerekir. Vücut tipine '
            'göre giyinme unsuruna uyan tasarımlara yatırım yapmak güzel giyinme tüyoları arasında öne çıkan noktalardan biridir. Yazlık giyim '
            'kombinleri için seçtiğin kıyafetlerin sana uygun olduğundan emin olmak için gardırobunda seni en iyi gösteren parçaların kesim, '
            'tasarım özelliklerine dikkat edebilirsin. Eğer dolabındaki o çiçek desenli kısa pantolon veya halat kemerli gömlek elbise sana '
            'yakışıyorsa aynı silüete sahip başka parçalar da alman yaz sezonu için iyi bir fikir olabilir. Bu seçimin ardından, görünümünü '
            'tamamlayan farklı renk, desen ve aksesuarlarla deneyler yapabilirsin.',
        imageUrl: 'assets/images/kombin.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: hints.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HintDetailScreen(
                    title: hints[index].title,
                    content: hints[index].content,
                    imageUrl: hints[index].imageUrl,
                  ),
                ),
              );
            },
            child: HintCard(hint: hints[index]),
          );
        },
      ),
    );
  }
}

class HintItem {
  final String title;
  final String content;
  final String imageUrl;

  HintItem({required this.title, required this.content, required this.imageUrl});
}

class HintCard extends StatelessWidget {
  final HintItem hint;

  HintCard({required this.hint});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Kartın gölge derinliği
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Kartın kenar yuvarlaklığı
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            child: Image.asset(
              hint.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hint.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HintDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final String imageUrl;

  HintDetailScreen({required this.title, required this.content, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 207, 70, 241),
                Color.fromARGB(255, 72, 70, 228),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                content,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
