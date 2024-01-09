import 'package:dressme/models/items.dart';
import 'package:flutter/material.dart';

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
          widget.model!.shortInfo!,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.model!.shortInfo.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.model!.title.toString(),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Renk: ${widget.model!.colorRGB}',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sezon: ${widget.model!.season}',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Stil: ${widget.model!.style}',
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      //   child: InkWell(
      //     onTap: () {},
      //     child: Container(
      //       decoration: BoxDecoration(
      //         gradient: LinearGradient(
      //           colors: [
      //             Color.fromARGB(255, 207, 70, 241),
      //             Color.fromARGB(255, 72, 70, 228),
      //           ],
      //           begin: FractionalOffset(0.0, 0.0),
      //           end: FractionalOffset(1.0, 0.0),
      //           stops: [0.0, 1.0],
      //           tileMode: TileMode.clamp,
      //         ),
      //         borderRadius: BorderRadius.circular(10.0),
      //       ),
      //       width: MediaQuery.of(context).size.width - 40,
      //       height: 45,
      //       child: Center(
      //         child: Text(
      //           "Güncelle",
      //           style: TextStyle(color: Colors.white, fontSize: 18),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
