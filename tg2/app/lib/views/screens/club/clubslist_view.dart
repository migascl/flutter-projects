import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/stadium_provider.dart';
import 'package:tg2/views/screens/club/club_view.dart';
import '../../../models/club_model.dart';
import '../../../models/country_model.dart';
import '../../../models/stadium_model.dart';
import '../../../provider/club_provider.dart';
import '../../../provider/country_provider.dart';
import '../../../utils/constants.dart';

class ClubListView extends StatefulWidget {
  @override
  State<ClubListView> createState() => _ClubListViewState();
}

class _ClubListViewState extends State<ClubListView> {

  @override
  void initState() {
    print("ClubList/V: Initialized State!");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<StadiumProvider>(context, listen: false).get();
      Provider.of<ClubProvider>(context, listen: false).get();
    });
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
                Provider.of<StadiumProvider>(context, listen: false).get();
                Provider.of<ClubProvider>(context, listen: false).get();
              },
            ),
          ],
        ),
        // TODO ADD CREATE FUNCTION
        floatingActionButton: null,
        body: Consumer<ClubProvider>(
            builder: (context, clubProvider, child) {
              if(clubProvider.state == ProviderState.ready) {
                Map<int, Club> clubList = clubProvider.items;
                Map<int, Stadium> stadiumList = clubProvider.stadiumProvider.items;
                Map<int, Country> countryList = clubProvider.stadiumProvider.countryProvider.items;
                // TODO ADD REMOVE FUNCTION
                return ListView.builder(
                  itemCount: clubList.length,
                  itemBuilder: (context, index) {
                    Club club = clubList.values.elementAt(index); // Get club at club list index
                    Stadium stadium = stadiumList[club.stadiumID]!; // Get club's stadium
                    Country country = countryList[stadium.countryID]!;
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