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
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            // TIMESTAMP
            Text(
              showTimeOnly ? DateFormat.Hm('pt_PT').format(match.date) : DateFormat.yMd('pt_PT').add_Hm().format(match.date),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // HOME CLUB
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: FutureImage(
                          image: match.homeClub.logo!,
                          height: 48,
                          aspectRatio: 1 / 1,
                        ),
                      ),
                      Text(
                        match.homeClub.nickname ?? match.homeClub.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                // SCORE
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    children: [
                      Text('${match.homeScore}', style: Theme.of(context).textTheme.headlineMedium),
                      Text(':', style: Theme.of(context).textTheme.headlineSmall),
                      Text('${match.awayScore}', style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                ),
                // AWAY CLUB
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: FutureImage(
                          image: match.awayClub.logo!,
                          height: 48,
                          aspectRatio: 1 / 1,
                        ),
                      ),
                      Text(
                        match.awayClub.nickname ?? match.awayClub.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
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
