import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/match_model.dart';

import '../../../provider/match_provider.dart';
import '../../../utils/constants.dart';
import '../../widgets/matchtile.dart';
import '../../widgets/menudrawer.dart';

// This page lists all matches
class MatchListView extends StatefulWidget {
  const MatchListView({super.key});

  @override
  State<MatchListView> createState() => _MatchListViewState();
}

class _MatchListViewState extends State<MatchListView> {
  final GlobalKey<RefreshIndicatorState> _matchListRefreshKey =
      GlobalKey<RefreshIndicatorState>();

  int _currentTab = 0;

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
    return Consumer<MatchProvider>(
      builder: (context, matchProvider, child) {
        if (matchProvider.state == ProviderState.ready) {
          List<Widget> tabs = List.from(matchProvider
              .getMatchweeks()
              .map((element) => Tab(text: "Jornada $element")));
          return DefaultTabController(
            initialIndex: _currentTab,
            length: tabs.length,
            child: Scaffold(
              appBar: AppBar(
                elevation: 1,
                title: const Text('Jornada'),
                bottom: TabBar(
                  tabs: tabs,
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
                children:
                    List.from(matchProvider.getMatchweeks().map((element) {
                  List<Match> matches = matchProvider.items.values
                      .where((match) => match.matchweek == element)
                      .toList();
                  return Card(
                    margin: const EdgeInsets.all(8),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: RefreshIndicator(
                      key: _matchListRefreshKey,
                      onRefresh: _loadPageData,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: matches.length,
                          itemBuilder: (context, index) {
                            Match match = matches[index];
                            return MatchTile(match: match);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      ),
                    ),
                  );
                })),
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Jornada"),
            elevation: 1,
          ),
          drawer: MenuDrawer(),
        );
      },
    );
  }
}
