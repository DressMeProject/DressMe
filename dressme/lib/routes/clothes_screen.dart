import 'package:flutter/material.dart';

class ClothesScreen extends StatelessWidget {
  final List<String> clothesImages = [
    'assets/images/kiyafet.png',
    'assets/images/kiyafet2.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Dolap Ekranı'),
      // ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: clothesImages.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => Card(
          elevation: 6,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  clothesImages[i],
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 0,
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Düzenleme işlemlerini burada yapın.
                  },
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Silme işlemlerini burada yapın.
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
