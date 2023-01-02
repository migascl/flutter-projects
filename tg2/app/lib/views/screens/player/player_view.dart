import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/utils/constants.dart';
import '../../../models/exam_model.dart';
import '../../../models/player_model.dart';
import '../../../provider/country_provider.dart';
import '../../../provider/exam_provider.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({super.key, required this.player});

  final Player player;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {

  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.info), label: 'Informação'),
            BottomNavigationBarItem(
                icon: Icon(Icons.file_copy_rounded), label: 'Contratos'),
            BottomNavigationBarItem(
                icon: Icon(Icons.science_rounded), label: 'Exames')

          ],
          onTap: _onTappedBar,
          currentIndex: _selectedIndex,
        ),
        // TODO IMPROVE PLAYER HEADER STYLE
        body: Column(children: [
          Container(
              color: Colors.blue,
              height: 200,
              padding: EdgeInsets.fromLTRB(16, 86, 16, 16),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    height: 64,
                    image: NetworkImage(widget.player.picture),
                  ),
                  Text(
                    widget.player.nickname ?? widget.player.name,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                        color: Colors.white,
                    )
                  )
                ],
              )),
          Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      ListTile(
                        title: Text("Nome"),
                        subtitle: Text(widget.player.name)
                      ),
                      ListTile(
                        title: Text("Nacionalidade"),
                        subtitle: Text(Provider.of<CountryProvider>(context, listen: false).items[widget.player.countryID]!.name),
                      ),
                      ListTile(
                        title: Text("Data de Nascimento"),
                        subtitle: Text("${widget.player.birthday} (${widget.player.age} anos)"),
                      ),
                      ListTile(
                        title: Text("Altura"),
                        subtitle: Text("${widget.player.height} cm"),
                      ),
                      ListTile(
                        title: Text("Peso"),
                        subtitle: Text("${widget.player.weight} kg"),
                      ),
                    ],
                  ),
                  // TODO ADD PLAYER CONTRACTS VIEW
                  Center(child: Text("Contratos")),
                  Consumer<ExamProvider>(builder: (context, examProvider, child) {
                    if(examProvider.state == ProviderState.ready) {
                      Map<int, Exam> examList = Map.fromEntries(examProvider.items.entries.expand((element) => [
                        if (element.value.playerID == widget.player.id) MapEntry(element.key, element.value)
                      ]));
                      if(examList.isEmpty) {
                        return const Center(child: Text("Nenhum exam encontrado."));
                      }
                      return ListView.builder(
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
                              ),
                              const Divider(
                                height: 2.0,
                              ),
                            ],
                          );
                        },
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
        ]));
  }
}