import 'package:flutter/material.dart';
import 'package:tg2/views/screens/club/clublist_view.dart';
import 'package:tg2/views/screens/match/matchlist_view.dart';
import 'package:tg2/views/screens/player/playerlist_view.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  // Root of the application
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text("Liga Portugal bwin"),
                  Text("Época 2022-2023")
                ],
              )),
          ListTile(
            leading: Icon(Icons.calendar_month_rounded),
            title: Text("Jornada"),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MatchListView(),
                maintainState: true,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text("Clubes"),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ClubListView(),
                maintainState: true,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.directions_run_rounded),
            title: Text("Jogadores"),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PlayerListView(),
                maintainState: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
