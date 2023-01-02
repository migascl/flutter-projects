import 'package:flutter/material.dart';
import 'package:tg2/provider/stadium_provider.dart';
import '../../../models/club_model.dart';
import '../../../models/player_model.dart';
import '../../../models/stadium_model.dart';
import '../../../provider/club_provider.dart';

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
                icon: Icon(Icons.science_rounded), label: 'Exames'),
            BottomNavigationBarItem(
                icon: Icon(Icons.file_copy_rounded), label: 'Contratos')
          ],
          onTap: _onTappedBar,
          selectedItemColor: Colors.orange,
          currentIndex: _selectedIndex,
        ),
        body: Column(children: [
          Container(
              color: Colors.blue,
              height: 200,
              padding: EdgeInsets.fromLTRB(16, 86, 16, 16),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.player.name,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                        fontSize: 24)
                  )
                ],
              )),
          Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  Center(child: Text("${widget.player.height}")),
                  Center(child: Text("Exames")),
                  Center(child: Text("Contratos")),
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