import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressme/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/loading_dialog.dart';
import '../home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;
  String userImageUrl = "";
  String completeAddress = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Lütfen bir resim seçin.",
            );
          });
    } else {
      if (passwordController.text == confirmPasswordController.text) {
        if (confirmPasswordController.text.isNotEmpty && emailController.text.isNotEmpty && nameController.text.isNotEmpty) {
          //resmi yüklemeye başla
          showDialog(
              context: context,
              builder: (c) {
                return LoadingDialog(
                  message: "Kayıt Oluşturuluyor",
                );
              });

          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("users").child(fileName);
          fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            userImageUrl = url;

            //bilgileri firestore'a kaydeder
            authenticateUserAndSignUp();
          });
        } else {
          showDialog(
              context: context,
              builder: (c) {
                return ErrorDialog(
                  message: "Lütfen Bilgileri Eksiksiz Doldurduğunuzdan Emin olun.",
                );
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Şifreler Uyuşmuyor.",
              );
            });
      }
    }
  }

  void authenticateUserAndSignUp() async {
    User? currentUser;

    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      saveDataToFireStore(currentUser!).then((value) {
        Navigator.pop(context);
        //kullanıcıyı anasayfaya yönlendirir.
        Route newRoute = MaterialPageRoute(builder: (c) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFireStore(User currentUser) async {
    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
      "userUID": currentUser.uid,
      "userEmail": currentUser.email,
      "userName": nameController.text.trim(),
      "userAvatarUrl": userImageUrl,
      "phone": phoneController.text.trim(),
      "status": "approved",
    });

    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", userImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                _getImage();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage: imageXFile == null ? null : FileImage(File(imageXFile!.path)),
                child: imageXFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: MediaQuery.of(context).size.width * 0.20,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: nameController,
                    hintText: "Ad Soyad",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: "Email",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.phone,
                    controller: phoneController,
                    hintText: "Telefon",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: "Şifre",
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.person,
                    controller: confirmPasswordController,
                    hintText: "Şifre Tekrarı",
                    isObsecre: true,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text(
                "Kayıt ol",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF68CAEA),
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12),
              ),
              onPressed: () {
                formValidation();
              },
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
