import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/models/exam_model.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/provider/country_provider.dart';
import 'package:tg2/provider/exam_provider.dart';
import 'package:tg2/views/screens/club/club_view.dart';

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
                            image: NetworkImage(_player.picture!),
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
                      child: Text("Este jogador não contêm contratos."));
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
                                      image:
                                          NetworkImage(contract.club.picture!),
                                      height: 32,
                                    )
                                  : null,
                              title: Text(contract.club.name),
                              subtitle: Text(
                                  "Ínicio: ${contract.period.start}\nFim: ${contract.period.end}"),
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
                      child: Text("Jogador não realizou nenhum exame."));
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
