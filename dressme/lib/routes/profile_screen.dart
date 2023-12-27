import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressme/global/global.dart';
import 'package:dressme/routes/authentication/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(userId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Hata'),
              ),
              body: Center(
                child: Text('Hata: ${snapshot.error}'),
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Veri Yok'),
              ),
              body: Center(
                child: Text('Kullanıcı verisi bulunamadı!'),
              ),
            );
          }
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
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
              title: const Text(
                "Profil",
                style: TextStyle(fontSize: 30, fontFamily: "Lobster", color: Color.fromARGB(240, 239, 231, 231)),
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
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Ad Soyad',
                        icon: Icon(Icons.person),
                      ),
                      controller: TextEditingController(
                        text: sharedPreferences!.getString("name")!,
                      ),
                      enabled: false,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Telefon Numarası',
                        icon: Icon(Icons.phone),
                      ),
                      controller: TextEditingController(text: data["phone"] ?? ''),
                      enabled: false,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'E-Mail',
                        icon: Icon(Icons.email),
                      ),
                      controller: TextEditingController(text: sharedPreferences!.getString("email")!),
                      enabled: false,
                    ),
                    ElevatedButton(
                      child: const Text(
                        "Çıkış Yap",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 72, 70, 228),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Çıkış Yap'),
                              content: Text('Çıkış yapmak istediğinize emin misiniz?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Evet'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    firebaseAuth.signOut().then((value) {
                                      Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));
                                    });
                                  },
                                ),
                                TextButton(
                                  child: Text('Hayır'),
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
                  ],
                ),
              ),
            ),
          );
        }

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
            title: const Text(
              "Profil",
              style: TextStyle(fontSize: 30, fontFamily: "Lobster", color: Color.fromARGB(240, 239, 231, 231)),
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
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
