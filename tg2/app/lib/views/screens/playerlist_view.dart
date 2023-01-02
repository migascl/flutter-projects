import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/provider/stadium_provider.dart';
import 'package:tg2/views/screens/club/club_view.dart';
import 'package:tg2/views/screens/player/player_view.dart';
import '../../models/club_model.dart';
import '../../models/country_model.dart';
import '../../models/player_model.dart';
import '../../models/stadium_model.dart';
import '../../provider/club_provider.dart';
import '../../provider/country_provider.dart';
import '../../utils/constants.dart';

class PlayerListView extends StatefulWidget {
  const PlayerListView({super.key});

  @override
  State<PlayerListView> createState() => _PlayerListViewState();
}

class _PlayerListViewState extends State<PlayerListView> {

  @override
  void initState() {
    print("PlayerList/V: Initialized State!");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PlayerProvider>(context, listen: false).get();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("PlayerList/V: Building...");
    return Scaffold(
      appBar: AppBar(
        title: Text("${Provider.of<CountryProvider>(context, listen: true).state.name}, "
            "${Provider.of<PlayerProvider>(context, listen: true).state.name}, "),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () {
              Provider.of<PlayerProvider>(context, listen: false).get();
            },
          ),
        ],
      ),
      body: Consumer<PlayerProvider>(
          builder: (context, playerProvider, child) {
            if(playerProvider.state == ProviderState.ready) {
              Map<int, Player> playerList = playerProvider.items;
              Map<int, Country> countryList = playerProvider.countryProvider.items;
              return ListView.builder(
                itemCount: playerList.length,
                itemBuilder: (context, index) {
                  Player player = playerList.values.elementAt(index); // Get club at club list index
                  Country country = countryList[player.countryID]!;
                  return Column(
                    children: [
                      ListTile(
                        leading: Image(
                          image: NetworkImage(player.profile),
                          height: 32,
                        ),
                        title: Text(player.name),
                        subtitle: Text(country.name),
                        onTap: () {
                          Provider.of<ClubProvider>(context, listen: false).get();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => PlayerView(player: player),
                              maintainState: false,
                            ),
                          );
                        },
                      ),
                      const Divider(
                        height: 2.0,
                      ),
                    ],
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator(),);
            }
          }
      ),
    );
  }
}