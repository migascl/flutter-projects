import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/provider/exam_provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/views/screens/exam_modify_view.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/models/exam_model.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/utils/dateutils.dart';
import 'package:tg2/views/widgets/contracttile.dart';
import 'package:tg2/views/widgets/futureimage.dart';
import 'package:tg2/views/screens/contract_view.dart';
import 'package:tg2/views/widgets/header.dart';
import 'package:tg2/views/screens/contract_add_view.dart';

// This widget displays all player information
// It requires a player object to initiate to use as fallback data if it can't retrieve an updated
// version of the player data from the server
class PlayerView extends StatefulWidget {
  const PlayerView({super.key, required this.player});

  final Player player;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late final Player _player = widget.player; // State player data
  List<Contract> contracts = [];
  List<Exam> _exams = [];

  // Page view controls
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  FloatingActionButton? fab;

  // Reload providers used by the page, displays snackbar if exception occurs
  Future loadPageData() async {
    print("Player/V: Reloading...");
    try {
      await Provider.of<PlayerProvider>(context, listen: false).get();
      contracts.clear();
      _exams.clear();
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
    print("Player/V: Initialized State!");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((context) => loadPageData());
  }

  @override
  Widget build(BuildContext context) {
    print("Player/V: Building...");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh_rounded), tooltip: 'Refresh', onPressed: () => loadPageData()),
        ],
      ),
      floatingActionButton: fab,
      body: Column(children: [
        // HEADER
        Container(
          padding: const EdgeInsets.all(24),
          color: Theme.of(context).colorScheme.primary,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: FutureImage(
                  image: _player.picture,
                  aspectRatio: 1 / 1,
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_player.nickname ?? _player.name,
                        style:
                            Theme.of(context).textTheme.titleLarge?.apply(color: Theme.of(context).colorScheme.onPrimary)),
                    const SizedBox(height: 8),
                    Text(
                      _player.country.name,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.apply(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.75)),
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
              controller: _pageController,
              children: [
                // INFO PAGE
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: HeaderWidget(
                      headerText: 'Dados Gerais',
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(title: const Text("Nome Completo"), subtitle: Text(_player.name)),
                            const Divider(height: 0, indent: 16, endIndent: 16),
                            ListTile(title: const Text("Nacionalidade"), subtitle: Text(_player.country.name)),
                            const Divider(height: 0, indent: 16, endIndent: 16),
                            ListTile(
                              title: const Text("Data de Nascimento"),
                              subtitle: Text("${DateFormat.yMd('pt_PT').format(_player.birthday)} (${_player.age} anos)"),
                            ),
                            const Divider(height: 0, indent: 16, endIndent: 16),
                            ListTile(title: const Text("Altura"), subtitle: Text("${_player.height} cm")),
                            const Divider(height: 0, indent: 16, endIndent: 16),
                            ListTile(title: const Text("Peso"), subtitle: Text("${_player.weight} kg")),
                            const Divider(height: 0, indent: 16, endIndent: 16),
                            if (_player.schooling != null)
                              ListTile(title: const Text("Escolaridade"), subtitle: Text(_player.schooling!.name))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // CONTRACTS
                Consumer<ContractProvider>(
                  builder: (context, contractProvider, child) {
                    if (contractProvider.state != ProviderState.busy && contracts.isEmpty) {
                      // Get all active contracts of the player
                      contracts = contractProvider.data.values.where((element) => element.player.id == _player.id).toList();
                      contracts.sort((a, b) => b.period.end.compareTo(a.period.end));
                    }
                    if (contracts.isNotEmpty) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: HeaderWidget(
                            headerText: 'Contratos',
                            child: Card(
                              child: ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: contracts.length,
                                itemBuilder: (context, index) {
                                  Contract contract = contracts.elementAt(index);
                                  return ContractTile(
                                    contract: contract,
                                    showClub: true,
                                    onTap: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          isDismissible: true,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) => ContractView(contract: contract));
                                    },
                                    onDelete: () => loadPageData(),
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
                        headerText: 'Contratos',
                        child: Expanded(
                          child: (contracts.isEmpty && contractProvider.state == ProviderState.busy)
                              ? const Center(child: CircularProgressIndicator())
                              // If nothing is found
                              : Card(
                                  child: Center(
                                    child: Text(
                                      'Este jogador não tem contratos.',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
                // EXAMS PAGE
                Consumer<ExamProvider>(
                  builder: (context, examProvider, child) {
                    if (examProvider.state != ProviderState.busy && _exams.isEmpty) {
                      // Get all active exams of the player and sort by most recent
                      _exams = examProvider.data.values.where((element) => element.player.id == _player.id).toList();
                      _exams.sort((a, b) => b.date.compareTo(a.date));
                    }
                    if (_exams.isNotEmpty) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: HeaderWidget(
                            headerText: 'Exames',
                            child: Card(
                              child: ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: _exams.length,
                                itemBuilder: (context, index) {
                                  Exam exam = _exams.elementAt(index);
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    title: Text("Exame ${exam.id}"),
                                    subtitle: Text(
                                        "Data: ${DateFormat.yMd('pt_PT').format(exam.date)}\nResultado: ${(exam.result) ? "Passou" : "Falhou"}"),
                                    trailing: PopupMenuButton(
                                      onSelected: (int value) {
                                        switch (value) {
                                          case 0:
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => ExamModifyView(
                                                exam: exam,
                                                player: _player,
                                                onComplete: loadPageData,
                                              ),
                                            );
                                            break;
                                          case 1:
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                title: const Text('Atenção!'),
                                                content: Text(
                                                    "Tem a certeza que pretende eliminar exame ${exam.id}?\nEsta operação não é reversível!"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        examProvider.delete(exam).then((value) => loadPageData());
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text('Eliminar')),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text('Cancelar')),
                                                ],
                                              ),
                                            );
                                            break;
                                        }
                                      },
                                      // Exam tile popup menu options
                                      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                                        const PopupMenuItem<int>(
                                          value: 0,
                                          child: Text('Editar'),
                                        ),
                                        const PopupMenuItem<int>(
                                          value: 1,
                                          child: Text('Remover'),
                                        ),
                                      ],
                                    ),
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
                        headerText: 'Exames',
                        child: Expanded(
                          child: (_exams.isEmpty && examProvider.state == ProviderState.busy)
                              ? const Center(child: CircularProgressIndicator())
                              // If nothing is found
                              : Card(
                                  child: Center(
                                    child: Text(
                                      'Este jogador ainda não realizou nenhum exame.',
                                      style: Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ],
              onPageChanged: (page) => setState(() => _selectedIndex = page)),
        ),
      ]),
      // BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info_sharp),
            label: 'Informação',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy_outlined),
            activeIcon: Icon(Icons.file_copy_sharp),
            label: 'Contratos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science_outlined),
            activeIcon: Icon(Icons.science_sharp),
            label: 'Exames',
          )
        ],
        onTap: (int value) {
          setState(() {
            _selectedIndex = value;
            switch (_selectedIndex) {
              case 1:
                fab = FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () => showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    pageBuilder: (buildContext, animation, secondaryAnimation) =>
                        ContractAddView(player: _player, onComplete: loadPageData),
                  ),
                );
                break;
              case 2:
                fab = FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () => showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    pageBuilder: (buildContext, animation, secondaryAnimation) => ExamModifyView(
                      player: _player,
                      onComplete: loadPageData,
                    ),
                  ),
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
        currentIndex: _selectedIndex,
      ),
    );
  }
}
