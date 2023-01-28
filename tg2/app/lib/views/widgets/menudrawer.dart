import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tg2/views/screens/club/clublist_view.dart';
import 'package:tg2/views/screens/match/matchlist_view.dart';
import 'package:tg2/views/screens/player/playerlist_view.dart';

// This widget is used as a scaffold drawer to navigate through pages
class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            child: SvgPicture.asset(
              height: 48,
              'assets/images/lp_logo.svg',
              theme: SvgTheme(currentColor: Theme.of(context).colorScheme.inverseSurface),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text("Jogos"),
            textColor: Theme.of(context).colorScheme.onPrimary,
            iconColor: Theme.of(context).colorScheme.onPrimary,
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MatchListView(),
                maintainState: false,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.group_outlined),
            title: const Text("Clubes"),
            textColor: Theme.of(context).colorScheme.onPrimary,
            iconColor: Theme.of(context).colorScheme.onPrimary,
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ClubListView(),
                maintainState: false,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.directions_outlined),
            title: const Text("Jogadores"),
            textColor: Theme.of(context).colorScheme.onPrimary,
            iconColor: Theme.of(context).colorScheme.onPrimary,
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PlayerListView(),
                maintainState: false,
              ),
            ),
          ),
          const Spacer(),
          ListTile(
            tileColor: Theme.of(context).colorScheme.tertiaryContainer,
            dense: true,
            title: Text("Miguel Leirosa 2022/2023",
                style:
                    Theme.of(context).textTheme.overline?.apply(color: Theme.of(context).colorScheme.onTertiaryContainer)),
          ),
        ],
      ),
    );
  }
}
