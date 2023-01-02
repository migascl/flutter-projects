// Library Imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/views/screens/player/player_view.dart';
import 'package:tg2/models/country_model.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/utils/constants.dart';


// This page lists all players
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
  }

  @override
  Widget build(BuildContext context) {
    print("PlayerList/V: Building...");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jogadores"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () {
              // Refresh page data
              Provider.of<PlayerProvider>(context, listen: false).get();
            },
          ),
        ],
      ),
      // TODO ADD CREATE FUNCTION
      floatingActionButton: null,
      body: Consumer<PlayerProvider>(builder: (context, playerProvider, child) {
        // Wait until provider is ready
        if(playerProvider.state == ProviderState.ready) {
            Map<int, Player> playerList = playerProvider.items; // Player list
            Map<int, Country> countryList = playerProvider.countryProvider.items; // Country list
            return ListView.builder(
              itemCount: playerList.length,
              itemBuilder: (context, index) {
                Player player = playerList.values.elementAt(index); // Get player by ID
                Country country = countryList[player.countryID]!; // Get player's country by ID
                return Column(
                  children: [
                    ListTile(
                      leading: Image(
                        image: NetworkImage(player.picture),
                        height: 32,
                      ),
                      title: Text(player.name),
                      subtitle: Text(country.name),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => PlayerView(player: player),
                            maintainState: false,
                          ),
                        );
                      },
                      onLongPress: () {
                        // TODO ADD REMOVE FUNCTION
                      },
                    ),
                    const Divider(height: 2.0)
                  ],
                );
              },
            );
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      }),
    );
  }
}