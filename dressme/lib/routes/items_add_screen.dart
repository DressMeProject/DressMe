import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dressme/models/categories.dart';
import 'package:dressme/routes/items_screen.dart';
import 'package:dressme/widgets/progress_bar%20copy.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';
import '../global/global.dart';
import '../widgets/error_dialog.dart';

class ItemsUploadScreen extends StatefulWidget {
  final Categories? model;
  ItemsUploadScreen({this.model});

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {
  List<String> selectedSeasons = [];
  List<String> selectedStyles = [];

  @override
  void initState() {
    super.initState();
    paletteColors = [];
  }

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController titleController = TextEditingController();
  TextEditingController shortInfoController = TextEditingController();
  TextEditingController renkController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  Widget mevsimButton(String metin, IconData icon, VoidCallback onPressed) {
    Widget iconWidget = Icon(icon); // Varsayılan olarak icon kullanılıyor
    if (metin == 'Sonbahar') {
      // Eğer Sonbahar ise, özel bir resim kullanabilirsiniz
      iconWidget = Image.asset(
        'assets/images/sonbahar.png', // Resminizin yolunu buraya girin
        width: 24,
        height: 24,
      );
    }
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (selectedSeasons.contains(metin)) {
                selectedSeasons.remove(metin);
              } else {
                selectedSeasons.add(metin);
              }
            });
            onPressed();
          },
          child: iconWidget,
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(10),
            primary: selectedSeasons.contains(metin) ? Colors.blue : Colors.transparent,
            onPrimary: Colors.black,
          ),
        ),
        SizedBox(height: 3),
        Text(metin),
      ],
    );
  }

  Widget styleButton(String metin, IconData icon, VoidCallback onPressed) {
    Widget iconWidget = Icon(icon);
    if (metin == 'Klasik\nGiyim') {
      iconWidget = Image.asset(
        'assets/images/klasik.png',
        width: 24,
        height: 24,
      );
    }
    if (metin == 'Günlük\nGiyim') {
      iconWidget = Image.asset(
        'assets/images/gunluk.png',
        width: 24,
        height: 24,
      );
    }
    if (metin == 'Spor\nGiyim') {
      iconWidget = Image.asset(
        'assets/images/spor.png',
        width: 24,
        height: 24,
      );
    }
    if (metin == 'Özel\nGün') {
      iconWidget = Image.asset(
        'assets/images/ozel.png',
        width: 24,
        height: 24,
      );
    }
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (selectedStyles.contains(metin)) {
                selectedStyles.remove(metin);
              } else {
                selectedStyles.add(metin);
              }
            });
            onPressed();
          },
          child: iconWidget,
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(10),
            primary: selectedStyles.contains(metin) ? Colors.blue : Colors.transparent,
            onPrimary: Colors.black,
          ),
        ),
        SizedBox(height: 3),
        Text(metin),
      ],
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
          "Yeni Parça Ekle",
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
                      style: TextStyle(color: Colors.white, fontSize: 20),
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

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            "Ürün Resmi",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "Valera"),
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
      maxHeight: 1080,
      maxWidth: 1920,
    );

    setState(() {
      imageXFile;
    });

    await pickPaletteColors();
  }

  pickImageFromGallery() async {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1920,
    );

    setState(() {
      imageXFile;
    });

    await pickPaletteColors();
  }

  List<Widget> buildColorCircles() {
    return paletteColors.map((color) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        margin: EdgeInsets.all(5),
      );
    }).toList();
  }

  PaletteGenerator? paletteGenerator;
  Color dominantColor = Colors.white;
  late List<Color> paletteColors;

  Future<void> pickPaletteColors() async {
    if (imageXFile != null) {
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        FileImage(File(imageXFile!.path)),
        //maximumColorCount: 5,
      );
      if (paletteGenerator.paletteColors.isNotEmpty) {
        setState(() {
          dominantColor = paletteGenerator.dominantColor!.color;
          paletteColors = paletteGenerator.paletteColors.map((paletteColor) => paletteColor.color).toList();

          renkController.text = '';
          for (var color in paletteColors) {
            final int r = color.red;
            final int g = color.green;
            final int b = color.blue;
            renkController.text += '$r$g$b ';
          }
        });
      }
    }
  }

  Color? selectedColor; // Seçilen rengi izlemek için
  String getRGBValues(Color color) {
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;
    return '$r,$g,$b'; // Rengin RGB değerlerini virgülle ayrılmış bir şekilde döndürür
  }

// Seçilebilir renk dairelerini oluşturan metod
  List<Widget> buildSelectableColorCircles() {
    return paletteColors.map((color) {
      bool isSelected = selectedColor == color;

      return GestureDetector(
        onTap: () {
          setState(() {
            selectedColor = isSelected ? null : color;
            if (selectedColor != null) {
              final String rgbValues = getRGBValues(color);
              renkController.text = rgbValues;
            } else {
              renkController.text = '';
            }
          });
        },
        child: Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: isSelected ? Border.all(color: Color.fromARGB(255, 238, 91, 91), width: 2) : null,
          ),
        ),
      );
    }).toList();
  }

  itemsUploadFormScreen() {
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
          "Parça Ekleniyor",
          style: TextStyle(fontSize: 20, fontFamily: "Lobster", color: Colors.white),
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
              color: Color(0xFFFFBED7),
            ),
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: buildSelectableColorCircles(),
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
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(fontSize: 18, color: Colors.black),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Parça Adı",
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
              Icons.title,
              color: Color(0xFFFFBED7),
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(fontSize: 18, color: Colors.black),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  hintText: "Parça Açıklaması",
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
            leading: Icon(
              Icons.perm_device_information,
              color: Color(0xFFFFBED7),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                mevsimButton('İlkbahar', Icons.wb_sunny, () {}),
                mevsimButton('Yaz', Icons.beach_access, () {}),
                mevsimButton('Sonbahar', Icons.image, () {}),
                mevsimButton('Kış', Icons.ac_unit, () {}),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Color(0xFFFFBED7),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                styleButton('Klasik\nGiyim', Icons.wb_sunny, () {}),
                styleButton('Günlük\nGiyim', Icons.image, () {}),
                styleButton('Spor\nGiyim', Icons.image, () {}),
                styleButton('Özel\nGün', Icons.image, () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  clearMenuUploadForm() {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if (imageXFile == null || selectedColor == null || titleController.text.isEmpty || selectedSeasons.isEmpty) {
      String errorMessage = "Lütfen ";

      if (imageXFile == null)
        errorMessage += "bir resim seçin";
      else if (selectedColor == null)
        errorMessage += "bir renk seçin";
      else if (titleController.text.isEmpty)
        errorMessage += "parça adını doldurun";
      else if (selectedSeasons.isEmpty) errorMessage += "en az bir mevsim seçin";

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
      String selectedSeasonsString = selectedSeasons.join(', ');

      String selectedStyleString = selectedStyles.join(', ');

      // Seçilen rengin RGB değerlerini alın
      final int r = selectedColor!.red;
      final int g = selectedColor!.green;
      final int b = selectedColor!.blue;

      // Firebase'e renk RGB değerlerini ekleyin
      saveInfo(downloadUrl, "$r,$g,$b", selectedSeasonsString, selectedStyleString);
    }
  }

  saveInfo(String downloadUrl, String rgbValues, String season, String style) {
    // RGB değerlerini virgülle ayrılmış bir dize olarak birleştirme
    final ref = FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("categories")
        .doc(widget.model!.categoryID)
        .collection("items");

    ref.doc(uniqueIdName).set({
      "itemID": uniqueIdName,
      "categoryID": widget.model!.categoryID,
      "userUID": sharedPreferences!.getString("uid"),
      "userName": sharedPreferences!.getString("name"),
      "shortInfo": shortInfoController.text.toString(),
      "colorRGB": rgbValues,
      "season": season,
      "style": style,
      "title": titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "awalible",
      "thumbnailUrl": downloadUrl,
    }).then((value) {
      final itemsRef = FirebaseFirestore.instance.collection("items");

      return itemsRef.doc(uniqueIdName).set({
        "itemID": uniqueIdName,
        "categoryID": widget.model!.categoryID,
        "userUID": sharedPreferences!.getString("uid"),
        "userName": sharedPreferences!.getString("name"),
        "shortInfo": shortInfoController.text.toString(),
        "colorRGB": rgbValues,
        "season": season,
        "style": style,
        "title": titleController.text.toString(),
        "publishedDate": DateTime.now(),
        "status": "awalible",
        "thumbnailUrl": downloadUrl,
      });
    }).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemsScreen(model: widget.model),
        ),
      ).then((_) {
        clearMenuUploadForm();
        setState(() {
          uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
          uploading = false;
        });
      });
    });
  }

  uploadImage(mImageFile) async {
    storageRef.Reference reference = storageRef.FirebaseStorage.instance.ref().child("items");

    storageRef.UploadTask uploadTask = reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : itemsUploadFormScreen();
  }
}
