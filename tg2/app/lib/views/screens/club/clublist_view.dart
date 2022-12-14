import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/match_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/models/club_model.dart';
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
                        }));
                list
                  ..sort((b, a) => a['matches'].compareTo(b['matches']))
                  ..sort((b, a) => a['points'].compareTo(b['points']));
                return Column(children: [
                  ListTile(
                      dense: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Text("Nome",
                                  style:
                                      Theme.of(context).textTheme.labelMedium)),
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              alignment: Alignment.center,
                              width: 48,
                              child: Text("Jogos",
                                  style:
                                      Theme.of(context).textTheme.labelMedium)),
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              alignment: Alignment.center,
                              width: 48,
                              child: Text("Pontos",
                                  style:
                                      Theme.of(context).textTheme.labelMedium)),
                        ],
                      )),
                  Expanded(
                      child: ListView.separated(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      Club club = list[index]['club'];
                      int totalMatches = list[index]['matches'];
                      int totalPoints = list[index]['points'];
                      return Column(children: [
                        ListTile(
                          leading: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: FadeInImage(
                              image: club.picture!,
                              placeholder: AssetImage(
                                  "assets/images/placeholder-club.jpg"),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                    "assets/images/placeholder-club.jpg",
                                    fit: BoxFit.contain);
                              },
                              fit: BoxFit.contain,
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(club.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall)),
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  alignment: Alignment.center,
                                  width: 48,
                                  child: Text(totalMatches.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge)),
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  alignment: Alignment.center,
                                  width: 48,
                                  child: Text(totalPoints.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge)),
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
                        )
                      ]);
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ))
                ]);
              }
              return Container();
            })));
  }
}
