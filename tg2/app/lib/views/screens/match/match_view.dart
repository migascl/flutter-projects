import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/models/match_model.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/utils/dateutils.dart';
import 'package:tg2/views/widgets/squadtile.dart';

import '../../widgets/futureimage.dart';

// This widgets shows a match's information
class MatchView extends StatefulWidget {
  const MatchView({super.key, required this.match});

  final Match match;

  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  @override
  Widget build(BuildContext context) {
    print("Match/V: Building...");
    return Consumer<ContractProvider>(
        builder: (context, contractProvider, child) {
      List<Contract> homeSquad = contractProvider.activeContracts.values
          .where((element) =>
              element.club == widget.match.clubHome && element.active)
          .toList();
      List<Contract> awaySquad = contractProvider.activeContracts.values
          .where((element) =>
              element.club == widget.match.clubAway && element.active)
          .toList();
      if (contractProvider.state == ProviderState.ready) {
        return DraggableScrollableSheet(
          initialChildSize: 1,
          maxChildSize: 1,
          minChildSize: 0.75,
          expand: false,
          builder: (context, controller) => Column(
            children: [
              // Handle
              Container(
                padding: const EdgeInsets.fromLTRB(0, 32, 0, 8),
                child: Divider(
                  thickness: 4,
                  color: Colors.white,
                  indent: MediaQuery.of(context).size.width * 0.45,
                  endIndent: MediaQuery.of(context).size.width * 0.45,
                ),
              ),
              // Header
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.05,
                    horizontal: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  image: DecorationImage(
                    image: AssetImage("assets/images/match-bg.png"),
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
                            Text(
                                "${DateUtilities().toYMD(widget.match.date)} ${DateUtilities().toHM(widget.match.date)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.merge(
                                        const TextStyle(color: Colors.white)))
                          ],
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 4,
                          children: [
                            const Icon(Icons.stadium_rounded,
                                size: 18, color: Colors.white),
                            Text(widget.match.stadium.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.merge(
                                        const TextStyle(color: Colors.white)))
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
                                  FutureImage(
                                    image: widget.match.clubHome.picture!,
                                    errorImageUri:
                                        'assets/images/placeholder-club.png',
                                    height: 64,
                                    aspectRatio: 1 / 1,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(widget.match.clubHome.name,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.merge(const TextStyle(
                                              color: Colors.white))),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${widget.match.homeScore}",
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
                                      Text("${widget.match.awayScore}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall
                                              ?.merge(const TextStyle(
                                                  color: Colors.white))),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 4,
                                    children: [
                                      const Icon(Icons.timelapse_rounded,
                                          size: 24, color: Colors.white),
                                      Text("${widget.match.duration} minutos",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              ?.merge(const TextStyle(
                                                  color: Colors.white)))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  FutureImage(
                                    image: widget.match.clubAway.picture!,
                                    errorImageUri:
                                        'assets/images/placeholder-club.png',
                                    height: 64,
                                    aspectRatio: 1 / 1,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(widget.match.clubAway.name,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.merge(const TextStyle(
                                              color: Colors.white))),
                                ])),
                          ]),
                    ]),
                  ],
                ),
              ),
              // Body
              Expanded(
                child: Container(
                    color: Theme.of(context).canvasColor,
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Row(
                      children: [
                        _MatchSquadList(
                            scrollController: controller,
                            club: widget.match.clubHome,
                            squad: homeSquad),
                        _MatchSquadList(
                          scrollController: controller,
                          club: widget.match.clubAway,
                          squad: awaySquad,
                          reversed: true,
                        ),
                      ],
                    )),
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}

class _MatchSquadList extends StatelessWidget {
  const _MatchSquadList(
      {super.key,
      required this.scrollController,
      required this.club,
      required this.squad,
      this.reversed = false});

  final ScrollController scrollController;
  final Club club;
  final List<Contract> squad;
  final bool reversed;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      FutureImage(
        image: club.picture!,
        errorImageUri: 'assets/images/placeholder-club.png',
        height: 32,
        aspectRatio: 1 / 1,
      ),
      Text(
        (reversed) ? "Equipa Fora" : "Equipa Casa",
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ];

    if (reversed) list = list.reversed.toList();

    return Expanded(
      child: Column(
        crossAxisAlignment:
            (reversed) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: list)),
          Card(
            child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              controller: scrollController,
              itemCount: squad.length,
              itemBuilder: (context, index) {
                return SquadTile(
                  contract: squad[index],
                  dense: true,
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}
