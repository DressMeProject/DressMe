import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressme/models/categorys.dart';
import 'package:dressme/models/items.dart';
import 'package:dressme/routes/items_add_screen.dart';
import 'package:dressme/widgets/items_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../global/global.dart';
import '../widgets/progress_bar.dart';

class ItemsScreen extends StatefulWidget {
  final Categorys? model;
  ItemsScreen({this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
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
          )),
        ),
        title: Text(
          widget.model!.categoryTitle!,
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.library_add,
              color: Colors.white,
            ),
            iconSize: 34,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => ItemsUploadScreen(model: widget.model)));
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(sharedPreferences!.getString("uid"))
                .collection("categorys")
                .doc(widget.model!.categoryID)
                .collection("items")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 2,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        Items model = Items.fromJson(
                          snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                        );
                        return ItemsDesignWidget(
                          model: model,
                          context: context,
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          ),
        ],
      ),
    );
  }
}
