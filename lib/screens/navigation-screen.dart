import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './home-screen.dart';
import './jadwal-screen.dart';
import './nilai-screen.dart';
import './absen-screen.dart';
import './profile-screen.dart';
import '../providers/navigation.dart';

class NavigationScreen extends StatefulWidget {
  static const routeName = '/navigation';
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = Provider.of<Navigation>(context, listen: true).index;
    void _onItemTapped(int index) {
      Provider.of<Navigation>(context, listen: false).setIndex(index);
    }

    const List<Widget> _widgetOptions = <Widget>[
      HomeScreen(),
      Jadwalscreen(),
      NilaiScreen(),
      AbsenScreen(),
      ProfileScreen(),
    ];
    return Scaffold(
        body: _widgetOptions
            .elementAt(Provider.of<Navigation>(context, listen: true).index),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 5,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule_rounded),
              label: 'Jadwal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_half_rounded),
              label: 'Nilai',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note_alt_rounded),
              label: 'Absen',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'Profil',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.person),
            //   label: 'Profil',
            //   backgroundColor: const Color.fromARGB(255, 0, 76, 138),
            // )
          ],
          currentIndex: Provider.of<Navigation>(context, listen: true).index,
          selectedItemColor: Color.fromARGB(255, 0, 76, 138),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ));
  }
}
