import 'package:flutter/material.dart';
import 'package:tg2/models/match_model.dart';
import '../screens/match/match_view.dart';

// TODO STYLING
class MatchTile extends StatelessWidget {
  const MatchTile({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
            child: (match.clubHome.picture != null)
                ? Image(image: match.clubHome.picture!, height: 48)
                : null),
        Text("${match.homeScore} : ${match.awayScore}"),
        Container(
            child: (match.clubAway.picture != null)
                ? Image(image: match.clubAway.picture!, height: 48)
                : null),
      ]),
      onTap: () {
        showModalBottomSheet(
            context: context, builder: (context) => MatchView(match: match));
      },
    );
  }
}
