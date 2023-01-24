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
        title: Column(
          children: [
            Text(
                "${DateUtilities().toYMD(match.date)} ${DateUtilities().toHM(match.date)}",
                style: Theme.of(context).textTheme.caption),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              FutureImage(
                image: match.clubHome.picture!,
                errorImageUri: 'assets/images/placeholder-club.png',
                height: 48,
                aspectRatio: 1 / 1,
              ),
              Row(
                children: [
                  Text("${match.homeScore}",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(width: 16),
                  Text(":", style: Theme.of(context).textTheme.subtitle1),
                  const SizedBox(width: 16),
                  Text("${match.awayScore}",
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              FutureImage(
                image: match.clubAway.picture!,
                errorImageUri: 'assets/images/placeholder-club.png',
                height: 48,
                aspectRatio: 1 / 1,
              ),
            ]),
          ],
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
