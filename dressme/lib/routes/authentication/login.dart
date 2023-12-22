import 'package:dressme/global/global.dart';
import 'package:dressme/routes/authentication/auth_screen.dart';
import 'package:dressme/routes/home_screen.dart';
import 'package:dressme/widgets/custom_text_field.dart';
import 'package:dressme/widgets/error_dialog.dart';
import 'package:dressme/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late bool rememberMe;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
    rememberMe = false;

    if (sharedPreferences != null && sharedPreferences!.containsKey("savedEmail")) {
      emailController.text = sharedPreferences!.getString("savedEmail") ?? "";
      rememberMe = true;
    }
  }

  void initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      if (rememberMe) {
        sharedPreferences?.setString("savedEmail", emailController.text);
      } else {
        // If Remember Me is unchecked, remove the saved email
        sharedPreferences?.remove("savedEmail");
      }
      //login
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Lütfen mail adresinizi ve şifrenizi yazdığınızdan emin olun.",
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

    User? currentUser;
    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Kullanıcı adı sisteme kayıtlı değil. Lütfen önce kayıt olun.",
            );
          });
    });
    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!);
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance.collection("users").doc(currentUser.uid).get().then((snapshot) async {
      if (snapshot.exists) {
        await sharedPreferences!.setString("uid", currentUser.uid);
        await sharedPreferences!.setString("email", snapshot.data()!["userEmail"]);
        await sharedPreferences!.setString("name", snapshot.data()!["userName"]);
        await sharedPreferences!.setString("photoUrl", snapshot.data()!["userAvatarUrl"]);

        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage(title: 'Dressme')));
      } else {
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));

        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Kayıt Bulunamadı.",
              );
            });
      }
    });
  }

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
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => ForgetPasswordMailScreen(),
                //         ),
                //       );
                //     },
                //     child: const Text(
                //       "Şifremi Unuttum",
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('Beni Hatırla'),
              Checkbox(
                value: rememberMe,
                onChanged: (bool? value) {
                  setState(() {
                    rememberMe = value!;
                  });
                },
              ),
            ],
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
            height: 10,
          ),
        ],
      ),
    );
  }
}
