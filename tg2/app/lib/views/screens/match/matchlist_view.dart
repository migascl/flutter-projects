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

  Map<int, Map<MatchDay, List<Match>>> _data = {};

  // Method to reload providers used by the page
  Future _loadPageData() async {
    try {
      _data.clear();
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
        if (_data.isEmpty) {
          List<Match> items = matchProvider.items.values.toList();
          items.sort((a, b) => a.date.compareTo(b.date));
          _data = Map.fromEntries(items.map((i) => MapEntry(
                i.matchweek,
                Map.fromEntries(items.where((j) => j.matchweek == i.matchweek).map((j) {
                  DateTime matchday = DateTime(j.date.year, j.date.month, j.date.day);
                  return MapEntry(
                    MatchDay(date: matchday, isExpanded: true),
                    List.from(items.where((l) => DateTime(l.date.year, l.date.month, l.date.day)
                        .isAtSameMomentAs(matchday))),
                  );
                })),
              )));
        }

        return DefaultTabController(
          initialIndex: _currentTab,
          length: _data.length,
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
                tabs: List.from(_data.keys.map((key) => Tab(text: "Jornada $key"))),
                isScrollable: true,
                onTap: (index) {
                  setState(() {
                    _currentTab = index;
                  });
                },
              ),
            ),
            drawer: const MenuDrawer(),
            body: TabBarView(
              children: _data.keys
                  .map(
                    (int matchweek) => SingleChildScrollView(
                      child: ExpansionPanelList(
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            _data[matchweek]?.keys.elementAt(index).isExpanded = !isExpanded;
                          });
                        },
                        children: _data[matchweek]!
                            .keys
                            .map((matchday) => ExpansionPanel(
                                  headerBuilder: (BuildContext context, bool isExpanded) {
                                    return ListTile(
                                      title: Text(DateUtilities().toYMD(matchday.date)),
                                    );
                                  },
                                  body: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: _data[matchweek]![matchday]!.length,
                                    itemBuilder: (context, index) {
                                      return MatchTile(
                                          match: _data[matchweek]![matchday]!.elementAt(index));
                                    },
                                    separatorBuilder: (BuildContext context, int index) =>
                                        const Divider(),
                                  ),
                                  isExpanded: matchday.isExpanded,
                                ))
                            .toList(),
                      ),
                    ),
                  )
                  .toList(),
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
