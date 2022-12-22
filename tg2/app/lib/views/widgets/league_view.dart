import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/league_model.dart';
import '../../controller/league_controller.dart';

class LeagueView extends StatefulWidget {
  const LeagueView({super.key});

  @override
  State<LeagueView> createState() => _LeagueViewState();
}

class _LeagueViewState extends State<LeagueView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LeagueController>(context, listen: false).getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("League View building...");
    return Consumer<LeagueController>(builder: (context, league, child) {
      if (league.leagues.isEmpty || league.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return DropdownButton(
          value: league.selectedLeague,
          items: league.leagues.values.map((League league) {
            return DropdownMenuItem(value: league, child: Text(league.name));
          }).toList(),
          onChanged: (League? newLeague) {
            league.selectedLeague = newLeague!;
          });
    });
  }
}
