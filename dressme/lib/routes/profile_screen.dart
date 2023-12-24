import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressme/global/global.dart';
import 'package:dressme/routes/authentication/auth_screen.dart';
import 'package:dressme/routes/authentication/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(userId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Scaffold(
            appBar: AppBar(
              title: Text('Profil Sayfası'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Ad Soyad',
                      ),
                      controller: TextEditingController(text: data['Ad Soyad']),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Telefon Numarası',
                      ),
                      controller:
                          TextEditingController(text: data['Telefon Numarası']),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'E-Mail',
                      ),
                      controller: TextEditingController(text: data['E-Mail']),
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                      ),
                      // Şifre genellikle doğrudan çekilmez ve gösterilmez
                    ),
                    TextButton(
                      child: Text('Çıkış Yap'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        firebaseAuth.signOut().then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => const AuthScreen()));
                        });
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
            title: Text('Profil Sayfası'),
          ),
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
