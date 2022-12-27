import 'package:flutter/material.dart';
import 'package:tg2/provider/stadium_provider.dart';
import '../../../models/club_model.dart';
import '../../../models/stadium_model.dart';
import '../../../provider/club_provider.dart';

class ClubView extends StatefulWidget {
  const ClubView({super.key, required this.id});

  final int id;

  @override
  State<ClubView> createState() => _ClubViewState();
}

class _ClubViewState extends State<ClubView> {
  late Future<Club> _getClub;

  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }

  @override
  void initState() {
    super.initState();
    _getClub = ClubProvider.getByID(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.analytics_rounded), label: 'Estatísticas'),
            BottomNavigationBarItem(
                icon: Icon(Icons.groups_rounded), label: 'Plantel'),
            BottomNavigationBarItem(
                icon: Icon(Icons.info), label: 'Dados Gerais')
          ],
          onTap: _onTappedBar,
          selectedItemColor: Colors.orange,
          currentIndex: _selectedIndex,
        ),
        body: FutureBuilder<Club>(
            future: _getClub,
            builder: (context, AsyncSnapshot<Club> snapshot) {
              if (snapshot.hasData) {
                Club club = snapshot.data!;
                return Column(children: [
                  Container(
                      color: club.color,
                      height: 200,
                      padding: EdgeInsets.fromLTRB(16, 86, 16, 16),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image(
                            height: 64,
                            image: NetworkImage(club.icon),
                          ),
                          Text(
                            club.name,
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.normal,
                                fontSize: 24,
                                color: club.color.computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white),
                          )
                        ],
                      )),
                  Expanded(
                      child: PageView(
                    controller: _pageController,
                    children: [
                      ClubStatsView(),
                      ClubSquadView(),
                      ClubInfoView(
                        club: club,
                      ),
                    ],
                    onPageChanged: (page) {
                      setState(() {
                        _selectedIndex = page;
                      });
                    },
                  )),
                ]);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}

class ClubStatsView extends StatefulWidget {
  const ClubStatsView({super.key});

  @override
  State<ClubStatsView> createState() => _ClubStatsViewState();
}

class _ClubStatsViewState extends State<ClubStatsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Estatisticas"),
    );
  }
}

class ClubSquadView extends StatefulWidget {
  const ClubSquadView({super.key});

  @override
  State<ClubSquadView> createState() => _ClubSquadViewState();
}

class _ClubSquadViewState extends State<ClubSquadView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Plantel"),
    );
  }
}

class ClubInfoView extends StatefulWidget {
  const ClubInfoView({super.key, required this.club});

  final Club club;

  @override
  State<ClubInfoView> createState() => _ClubInfoViewState();
}

class _ClubInfoViewState extends State<ClubInfoView> {
  late Future<Stadium> _getStadium;

  @override
  void initState() {
    super.initState();
    _getStadium = StadiumProvider.getByID(widget.club.stadiumID);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            ListTile(
              title: Text("Morada"),
              subtitle: FutureBuilder<Stadium>(
                  future: _getStadium,
                  builder: (context, AsyncSnapshot<Stadium> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data!.name),
                          Text(snapshot.data!.address)
                        ],
                      );
                    } else {
                      return const Text("");
                    }
                  }),
            ),
            ListTile(
              title: Text("Telefone"),
              subtitle: Text(widget.club.phone),
            ),
            ListTile(
              title: Text("Fax"),
              subtitle: Text(widget.club.fax),
            ),
            ListTile(
              title: Text("Email"),
              subtitle: Text(widget.club.email),
            ),
          ],
        ));
  }
}
