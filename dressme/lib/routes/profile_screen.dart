import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressme/global/global.dart';
import 'package:dressme/routes/authentication/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

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
                  ),
                ),
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
            body: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 25, bottom: 10),
                  child: Column(
                    children: [
                      Material(
                        borderRadius: const BorderRadius.all(Radius.circular(80)),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            height: 150,
                            width: 150,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                sharedPreferences!.getString("photoUrl")!,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        sharedPreferences!.getString("name")!,
                        style: TextStyle(color: Colors.black, fontSize: 24, fontFamily: "Lobster"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
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
                            style: TextStyle(fontFamily: "Lobster"), // Set fontFamily
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Telefon Numarası',
                              icon: Icon(Icons.phone),
                            ),
                            controller: TextEditingController(text: data["phone"] ?? ''),
                            enabled: false,
                            style: TextStyle(fontFamily: "Lobster"), // Set fontFamily
                          ),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'E-Mail',
                              icon: Icon(Icons.email),
                            ),
                            controller: TextEditingController(text: sharedPreferences!.getString("email")!),
                            enabled: false,
                            style: TextStyle(fontFamily: "Lobster"), // Set fontFamily
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    _showPasswordChangeDialog(context);
                  },
                  child: Container(
                    width: 380,
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
                    height: 45,
                    child: Center(
                      child: Text(
                        "Şifre Değiştir",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Lobster"),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () {
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
                      height: 45,
                      child: Center(
                        child: Text(
                          "Çıkış Yap",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Lobster"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                ),
              ),
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

  void _showPasswordChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Şifre Değiştir'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Eski Şifre',
                ),
              ),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Yeni Şifre',
                ),
              ),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Yeni Şifre Onayı',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
                _currentPasswordController.clear();
                _newPasswordController.clear();
                _confirmPasswordController.clear();
              },
            ),
            TextButton(
              child: Text('Kaydet'),
              onPressed: () {
                _changePassword(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _changePassword(BuildContext context) async {
    String currentPassword = _currentPasswordController.text;
    var user = FirebaseAuth.instance.currentUser;

    try {
      var credential = EmailAuthProvider.credential(email: user!.email!, password: currentPassword);
      await user.reauthenticateWithCredential(credential);

      String newPassword = _newPasswordController.text;
      await user.updatePassword(newPassword);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Başarılı'),
            content: Text('Şifreniz başarıyla değiştirildi.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  _currentPasswordController.clear();
                  _newPasswordController.clear();
                  _confirmPasswordController.clear();
                },
                child: Text('Tamam'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      String errorMessage;
      if (error is FirebaseAuthException && error.code == 'wrong-password') {
        errorMessage = 'Eski şifre yanlış, lütfen kontrol edin.';
      } else {
        errorMessage = 'Şifre değiştirme başarısız.';
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hata'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Kapat'),
              ),
            ],
          );
        },
      );
    }
  }
}
