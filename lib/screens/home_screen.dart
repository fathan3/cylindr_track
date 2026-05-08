import 'package:flutter/material.dart';
import 'package:cylindr_track/config/theme.dart';
import 'package:cylindr_track/screens/beranda_screen.dart';
import 'package:cylindr_track/screens/transaksi_screen.dart';
import 'package:cylindr_track/screens/monitoring_screen.dart';
import 'package:cylindr_track/screens/evaluasi_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const BerandaScreen(),
    const TransaksiScreen(),
    const MonitoringScreen(),
    const EvaluasiScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Monitoring',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Evaluasi',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
