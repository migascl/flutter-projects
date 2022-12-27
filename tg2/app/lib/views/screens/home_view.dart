import 'package:flutter/material.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/country_provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/provider/stadium_provider.dart';
import '../../models/club_model.dart';
import '../../models/country_model.dart';
import '../../models/player_model.dart';
import '../../models/stadium_model.dart';
import 'club/club_view.dart';

enum Sections { matchweeks, clubs, players }

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late TabController _tabController;
  Sections currentSection = Sections.clubs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar;
    Widget body;

    switch (currentSection) {
      case Sections.matchweeks:
        _tabController = TabController(length: 3, vsync: this);
        appBar = AppBar(
          title: Text("Jornadas"),
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                icon: Icon(Icons.beach_access_sharp),
              ),
              Tab(
                icon: Icon(Icons.brightness_5_sharp),
              ),
            ],
          ),
        );
        body = TabBarView(
          controller: _tabController,
          children: const <Widget>[
            Center(
              child: Text("It's cloudy here"),
            ),
            Center(
              child: Text("It's rainy here"),
            ),
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        );
        break;
      case Sections.clubs:
        appBar = AppBar(title: Text("Clubes"));
        body = ClubListView();
        break;
      case Sections.players:
        appBar = AppBar(title: Text("Jogadores"));
        body = PlayerListView();
        break;
    }

    return Scaffold(
        appBar: appBar,
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text("Liga Portugal bwin"),
                      Text("Época 2021-2022")
                    ],
                  )),
              ListTile(
                leading: Icon(Icons.calendar_month_rounded),
                title: Text("Jornada"),
                onTap: () {
                  setState(() {
                    currentSection = Sections.matchweeks;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.group),
                title: Text("Clubes"),
                onTap: () {
                  setState(() {
                    currentSection = Sections.clubs;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.directions_run_rounded),
                title: Text("Jogadores"),
                onTap: () {
                  setState(() {
                    currentSection = Sections.players;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: body);
  }
}

class MatchweeksView extends StatefulWidget {
  const MatchweeksView({super.key});

  @override
  State<MatchweeksView> createState() => _MatchweeksViewState();
}

class _MatchweeksViewState extends State<MatchweeksView> {
  @override
  Widget build(BuildContext context) {
    print("Matchweeks View: Building...");
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBar Widget'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(
                text: "Jornada 13",
              ),
              Tab(
                text: "Jornada 12",
              ),
              Tab(
                text: "Jornada 11",
              ),
              Tab(
                text: "Jornada 10",
              ),
              Tab(
                text: "Jornada 9",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
                child: Column(
              children: [
                Text("Jogos"),
                Column(
                  children: [Container(child: Text("12 de Novembro 2021"))],
                ),
              ],
            )),
            Center(
              child: Text("It's rainy here"),
            ),
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
      ),
    );
  }
}

class ClubListView extends StatefulWidget {
  const ClubListView({super.key});

  @override
  State<ClubListView> createState() => _ClubListViewState();
}

class _ClubListViewState extends State<ClubListView> {
  late Future<Map<int, Club>> _getAllClubs;

  @override
  void initState() {
    super.initState();
    _getAllClubs = ClubProvider().getAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<int, Club>>(
        future: _getAllClubs,
        builder: (context, AsyncSnapshot<Map<int, Club>> snapshot) {
          if (snapshot.hasData) {
            List<Club> list = snapshot.data!.values.toList();
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                Club club = list.elementAt(index);
                return FutureBuilder<Stadium>(
                    future: StadiumProvider().getByID(club.id),
                    builder: (context, AsyncSnapshot<Stadium> snapshot) {
                      if (snapshot.hasData) {
                        Stadium stadium = snapshot.data!;
                        return Column(
                          children: [
                            ListTile(
                              leading: Image(
                                image: NetworkImage(club.icon),
                                height: 32,
                              ),
                              title: Text(club.name),
                              subtitle: Text(stadium.name),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ClubView(id: club.id),
                                    maintainState: true,
                                  ),
                                );
                              },
                            ),
                            const Divider(
                              height: 2.0,
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    });
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class PlayerListView extends StatefulWidget {
  const PlayerListView({super.key});

  @override
  State<PlayerListView> createState() => _PlayerListViewState();
}

class _PlayerListViewState extends State<PlayerListView> {
  late Future<Map<int, Player>> _getAllPlayers;

  @override
  void initState() {
    super.initState();
    _getAllPlayers = PlayerProvider.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<int, Player>>(
        future: _getAllPlayers,
        builder: (context, AsyncSnapshot<Map<int, Player>> snapshot) {
          if (snapshot.hasData) {
            List<Player> list = snapshot.data!.values.toList();
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                Player player = list.elementAt(index);
                return FutureBuilder<Country>(
                    future: CountryProvider().getByID(player.countryID),
                    builder: (context, AsyncSnapshot<Country> snapshot) {
                      if (snapshot.hasData) {
                        Country country = snapshot.data!;
                        return Column(
                          children: [
                            ListTile(
                              title: Text(player.name),
                              subtitle: Text(country.name),
                              onTap: () {
                                // TODO NAVIGATION TO PLAYER VIEW
                              },
                            ),
                            const Divider(
                              height: 2.0,
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    });
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
