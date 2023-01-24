import 'package:flutter/material.dart';
import 'package:tg2/views/screens/club/clublist_view.dart';
import 'package:tg2/views/screens/match/matchlist_view.dart';
import 'package:tg2/views/screens/player/playerlist_view.dart';

// This widget is used as a scaffold drawer to navigate through pages
class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Text(
                        "Liga Portugal bwin",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.merge(const TextStyle(color: Colors.white)),
                      ),
                      Text(
                        "Época 2022-2023",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.merge(const TextStyle(color: Colors.white70)),
                      ),
                    ],
                  ),
                  Text(
                    "Miguel Leirosa 2022/2023",
                    style: Theme.of(context)
                        .textTheme
                        .overline
                        ?.merge(const TextStyle(color: Colors.white70)),
                  ),
                ],
              )),
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded),
            title: const Text("Jornada"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MatchListView(),
                maintainState: false,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text("Clubes"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ClubListView(),
                maintainState: false,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.directions_run_rounded),
            title: const Text("Jogadores"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlayerListView(),
                maintainState: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
