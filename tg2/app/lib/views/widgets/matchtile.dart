import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tg2/models/match_model.dart';
import 'package:tg2/views/screens/match/match_view.dart';
import 'package:tg2/views/widgets/futureimage.dart';

// Match tile. It displays basic match information.
class MatchTile extends StatelessWidget {
  const MatchTile({super.key, required this.match, this.showTimeOnly = false});

  final Match match; // Widget match data
  final bool showTimeOnly;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.surface,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            // TIMESTAMP
            Text(
              showTimeOnly
                  ? DateFormat.Hm('pt_PT').format(match.date)
                  : DateFormat.yMMMMd('pt_PT').add_Hm().format(match.date),
              style: Theme.of(context).textTheme.caption,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // HOME CLUB BADGE
                Expanded(
                  child: FutureImage(
                    image: match.clubHome.picture!,
                    errorImageUri: 'assets/images/placeholder-club.png',
                    height: 48,
                    aspectRatio: 1 / 1,
                  ),
                ),
                // SCORE
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('${match.homeScore}', style: Theme.of(context).textTheme.headlineMedium),
                      Text(':', style: Theme.of(context).textTheme.headlineSmall),
                      Text('${match.awayScore}', style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                ),
                // AWAY CLUB BADGE
                Expanded(
                  child: FutureImage(
                    image: match.clubAway.picture!,
                    errorImageUri: 'assets/images/placeholder-club.png',
                    height: 48,
                    aspectRatio: 1 / 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // CLUBS NAME
            Row(
              children: [
                Expanded(
                  child: Text(
                    match.clubHome.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: Text(
                    match.clubAway.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          isDismissible: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => MatchView(match: match),
        );
      },
    );
  }
}
