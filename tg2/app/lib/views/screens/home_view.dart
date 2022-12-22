import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/controller/season_controller.dart';
import 'package:tg2/views/widgets/season_view.dart';
import '../../controller/league_controller.dart';
import '../../models/league_model.dart';
import '../widgets/league_view.dart';

enum Section { MATCHWEEK, TEAMS }

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LeagueView(),
        SeasonView(),
        ElevatedButton(
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MatchweeksView(),
                    maintainState: false,
                  ),
                ),
            child: Text("Jornadas")),
        ElevatedButton(
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MatchweeksView(),
                    maintainState: false,
                  ),
                ),
            child: Text("Clubes")),
      ],
    )));
  }
}

class MatchweeksView extends StatefulWidget {
  const MatchweeksView({super.key});

  @override
  State<MatchweeksView> createState() => _MatchweeksViewState();
}

class _MatchweeksViewState extends State<MatchweeksView> {
  @override
  Widget build(BuildContext context) {
    print("Matchweeks View: Building...");
    return Scaffold(
        appBar: AppBar(title: Text("Clubes")),
        body: Center(
          child: Consumer<SeasonController>(
            builder: (context, season, child) {
              return Text(
                  'Jornada da liga ${season.leagueController.selectedLeague.name} na ${season.selectedSeason.name}');
            },
          ),
        ));
  }
}

class TeamsView extends StatefulWidget {
  const TeamsView({super.key});

  @override
  State<TeamsView> createState() => _TeamsViewState();
}

class _TeamsViewState extends State<TeamsView> {
  @override
  Widget build(BuildContext context) {
    print("Teams View: Building...");
    return Scaffold(
        appBar: AppBar(title: Text("Clubes")),
        body: Center(
          child: Consumer<SeasonController>(
            builder: (context, season, child) {
              return Text(
                  'Club da liga ${season.leagueController.selectedLeague.name} na ${season.selectedSeason.name}');
            },
          ),
        ));
  }
}
