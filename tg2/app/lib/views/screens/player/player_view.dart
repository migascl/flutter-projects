import 'package:flutter/material.dart';
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

import '../contract_add_view.dart';

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

  // Page view controls
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  FloatingActionButton? fab;

  // Reload providers used by the page, displays snackbar if exception occurs
  Future _loadPageData() async {
    try {
      await Provider.of<PlayerProvider>(context, listen: false).get();
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
  }

  @override
  Widget build(BuildContext context) {
    print("Player/V: Building...");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh',
              onPressed: () => _loadPageData()),
        ],
      ),
      floatingActionButton: fab,
      body: Column(children: [
        // ############# Header #############
        Card(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
          color: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            height: MediaQuery.of(context).size.height * 0.2,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FutureImage(
                  image: _player.picture!,
                  errorImageUri: 'assets/images/placeholder-player.png',
                  aspectRatio: 1 / 1,
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _player.nickname ?? _player.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _player.country.name,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        // ############# Page body #############
        Expanded(
          child: PageView(
            controller: _pageController,
            children: [
              // ############# Info Page #############
              Card(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(title: const Text("Nome"), subtitle: Text(_player.name)),
                      ListTile(
                        title: const Text("Nacionalidade"),
                        subtitle: Text(_player.country.name),
                      ),
                      ListTile(
                        title: const Text("Data de Nascimento"),
                        subtitle: Text(
                            "${DateUtilities().toYMD(_player.birthday)} (${_player.age} anos)"),
                      ),
                      ListTile(
                        title: const Text("Altura"),
                        subtitle: Text("${_player.height} cm"),
                      ),
                      ListTile(
                        title: const Text("Peso"),
                        subtitle: Text("${_player.weight} kg"),
                      ),
                      if (_player.schoolingLvl != null)
                        ListTile(
                          title: const Text("Escolaridade"),
                          subtitle: Text(_player.schoolingLvl!.name),
                        )
                    ],
                  ),
                ),
              ),
              // ############# Contracts Page #############
              Card(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                child: Consumer<ContractProvider>(
                  builder: (context, contractProvider, child) {
                    if (contractProvider.state == ProviderState.ready) {
                      // Get all contracts from player and sort them from most recent
                      List<Contract> list = List.from(contractProvider.items.values
                          .where((element) => element.player.id == _player.id));
                      list.sort((a, b) => b.period.end.compareTo(a.period.end));

                      if (list.isEmpty) {
                        return Center(
                          child: Text(
                            "Este jogador não contêm contratos.",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        );
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
                              showClub: true,
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
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              // ############# Exams Page #############
              Card(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                child: Consumer<ExamProvider>(
                  builder: (context, examProvider, child) {
                    if (examProvider.state == ProviderState.ready) {
                      // Get all contracts from player and sort them from most recent
                      List<Exam> list = List.from(examProvider.items.values
                          .where((element) => element.player.id == _player.id));
                      list.sort((a, b) => b.date.compareTo(a.date));

                      if (list.isEmpty) {
                        return Center(
                          child: Text(
                            "Jogador não realizou nenhum exame.",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        );
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ListView.separated(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            Exam exam = list.elementAt(index);
                            return Column(
                              children: [
                                ListTile(
                                  title: Text("Exame ${exam.id}"),
                                  subtitle: Text(
                                      "Data: ${DateUtilities().toYMD(exam.date)}\nResultado: ${(exam.result) ? "Passou" : "Falhou"}"),
                                  trailing: PopupMenuButton(
                                    onSelected: (int value) {
                                      switch (value) {
                                        case 0:
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) => ExamModifyView(
                                              initialValue: exam,
                                              player: _player,
                                            ),
                                          );
                                          break;
                                        case 1:
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text('Atenção!'),
                                              content: Text(
                                                  "Tem a certeza que pretende eliminar exame ${exam.id}? Esta operação não é reversível!"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      examProvider.delete(exam);
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
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, int index) => const Divider(),
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
            onPageChanged: (page) {
              setState(() {
                _selectedIndex = page;
              });
            },
          ),
        ),
      ]),
      // ############# Bottom Nav #############
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Informação'),
          BottomNavigationBarItem(icon: Icon(Icons.file_copy_rounded), label: 'Contratos'),
          BottomNavigationBarItem(icon: Icon(Icons.science_rounded), label: 'Exames')
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
                      pageBuilder: (BuildContext buildContext, Animation animation,
                              Animation secondaryAnimation) =>
                          ContractAddView(player: _player)),
                );
                break;
              case 2:
                fab = FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () => showGeneralDialog(
                      context: context,
                      barrierDismissible: false,
                      pageBuilder: (BuildContext buildContext, Animation animation,
                              Animation secondaryAnimation) =>
                          ExamModifyView(player: _player)),
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
