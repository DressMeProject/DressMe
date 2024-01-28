import 'package:dressme/models/items.dart';
import 'package:flutter/material.dart';

class CircularColorPalette extends StatelessWidget {
  final List<int> rgbValues;

  CircularColorPalette({required this.rgbValues});

  @override
  Widget build(BuildContext context) {
    Color color = Color.fromARGB(255, rgbValues[0], rgbValues[1], rgbValues[2]);

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;
  ItemDetailsScreen({required this.model});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

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
        title: Text(
          widget.model!.title!,
          style: const TextStyle(fontSize: 30, fontFamily: "Lobster", color: Colors.white),
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    widget.model!.thumbnailUrl.toString(),
                    width: MediaQuery.of(context).size.width * 0.8, // %80 genişlik
                    height: MediaQuery.of(context).size.height * 0.5, // %30 yükseklik
                    fit: BoxFit.contain, // Resmi boyutları koruyarak içine sığacak şekilde küçült
                    alignment: Alignment.center, // Resmi ortala
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.color_lens, color: Color(0xFFFFBED7)),
                      SizedBox(width: 8),
                      Text(
                        'Renk:  ',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          fontFamily: "Lobster",
                        ),
                      ),
                      CircularColorPalette(rgbValues: widget.model!.parseColorRGB()),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.label, color: Color(0xFFFFBED7)),
                      SizedBox(width: 8),
                      Text(
                        'Parça Adı : ${widget.model!.title.toString()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          fontFamily: "Lobster",
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                if (widget.model!.shortInfo != null && widget.model!.shortInfo!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.description, color: Color(0xFFFFBED7)),
                        SizedBox(width: 8),
                        Text(
                          'Parça Açıklaması : ${widget.model!.shortInfo.toString()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            fontFamily: "Lobster",
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.model!.shortInfo != null && widget.model!.shortInfo!.isNotEmpty)
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.wb_sunny, color: Color(0xFFFFBED7)),
                      SizedBox(width: 8),
                      Text(
                        'Mevsimler : ${widget.model!.season}',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          fontFamily: "Lobster",
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_bag, color: Color(0xFFFFBED7)),
                      SizedBox(width: 8),
                      Text(
                        'Giyim Türü : ${widget.model!.style?.replaceAll('\n', ' ')}',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          fontFamily: "Lobster",
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension ColorParser on Items {
  List<int> parseColorRGB() {
    return colorRGB!.split(',').map((e) => int.parse(e)).toList();
  }
}
