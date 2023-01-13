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
    return Column(children: [
      Container(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.04,
            horizontal: 16),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/match-bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Column(
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  children: [
                    const Icon(Icons.calendar_month_rounded,
                        size: 18, color: Colors.white),
                    Text("${match.date.toUtc()}",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.merge(const TextStyle(color: Colors.white)))
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  children: [
                    const Icon(Icons.stadium_rounded,
                        size: 18, color: Colors.white),
                    Text(match.stadium.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.merge(const TextStyle(color: Colors.white)))
                  ],
                ),
              ],
            ),
            Column(children: [
              const SizedBox(height: 16),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 64,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: FadeInImage(
                                image: match.clubHome.picture!,
                                placeholder: const AssetImage(
                                    "assets/images/placeholder-club.jpg"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                      "assets/images/placeholder-club.jpg",
                                      fit: BoxFit.contain);
                                },
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(match.clubHome.name,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.merge(
                                      const TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${match.homeScore}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.merge(const TextStyle(
                                          color: Colors.white))),
                              const SizedBox(width: 16),
                              Text(":",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.merge(const TextStyle(
                                          color: Colors.white))),
                              const SizedBox(width: 16),
                              Text("${match.awayScore}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.merge(const TextStyle(
                                          color: Colors.white))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 4,
                            children: [
                              const Icon(Icons.timelapse_rounded,
                                  size: 24, color: Colors.white),
                              Text("${match.duration} minutos",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      ?.merge(
                                          const TextStyle(color: Colors.white)))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          SizedBox(
                            height: 64,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: FadeInImage(
                                image: match.clubAway.picture!,
                                placeholder: const AssetImage(
                                    "assets/images/placeholder-club.jpg"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                      "assets/images/placeholder-club.jpg",
                                      fit: BoxFit.contain);
                                },
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(match.clubAway.name,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.merge(
                                      const TextStyle(color: Colors.white))),
                        ])),
                  ]),
            ]),
          ],
        ),
      ),
    ]);
  }
}
