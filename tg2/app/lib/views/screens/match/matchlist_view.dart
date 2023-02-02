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
  List<int> matchweeks = []; // Data structure of the page

  int currentTab = 0; // Current tab index number

  // Method to reload providers used by the page
  Future _loadPageData() async {
    try {
      await Provider.of<MatchProvider>(context, listen: false).get();
      matchweeks.clear();
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
    print('MatchListView/V: Initialized State!');
    super.initState();
    // Run once after build is complete
    WidgetsBinding.instance.addPostFrameCallback((context) => _loadPageData());
  }

  @override
  Widget build(BuildContext context) {
    print('MatchListView/V: Building...');
    return Consumer<MatchProvider>(builder: (context, matchProvider, child) {
      // Get matchweek numbers to populate tabs & tab views
      if (matchProvider.state != ProviderState.busy && matchweeks.isEmpty) {
        matchweeks = matchProvider.getMatchweeks();
      }

      return DefaultTabController(
        initialIndex: currentTab,
        length: matchweeks.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Jogos'),
            bottom: TabBar(
              tabs: matchweeks.map((matchweek) => Tab(text: 'Jornada $matchweek')).toList(),
              isScrollable: true,
              onTap: (index) => setState(() => currentTab = index),
            ),
          ),
          drawer: const MenuDrawer(),
          body: Builder(builder: (BuildContext context) {
            // As long as the page data is not empty, it will show whatever data it has stored in cache
            if (matchweeks.isNotEmpty) {
              return TabBarView(
                children: matchweeks.map((int matchweek) {
                  // Get matchdays of that matchweek
                  List<String> matchdays = matchProvider.data.values
                      .where((e) => (e.matchweek == matchweek))
                      .map((match) => DateTime(match.date.year, match.date.month, match.date.day).toIso8601String())
                      .toSet()
                      .toList();
                  return RefreshIndicator(
                      key: GlobalKey<RefreshIndicatorState>(),
                      onRefresh: _loadPageData,
                      child: SingleChildScrollView(
                        primary: true,
                        child: Card(
                          margin: const EdgeInsets.all(16),
                          // MATCHDAY GROUP
                          child: ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: matchdays.length,
                            itemBuilder: (context, index) {
                              // Get matches from matchday
                              DateTime matchday = DateTime.parse(matchdays[index]);
                              String matchdayLabel = DateFormat.yMMMMEEEEd('pt_PT').format(matchday);
                              List<Match> matches = matchProvider.data.values
                                  .where((match) => DateUtils.isSameDay(match.date, matchday))
                                  .toList();
                              return Column(children: [
                                ListTile(
                                  tileColor: Theme.of(context).colorScheme.surfaceVariant,
                                  dense: true,
                                  textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                                  title: Text(
                                    matchdayLabel.replaceRange(0, 1, matchdayLabel.substring(0, 1).toUpperCase()),
                                    // Capitalize week day
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                                // MATCHES IN MATCHDAY GROUP
                                ListView.separated(
                                  primary: false,
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: matches.length,
                                  itemBuilder: (context, index) {
                                    Match match = matches[index];
                                    return MatchTile(match: match, showTimeOnly: true);
                                  },
                                  separatorBuilder: (context, index) => const Divider(height: 0),
                                ),
                              ]);
                            },
                            separatorBuilder: (context, index) => const Divider(height: 0),
                          ),
                        ),
                      ));
                }).toList(),
              );
            }
            // If the page data is empty, but the provider is busy, show loading indicator
            if (matchweeks.isEmpty && matchProvider.state == ProviderState.busy) {
              return const Center(child: CircularProgressIndicator());
            } else {
              // If nothing is found
              return Center(
                child: Wrap(direction: Axis.vertical, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  const Text('Não foram encontradas nenhuns jogos'),
                  ElevatedButton(onPressed: _loadPageData, child: const Text('Tentar novamente')),
                ]),
              );
            }
          }),
        ),
      );
    });
  }
}
