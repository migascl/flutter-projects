// Library Imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/views/screens/club/club_view.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/models/country_model.dart';
import 'package:tg2/models/stadium_model.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/provider/stadium_provider.dart';

// This page lists all clubs
class ClubListView extends StatefulWidget {
  const ClubListView({super.key});

  @override
  State<ClubListView> createState() => _ClubListViewState();
}

class _ClubListViewState extends State<ClubListView> {

  @override
  void initState() {
    print("ClubList/V: Initialized State!");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("ClubList/V: Building...");
    return Scaffold(
        appBar: AppBar(
            title: const Text("Clubes"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh',
              onPressed: () {
                // Refresh page data
                Provider.of<StadiumProvider>(context, listen: false).get();
                Provider.of<ClubProvider>(context, listen: false).get();
              },
            ),
          ],
        ),
        // TODO ADD CREATE FUNCTION
        floatingActionButton: null,
        body: Consumer<ClubProvider>(builder: (context, clubProvider, child) {
          // Wait until provider is ready
          if(clubProvider.state == ProviderState.ready) {
            Map<int, Club> clubList = clubProvider.items; // Club list
            Map<int, Stadium> stadiumList = clubProvider.stadiumProvider.items; // Stadium list
            Map<int, Country> countryList = clubProvider.stadiumProvider.countryProvider.items; // Country list
            return ListView.builder(
              itemCount: clubList.length,
              itemBuilder: (context, index) {
                Club club = clubList.values.elementAt(index); // Get club by ID
                Stadium stadium = stadiumList[club.stadiumID]!; // Get club's stadium by ID
                Country country = countryList[stadium.countryID]!; // Get stadium's country by ID
                return Column(
                  children: [
                    ListTile(
                      leading: Image(
                        image: NetworkImage(club.picture),
                        height: 32,
                      ),
                      title: Text(club.name),
                      subtitle: Text("${stadium.name}, ${country.name}"),
                      onTap: () {
                        Provider.of<ClubProvider>(context, listen: false).get();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => ClubView(club: club),
                            maintainState: false,
                          ),
                        );
                      },
                      onLongPress: () {
                        // TODO ADD REMOVE FUNCTION
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
            return const Center(child: CircularProgressIndicator(),);
          }
        }),
    );
  }
}