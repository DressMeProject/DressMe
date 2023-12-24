import 'package:dressme/routes/clothes_screen.dart';
import 'package:dressme/routes/profile_screen.dart';
import 'package:dressme/routes/uploadScreen/upload_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DressMe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'DressMe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Text('Ana Sayfa', style: TextStyle(fontSize: 24.0)),
    ClothesScreen(),
    Text('Ekle'),
    Text('İpuçları'),
    Text('Ayarlar'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Hoşgeldin Harun',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: Icon(
                Icons.account_circle,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: 'Dolap',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Ekle',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb),
              label: 'İpuçları',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Ayarlar',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          //onTap: _onItemTapped,

          onTap: (int index) {
            // BottomNavigationBarItem'a tıklanınca yapılacak işlemleri burada gerçekleştirin
            if (index == 1) {
              // Ekle ikonuna tıklandığında upload_screen ekranını aç
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClothesScreen()),
              );
            }
            if (index == 2) {
              // Ekle ikonuna tıklandığında upload_screen ekranını aç
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenusUploadScreen()),
              );
            }
          }),
    );
  }
}
