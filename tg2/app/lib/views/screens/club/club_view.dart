// Library Imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/provider/stadium_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/models/country_model.dart';
import 'package:tg2/models/stadium_model.dart';
import 'package:tg2/provider/country_provider.dart';

import '../../../models/contract_model.dart';
import '../../../models/player_model.dart';
import '../player/player_view.dart';

class ClubView extends StatefulWidget {
  const ClubView({super.key, required this.club});

  final Club club;

  @override
  State<ClubView> createState() => _ClubViewState();
}

class _ClubViewState extends State<ClubView> {

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
                Provider.of<StadiumProvider>(context, listen: false).get();
              },
            ),
          ],
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
          selectedItemColor: widget.club.color,
          currentIndex: _selectedIndex,
        ),
        // TODO IMPROVE PLAYER HEADER STYLE
        body: Column(children: [
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
          Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  Container(
                    // TODO ADD CLUB STATS
                  ),
                  Consumer2<ContractProvider, PlayerProvider>(builder: (context, contractProvider, playerProvider, child) {
                    if(contractProvider.state == ProviderState.ready) {
                      Map<int, Contract> contractList = Map.fromEntries(contractProvider.items.entries.expand((element) => [
                        if (element.value.clubID == widget.club.id) MapEntry(element.key, element.value)
                      ]));
                      if(contractList.isEmpty) {
                        return const Center(child: Text("Não existem jogadores neste clube."));
                      }
                      return MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemCount: contractList.length,
                            itemBuilder: (context, index) {
                              Contract contract = contractList.values.elementAt(index);
                              Player player = playerProvider.items[contract.playerID]!;
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Image(
                                      image: NetworkImage(player.picture),
                                      height: 32,
                                    ),
                                    title: Text("${contract.number}. ${player.nickname ?? player.name}"),
                                    subtitle: Text(contract.position.name),
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
                                  const Divider(
                                    height: 2.0,
                                  ),
                                ],
                              );
                            },
                          ));
                    } else {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                  }),
                  Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Consumer2<CountryProvider, StadiumProvider>(
                          builder: (context, countryProvider, stadiumProvider, child) {
                            if(stadiumProvider.state == ProviderState.ready) {
                              Stadium stadium = stadiumProvider.items[widget.club.stadiumID]!;
                              Country country = countryProvider.items[stadium.countryID]!;
                              return MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: ListView(
                                    padding: const EdgeInsets.all(8),
                                    children: [
                                      ListTile(
                                        title: Text("Morada"),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(stadium.name),
                                            Text("${stadium.address}, ${country.name}")
                                          ],
                                        ),
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
                                  )
                              );
                            } else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          }
                          )
                  ),
              ],
              onPageChanged: (page) {
                setState(() {
                  _selectedIndex = page;
                });
              },
            )),
        ]));
  }
}