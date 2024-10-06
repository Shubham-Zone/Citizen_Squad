import 'package:flutter/material.dart';
import 'package:hackingly_new/ui/components/index.dart';
import 'package:hackingly_new/ui/screens/user/profile.dart';
import 'package:hackingly_new/ui/screens/utilities/tracking.dart';

class NavBar extends StatefulWidget {
  final int idx;

  const NavBar({super.key, required this.idx});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int index;

  // List of pages
  List pages = [const Index(), const Track(), const Profile()];

  @override
  void initState() {
    index = widget.idx;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.deepOrange,
        ),
        child: NavigationBar(
          selectedIndex: index,
          elevation: 8,
          height: MediaQuery.of(context).size.height * 0.085,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            NavigationDestination(
                icon: Icon(Icons.track_changes), label: "Track"),
            NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
