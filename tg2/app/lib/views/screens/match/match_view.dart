import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/models/match_model.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/utils/dateutils.dart';
import 'package:tg2/views/widgets/contracttile.dart';
import 'package:tg2/views/widgets/futureimage.dart';

// This widgets shows a match's information
class MatchView extends StatefulWidget {
  const MatchView({super.key, required this.match});

  final Match match;

  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  Widget _clubBadgeWidget(Club club) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureImage(
            image: club.picture!,
            errorImageUri: 'assets/images/placeholder-club.png',
            height: 64,
            aspectRatio: 1 / 1,
          ),
          const SizedBox(height: 8),
          Text(
            club.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.merge(const TextStyle(color: Colors.white)),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    print("Match/V: Building...");
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 1,
      minChildSize: 0.75,
      expand: false,
      builder: (context, controller) => Column(children: [
        // ############# Handle #############
        Container(
          padding: const EdgeInsets.fromLTRB(0, 32, 0, 8),
          child: Divider(
            thickness: 4,
            color: Colors.white,
            indent: MediaQuery.of(context).size.width * 0.45,
            endIndent: MediaQuery.of(context).size.width * 0.45,
          ),
        ),
        // ############# Header #############
        Container(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.05,
            horizontal: 16,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            image: DecorationImage(
              image: AssetImage("assets/images/match-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: [
            Column(children: [
              // ############# Date #############
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                children: [
                  const Icon(Icons.calendar_month_rounded, size: 18, color: Colors.white),
                  Text(
                    "${DateUtilities().toYMD(widget.match.date)} ${DateUtilities().toHM(widget.match.date)}",
                    style: Theme.of(context).textTheme.bodySmall?.merge(const TextStyle(color: Colors.white)),
                  )
                ],
              ),
              const SizedBox(height: 4),
              // ############# Stadium #############
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4,
                children: [
                  const Icon(Icons.stadium_rounded, size: 18, color: Colors.white),
                  Text(
                    widget.match.stadium.name,
                    style: Theme.of(context).textTheme.bodySmall?.merge(const TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ]),
            Column(children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ############# Club Home #############
                  Expanded(child: _clubBadgeWidget(widget.match.clubHome)),
                  // ############# Score & Time #############
                  Expanded(
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.match.homeScore}",
                            style: Theme.of(context).textTheme.displaySmall?.merge(const TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            ":",
                            style: Theme.of(context).textTheme.displaySmall?.merge(const TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "${widget.match.awayScore}",
                            style: Theme.of(context).textTheme.displaySmall?.merge(const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        children: [
                          const Icon(Icons.timelapse_rounded, size: 24, color: Colors.white),
                          Text(
                            "${widget.match.duration} minutos",
                            style: Theme.of(context).textTheme.caption?.merge(const TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    ]),
                  ),
                  // ############# Club Away #############
                  Expanded(child: _clubBadgeWidget(widget.match.clubAway)),
                ],
              ),
            ]),
          ]),
        ),
        // ############# Body #############
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            color: Theme.of(context).canvasColor,
            child: Row(
              children: [
                Expanded(
                  child: _MatchSquadList(scrollController: controller, club: widget.match.clubHome),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MatchSquadList(scrollController: controller, club: widget.match.clubAway, mirrored: true),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

// Widget to display each clubs team list
class _MatchSquadList extends StatefulWidget {
  const _MatchSquadList({super.key, required this.scrollController, required this.club, this.mirrored = false});

  final ScrollController scrollController;
  final Club club;
  final bool mirrored;

  @override
  State<_MatchSquadList> createState() => _MatchSquadListState();
}

class _MatchSquadListState extends State<_MatchSquadList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ContractProvider>(
      builder: (context, contractProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(child: child),
            Divider(height: 0, color: widget.club.color, thickness: 3),
            Expanded(
              child: Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
                  margin: EdgeInsets.zero,
                  child: Builder(builder: (context) {
                    List<Contract> _squad =
                        contractProvider.items.values.where((e) => e.club == widget.club && e.active).toList();
                    switch (contractProvider.state) {
                      case ProviderState.busy:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        return ListView.builder(
                          primary: false,
                          controller: widget.scrollController,
                          itemCount: _squad.length,
                          itemBuilder: (context, index) {
                            return ContractTile(
                              contract: _squad[index],
                              showClub: false,
                              dense: true,
                            );
                          },
                        );
                    }
                  })),
            ),
          ],
        );
      },
      child: Builder(builder: (context) {
        List<Widget> _header = [
          FutureImage(
            image: widget.club.picture!,
            errorImageUri: 'assets/images/placeholder-club.png',
            height: 32,
            aspectRatio: 1 / 1,
          ),
          Text(
            (widget.mirrored) ? "Equipa Fora" : "Equipa Casa",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ];
        if (widget.mirrored) _header = _header.reversed.toList();
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            alignment: (widget.mirrored) ? WrapAlignment.end : WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: _header,
          ),
        );
      }),
    );
  }
}
