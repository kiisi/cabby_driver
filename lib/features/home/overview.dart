import 'package:auto_route/auto_route.dart';
import 'package:cabby_driver/features/home/account.dart';
import 'package:cabby_driver/features/home/activity.dart';
import 'package:cabby_driver/features/home/history.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  List<Widget> pages = [
    const ActivityScreen(),
    const HistoryScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 350),
        backgroundColor: Colors.black,
        key: _bottomNavigationKey,
        items: const <Widget>[
          Icon(Icons.home, size: 32),
          Icon(Icons.history, size: 32),
          Icon(Icons.account_circle, size: 32),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: pages[_page],
    );
  }
}
