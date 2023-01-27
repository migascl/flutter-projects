import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/match_model.dart';
import 'package:tg2/provider/match_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/views/widgets/matchtile.dart';
import 'package:tg2/views/widgets/menudrawer.dart';

// This page lists all matches and groups then by matchweek
class MatchListView extends StatefulWidget {
  const MatchListView({super.key});

  @override
  State<MatchListView> createState() => _MatchListViewState();
}

class _MatchListViewState extends State<MatchListView> {
  Map<int, Map<String, List<Match>>> _data = {}; // Data structure of the page

  int _currentTab = 0; // Current tab index number

  // Method to reload providers used by the page
  Future _loadPageData() async {
    try {
      await Provider.of<MatchProvider>(context, listen: false).get();
      _data.clear();
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
    print("MatchListView/V: Initialized State!");
    super.initState();
    // Run once after build is complete
    WidgetsBinding.instance.addPostFrameCallback((context) => _loadPageData());
  }

  @override
  Widget build(BuildContext context) {
    print("MatchListView/V: Building...");
    return Consumer<MatchProvider>(builder: (context, matchProvider, child) {
      /*
      Page data structure query
      Only performs the query if provider data is not empty, to save on processing
      It first starts by mapping all the matches matchweeks into keys and the values as child map
      That fragments each matchweek into matchdays as keys and their values will be a list of matches
      that took place in that matchday.
      Here's the visual representation of the data tree:
      {
        matchweek1: [
          {matchday1: [match1, match2, match3]},
          {matchday2: [match4, match5, match6, ...]},
          ...
        ],
        matchweek2": [
          {matchday5: [match12, match13, match14]},
          ...
        ],
        ...
      }
      */
      if (matchProvider.state != ProviderState.busy && _data.isEmpty) {
        List<Match> items = matchProvider.items.values.toList();
        items.sort((a, b) => b.matchweek.compareTo(a.matchweek));
        _data = Map.fromEntries(items.map((i) => MapEntry(
              i.matchweek, // Matchweek Number
              Map.fromEntries(items.where((j) => j.matchweek == i.matchweek).map((k) {
                DateTime matchday = DateTime(k.date.year, k.date.month, k.date.day);
                List<Match> matches = items.where((l) => DateUtils.isSameDay(l.date, matchday)).toList();
                return MapEntry(
                  matchday.toIso8601String(),
                  matches,
                );
              })),
            )));
      }

      return DefaultTabController(
        initialIndex: _currentTab,
        length: _data.length,
        child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            title: const Text("Jogos"),
            centerTitle: true,
            bottom: TabBar(
              tabs: _data.keys.map((key) => Tab(text: "Jornada $key")).toList(),
              isScrollable: true,
              onTap: (index) {
                setState(() {
                  _currentTab = index;
                });
              },
            ),
          ),
          drawer: const MenuDrawer(),
          body: Builder(builder: (BuildContext context) {
            // As long as the page data is not empty, it will show whatever data it has stored in cache
            if (_data.isNotEmpty) {
              return TabBarView(
                children: _data.keys.map((int matchweek) {
                  return RefreshIndicator(
                      key: GlobalKey<RefreshIndicatorState>(),
                      onRefresh: _loadPageData,
                      child: SingleChildScrollView(
                          primary: true,
                          child: Card(
                            elevation: 1,
                            margin: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.5,
                                color: Colors.black.withOpacity(0.25),
                              ),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: ListView.separated(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: _data[matchweek]!.length,
                                itemBuilder: (context, index) {
                                  String matchday = _data[matchweek]!.keys.elementAt(index);
                                  return Column(children: [
                                    Material(
                                      color: Theme.of(context).colorScheme.tertiary,
                                      elevation: 4,
                                      shadowColor: Theme.of(context).colorScheme.shadow,
                                      child: ListTile(
                                        dense: true,
                                        title: Text(
                                          DateFormat.yMMMMd('pt_PT').format(DateTime.parse(matchday)),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer),
                                        ),
                                      ),
                                    ),
                                    ListView.separated(
                                      primary: false,
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _data[matchweek]![matchday]!.length,
                                      itemBuilder: (context, index) {
                                        Match match = _data[matchweek]![matchday]!.elementAt(index);
                                        return MatchTile(match: match);
                                      },
                                      separatorBuilder: (context, index) => const Divider(height: 0, thickness: 1),
                                    ),
                                  ]);
                                },
                                separatorBuilder: (context, index) => const Divider(height: 0, thickness: 1),
                              ),
                            ),
                          )));
                }).toList(),
              );
            }
            // If the page data is empty, but the provider is busy, show loading indicator
            if (_data.isEmpty && matchProvider.state == ProviderState.busy) {
              return const Center(child: CircularProgressIndicator());
            } else {
              // If nothing is found
              return Center(
                child: Wrap(direction: Axis.vertical, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  Text("Não foram encontradas nenhuns jogos"),
                  ElevatedButton(onPressed: _loadPageData, child: Text("Tentar novamente")),
                ]),
              );
            }
          }),
        ),
      );
    });
  }
}
