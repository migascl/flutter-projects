import 'package:flutter/material.dart';
import 'package:tg2/models/match_model.dart';

// TODO STYLING
// This widgets shows a match's information
class MatchView extends StatelessWidget {
  const MatchView({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    print("Match/V: Building...");
    return Column(
      children: [
        Text(match.date.toString()),
        Text(match.stadium.name),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(child: (match.clubHome.picture != null) ? Image(image: NetworkImage(match.clubHome.picture!), height: 48) : null),
              Text("${match.homeScore} : ${match.awayScore}"),
              Container(child: (match.clubAway.picture != null) ? Image(image: NetworkImage(match.clubAway.picture!), height: 48) : null),
            ]
        ),
        Text("${match.duration} minutos"),
      ]
    );
  }
}