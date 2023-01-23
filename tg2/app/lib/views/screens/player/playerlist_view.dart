import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/exam_provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/views/screens/player/player_view.dart';
import 'package:tg2/views/widgets/futureimage.dart';

import '../../../models/exam_model.dart';
import '../../../models/player_model.dart';
import '../../../utils/dateutils.dart';
import '../../widgets/menudrawer.dart';

enum _ExamFilters {
  empty,
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

  TextEditingController dateStartFieldController = TextEditingController();
  TextEditingController dateEndFieldController = TextEditingController();
  String? errorText;

  _ExamFilters _filter = _ExamFilters.empty;
  DateTimeRange _filterPeriod =
      DateTimeRange(start: DateTime(1970, 1, 1), end: DateTime.now());

  // Method to reload providers used by the page
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

  void _setFilter(_ExamFilters newFilter) =>
      setState(() => _filter = newFilter);

  void _setPeriod(DateTimeRange? range) => setState(() {
        if (range != null) {
          _filterPeriod = range;
          dateStartFieldController.text = DateUtilities().toYMD(range.start);
          dateEndFieldController.text = DateUtilities().toYMD(range.end);
        } else {
          _filterPeriod =
              DateTimeRange(start: DateTime(1970, 1, 1), end: DateTime.now());
          dateStartFieldController.clear();
          dateEndFieldController.clear();
        }
      });

  void _showDatePicker() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1970, 1, 1),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    _setPeriod(result);
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
                  return Dialog(
                    child: StatefulBuilder(
                      builder: (context, setState) => Container(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Filtros',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                              child: const Divider(thickness: 1),
                            ),
                            Text(
                              'Realizou Testes?',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Wrap(
                              spacing: 8,
                              children: [
                                ActionChip(
                                    label: const Icon(
                                        Icons.highlight_remove_rounded),
                                    tooltip: "Remover Filtro",
                                    onPressed: () => setState(
                                        () => _setFilter(_ExamFilters.empty))),
                                ChoiceChip(
                                    label: const Text('Sim'),
                                    selectedColor: Colors.blue,
                                    selected: _filter == _ExamFilters.hasTests,
                                    onSelected: (bool selected) => setState(
                                        () =>
                                            _setFilter(_ExamFilters.hasTests))),
                                ChoiceChip(
                                    label: const Text('Não'),
                                    selectedColor: Colors.blue,
                                    selected: _filter == _ExamFilters.noTests,
                                    onSelected: (bool selected) => setState(
                                        () =>
                                            _setFilter(_ExamFilters.noTests))),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Período',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ActionChip(
                                  label: const Icon(
                                      Icons.highlight_remove_rounded),
                                  tooltip: "Apagar data",
                                  onPressed: () => _setPeriod(null),
                                ),
                                const SizedBox(width: 16),
                                Flexible(
                                  child: TextField(
                                    controller: dateStartFieldController,
                                    readOnly: true,
                                    enabled: _filter != _ExamFilters.empty,
                                    decoration: const InputDecoration(
                                      labelText: "Início",
                                      border: OutlineInputBorder(),
                                    ),
                                    onTap: () => _showDatePicker(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: TextField(
                                    controller: dateEndFieldController,
                                    readOnly: true,
                                    enabled: _filter != _ExamFilters.empty,
                                    decoration: const InputDecoration(
                                      labelText: "Final",
                                      border: OutlineInputBorder(),
                                    ),
                                    onTap: () => _showDatePicker(),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
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
              Map<int, Player> list = {};
              if (_filter == _ExamFilters.empty) {
                list = playerProvider.items;
              } else {
                for (var player in playerProvider.items.values) {
                  List<Exam> exams =
                      examProvider.getByDate(_filterPeriod).values.toList();
                  if (_filter == _ExamFilters.hasTests &&
                      exams.any((element) => element.player.id == player.id)) {
                    list.putIfAbsent(player.id!, () => player);
                  }
                  if (_filter == _ExamFilters.noTests &&
                      !exams.any((element) => element.player.id == player.id)) {
                    list.putIfAbsent(player.id!, () => player);
                  }
                }
              }
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  Player player = list.values.elementAt(index);
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
