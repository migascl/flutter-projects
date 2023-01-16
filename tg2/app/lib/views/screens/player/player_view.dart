import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/models/exam_model.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/provider/exam_provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/utils/dateutils.dart';
import 'package:tg2/views/screens/exam_modify_view.dart';

import '../../widgets/futureimage.dart';
import '../contract_view.dart';

// This page shows player's information
class PlayerView extends StatefulWidget {
  const PlayerView({super.key, required this.player});

  final Player player;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late final Player _player = widget.player;

  void _loadPageData() {
    Provider.of<PlayerProvider>(context, listen: false).get();
    Provider.of<ContractProvider>(context, listen: false).get();
    Provider.of<ExamProvider>(context, listen: false).get();
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
    print("Player/V: Initialized State!");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPageData();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Player/V: Building...");

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh',
              onPressed: () => _loadPageData()),
        ],
      ),
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => showDialog(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) =>
                      ExamModifyView(player: _player)),
            )
          : null,
      body: Column(children: [
        // Page header
        Container(
            color: Colors.blue,
            padding: const EdgeInsets.fromLTRB(32, 86, 32, 32),
            height: 200,
            alignment: Alignment.topLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureImage(
                  image: _player.picture!,
                  errorImageUri: 'assets/images/placeholder-club.png',
                  aspectRatio: 1 / 1,
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(
                        _player.nickname ?? _player.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.merge(const TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _player.country.name,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.merge(const TextStyle(color: Colors.white70)),
                      ),
                    ]))
              ],
            )),
        // Page body
        Expanded(
            child: PageView(
          controller: _pageController,
          children: [
            // Player information view
            ListView(
              padding: const EdgeInsets.all(8),
              children: [
                ListTile(
                    title: const Text("Nome"), subtitle: Text(_player.name)),
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
              ],
            ),
            // Player contracts page
            Consumer<ContractProvider>(
                builder: (context, contractProvider, child) {
              if (contractProvider.state == ProviderState.ready) {
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
                return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.separated(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        Contract contract = list.elementAt(index);
                        return Column(
                          children: [
                            ListTile(
                              leading: FutureImage(
                                image: contract.club.picture!,
                                errorImageUri:
                                    'assets/images/placeholder-club.png',
                                height: 48,
                                aspectRatio: 1 / 1,
                              ),
                              title: Text(contract.club.name),
                              subtitle: Text(
                                  "Ínicio: ${DateUtilities().toYMD(contract.period.start)} | Fim: ${DateUtilities().toYMD(contract.period.end)}"),
                              // Show warning icon that shows a tooltip with remaining contract duration and expiry date
                              trailing:
                                  contract.needsRenovation && contract.active
                                      ? Tooltip(
                                          message:
                                              'Contrato expira em ${contract.remainingTime.inDays} dias!\n(${contract.period.end.toLocal()})',
                                          textAlign: TextAlign.center,
                                          child: const Icon(
                                            Icons.warning_rounded,
                                            size: 32,
                                            color: Colors.amber,
                                          ),
                                        )
                                      : null,
                              onTap: () => showModalBottomSheet(
                                  isScrollControlled: true,
                                  isDismissible: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) =>
                                      ContractView(contract: contract)),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
            // Player exams page
            Consumer<ExamProvider>(builder: (context, examProvider, child) {
              if (examProvider.state == ProviderState.ready) {
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
                return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        Exam exam = list.elementAt(index);
                        return Column(
                          children: [
                            ListTile(
                                title: Text("Exame ${exam.id}"),
                                subtitle: Text(
                                    "Data: ${DateUtilities().toYMD(exam.date)} | Resultado: ${(exam.result) ? "Passou" : "Falhou"}"),
                                trailing: PopupMenuButton(
                                  // Callback that sets the selected popup menu item.
                                  onSelected: (int value) {
                                    if (value == 0) {
                                      showDialog(
                                          context: context,
                                          barrierDismissible:
                                              false, // user must tap button!
                                          builder: (BuildContext context) =>
                                              ExamModifyView(
                                                  exam: exam, player: _player));
                                    }
                                    if (value == 1) examProvider.delete(exam);
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<int>>[
                                    const PopupMenuItem<int>(
                                      value: 0,
                                      child: Text('Editar'),
                                    ),
                                    const PopupMenuItem<int>(
                                      value: 1,
                                      child: Text('Remover'),
                                    ),
                                  ],
                                )),
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
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Informação'),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_copy_rounded), label: 'Contratos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.science_rounded), label: 'Exames')
        ],
        onTap: _onTabTap,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
