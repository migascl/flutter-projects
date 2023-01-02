// Library Imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/provider/match_provider.dart';
import 'package:tg2/provider/stadium_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/models/country_model.dart';
import 'package:tg2/models/stadium_model.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/models/match_model.dart';
import 'package:tg2/views/screens/player/player_view.dart';

// This page shows club's information
class ClubView extends StatefulWidget {
  const ClubView({super.key, required this.club});

  final Club club;

  @override
  State<ClubView> createState() => _ClubViewState();
}

class _ClubViewState extends State<ClubView> {

  void loadPageData() {
    Provider.of<StadiumProvider>(context, listen: false).get();
    Provider.of<ClubProvider>(context, listen: false).get();
    Provider.of<MatchProvider>(context, listen: false).get();
    Provider.of<ContractProvider>(context, listen: false).get();
  }

  // Page view controls
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  void _onTabTap(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadPageData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh',
              onPressed: () {
                loadPageData();
              },
            ),
          ],
        ),
        // TODO IMPROVE PLAYER HEADER STYLE
        body: Column(children: [
          // Page header
          Container(
              color: widget.club.color,
              height: 200,
              padding: const EdgeInsets.fromLTRB(16, 86, 16, 16),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image(
                    height: 64,
                    image: NetworkImage(widget.club.picture),
                  ),
                  Text(
                    widget.club.name,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                        color: widget.club.color.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white),
                  )
                ],
              )),
          // Page body
          Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  // Club season statistics
                  Consumer<MatchProvider>(builder: (context, matchProvider, child) {
                    if(matchProvider.state == ProviderState.ready) {
                      // List of matches the club participated on (Either home or away)
                      Map<int, Match> matchList = Map.fromEntries(matchProvider.items.entries.expand((element) => [
                        if (element.value.clubHomeID == widget.club.id || element.value.clubAwayID == widget.club.id)
                          MapEntry(element.key, element.value)
                      ]));
                      if(matchList.isEmpty) return const Center(child: Text("Este clube ainda não participou em nenhum jogo."));
                      // Club total points
                      int points = 0;
                      for (var item in matchList.values) {
                        if(item.clubHomeID == widget.club.id) {
                          points += item.homeScore;
                          break;
                        }
                        if(item.clubAwayID == widget.club.id) {
                          points += item.awayScore;
                          break;
                        }
                      }
                      return Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(children: [
                                  const Text("Jogos Total"),
                                  Text("${matchList.length}"),
                                ]),
                                Column(children: [
                                  const Text("Pontos Total"),
                                  Text("$points"),
                                ]),
                          ]),
                          const Text("Jogos"),
                          MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: matchList.length,
                              itemBuilder: (context, index) {
                                Match match = matchList.values.elementAt(index);
                                Club clubHome = matchProvider.clubProvider.items[match.clubHomeID]!;
                                Club clubAway = matchProvider.clubProvider.items[match.clubAwayID]!;
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if(clubHome.id != widget.club.id){
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) => ClubView(club: clubHome),
                                                    maintainState: false,
                                                  ),
                                                );
                                              }
                                            }, // Image tapped
                                            child: Image(
                                              image: NetworkImage(clubHome.picture),
                                              height: 48,
                                            ),
                                          ),
                                          Text("${match.homeScore} : ${match.awayScore}"),
                                          GestureDetector(
                                            onTap: () {
                                              if(clubAway.id != widget.club.id){
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) => ClubView(club: clubAway),
                                                    maintainState: false,
                                                  ),
                                                );
                                              }
                                            }, // Image tapped
                                            child: Image(
                                              image: NetworkImage(clubAway.picture),
                                              height: 48,
                                            ),
                                          ),
                                        ]
                                      ),
                                    ),
                                    const Divider(height: 2.0),
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                  }),
                  // Club team list
                  Consumer<ContractProvider>(builder: (context, contractProvider, child) {
                    if(contractProvider.state == ProviderState.ready) {
                      Map<int, Contract> contractList = Map.fromEntries(contractProvider.items.entries.expand((element) => [
                        if (element.value.clubID == widget.club.id) MapEntry(element.key, element.value)
                      ]));
                      if(contractList.isEmpty) return const Center(child: Text("Não existem jogadores neste clube."));
                      return MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemCount: contractList.length,
                            itemBuilder: (context, index) {
                              Contract contract = contractList.values.elementAt(index);
                              Player player = contractProvider.playerProvider.items[contract.playerID]!;
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Image(
                                      image: NetworkImage(player.picture),
                                      height: 32,
                                    ),
                                    title: Text("${contract.number}. ${player.nickname ?? player.name}"),
                                    subtitle: Text(contract.position.name),
                                    trailing: PopupMenuButton<int>(
                                        onSelected: (int value) {
                                          // Remove player
                                          if(value == 0) {
                                            showDialog<String>(
                                                context: context,
                                                builder: (BuildContext context) => AlertDialog(
                                                  title: const Text('Atenção!'),
                                                  content: Text("Tem a certeza que pretende eliminar contracto #${contract.id} ?\n"
                                                      "Esta operação não irreversível!"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        contractProvider.delete(contract).then((value) => loadPageData());
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text('Sim'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text('Não'),
                                                    ),
                                                  ],
                                                ));
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                                          const PopupMenuItem<int>(
                                            value: 0,
                                            child: Text('Remover'),
                                          ),
                                        ]
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => PlayerView(player: player),
                                          maintainState: false,
                                        ),
                                      );
                                    },
                                  ),
                                  const Divider(height: 2.0),
                                ],
                              );
                            },
                          ));
                    } else {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                  }),
                  // Club information
                  Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Consumer<StadiumProvider>(builder: (context, stadiumProvider, child) {
                        if(stadiumProvider.state == ProviderState.ready) {
                          Stadium stadium = stadiumProvider.items[widget.club.stadiumID]!;
                          Country country = stadiumProvider.countryProvider.items[stadium.countryID]!;
                          return MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView(
                                padding: const EdgeInsets.all(8),
                                children: [
                                  ListTile(
                                    title: const Text("Morada"),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(stadium.name),
                                        Text("${stadium.address}, ${country.name}")
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text("Telefone"),
                                    subtitle: Text(widget.club.phone),
                                  ),
                                  ListTile(
                                    title: const Text("Fax"),
                                    subtitle: Text(widget.club.fax),
                                  ),
                                  ListTile(
                                    title: const Text("Email"),
                                    subtitle: Text(widget.club.email),
                                  ),
                                ],
                              )
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      })
                  ),
              ],
              onPageChanged: (page) {
                setState(() {
                  _selectedIndex = page;
                });
              },
            )),
        ]),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics_rounded), label: 'Estatísticas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups_rounded), label: 'Plantel'),
          BottomNavigationBarItem(
              icon: Icon(Icons.info), label: 'Dados Gerais')
        ],
        onTap: _onTabTap,
        selectedItemColor: widget.club.color,
        currentIndex: _selectedIndex,
      ),
    );
  }
}