import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MatchweeksView(),
                    maintainState: false,
                  ),
                ),
            child: Text("Jornadas")),
        ElevatedButton(
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TeamsView(),
                    maintainState: false,
                  ),
                ),
            child: Text("Clubes")),
      ],
    )));
  }
}

class MatchweeksView extends StatefulWidget {
  const MatchweeksView({super.key});

  @override
  State<MatchweeksView> createState() => _MatchweeksViewState();
}

class _MatchweeksViewState extends State<MatchweeksView> {
  @override
  Widget build(BuildContext context) {
    print("Matchweeks View: Building...");
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TabBar Widget'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(
                text: "Jornada 13",
              ),
              Tab(
                text: "Jornada 12",
              ),
              Tab(
                text: "Jornada 11",
              ),
              Tab(
                text: "Jornada 10",
              ),
              Tab(
                text: "Jornada 9",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
                child: Column(
              children: [
                Text("Jogos"),
                Column(
                  children: [Container(child: Text("12 de Novembro 2021"))],
                ),
              ],
            )),
            Center(
              child: Text("It's rainy here"),
            ),
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamsView extends StatefulWidget {
  const TeamsView({super.key});

  @override
  State<TeamsView> createState() => _TeamsViewState();
}

class _TeamsViewState extends State<TeamsView> {
  @override
  Widget build(BuildContext context) {
    print("Teams View: Building...");
    return Scaffold(
        appBar: AppBar(title: Text("Clubes")),
        body: Center(child: Text("Equipas")));
  }
}
