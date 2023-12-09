import 'package:dressme/widgets/custom_text_field.dart';
import 'package:dressme/widgets/error_dialog.dart';
import 'package:dressme/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      //login
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message:
                  "Lütfen mail adresinizi ve şifrenizi yazdığınızdan emin olun.",
            );
          });
    }
  }

  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(
            message: "Bilgileriniz kontrol ediliyor",
          );
        });

    // User? currentUser;
    // await firebaseAuth
    //     .signInWithEmailAndPassword(
    //   email: emailController.text.trim(),
    //   password: passwordController.text.trim(),
    // )
    //     .then((auth) {
    //   currentUser = auth.user!;
    // }).catchError((error) {
    //   Navigator.pop(context);
    //   showDialog(
    //       context: context,
    //       builder: (c) {
    //         return ErrorDialog(
    //           message: "Kullanıcı adı sisteme kayıtlı değil. Lütfen önce kayıt olun.",
    //         );
    //       });
    // });
    // if (currentUser != null) {
    //   readDataAndSetDataLocally(currentUser!);
    // }
  }

  // Future readDataAndSetDataLocally(User currentUser) async {
  //   await FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).get().then((snapshot) async {
  //     if (snapshot.exists) {
  //       await sharedPreferences!.setString("uid", currentUser.uid);
  //       await sharedPreferences!.setString("email", snapshot.data()!["sellerEmail"]);
  //       await sharedPreferences!.setString("name", snapshot.data()!["sellerName"]);
  //       await sharedPreferences!.setString("photoUrl", snapshot.data()!["sellerAvatarUrl"]);

  //       Navigator.pop(context);
  //       Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
  //     } else {
  //       firebaseAuth.signOut();
  //       Navigator.pop(context);
  //       Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));

  //       showDialog(
  //           context: context,
  //           builder: (c) {
  //             return ErrorDialog(
  //               message: "Kayıt Bulunamadı.",
  //             );
  //           });
  //     }
  //   });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Image.asset(
                "assets/images/login.png",
                height: 270,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: "Email",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: "Şifre",
                  isObsecre: true,
                ),
              ],
            ),
          ),
          ElevatedButton(
            child: const Text(
              "Giriş Yap",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF68CAEA),
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
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
    );
  }
}
