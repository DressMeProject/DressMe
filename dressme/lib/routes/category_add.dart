import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressme/routes/category_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../global/global.dart';
import '../widgets/error_dialog.dart';
import '../widgets/progress_bar.dart';

class KategoriEkleScreen extends StatefulWidget {
  const KategoriEkleScreen({super.key});

  @override
  State<KategoriEkleScreen> createState() => _KategoriEkleScreenState();
}

class _KategoriEkleScreenState extends State<KategoriEkleScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  List<String> selectedClothes = [];

  Widget GiyimButton(String metin, IconData icon, VoidCallback onPressed) {
    Widget iconWidget = Icon(icon);
    if (metin == 'Üst Giyim') {
      iconWidget = Image.asset(
        'assets/images/ustgiyim.png',
        width: 24,
        height: 24,
      );
    }
    if (metin == 'Alt Giyim') {
      iconWidget = Image.asset(
        'assets/images/altgiyim.png',
        width: 24,
        height: 24,
      );
    }
    if (metin == 'Dış Giyim') {
      iconWidget = Image.asset(
        'assets/images/disgiyim.png',
        width: 24,
        height: 24,
      );
    }
    if (metin == 'Aksesuar') {
      iconWidget = Image.asset(
        'assets/images/aksesuar.png',
        width: 24,
        height: 24,
      );
    }
    if (metin == 'Ayakkabı') {
      iconWidget = Image.asset(
        'assets/images/ayakkabi.png',
        width: 24,
        height: 24,
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 8.0), // Dikey yönde boşluk ekleme
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (selectedClothes.contains(metin)) {
                  selectedClothes.clear();
                } else {
                  selectedClothes = [metin];
                }
              });
              onPressed();
            },
            child: iconWidget,
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
              primary: selectedClothes.contains(metin)
                  ? Colors.blue
                  : Colors.transparent,
              onPrimary: Colors.black,
            ),
          ),
          SizedBox(height: 3), // Düğme ile metin arasında boşluk bırakma
          Text(metin),
        ],
      ),
    );
  }

  defaultScreen() {
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
            "Yeni Kategori Ekle",
            style: TextStyle(
                fontSize: 30,
                fontFamily: "Lobster",
                color: Color.fromARGB(240, 239, 231, 231)),
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
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shop_two,
                  color: Colors.grey,
                  size: 200.0,
                ),
                InkWell(
                  onTap: () {
                    takeImage(context);
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
                    width: MediaQuery.of(context).size.width - 200,
                    height: 45,
                    child: Center(
                      child: Text(
                        "Ekle",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            "Kategori Resmi",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "Valera"),
          ),
          children: [
            SimpleDialogOption(
              child: const Text(
                "Fotoğraf Çek",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              onPressed: captureImageWithCamera,
            ),
            SimpleDialogOption(
              child: const Text(
                "Galeriden Seç",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: const Text(
                "Vazgeç",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  captureImageWithCamera() async {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  menusUploadFormScreen() {
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
          "Kategori Ekleniyor",
          style: TextStyle(
              fontSize: 20, fontFamily: "Lobster", color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            clearMenuUploadForm();
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              "Ekle",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Varela",
                letterSpacing: 2,
              ),
            ),
            onPressed: uploading ? null : () => validateUploadForm(),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : const Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(imageXFile!.path)),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Color.fromARGB(255, 89, 86, 253),
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(fontSize: 18, color: Colors.black),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Kategori Adı",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Color(0xFFFFBED7),
            ),
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GiyimButton('Üst Giyim', Icons.image, () {}),
                  GiyimButton('Alt Giyim', Icons.image, () {}),
                  GiyimButton('Dış Giyim', Icons.image, () {}),
                  GiyimButton('Aksesuar', Icons.image, () {}),
                  GiyimButton('Ayakkabı', Icons.image, () {}),
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  clearMenuUploadForm() {
    setState(() {
      titleController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if (imageXFile == null ||
        titleController.text.isEmpty ||
        selectedClothes.isEmpty) {
      String errorMessage = "Lütfen ";

      if (imageXFile == null)
        errorMessage += "bir resim seçin";
      else if (titleController.text.isEmpty)
        errorMessage += "kategori adını doldurun";
      else if (selectedClothes.isEmpty) errorMessage += " bir giyim türü seçin";

      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: errorMessage,
          );
        },
      );
    } else {
      setState(() {
        uploading = true;
      });

      //resim yükleme
      String downloadUrl = await uploadImage(File(imageXFile!.path));

      // Seçilen mevsimler listesini bir dizeye dönüştür
      String selectedClothesString = selectedClothes.join('');

      // Firebase'e renk RGB değerlerini ekleyin
      saveInfo(downloadUrl, selectedClothesString);
    }
  }

  saveInfo(String downloadUrl, String clothes) {
    final userUID = sharedPreferences?.getString("uid");
    if (sharedPreferences == null || uniqueIdName == null) {
      return;
    }

    final ref = FirebaseFirestore.instance
        .collection("users")
        .doc(userUID)
        .collection("categorys");

    ref.doc(uniqueIdName).set({
      "categoryID": uniqueIdName,
      "userUID": userUID,
      "categoryTitle": titleController.text.toString(),
      "clothes": clothes,
      "publishedDate": DateTime.now(),
      "status": "awalible",
      "thumbnailUrl": downloadUrl,
    }).then((value) {
      clearMenuUploadForm();

      // Bilgileri başarıyla kaydettikten sonra KategoriSreen'e yönlendirme
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => KategoriScreen()),
      );

      setState(() {
        uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
        uploading = false;
      });
    });
  }

  uploadImage(mImageFile) async {
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child("categorys");

    storageRef.UploadTask uploadTask =
        reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menusUploadFormScreen();
  }
}
