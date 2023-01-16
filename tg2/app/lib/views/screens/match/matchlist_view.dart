import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/match_model.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/match_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/views/widgets/matchtile.dart';

// This page lists all matches
class MatchListView extends StatefulWidget {
  const MatchListView({super.key});

  @override
  State<MatchListView> createState() => _MatchListViewState();
}

class _MatchListViewState extends State<MatchListView> {
  int _currentTab = 0;

  // Method to reload providers used by the page
  Future _loadPageData() async {
    try {
      await Provider.of<ClubProvider>(context, listen: false).get();
      await Provider.of<MatchProvider>(context, listen: false).get();
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
    return Consumer2<ClubProvider, MatchProvider>(
      builder: (context, clubProvider, matchProvider, child) {
        if (matchProvider.state == ProviderState.ready &&
            clubProvider.state == ProviderState.ready) {
          List<Widget> tabs = List.from(matchProvider
              .getMatchweeks()
              .map((element) => Tab(text: "Jornada $element")));
          return DefaultTabController(
              initialIndex: _currentTab,
              length: tabs.length,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Jornadas'),
                  actions: [
                    IconButton(
                        icon: const Icon(Icons.refresh_rounded),
                        tooltip: 'Refresh',
                        onPressed: () => _loadPageData()),
                  ],
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
                body: TabBarView(
                    children:
                        List.from(matchProvider.getMatchweeks().map((element) {
                  List<Match> matchweeks = matchProvider.items.values
                      .where((match) => match.matchweek == element)
                      .toList();
                  return ListView.builder(
                    itemCount: matchweeks.length,
                    itemBuilder: (context, index) {
                      Match match = matchweeks[index];
                      return Column(
                        children: [
                          MatchTile(match: match),
                          const Divider(height: 2.0),
                        ],
                      );
                    },
                  );
                }))),
              ));
        }
        return Scaffold(
          appBar: AppBar(title: Text("Jornadas")),
        );
      },
    );
  }
}
