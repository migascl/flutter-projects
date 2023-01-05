import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/match_provider.dart';
import 'package:tg2/utils/constants.dart';
import '../../../models/club_model.dart';

// This page lists all clubs
class ClubListView extends StatefulWidget {
  const ClubListView({super.key});

  @override
  State<ClubListView> createState() => _ClubListViewState();
}

class _ClubListViewState extends State<ClubListView> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  // Method to
  Future _refresh() async {
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
      _refresh();
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
            onRefresh: _refresh,
            child: Consumer2<ClubProvider, MatchProvider>(builder: (context, clubProvider, matchProvider, child) {
              if(matchProvider.items.isEmpty && matchProvider.state == ProviderState.ready) return ListView(children: [Text("Não existem nenhum clube.")]);
              if(matchProvider.state != ProviderState.empty) {
                List<Club> list = clubProvider.items.values.toList();
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    Club club = list[index];
                    int totalMatches = matchProvider.getByClub(club).length;
                    int totalPoints = matchProvider.getClubPoints(club);
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
                            // TODO CLUB NAVIGATION
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