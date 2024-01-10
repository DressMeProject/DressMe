import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressme/global/global.dart';
import 'package:dressme/models/categories.dart';
import 'package:dressme/routes/category_add.dart';
import 'package:dressme/widgets/categories_design.dart';
import 'package:dressme/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({Key? key}) : super(key: key);

  @override
  _KategoriScreenState createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   flexibleSpace: Container(
      //     decoration: const BoxDecoration(
      //       gradient: LinearGradient(
      //         colors: [
      //           Color.fromARGB(255, 207, 70, 241),
      //           Color.fromARGB(255, 72, 70, 228),
      //         ],
      //         begin: FractionalOffset(0.0, 0.0),
      //         end: FractionalOffset(1.0, 0.0),
      //         stops: [0.0, 1.0],
      //         tileMode: TileMode.clamp,
      //       ),
      //     ),
      //   ),
      //   title: const Text(
      //     "Dolabım",
      //     style: TextStyle(
      //       fontSize: 30,
      //       fontFamily: "Lobster",
      //       color: Color.fromARGB(240, 239, 231, 231),
      //     ),
      //   ),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      // ),
      body: CustomScrollView(
        slivers: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("users").doc(sharedPreferences!.getString("uid")).collection("categories").snapshots(),
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
                        Categories model = Categories.fromJson(
                          snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                        );
                        return InfoDesignWidget(
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KategoriEkleScreen()),
            );
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
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: MediaQuery.of(context).size.width - 40,
            height: 45,
            child: Center(
              child: Text(
                "Kategori Ekle",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
