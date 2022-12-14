import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/models/exam_model.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/provider/exam_provider.dart';
import 'package:tg2/views/screens/exam_modify_view.dart';
import '../contract_view.dart';

// This page shows player's information
class PlayerView extends StatefulWidget {
  const PlayerView({super.key, required this.player});

  final Player player;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late Player _player = widget.player;

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
      // TODO IMPROVE PLAYER HEADER STYLE
      body: Column(children: [
        // Page header
        Container(
            color: Colors.blue,
            height: 200,
            padding: const EdgeInsets.fromLTRB(16, 86, 16, 16),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    child: (_player.picture != null)
                        ? Image(
                            image: _player.picture!,
                            height: 64,
                          )
                        : null),
                Text(
                    _player.nickname ??
                        _player.name, // Prioritize showing nickname on header
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                      fontSize: 24,
                      color: Colors.white,
                    ))
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
                  subtitle: Text("${_player.birthday} (${_player.age} anos)"),
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
                if (list.isEmpty)
                  return const Center(
                      child: Text("Este jogador n??o cont??m contratos."));
                return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        Contract contract = list.elementAt(index);
                        return Column(
                          children: [
                            ListTile(
                              leading: (contract.club.picture != null)
                                  ? Image(
                                      image: contract.club.picture!,
                                      height: 32,
                                    )
                                  : null,
                              title: Text(contract.club.name),
                              subtitle: Text(
                                  "??nicio: ${contract.period.start}\nFim: ${contract.period.end}"),
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
                return const Center(child: CircularProgressIndicator());
              }
            }),
            // Player exams page
            Consumer<ExamProvider>(builder: (context, examProvider, child) {
              if (examProvider.state == ProviderState.ready) {
                List<Exam> list = List.from(examProvider.items.values
                    .where((element) => element.player.id == _player.id));
                if (list.isEmpty)
                  return const Center(
                      child: Text("Jogador n??o realizou nenhum exame."));
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
                                title: Text("Exame #${exam.id}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Data: ${exam.date}"),
                                    Text(
                                        "Resultado: ${(exam.result) ? "Passou" : "Falhou"}")
                                  ],
                                ),
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
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Informa????o'),
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
