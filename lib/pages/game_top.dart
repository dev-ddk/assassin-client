// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:assassin_client/colors.dart';

class GameRoute extends StatelessWidget {
  //final _pageViewController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: assassinDarkestBlue,
      body: PageView(
        children: [
          Container(color: Colors.red),
          Container(color: Colors.green),
          Container(color: Colors.blue)
        ],
      ),
      appBar: AppBar(
        title: Text('PARTITA DEMOCRATICA'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit),
              activeIcon: Icon(Icons.safety_divider),
              label: 'Perimetro'),
          BottomNavigationBarItem(
              icon: Icon(Icons.nat),
              activeIcon: Icon(Icons.water_damage),
              label: 'Cavolfiore'),
        ],
      ),
    );
  }
}
