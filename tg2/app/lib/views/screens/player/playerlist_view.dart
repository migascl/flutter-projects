import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/exam_provider.dart';
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
  final GlobalKey<RefreshIndicatorState> _playerListRefreshKey =
      GlobalKey<RefreshIndicatorState>();

  // Method to reload providers used by the page
  Future _loadPageData() async {
    try {
      await Provider.of<PlayerProvider>(context, listen: false).get();
      await Provider.of<ExamProvider>(context, listen: false).get();
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
    print("PlayerList/V: Initialized State!");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("PlayerList/V: Building...");
    return Scaffold(
        appBar: AppBar(
          title: const Text("Jogadores"),
        ),
        body: RefreshIndicator(
          key: _playerListRefreshKey,
          onRefresh: _loadPageData,
          child: Consumer<PlayerProvider>(
              builder: (context, playerProvider, child) {
            // Wait until provider is ready
            if (playerProvider.state == ProviderState.ready) {
              return ListView.builder(
                itemCount: playerProvider.items.length,
                itemBuilder: (context, index) {
                  Player player = playerProvider.items.values.elementAt(index);
                  return Column(
                    children: [
                      ListTile(
                          leading: (player.picture != null)
                              ? Image(
                                  image: NetworkImage(player.picture!),
                                  height: 32,
                                )
                              : null,
                          title: Text(player.name),
                          subtitle: Text(player.country.name),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PlayerView(player: player),
                                maintainState: false,
                              ),
                            );
                          }),
                      const Divider(height: 2.0)
                    ],
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ));
  }
}
