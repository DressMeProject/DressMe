import 'dart:io';

import 'package:dressme/widgets/custom_text_field.dart';
import 'package:dressme/widgets/error_dialog.dart';
import 'package:dressme/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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

  String sellerImageUrl = "";

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

          // String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          // fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("users").child(fileName);
          // fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
          // fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
          // await taskSnapshot.ref.getDownloadURL().then((url) {
          //   sellerImageUrl = url;

          //   //bilgileri firestore'a kaydeder
          //   authenticateSellerAndSignUp();
          // });
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
