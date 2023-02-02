import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/models/match_model.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/views/widgets/futureimage.dart';

// This widgets shows a match's information
class MatchView extends StatefulWidget {
  const MatchView({super.key, required this.match});

  final Match match;

  @override
  State<MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<MatchView> {
  Widget clubBadgeWidget(Club club) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureImage(
            image: club.logo,
            height: 64,
            aspectRatio: 1 / 1,
          ),
          const SizedBox(height: 8),
          Text(
            club.nickname ?? club.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.merge(const TextStyle(color: Colors.white)),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    print('Match/V: Building...');
    return DraggableScrollableSheet(
      initialChildSize: 1,
      maxChildSize: 1,
      expand: true,
      builder: (context, controller) => Column(children: [
        // ############# Header #############
        Container(
          margin: const EdgeInsets.fromLTRB(0, 32, 0, 0),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/match-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(children: [
                // ############# Handle #############
                Divider(
                  height: 0,
                  thickness: 4,
                  color: Colors.white,
                  indent: MediaQuery.of(context).size.width * 0.4,
                  endIndent: MediaQuery.of(context).size.width * 0.4,
                ),
                const SizedBox(height: 16),
                // ############# Date #############
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  children: [
                    const Icon(Icons.calendar_month_rounded, size: 18, color: Colors.white),
                    Text(
                      DateFormat.yMMMMd('pt_PT').add_Hm().format(widget.match.date),
                      style: Theme.of(context).textTheme.bodySmall?.merge(const TextStyle(color: Colors.white)),
                    )
                  ],
                ),
                const SizedBox(height: 8),
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ############# Club Home #############
                  Expanded(child: clubBadgeWidget(widget.match.homeClub)),
                  // ############# Score & Time #############
                  Expanded(
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${widget.match.homeScore}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall?.merge(const TextStyle(color: Colors.white)),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ':',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall?.merge(const TextStyle(color: Colors.white70)),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${widget.match.awayScore}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall?.merge(const TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        children: [
                          const Icon(Icons.timelapse_rounded, size: 24, color: Colors.white),
                          Text(
                            '${widget.match.duration} minutos',
                            style: Theme.of(context).textTheme.bodySmall?.merge(const TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    ]),
                  ),
                  // ############# Club Away #############
                  Expanded(child: clubBadgeWidget(widget.match.awayClub)),
                ],
              ),
            ],
          ),
        ),
        // ############# Body #############
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            color: Theme.of(context).canvasColor,
            child: Row(
              children: [
                Expanded(
                  child: _MatchSquadList(scrollController: controller, club: widget.match.homeClub),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MatchSquadList(scrollController: controller, club: widget.match.awayClub, mirrored: true),
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
                child: Builder(
                  builder: (context) {
                    List<Contract> squad =
                        contractProvider.data.values.where((e) => e.club == widget.club && e.active).toList();
                    switch (contractProvider.state) {
                      case ProviderState.busy:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        return ListView.builder(
                          primary: false,
                          controller: widget.scrollController,
                          itemCount: squad.length,
                          itemBuilder: (context, index) {
                            Contract contract = squad[index];
                            return ListTile(
                              dense: true,
                              minVerticalPadding: 0,
                              horizontalTitleGap: 0,
                              leading: FutureImage(
                                image: contract.player.picture,
                                height: 32,
                                aspectRatio: 1 / 1,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              title: Text(
                                '${contract.shirtNumber}. ${contract.player.nicknameFallback}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              subtitle: Text(
                                contract.position.name,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            );
                          },
                        );
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
      child: Builder(builder: (context) {
        List<Widget> header = [
          FutureImage(
            image: widget.club.logo,
            height: 32,
            aspectRatio: 1 / 1,
          ),
          Text(
            (widget.mirrored) ? 'Equipa Fora' : 'Equipa Casa',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ];
        if (widget.mirrored) header = header.reversed.toList();
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            alignment: (widget.mirrored) ? WrapAlignment.end : WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: header,
          ),
        );
      }),
    );
  }
}
