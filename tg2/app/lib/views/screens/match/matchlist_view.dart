import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/match_model.dart';
import 'package:tg2/provider/match_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/utils/dateutils.dart';
import 'package:tg2/views/widgets/matchtile.dart';
import 'package:tg2/views/widgets/menudrawer.dart';

class MatchDay {
  MatchDay({
    required this.date,
    this.isExpanded = false,
  });

  DateTime date;
  bool isExpanded;
}

// This page lists all matches and groups then by matchweek
class MatchListView extends StatefulWidget {
  const MatchListView({super.key});

  @override
  State<MatchListView> createState() => _MatchListViewState();
}

class _MatchListViewState extends State<MatchListView> {
  int _currentTab = 0; // Current tab index number
  final String appBarTitle = "Jogos";

  // Method to reload providers used by the page
  Future _loadPageData() async {
    try {
      Provider.of<MatchProvider>(context, listen: false).get();
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
  }

  @override
  Widget build(BuildContext context) {
    print("MatchListView/V: Building...");
    return Consumer<MatchProvider>(builder: (context, matchProvider, child) {
      if (matchProvider.state == ProviderState.ready) {
        // Get a list of tabs from the number of matchweeks given by the provider
        Set<int> matchweeks = Set.from(matchProvider.items.values.map((e) => e.matchweek));
        return DefaultTabController(
          initialIndex: _currentTab,
          length: matchweeks.length,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              title: Text(appBarTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Refresh',
                  onPressed: () => _loadPageData(),
                ),
              ],
              bottom: TabBar(
                tabs: List.from(matchweeks.map((key) => Tab(text: "Jornada $key"))),
                isScrollable: true,
                onTap: (index) {
                  setState(() {
                    _currentTab = index;
                  });
                },
              ),
            ),
            drawer: const MenuDrawer(),
            // Generate pages based on the list of matches of a select matchweek
            body: TabBarView(
              children: List.from(matchweeks.map((matchweek) {
                // Get unique days in every single matchweek
                Set<DateTime> matchDays = Set.from(matchProvider.items.values
                    .where((element) => element.matchweek == matchweek)
                    .map((e) => DateTime(e.date.year, e.date.month, e.date.day)));

                return SingleChildScrollView(
                  child: ExpansionPanelList(
                    children: matchDays.map<ExpansionPanel>((DateTime matchDay) {
                      List<Match> matches = List.from(matchProvider.items.values.where((element) =>
                          DateTime(element.date.year, element.date.month, element.date.day)
                              .isAtSameMomentAs(matchDay)));

                      return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text(DateUtilities().toYMD(matchDay)),
                          );
                        },
                        body: ListView.separated(
                          shrinkWrap: true,
                          itemCount: matches.length,
                          itemBuilder: (context, index) {
                            Match match = matches.elementAt(index);
                            return MatchTile(match: match);
                          },
                          separatorBuilder: (BuildContext context, int index) => const Divider(),
                        ),
                        isExpanded: true,
                      );
                    }).toList(),
                  ),
                );
              })),
            ),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          elevation: 1,
        ),
        drawer: const MenuDrawer(),
        body: const Center(child: CircularProgressIndicator()),
      );
    });
  }
}
