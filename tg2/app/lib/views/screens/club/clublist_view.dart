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

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  // Method to reload providers used by the page
  Future _loadPageData() async {
    try{
      await Provider.of<ClubProvider>(context, listen: false).get();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPageData();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("ClubList/V: Building...");
    return Scaffold(
        appBar: AppBar(
            title: Text("Clubes")
        ),
        body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _loadPageData,
            child: Consumer2<ClubProvider, MatchProvider>(builder: (context, clubProvider, matchProvider, child) {
              if(matchProvider.items.isEmpty && matchProvider.state == ProviderState.ready) return ListView(children: [Text("Não existem nenhum clube.")]);
              if(matchProvider.state != ProviderState.empty) {
                var _list = List.from(clubProvider.items.entries.map((e) => {
                  'club': e.value,
                  'matches' : matchProvider.getByClub(e.value).length,
                  'points' : matchProvider.getClubPoints(e.value)
                }));
                // Sort clubs by who has the highest points and matches
                _list
                  ..sort((b, a) => a['points'].compareTo(b['points']))
                  ..sort((b, a) => a['matches'].compareTo(b['matches']));
                return ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (context, index) {
                    Club club = _list[index]['club'];
                    int totalMatches = _list[index]['matches'];
                    int totalPoints = _list[index]['points'];
                    return Column(
                      children: [
                        ListTile(
                          leading: (club.picture != null) ?
                          Image(
                            image: NetworkImage(club.picture!),
                            height: 32,
                          ) :
                          null,
                          title: Text(club.name),
                          subtitle: Text("$totalMatches, $totalPoints"),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => ClubView(club: club),
                                maintainState: false,
                              ),
                            );
                          },
                        ),
                        const Divider(height: 2.0),
                      ],
                    );
                  },
                );
              }
              return Container();
            }))
    );
  }
}