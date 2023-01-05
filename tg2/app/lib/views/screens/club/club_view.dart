import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/provider/match_provider.dart';
import 'package:tg2/provider/stadium_provider.dart';
import '../../../models/club_model.dart';
import '../../../models/match_model.dart';
import '../../../models/contract_model.dart';
import '../../../utils/constants.dart';

// This page lists all clubs
class ClubView extends StatefulWidget {
  const ClubView({super.key, required this.club});

  final Club club;

  @override
  State<ClubView> createState() => _ClubViewState();
}

class _ClubViewState extends State<ClubView> {
  late Club _club = widget.club;

  // Method to reload providers used by the page
  Future _loadPageData() async {
    try{
      await Provider.of<StadiumProvider>(context, listen: false).get();
      await Provider.of<ClubProvider>(context, listen: false).get();
      await Provider.of<ContractProvider>(context, listen: false).get();
      await Provider.of<MatchProvider>(context, listen: false).get();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro. Tente novamente.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
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
      _loadPageData();
      setState(() {
        _club = Provider.of<ClubProvider>(context, listen: false).items[widget.club.id]!;
      });
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
              _loadPageData();
            },
          ),
        ],
      ),
      // TODO IMPROVE PLAYER HEADER STYLE
      body: Consumer<ClubProvider>(builder: (context, clubProvider, child) {
        return Column(children: [
          // Page header
          Container(
              color: widget.club.color,
              height: 200,
              padding: const EdgeInsets.fromLTRB(16, 86, 16, 16),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(child: (_club.picture != null) ? Image(image: NetworkImage(_club.picture!), height: 64,) : null ),
                  Text(
                    widget.club.name,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                        color: widget.club.color!.computeLuminance() > 0.5 ? Colors.black : Colors.white
                    ),
                  )
                ],
              )),
          // Page body
          Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  // Club season statistics
                  Consumer<MatchProvider>(builder: (context, provider, child) {
                    if(provider.state == ProviderState.ready) {
                      if(provider.items.isEmpty) return const Center(child: Text("Este clube ainda não participou em nenhum jogo."));
                      var _list = provider.getByClub(_club).values.toList();
                      return Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(children: [
                                  const Text("Jogos Totais"),
                                  Text("${_list.length}"),
                                ]),
                                Column(children: [
                                  const Text("Pontos Total"),
                                  Text("${provider.getClubPoints(_club)}"),
                                ]),
                              ]),
                          const Text("Jogos"),
                          MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _list.length,
                              itemBuilder: (context, index) {
                                Match match = _list[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(child: (match.clubHome.picture != null) ? Image(image: NetworkImage(match.clubHome.picture!), height: 48) : null),
                                            Text("${match.homeScore} : ${match.awayScore}"),
                                            Container(child: (match.clubAway.picture != null) ? Image(image: NetworkImage(match.clubAway.picture!), height: 48) : null),
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
                  Consumer<ContractProvider>(builder: (context, provider, child) {
                    if(provider.state == ProviderState.ready) {
                      if(provider.items.isEmpty) return const Center(child: Text("Não existem jogadores neste clube."));
                      List<Contract> list = provider.items.values.toList();
                      return MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              Contract contract = list[index];
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Container(child: (contract.player.picture != null) ? Image(image: NetworkImage(contract.player.picture!), height: 32,) : null ),
                                    title: Text("${contract.number}. ${contract.player.nickname ?? contract.player.name}"),
                                    subtitle: Text(contract.position.name),
                                    trailing: (contract.needsRenovation) ? Text("Necessita de renovação!") : null,
                                    onTap: () {
                                      // TODO NAVIGATE TO PLAYER
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
                      child: Consumer<ClubProvider>(builder: (context, provider, child) {
                        if(provider.state == ProviderState.ready) {
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
                                        Text(_club.name),
                                        Text("${_club.stadium?.name}, ${_club.stadium?.country.name}")
                                      ],
                                    ),
                                  ),
                                  if (_club.phone != null) ListTile(
                                    title: const Text("Telefone"),
                                    subtitle: Text(_club.phone!),
                                  ),
                                  if (_club.fax != null) ListTile(
                                    title: const Text("Fax"),
                                    subtitle: Text(_club.fax!),
                                  ),
                                  if (_club.email != null) ListTile(
                                    title: const Text("Email"),
                                    subtitle: Text(_club.email!),
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
          ]);
        }
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
        onTap: _onTabTap,
        selectedItemColor: widget.club.color,
        currentIndex: _selectedIndex,
      ),
    );
  }
}