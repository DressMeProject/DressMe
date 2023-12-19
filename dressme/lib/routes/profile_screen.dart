import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Sayfası'),
      ),
      body: Center(
        child: Text(
          'Buraya profil bilgilerinizi ekleyin',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
