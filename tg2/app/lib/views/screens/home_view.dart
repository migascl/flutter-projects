import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/country_provider.dart';
import 'package:tg2/views/screens/match/matchlist_view.dart';
import 'package:tg2/views/screens/player/playerlist_view.dart';

import 'club/clublist_view.dart';

// TODO IMPLEMENT DRAWER BASED NAVIGATION
// TODO IMPROVE PROVIDER STATE SYSTEM

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    print("Home/V: Initialized State!");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CountryProvider>(context, listen: false).get();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Home/V: Building...");
    return Scaffold(
        appBar: AppBar(title: Text("Home")),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const ClubListView(),
                      maintainState: false,
                    ),
                  );
                },
                child: Text("Clubes")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const MatchListView(),
                      maintainState: false,
                    ),
                  );
                },
                child: Text("Jornadas")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const PlayerListView(),
                      maintainState: false,
                    ),
                  );
                },
                child: Text("Jogadores")),
          ],
        )));
  }
}
