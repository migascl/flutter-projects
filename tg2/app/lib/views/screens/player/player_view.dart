// Library Imports
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
import 'package:tg2/views/screens/exam_modify_view.dart';

// This page shows player's information
class PlayerView extends StatefulWidget {
  const PlayerView({super.key, required this.player});

  final Player player;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {

  FloatingActionButton? fab = null;

  void loadPageData() {
    Provider.of<ClubProvider>(context, listen: false).get();
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
      loadPageData();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Player/V: Building...");

    switch(_selectedIndex) {
      case 0:
        fab = null;
        break;
      case 1:
        fab = FloatingActionButton(
          onPressed: () {
          },
          child: const Icon(Icons.add_rounded),
        );
        break;
      case 2:
        fab = FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ExamModifyView(),
                maintainState: false,
              ),
            );
          },
          child: const Icon(Icons.add_rounded),
        );
        break;
    }

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
                // Refresh page data
                loadPageData();
              },
            ),
          ],
        ),
        floatingActionButton: fab,
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
                  Image(
                    height: 64,
                    image: NetworkImage(widget.player.picture),
                  ),
                  Text(
                    widget.player.nickname ?? widget.player.name, // Prioritize showing nickname on header
                    style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                        color: Colors.white,
                    )
                  )
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
                        title: const Text("Nome"),
                        subtitle: Text(widget.player.name)
                      ),
                      ListTile(
                        title: const Text("Nacionalidade"),
                        subtitle: Text(Provider.of<CountryProvider>(context, listen: false).items[widget.player.countryID]!.name),
                      ),
                      ListTile(
                        title: const Text("Data de Nascimento"),
                        subtitle: Text("${widget.player.birthday} (${widget.player.age} anos)"),
                      ),
                      ListTile(
                        title: const Text("Altura"),
                        subtitle: Text("${widget.player.height} cm"),
                      ),
                      ListTile(
                        title: const Text("Peso"),
                        subtitle: Text("${widget.player.weight} kg"),
                      ),
                    ],
                  ),
                  // Player contracts page
                  Consumer<ContractProvider>(builder: (context, contractProvider, child) {
                    if(contractProvider.state == ProviderState.ready) {
                      Map<int, Contract> contractList = Map.fromEntries(contractProvider.items.entries.expand((element) => [
                        if (element.value.playerID == widget.player.id) MapEntry(element.key, element.value)
                      ]));
                      if(contractList.isEmpty) return const Center(child: Text("Este jogador não contêm contratos."));
                      return MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          itemCount: contractList.length,
                          itemBuilder: (context, index) {
                            Contract contract = contractList.values.elementAt(index);
                            Club club = contractProvider.clubProvider.items[contract.clubID]!;
                            return Column(
                              children: [
                                ListTile(
                                  leading: Image(
                                    image: NetworkImage(club.picture),
                                    height: 32,
                                  ),
                                  title: Text(club.name),
                                  subtitle: Text("Ínicio: ${contract.period.start}\nFim: ${contract.period.end}"),
                                  trailing: PopupMenuButton<int>(
                                    // TODO ADD EDIT CONTRACT NAVIGATION
                                      onSelected: (int value) {
                                        // Remove player
                                        if(value == 0) {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                title: const Text('Atenção!'),
                                                content: Text("Tem a certeza que pretende eliminar contracto #${contract.id} ?\n"
                                                    "Esta operação não irreversível!"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      contractProvider.delete(contract).then((value) => loadPageData());
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text('Sim'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text('Não'),
                                                  ),
                                                ],
                                              ));
                                        }
                                      },
                                      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                                        const PopupMenuItem<int>(
                                          value: 0,
                                          child: Text('Remover'),
                                        ),
                                      ]
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => ClubView(club: club),
                                        maintainState: false,
                                      ),
                                    );
                                  },
                                ),
                                const Divider(
                                  height: 2.0,
                                ),
                              ],
                            );
                          },
                        )
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                  }),
                  // Player exams page
                  Consumer<ExamProvider>(builder: (context, examProvider, child) {
                    if(examProvider.state == ProviderState.ready) {
                      Map<int, Exam> examList = Map.fromEntries(examProvider.items.entries.expand((element) => [
                        if (element.value.playerID == widget.player.id) MapEntry(element.key, element.value)
                      ]));
                      if(examList.isEmpty) return const Center(child: Text("Jogador não realizou nenhum exame."));
                      return MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemCount: examList.length,
                            itemBuilder: (context, index) {
                              Exam exam = examList.values.elementAt(index);
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text("Exame #${exam.id}"),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Data: ${exam.date}"),
                                        Text("Resultado: ${(exam.result) ? "Passou" : "Falhou"}")
                                      ],
                                    ),
                                    trailing: PopupMenuButton<int>(
                                      onSelected: (int value) {
                                        if(value == 0) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ExamModifyView(exam: exam,),
                                              maintainState: false,
                                            ),
                                          );
                                        }
                                        if(value == 1) {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text('Atenção!'),
                                              content: Text("Tem a certeza que pretende eliminar exame #${exam.id} ?\n"
                                                  "Esta operação não irreversível!"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    examProvider.delete(exam).then((value) => loadPageData());
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Sim'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Não'),
                                                ),
                                              ],
                                            ));
                                        }
                                      },
                                      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                                        const PopupMenuItem<int>(
                                          value: 0,
                                          child: Text('Editar'),
                                        ),
                                        const PopupMenuItem<int>(
                                          value: 1,
                                          child: Text('Remover'),
                                        ),
                                      ]
                                    ),
                                  ),
                                  const Divider(height: 2.0),
                                ],
                              );
                            },
                          )
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator(),);
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
          BottomNavigationBarItem(
              icon: Icon(Icons.info), label: 'Informação'),
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