import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/models/match_model.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/provider/match_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/views/widgets/contracttile.dart';
import 'package:tg2/views/widgets/futureimage.dart';
import 'package:tg2/views/widgets/matchtile.dart';
import 'package:tg2/views/screens/contract_view.dart';
import 'package:tg2/views/widgets/header.dart';
import 'package:tg2/views/screens/contract_add_view.dart';

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
  List<Match> _matches = [];
  List<Contract> _contracts = [];

  // Page view controls
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  FloatingActionButton? fab;

  // Reload providers used by the page, displays snackbar if exception occurs
  Future _loadPageData() async {
    try {
      await Provider.of<ClubProvider>(context, listen: false).get();
      _matches.clear();
      _contracts.clear();
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
    WidgetsBinding.instance.addPostFrameCallback((context) => _loadPageData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: widget.club.color,
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
        Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.2,
          color: widget.club.color,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              FutureImage(
                image: widget.club.picture!,
                errorImageUri: 'assets/images/placeholder-club.png',
                aspectRatio: 1 / 1,
                height: double.infinity,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
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
                      widget.club.stadium?.name ?? '',
                      style: Theme.of(context).textTheme.subtitle1?.merge(
                          TextStyle(color: widget.club.color!.computeLuminance() > 0.5 ? Colors.black54 : Colors.white70)),
                    ),
                  ],
                ),
              )
            ],
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
                  if (matchProvider.state != ProviderState.busy && _matches.isEmpty) {
                    // Get all matches from the club and sort them by most recent
                    _matches = matchProvider.items.values.toList();
                    //_matches = matchProvider.getByClub(widget.club).values.toList();
                    _matches.sort((a, b) => b.date.compareTo(a.date));
                  }

                  if (_matches.isNotEmpty) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                // Statistics (total games & points)
                                HeaderWidget(
                                  headerText: 'Estatísticas',
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Jogos Totais',
                                                    style: Theme.of(context).textTheme.subtitle1,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    '${_matches.length}',
                                                    style: Theme.of(context).textTheme.headline5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const VerticalDivider(thickness: 1),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Pontos Total',
                                                    style: Theme.of(context).textTheme.subtitle1,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    '${matchProvider.getClubPoints(widget.club)}',
                                                    style: Theme.of(context).textTheme.headline5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                // Recent games
                                HeaderWidget(
                                  headerText: 'Histórico de Jogos',
                                  child: Card(
                                    child: ListView.separated(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: _matches.length,
                                      itemBuilder: (context, index) {
                                        Match match = _matches[index];
                                        return MatchTile(match: match);
                                      },
                                      separatorBuilder: (context, index) => const Divider(height: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (_matches.isEmpty && matchProvider.state == ProviderState.busy) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // If nothing is found
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                        child: Text(
                      'Este clube ainda não participou em nenhuma competição',
                      style: Theme.of(context).textTheme.caption,
                    )),
                  );
                },
              ),
              // ############# Team Page #############
              Consumer<ContractProvider>(
                builder: (context, contractProvider, child) {
                  if (contractProvider.state != ProviderState.busy && _contracts.isEmpty) {
                    // Get all active contracts of the club
                    _contracts = contractProvider.items.values
                        .where((element) => element.club.id == widget.club.id && element.active)
                        .toList();
                  }
                  if (_contracts.isNotEmpty) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: HeaderWidget(
                          headerText: 'Plantel',
                          child: Card(
                            child: ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _contracts.length,
                              itemBuilder: (context, index) {
                                Contract contract = _contracts.elementAt(index);
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
                                  onDelete: () {
                                    _loadPageData();
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => Divider(
                                  height: 0, indent: 16, endIndent: 16, color: Theme.of(context).colorScheme.outline),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: HeaderWidget(
                      headerText: 'Plantel',
                      child: Expanded(
                        child: (_contracts.isEmpty && contractProvider.state == ProviderState.busy)
                            ? const Center(child: CircularProgressIndicator())
                            // If nothing is found
                            : Card(
                                child: Center(
                                  child: Text(
                                    'Não existem jogadores neste clube.',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
              // ############# Info Page #############
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: HeaderWidget(
                    headerText: 'Dados Gerais',
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            isThreeLine: true,
                            title: const Text('Morada'),
                            subtitle: Text(
                              '${widget.club.stadium!.address}\n'
                              '${widget.club.stadium?.city}, ${widget.club.stadium?.country.name}',
                            ),
                          ),
                          const Divider(height: 0, indent: 16, endIndent: 16),
                          if (widget.club.phone != null)
                            ListTile(title: const Text('Telefone'), subtitle: Text(widget.club.phone!)),
                          const Divider(height: 0, indent: 16, endIndent: 16),
                          if (widget.club.fax != null) ListTile(title: const Text('Fax'), subtitle: Text(widget.club.fax!)),
                          const Divider(height: 0, indent: 16, endIndent: 16),
                          if (widget.club.email != null)
                            ListTile(title: const Text('Email'), subtitle: Text(widget.club.email!)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(thickness: 1, height: 0, color: Theme.of(context).colorScheme.outline)
      ]),

      // ############# Bottom Nav #############
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Estatísticas'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), label: 'Plantel'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Dados Gerais')
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
                          ContractAddView(club: widget.club, onComplete: _loadPageData)),
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
