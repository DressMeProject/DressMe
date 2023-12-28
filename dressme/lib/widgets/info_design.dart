import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressme/models/categorys.dart';
import 'package:dressme/routes/itemsScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';

class InfoDesignWidget extends StatefulWidget {
  Categorys? model;
  BuildContext? context;

  InfoDesignWidget({this.model, this.context});

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  deleteMenu(String categoryID) {
    FirebaseFirestore.instance.collection("users").doc(sharedPreferences!.getString("uid")).collection("categorys").doc(categoryID).delete();

    Fluttertoast.showToast(msg: "Kategori Silindi");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c) => ItemsScreen(model: widget.model)));
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
                bottom: 15.0,
                left: 0,
                right: 5.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.model!.categoryTitle!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 254, 254),
                      fontSize: 22,
                      fontFamily: "Lobster",
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 9.0,
                right: 5.0,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context, // Yeni oluşturduğumuz context'i kullandık
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text('Kategori Sil'),
                          content: Text('Kategoriyi silmek istediğinize emin misiniz?', style: TextStyle(color: Colors.black)),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Evet', style: TextStyle(color: Colors.black)),
                              onPressed: () {
                                deleteMenu(widget.model!.categoryID!);
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Hayır', style: TextStyle(color: Colors.black)),
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
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
