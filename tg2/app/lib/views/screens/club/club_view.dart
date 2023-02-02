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
  const ClubView({super.key, required this.club, this.selectedMatchweek});

  final Club club;
  final int? selectedMatchweek;

  @override
  State<ClubView> createState() => _ClubViewState();
}

class _ClubViewState extends State<ClubView> {
  List<Match> matches = [];
  int? selectedMatchweek;
  List<int> matchweeks = [];
  List<Contract> contracts = [];

  // Page view controls
  int selectedIndex = 0;
  final PageController pageController = PageController();

  FloatingActionButton? fab;

  // Reload providers used by the page, displays snackbar if exception occurs
  Future loadPageData() async {
    try {
      await Provider.of<ClubProvider>(context, listen: false).get();
      matches.clear();
      contracts.clear();
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
    selectedMatchweek = widget.selectedMatchweek;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((context) => loadPageData());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    if (widget.club.color != null) {
      theme = theme.copyWith(colorScheme: ColorScheme.fromSeed(seedColor: widget.club.color!));
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
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
      floatingActionButton: fab,
      body: Column(children: [
        // HEADER
        Container(
          padding: const EdgeInsets.all(24),
          color: theme.colorScheme.primary,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: FutureImage(
                  image: widget.club.logo,
                  aspectRatio: 1 / 1,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.club.name,
                      style: Theme.of(context).textTheme.titleLarge?.apply(color: theme.colorScheme.onPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.club.stadium?.name ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.apply(color: theme.colorScheme.onPrimary.withOpacity(0.75)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        // BODY
        Expanded(
          child: PageView(
            controller: pageController,
            children: [
              // STATS PAGE
              Consumer<MatchProvider>(
                builder: (context, matchProvider, child) {
                  if (matchProvider.state != ProviderState.busy && matches.isEmpty) {
                    matchweeks = matchProvider.getMatchweeks();
                    // Get all matches from the club and sort them by most recent
                    matches = matchProvider.getByClub(widget.club).values.toList();
                    if (selectedMatchweek != null) {
                      matches = matches.where((element) => element.matchweek == selectedMatchweek).toList();
                    }
                    matches.sort((a, b) => b.date.compareTo(a.date));
                  }

                  if (matches.isNotEmpty) {
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
                                  headerAction: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      DropdownButton<int>(
                                        items: matchweeks.map<DropdownMenuItem<int>>((int value) {
                                          return DropdownMenuItem<int>(
                                            value: value,
                                            child: Text('Jornada $value'),
                                          );
                                        }).toList(),
                                        hint: const Text('Época Inteira'),
                                        value: selectedMatchweek,
                                        onChanged: (value) {
                                          setState(() {
                                            matches.clear();
                                            selectedMatchweek = value;
                                          });
                                        },
                                        underline: Container(),
                                      ),
                                      IconButton(
                                        splashRadius: 24,
                                        onPressed: () => setState(() {
                                          selectedMatchweek = null;
                                        }),
                                        icon: const Icon(Icons.clear_sharp, size: 24),
                                      ),
                                    ],
                                  ),
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
                                                    selectedMatchweek != null
                                                        ? '${matches.where((match) => match.matchweek == selectedMatchweek).length}'
                                                        : '${matches.length}',
                                                    style: Theme.of(context).textTheme.headlineSmall,
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
                                                    '${matchProvider.getClubPoints(club: widget.club, matchweek: selectedMatchweek)}',
                                                    style: Theme.of(context).textTheme.headlineSmall,
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
                                Column(
                                  children: [
                                    ListTile(
                                      tileColor: Theme.of(context).colorScheme.surfaceVariant,
                                      dense: true,
                                      textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                                      title: Text(
                                        'Histórico de Jogos',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ),
                                    Card(
                                      child: ListView.separated(
                                        primary: false,
                                        shrinkWrap: true,
                                        itemCount: matches.length,
                                        itemBuilder: (context, index) {
                                          Match match = matches[index];
                                          return MatchTile(match: match);
                                        },
                                        separatorBuilder: (context, index) => const Divider(height: 0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (matches.isEmpty && matchProvider.state == ProviderState.busy) {
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
              // TEAM PAGE
              Consumer<ContractProvider>(
                builder: (context, contractProvider, child) {
                  if (contractProvider.state != ProviderState.busy && contracts.isEmpty) {
                    // Get all active contracts of the club
                    contracts = contractProvider.data.values
                        .where((element) => element.club.id == widget.club.id && element.active)
                        .toList();
                  }
                  if (contracts.isNotEmpty) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: HeaderWidget(
                          headerText: 'Plantel',
                          child: Card(
                            child: ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: contracts.length,
                              itemBuilder: (context, index) {
                                Contract contract = contracts.elementAt(index);
                                return ContractTile(
                                  contract: contract,
                                  showClub: false,
                                  onTap: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      isDismissible: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (context) => ContractView(contract: contract),
                                    );
                                  },
                                  onDelete: () {
                                    loadPageData();
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => Divider(
                                height: 0,
                                indent: 16,
                                endIndent: 16,
                                color: Theme.of(context).colorScheme.outline,
                              ),
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
                        child: (contracts.isEmpty && contractProvider.state == ProviderState.busy)
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
              // INFO PAGE
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

      // BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: theme.colorScheme.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics_sharp),
            label: 'Estatísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups_sharp),
            label: 'Plantel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info_sharp),
            label: 'Dados Gerais',
          )
        ],
        onTap: (int value) {
          setState(() {
            selectedIndex = value;
            switch (selectedIndex) {
              case 1:
                fab = FloatingActionButton(
                  backgroundColor: theme.colorScheme.primary,
                  onPressed: () => showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) =>
                        ContractAddView(club: widget.club, onComplete: loadPageData),
                  ),
                  child: const Icon(Icons.add),
                );
                break;
              default:
                fab = null;
                break;
            }
          });
          pageController.animateToPage(
            value,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeIn,
          );
        },
        currentIndex: selectedIndex,
      ),
    );
  }
}
