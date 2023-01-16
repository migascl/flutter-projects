import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/exam_model.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/provider/exam_provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/views/screens/player/player_view.dart';
import 'package:tg2/views/widgets/futureimage.dart';

import '../../widgets/menudrawer.dart';

enum _ExamFilters {
  hasTests,
  noTests,
}

// This page lists all players
class PlayerListView extends StatefulWidget {
  const PlayerListView({super.key});

  @override
  State<PlayerListView> createState() => _PlayerListViewState();
}

class _PlayerListViewState extends State<PlayerListView> {
  final GlobalKey<RefreshIndicatorState> _playerListRefreshKey =
      GlobalKey<RefreshIndicatorState>();

  final List<_ExamFilters> _filters = [];
  DateTimeRange _filterPeriod =
      DateTimeRange(start: DateTime(1970, 1, 1), end: DateTime.now());

  void addFilter(_ExamFilters filter) {
    setState(() => _filters.add(filter));
  }

  void removeFilter(_ExamFilters filter) {
    setState(() => _filters.remove(filter));
  }

  // Method to reload providers used by the page
  Future _loadPageData() async {
    try {
      await Provider.of<PlayerProvider>(context, listen: false).get();
      await Provider.of<ExamProvider>(context, listen: false).get();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro. Tente novamente.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  void _showDatePicker() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.input,
      firstDate: DateTime(1970, 1, 1),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
    );

    if (result != null) setState(() => _filterPeriod = result);
  }

  @override
  void initState() {
    print("PlayerList/V: Initialized State!");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("PlayerList/V: Building...");
    return Scaffold(
        appBar: AppBar(
          title: const Text("Jogadores"),
          actions: [
            IconButton(
                icon: const Icon(Icons.sort_rounded),
                tooltip: 'Filtrar',
                // TODO IMPROVE PLAYER LIST FILTER STYLING
                onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text('Filtros'),
                          content: StatefulBuilder(
                              builder: (BuildContext context,
                                      StateSetter setState) =>
                                  Wrap(
                                    children: [
                                      const Text('Realizou Testes?'),
                                      Row(
                                        children: [
                                          Text("Sim"),
                                          Switch(
                                              value: _filters.contains(
                                                  _ExamFilters.hasTests),
                                              onChanged: (bool value) =>
                                                  setState(() => _filters
                                                          .contains(_ExamFilters
                                                              .hasTests)
                                                      ? removeFilter(
                                                          _ExamFilters.hasTests)
                                                      : addFilter(_ExamFilters
                                                          .hasTests))),
                                          Text("Não"),
                                          Switch(
                                            value: _filters
                                                .contains(_ExamFilters.noTests),
                                            onChanged: (bool value) => setState(
                                                () => _filters.contains(
                                                        _ExamFilters.noTests)
                                                    ? removeFilter(
                                                        _ExamFilters.noTests)
                                                    : addFilter(
                                                        _ExamFilters.noTests)),
                                          ),
                                          IconButton(
                                              onPressed: () =>
                                                  _showDatePicker(),
                                              icon: Icon(
                                                  Icons.calendar_month_rounded))
                                        ],
                                      ),
                                    ],
                                  )));
                    }))
          ],
        ),
        drawer: MenuDrawer(),
        body: RefreshIndicator(
          key: _playerListRefreshKey,
          onRefresh: _loadPageData,
          child: Consumer2<PlayerProvider, ExamProvider>(
              builder: (context, playerProvider, examProvider, child) {
            // Wait until provider is ready
            if (examProvider.state == ProviderState.ready) {
              Map<int, Player> _list = {};
              for (var player in playerProvider.items.values) {
                if (_filters.isEmpty) {
                  _list.putIfAbsent(player.id!, () => player);
                  continue;
                }
                List<Exam> _exams =
                    examProvider.getByDate(_filterPeriod).values.toList();
                if (_filters.contains(_ExamFilters.hasTests) &&
                    _exams.any((element) => element.player.id == player.id)) {
                  _list.putIfAbsent(player.id!, () => player);
                }
                if (_filters.contains(_ExamFilters.noTests) &&
                    !_exams.any((element) => element.player.id == player.id)) {
                  _list.putIfAbsent(player.id!, () => player);
                }
              }
              return ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  Player player = _list.values.elementAt(index);
                  return Column(
                    children: [
                      ListTile(
                          leading: FutureImage(
                            image: player.picture!,
                            errorImageUri:
                                'assets/images/placeholder-player.png',
                            aspectRatio: 1 / 1,
                          ),
                          title: Text(player.nickname ?? player.name),
                          subtitle: Text(player.country.name),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PlayerView(player: player),
                                maintainState: true,
                              ),
                            );
                          }),
                      const Divider()
                    ],
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ));
  }
}
