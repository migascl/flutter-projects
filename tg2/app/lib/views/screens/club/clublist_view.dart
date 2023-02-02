import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/match_provider.dart';
import 'package:tg2/utils/constants.dart';

import '../../widgets/futureimage.dart';
import '../../widgets/header.dart';
import '../../widgets/menudrawer.dart';
import 'club_view.dart';

// This page lists all clubs
class ClubListView extends StatefulWidget {
  const ClubListView({super.key});

  @override
  State<ClubListView> createState() => _ClubListViewState();
}

class _ClubListViewState extends State<ClubListView> {
  List<Map<String, dynamic>> matches = []; // Data structure of the page
  List<int> filterData = []; // Filter data (Dropdown items)
  int? selectedMatchweek;

  void setMatchweek(int? matchweek) {
    setState(() => selectedMatchweek = matchweek);
    matches.clear();
  }

  // Reload providers used by the page, displays snackbar if exception occurs
  Future _loadPageData() async {
    try {
      await Provider.of<ClubProvider>(context, listen: false).get();
      filterData.clear();
      matches.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro. Tente novamente.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  void initState() {
    print('ClubList/V: Initialized State!');
    super.initState();
    // Run once after build is complete
    WidgetsBinding.instance.addPostFrameCallback((context) => _loadPageData());
  }

  @override
  Widget build(BuildContext context) {
    print('ClubList/V: Building...');
    return Consumer2<ClubProvider, MatchProvider>(builder: (context, clubProvider, matchProvider, child) {
      // Since match provider depends on club provider, its state dictates the page's state
      // But the page data does not depend on match data being empty or not
      if (matchProvider.state != ProviderState.busy && matches.isEmpty) {
        filterData = matchProvider.getMatchweeks();
        // Query data from clubs and matches to sort them by who has the most points and matches
        matches = clubProvider.items.values
            .where((club) => club.playing == true)
            .map((club) => {
                  'club': club,
                  'matches': matchProvider.getByClub(club).length,
                  'points': matchProvider.getClubPoints(club: club, matchweek: selectedMatchweek),
                })
            .toList();
        matches
          ..sort((b, a) => a['matches'].compareTo(b['matches']))
          ..sort((b, a) => a['points'].compareTo(b['points']));
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Clubes'),
          // FILTER POPUP
          actions: filterData.isNotEmpty
              ? [
                  IconButton(
                    icon: const Icon(Icons.sort_outlined),
                    tooltip: 'Filtos',
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: HeaderWidget(
                                  headerText: 'Selecionar Jornada',
                                  headerAction: IconButton(
                                    splashRadius: 24,
                                    icon: const Icon(Icons.clear),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: DropdownButtonFormField<int>(
                                              items: filterData.map<DropdownMenuItem<int>>((int value) {
                                                return DropdownMenuItem<int>(
                                                  value: value,
                                                  child: Text('Jornada $value'),
                                                );
                                              }).toList(),
                                              value: selectedMatchweek,
                                              onChanged: (value) => setState(() => setMatchweek(value)),
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.zero,
                                                ),
                                                labelText: 'Jornada',
                                              ),
                                              isExpanded: true,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          TextButton(
                                            onPressed: () => setState(() => setMatchweek(null)),
                                            child: const Text('Limpar'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ]
              : null,
        ),
        drawer: const MenuDrawer(),
        body: RefreshIndicator(
          key: GlobalKey<RefreshIndicatorState>(),
          onRefresh: _loadPageData,
          child: Builder(
            builder: (BuildContext context) {
              if (matches.isNotEmpty) {
                return Column(children: [
                  Material(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: ListTile(
                      dense: true,
                      title: Row(
                        children: [
                          Expanded(child: Text('Nome do Clube', style: Theme.of(context).textTheme.labelMedium)),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            alignment: Alignment.center,
                            width: 48,
                            child: Text('Jogos', style: Theme.of(context).textTheme.labelMedium),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            alignment: Alignment.center,
                            width: 48,
                            child: Text('Pontos', style: Theme.of(context).textTheme.labelMedium),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 0, thickness: 1),
                  Expanded(
                    child: ListView.separated(
                      itemCount: matches.length,
                      itemBuilder: (context, index) {
                        Club club = matches[index]['club'];
                        int totalMatches = matches[index]['matches'];
                        int totalPoints = matches[index]['points'];
                        return ListTile(
                          tileColor: Theme.of(context).colorScheme.surface,
                          dense: true,
                          leading: FutureImage(
                            image: club.logo!,
                            errorImageUri: 'assets/images/placeholder-club.png',
                            aspectRatio: 1 / 1,
                            height: 42,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(club.name, style: Theme.of(context).textTheme.titleSmall)),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                alignment: Alignment.center,
                                width: 48,
                                child: Text('$totalMatches', style: Theme.of(context).textTheme.labelLarge),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                alignment: Alignment.center,
                                width: 48,
                                child: Text('$totalPoints', style: Theme.of(context).textTheme.labelLarge),
                              ),
                            ],
                          ),
                          subtitle: Text(club.stadium!.city, style: Theme.of(context).textTheme.caption),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ClubView(club: club, selectedMatchweek: selectedMatchweek),
                                maintainState: false,
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(height: 0),
                    ),
                  )
                ]);
              }
              if (matches.isEmpty && matchProvider.state == ProviderState.busy) {
                return const Center(child: CircularProgressIndicator());
              }
              // If nothing is found
              return Center(
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text('Não foram encontrados nenhuns clubes'),
                    ElevatedButton(onPressed: _loadPageData, child: const Text('Tentar novamente')),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
