import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/models/match_model.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/provider/match_provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/views/widgets/contracttile.dart';
import 'package:tg2/views/widgets/futureimage.dart';
import 'package:tg2/views/widgets/matchtile.dart';
import 'package:tg2/views/screens/contract_view.dart';

import '../contract_add_view.dart';

// This widget displays all club information
// It requires a club object to initiate to use as fallback data if it can't retrieve an updated
// version of the club data from the server
class ClubView extends StatefulWidget {
  const ClubView({super.key, required this.club});

  final Club club;

  @override
  State<ClubView> createState() => _ClubViewState();
}

class _ClubViewState extends State<ClubView> {
  // Page view controls
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  FloatingActionButton? fab;

  // Reload providers used by the page, displays snackbar if exception occurs
  Future _loadPageData() async {
    try {
      await Provider.of<ClubProvider>(context, listen: false)
          .get()
          .then((value) => Provider.of<PlayerProvider>(context, listen: false).get());
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: widget.club.color,
        iconTheme: IconThemeData(color: widget.club.color!.computeLuminance() > 0.5 ? Colors.black : Colors.white),
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
      floatingActionButton: fab,
      body: Column(children: [
        // Page header
        Card(
          margin: const EdgeInsets.all(0),
          color: widget.club.color,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            height: MediaQuery.of(context).size.height * 0.2,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FutureImage(
                  image: widget.club.picture!,
                  errorImageUri: 'assets/images/placeholder-club.png',
                  aspectRatio: 1 / 1,
                  height: double.infinity,
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.club.name,
                      style: Theme.of(context).textTheme.titleLarge?.merge(
                          TextStyle(color: widget.club.color!.computeLuminance() > 0.5 ? Colors.black : Colors.white)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.club.stadium!.country.name,
                      style: Theme.of(context).textTheme.subtitle1?.merge(
                          TextStyle(color: widget.club.color!.computeLuminance() > 0.5 ? Colors.black54 : Colors.white70)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        // Page body
        Expanded(
          child: PageView(
            controller: _pageController,
            children: [
              // ############# Stats Page #############
              Consumer<MatchProvider>(
                builder: (context, matchProvider, child) {
                  if (matchProvider.state == ProviderState.ready) {
                    // Get all matches from the club and sort them by most recent
                    List<Match> list = matchProvider.getByClub(widget.club).values.toList();
                    list.sort((a, b) => b.date.compareTo(a.date));

                    if (list.isEmpty) {
                      return Center(
                        child: Text(
                          "Este clube ainda não participou em nenhum jogo.",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // Statistics (total games & points)
                          Card(
                            margin: const EdgeInsets.all(16),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(32, 16, 16, 16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Jogos Totais",
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                        Divider(height: 8),
                                        Text(
                                          "${list.length}",
                                          style: Theme.of(context).textTheme.headline5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const VerticalDivider(thickness: 1, indent: 16, endIndent: 16),
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(16, 16, 32, 16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Pontos Total",
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                        const Divider(height: 8),
                                        Text(
                                          "${matchProvider.getClubPoints(widget.club)}",
                                          style: Theme.of(context).textTheme.headline5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Recent games
                          const SizedBox(height: 8),
                          Text("Histórico de Jogos", style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 8),
                          Card(
                            margin: const EdgeInsets.all(8),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                            child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    Match match = list[index];
                                    return MatchTile(match: match);
                                  },
                                  separatorBuilder: (context, index) => const Divider(),
                                )),
                          ),
                        ],
                      ),
                    );
                  } else if (matchProvider.state == ProviderState.busy) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                      child: Text(
                        "Não existem nenhuns jogos.",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    );
                  }
                },
              ),
              // ############# Team Page #############
              Card(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                child: Consumer<ContractProvider>(
                  builder: (context, contractProvider, child) {
                    if (contractProvider.state == ProviderState.ready) {
                      // Get all active contracts of the club
                      List<Contract> list = contractProvider.items.values
                          .where((element) => element.club.id == widget.club.id && element.active)
                          .toList();

                      if (list.isEmpty) {
                        return Center(
                            child: Text(
                          "Não existem jogadores neste clube.",
                          style: Theme.of(context).textTheme.caption,
                        ));
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            Contract contract = list.elementAt(index);
                            return ContractTile(
                              contract: contract,
                              showClub: false,
                              showAlert: true,
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    isDismissible: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) => ContractView(contract: contract));
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => const Divider(),
                        ),
                      );
                    } else if (contractProvider.state == ProviderState.busy) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Center(
                        child: Text(
                          "Não existem nenhuns contratos.",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      );
                    }
                  },
                ),
              ),
              // ############# Info Page #############
              Card(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        isThreeLine: true,
                        title: const Text("Morada"),
                        subtitle: Text(
                            "${widget.club.stadium!.name},\n${widget.club.stadium!.address}\n${widget.club.stadium?.city}, ${widget.club.stadium?.country.name}"),
                      ),
                      if (widget.club.phone != null)
                        ListTile(
                          title: const Text("Telefone"),
                          subtitle: Text(widget.club.phone!),
                        ),
                      if (widget.club.fax != null)
                        ListTile(
                          title: const Text("Fax"),
                          subtitle: Text(widget.club.fax!),
                        ),
                      if (widget.club.email != null)
                        ListTile(
                          title: const Text("Email"),
                          subtitle: Text(widget.club.email!),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
      // ############# Bottom Nav #############
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Estatísticas'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_rounded), label: 'Plantel'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Dados Gerais')
        ],
        onTap: (int value) {
          setState(() {
            _selectedIndex = value;
            switch (_selectedIndex) {
              case 1:
                fab = FloatingActionButton(
                  backgroundColor: widget.club.color,
                  onPressed: () => showGeneralDialog(
                      context: context,
                      barrierDismissible: false,
                      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) =>
                          ContractAddView(club: widget.club)),
                  child: const Icon(Icons.add),
                );
                break;
              default:
                fab = null;
                break;
            }
          });
          _pageController.animateToPage(
            value,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeIn,
          );
        },
        selectedItemColor: widget.club.color,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
