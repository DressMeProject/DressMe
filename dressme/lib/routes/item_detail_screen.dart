import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressme/models/items.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;
  ItemDetailsScreen({this.model});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  deleteItem(String itemID) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("categorys")
        .doc(widget.model!.categoryID!)
        .collection("items")
        .doc(itemID)
        .delete()
        .then((value) {
      FirebaseFirestore.instance.collection("items").doc(itemID).delete();

      //Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
      Fluttertoast.showToast(msg: "Ürün Silindi.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: SimpleAppBar(
        //   title: sharedPreferences!.getString("name"),
        // ),
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
            )),
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.model!.thumbnailUrl.toString()),
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
                  widget.model!.price.toString() + " ₺",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    deleteItem(widget.model!.itemID!);
                  },
                  child: Container(
                    decoration: BoxDecoration(
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
                      borderRadius: BorderRadius.circular(12.0), // Kenarlara radius ekleme
                    ),
                    width: MediaQuery.of(context).size.width - 20,
                    height: 45,
                    child: Center(
                      child: Text(
                        "Parçayı Sil",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
