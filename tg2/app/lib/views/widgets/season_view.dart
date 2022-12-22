import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/utils/constants.dart';
import '../../controller/season_controller.dart';
import '../../models/season_model.dart';

class SeasonView extends StatefulWidget {
  const SeasonView({super.key});

  @override
  State<SeasonView> createState() => _SeasonViewState();
}

class _SeasonViewState extends State<SeasonView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SeasonController>(context, listen: false).getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Season View: building...");
    return Consumer<SeasonController>(builder: (context, season, child) {
      if (season.seasons.isEmpty || season.state == ControllerState.busy) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return DropdownButton(
          value: season.selectedSeason,
          items: season.seasons.values.map((Season season) {
            return DropdownMenuItem(value: season, child: Text(season.name));
          }).toList(),
          onChanged: (Season? newSeason) {
            season.selectedSeason = newSeason!;
          });
    });
  }
}
