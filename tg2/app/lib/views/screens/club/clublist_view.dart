import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/match_provider.dart';
import 'package:tg2/utils/constants.dart';
import '../../../models/club_model.dart';
import 'club_view.dart';

// This page lists all clubs
class ClubListView extends StatefulWidget {
  const ClubListView({super.key});

  @override
  State<ClubListView> createState() => _ClubListViewState();
}

class _ClubListViewState extends State<ClubListView> {
  final GlobalKey<RefreshIndicatorState> _clubListRefreshKey =
      GlobalKey<RefreshIndicatorState>();

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
    print("ClubList/V: Initialized State!");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("ClubList/V: Building...");
    return Scaffold(
        appBar: AppBar(title: Text("Clubes")),
        body: RefreshIndicator(
            key: _clubListRefreshKey,
            onRefresh: _loadPageData,
            child: Consumer2<ClubProvider, MatchProvider>(
                builder: (context, clubProvider, matchProvider, child) {
              if (matchProvider.state != ProviderState.empty &&
                  clubProvider.state != ProviderState.empty) {
                // Query data from clubs and matches to sort them by who has the most points and matches
                var list = List.from(clubProvider.items.values
                    .where((element) => element.playing == true)
                    .map((e) => {
                      'club': e,
                      'matches': matchProvider.getByClub(e).length,
                      'points': matchProvider.getClubPoints(e)
                    })
                );
                list
                  ..sort((b, a) => a['matches'].compareTo(b['matches']))
                  ..sort((b, a) => a['points'].compareTo(b['points']));
                // TODO BETTER STYLING
                return Column(children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Expanded(child: Text("Nome")),
                        Container(
                          alignment: Alignment.center,
                          width: 48,
                          child: const Text("Jogos"),
                        ),
                        SizedBox(width: 8),
                        Container(
                          alignment: Alignment.center,
                          width: 48,
                          child: const Text("Pontos"),
                        ),
                      ],
                    )
                  ),
                  Expanded(child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      Club club = list[index]['club'];
                      int totalMatches = list[index]['matches'];
                      int totalPoints = list[index]['points'];
                      return Column(
                        children: [
                          ListTile(
                            leading: Container(
                              width: 48,
                              child: (club.picture != null)
                                  ? Image(image: NetworkImage(club.picture!), height: 48)
                                  : null
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(club.name)),
                                Container(
                                  alignment: Alignment.center,
                                  width: 48,
                                  child: Text(totalMatches.toString()),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  alignment: Alignment.center,
                                  width: 48,
                                  child: Text(totalPoints.toString()),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ClubView(club: club),
                                  maintainState: true,
                                ),
                              );
                            },
                          ),
                          const Divider(height: 2.0),
                        ],
                      );
                    },
                  ))
                ]);
              }
              return Container();
            })));
  }
}
