import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/provider/match_provider.dart';
import 'package:tg2/views/screens/contract_view.dart';
import 'package:tg2/views/widgets/matchtile.dart';
import '../../../models/club_model.dart';
import '../../../models/match_model.dart';
import '../../../models/contract_model.dart';
import '../../../utils/constants.dart';

// This page lists all clubs
class ClubView extends StatefulWidget {
  const ClubView({super.key, required this.club});

  final Club
      club; // This club is used as a preloader for the actual club info from the provider

  @override
  State<ClubView> createState() => _ClubViewState();
}

class _ClubViewState extends State<ClubView> {
  late Club _club = widget.club;

  // Method to reload providers used by the page
  Future _loadPageData() async {
    try {
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
    setState(() {
      _club = Provider.of<ClubProvider>(context, listen: false)
          .items[widget.club.id]!;
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
      body: Consumer<ClubProvider>(builder: (context, clubProvider, child) {
        return Column(children: [
          // Page header
          Container(
              color: widget.club.color,
              padding: const EdgeInsets.fromLTRB(32, 86, 32, 32),
              height: 200,
              alignment: Alignment.topLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: FadeInImage(
                        image: _club.picture!,
                        placeholder:
                            AssetImage("assets/images/placeholder-club.jpg"),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                              "assets/images/placeholder-club.jpg",
                              fit: BoxFit.contain);
                        },
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        Text(widget.club.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.merge(TextStyle(
                                    color:
                                        widget.club.color!.computeLuminance() >
                                                0.5
                                            ? Colors.black
                                            : Colors.white))),
                        const SizedBox(height: 8),
                        Text(widget.club.stadium!.country.name,
                            style: Theme.of(context).textTheme.subtitle1?.merge(
                                TextStyle(
                                    color:
                                        widget.club.color!.computeLuminance() >
                                                0.5
                                            ? Colors.black54
                                            : Colors.white70))),
                      ]))
                ],
              )),
          // Page body
          Expanded(
              child: PageView(
            controller: _pageController,
            children: [
              // Club season statistics
              Consumer<MatchProvider>(builder: (context, provider, child) {
                if (provider.state == ProviderState.ready) {
                  List<Match> list = provider.getByClub(_club).values.toList();
                  if (list.isEmpty) {
                    return Center(
                        child: Text(
                      "Este clube ainda não participou em nenhum jogo.",
                      style: Theme.of(context).textTheme.caption,
                    ));
                  }
                  return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Card(
                                    child: Container(
                                        margin: const EdgeInsets.all(16),
                                        child: Column(children: [
                                          Text("Jogos Totais",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1),
                                          const SizedBox(height: 8),
                                          Text("${list.length}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5),
                                        ]))),
                                Card(
                                    child: Container(
                                        margin: const EdgeInsets.all(16),
                                        child: Column(children: [
                                          Text("Pontos Total",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1),
                                          const SizedBox(height: 8),
                                          Text(
                                              "${provider.getClubPoints(_club)}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5),
                                        ]))),
                              ]),
                          const SizedBox(height: 32),
                          Text("Histórico de Jogos",
                              style: Theme.of(context).textTheme.subtitle1),
                          const SizedBox(height: 16),
                          MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                              child: Card(
                                child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: ListView.separated(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: list.length,
                                      itemBuilder: (context, index) {
                                        Match match = list[index];
                                        return MatchTile(match: match);
                                      },
                                      separatorBuilder: (context, index) =>
                                          const Divider(),
                                    )),
                              ))
                        ],
                      ));
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
              // Club team list
              Consumer<ContractProvider>(builder: (context, provider, child) {
                if (provider.state == ProviderState.ready) {
                  List<Contract> list = provider.items.values
                      .where((element) =>
                          element.club.id == _club.id && element.active)
                      .toList();
                  if (list.isEmpty)
                    return const Center(
                        child: Text("Não existem jogadores neste clube."));
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
                                leading: Container(
                                    child: (contract.player.picture != null)
                                        ? Image(
                                            image: contract.player.picture!,
                                            height: 32,
                                          )
                                        : null),
                                title: Text(
                                    "${contract.number}. ${contract.player.nickname ?? contract.player.name}"),
                                subtitle: Text(contract.position.name),
                                trailing: (contract.needsRenovation)
                                    ? Text("Necessita de renovação!")
                                    : null,
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          ContractView(contract: contract));
                                },
                              ),
                              const Divider(height: 2.0),
                            ],
                          );
                        },
                      ));
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
              // Club information
              Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Consumer<ClubProvider>(
                      builder: (context, provider, child) {
                    if (provider.state == ProviderState.ready) {
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
                                    Text(_club.stadium!.name),
                                    Text(
                                        "${_club.stadium!.address}, ${_club.stadium?.country.name}")
                                  ],
                                ),
                              ),
                              if (_club.phone != null)
                                ListTile(
                                  title: const Text("Telefone"),
                                  subtitle: Text(_club.phone!),
                                ),
                              if (_club.fax != null)
                                ListTile(
                                  title: const Text("Fax"),
                                  subtitle: Text(_club.fax!),
                                ),
                              if (_club.email != null)
                                ListTile(
                                  title: const Text("Email"),
                                  subtitle: Text(_club.email!),
                                ),
                            ],
                          ));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  })),
            ],
            onPageChanged: (page) {
              setState(() {
                _selectedIndex = page;
              });
            },
          )),
        ]);
      }),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics_rounded), label: 'Estatísticas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups_rounded), label: 'Plantel'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Dados Gerais')
        ],
        onTap: _onTabTap,
        selectedItemColor: widget.club.color,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
