import 'package:flutter/material.dart';
import 'package:tg2/models/match_model.dart';
import 'package:tg2/utils/dateutils.dart';
import 'package:tg2/views/screens/match/match_view.dart';
import 'package:tg2/views/widgets/futureimage.dart';

// Match tile. It displays basic match information.
class MatchTile extends StatelessWidget {
  const MatchTile({super.key, required this.match});

  final Match match; // Widget match data

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: [
              Text("${DateUtilities().toYMD(match.date)} ${DateUtilities().toHM(match.date)}",
                  style: Theme.of(context).textTheme.caption),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Expanded(
                  child: Column(
                    children: [
                      FutureImage(
                        image: match.clubHome.picture!,
                        errorImageUri: 'assets/images/placeholder-club.png',
                        height: 48,
                        aspectRatio: 1 / 1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        match.clubHome.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${match.homeScore}", style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(width: 16),
                      Text(":", style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(width: 16),
                      Text("${match.awayScore}", style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      FutureImage(
                        image: match.clubAway.picture!,
                        errorImageUri: 'assets/images/placeholder-club.png',
                        height: 48,
                        aspectRatio: 1 / 1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        match.clubAway.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => MatchView(match: match));
        });
  }
}
