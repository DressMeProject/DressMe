import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressme/global/global.dart';
import 'package:dressme/models/items.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ItemsDesignWidget extends StatefulWidget {
  Items? model;
  BuildContext? context;

  ItemsDesignWidget({this.model, this.context});

  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  deleteItem(String categoryID, String itemID) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("categorys")
        .doc(categoryID)
        .collection("items")
        .doc(itemID)
        .delete();

    Fluttertoast.showToast(msg: "Parça Silindi");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Navigator.push(context, MaterialPageRoute(builder: (c) => ItemDetailsScreen(model: widget.model)));
      },
      splashColor: Color.fromARGB(255, 227, 223, 224),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  widget.model!.thumbnailUrl!,
                  height: 230.0,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 5.0,
                right: 5.0,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Parça Sil'),
                          content: Text('Parçayı silmek istediğinize emin misiniz?', style: TextStyle(color: Colors.white)),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Evet', style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                deleteItem(widget.model!.categoryID ?? '', widget.model!.itemID ?? '');
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Hayır', style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 15.0,
                left: 0,
                right: 5.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.model!.title!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 254, 254),
                      fontSize: 22,
                      fontFamily: "Lobster",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
