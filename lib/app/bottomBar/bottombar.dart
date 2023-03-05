import 'package:elevshopfirebase/app/constant/color.dart';
import 'package:elevshopfirebase/app/dynamic/profil.dart';
import 'package:elevshopfirebase/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomBar extends StatefulWidget {
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
// navigasi footer

  late var _pgno = [
    HomeView(),
    ProfilView(),
  ];
  int _pilihtabbar = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
      style: optionStyle,
    ),
    Text(
      'Profile',
      style: optionStyle,
    ),
  ];

  void _changetabbar(int index) {
    setState(() {
      _pilihtabbar = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //package
      body: _pgno[_pilihtabbar],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Color(0xFF0595A7)!,
              hoverColor: Color(0xFF095160)!,
              gap: 3,
              activeColor: appPrimary,
              iconSize: 18,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: appPrimary,
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _pilihtabbar,
              onTabChange: (index) {
                setState(() {
                  _pilihtabbar = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
