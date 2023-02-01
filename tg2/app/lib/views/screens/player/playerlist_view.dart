import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/exam_provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/views/screens/player/player_view.dart';
import 'package:tg2/views/widgets/futureimage.dart';
import 'package:tg2/models/exam_model.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/views/widgets/header.dart';
import 'package:tg2/views/widgets/menudrawer.dart';

// Enumerator of all possible filter states
enum _ExamFilters {
  empty,
  hasTests,
  noTests,
}

// This widget lists all players and allows to filter based on their exam records
// (if they have any and if so, in what specified period of time)
class PlayerListView extends StatefulWidget {
  const PlayerListView({super.key});

  @override
  State<PlayerListView> createState() => _PlayerListViewState();
}

class _PlayerListViewState extends State<PlayerListView> {
  Map<int, Player> players = {}; // Data structure of the page

  // Glocal key for refresh indicator
  final GlobalKey<RefreshIndicatorState> playerListRefreshKey = GlobalKey<RefreshIndicatorState>();

  // Text field controllers
  TextEditingController periodFieldController = TextEditingController();
  String? errorText; // Date field error text (will activate if non-null)

  _ExamFilters filter = _ExamFilters.empty; // Current Filter
  DateTimeRange? filterPeriod; // Exam period filter

  // Reload providers used by the page, displays snackbar if exception occurs
  Future _loadPageData() async {
    try {
      await Provider.of<PlayerProvider>(context, listen: false).get();
      players.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro. Tente novamente.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  void setFilter(_ExamFilters newFilter) => setState(() => filter = newFilter);

  void setPeriod(DateTimeRange? range) => setState(() {
        if (range != null) {
          filterPeriod = range;
          //dateFieldController.text = DateUtilities().toYMD(range.start);
          periodFieldController.text =
              '${DateFormat.yMMMd('pt_PT').format(range.start)} - ${DateFormat.yMMMd('pt_PT').format(range.end)}';
        } else {
          filterPeriod = DateTimeRange(start: DateTime(1970, 1, 1), end: DateTime.now());
          periodFieldController.clear();
        }
      });

  // Method to show date picker modal and set filter period
  void showDatePicker() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      initialDateRange: filterPeriod,
      firstDate: DateTime(1970, 1, 1),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
    );
    setPeriod(result);
  }

  @override
  void initState() {
    print('PlayerList/V: Initialized State!');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((context) => _loadPageData());
  }

  @override
  Widget build(BuildContext context) {
    print('PlayerList/V: Building...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogadores'),
        actions: [
          // FILTER
          IconButton(
            icon: const Icon(Icons.sort_outlined),
            tooltip: 'Filtos',
            onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: HeaderWidget(
                        headerText: 'Filtros',
                        headerAction: IconButton(
                          splashRadius: 24,
                          icon: const Icon(Icons.clear),
                          onPressed: () => Navigator.pop(context),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Realizou Testes?', style: Theme.of(context).textTheme.labelLarge),
                            Wrap(
                              spacing: 8,
                              children: [
                                ActionChip(
                                  label: const Icon(Icons.highlight_remove_rounded),
                                  tooltip: 'Remover Filtro',
                                  onPressed: () => setState(() {
                                    setFilter(_ExamFilters.empty);
                                    setPeriod(null);
                                  }),
                                ),
                                ChoiceChip(
                                  label: const Text('Sim'),
                                  selected: filter == _ExamFilters.hasTests,
                                  onSelected: (bool selected) => setState(() => setFilter(_ExamFilters.hasTests)),
                                ),
                                ChoiceChip(
                                  label: const Text('Não'),
                                  selected: filter == _ExamFilters.noTests,
                                  onSelected: (bool selected) => setState(() => setFilter(_ExamFilters.noTests)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Período', style: Theme.of(context).textTheme.labelLarge),
                            const SizedBox(height: 8),
                            Flexible(
                              child: TextField(
                                controller: periodFieldController,
                                readOnly: true,
                                enabled: filter != _ExamFilters.empty,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  hintText: 'Clique aqui',
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() => setPeriod(null)),
                                    icon: const Icon(Icons.clear),
                                  ),
                                ),
                                onTap: () => showDatePicker(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: const MenuDrawer(),
      // ############# Body #############
      body: RefreshIndicator(
        key: playerListRefreshKey,
        onRefresh: _loadPageData,
        child: Consumer2<PlayerProvider, ExamProvider>(builder: (context, playerProvider, examProvider, child) {
          if (examProvider.state != ProviderState.busy && players.isEmpty) {
            players = playerProvider.items;
          }

          if (players.isNotEmpty) {
            Map<int, Player> filterResults = {};
            // First it checks the filter state. If it's set to empty, add all players to the list.
            // Otherwise, it starts the filtering process by getting every exam entry on the given date range
            // It then iterates through every player, and depending on what filter state it's selected,
            // tries to find any exam (or none) that contains the player id of the current player iteration
            if (filter == _ExamFilters.empty) {
              filterResults = players;
            } else {
              List<Exam> exams =
                  (filterPeriod != null ? examProvider.getByDate(filterPeriod!).values : examProvider.items.values).toList();
              for (var player in players.values) {
                if (filter == _ExamFilters.hasTests && exams.any((element) => element.player.id == player.id)) {
                  filterResults.putIfAbsent(player.id!, () => player);
                }
                if (filter == _ExamFilters.noTests && !exams.any((element) => element.player.id == player.id)) {
                  filterResults.putIfAbsent(player.id!, () => player);
                }
              }
            }

            if (filterResults.isNotEmpty) {
              return ListView.separated(
                itemCount: filterResults.length,
                itemBuilder: (context, index) {
                  Player player = filterResults.values.elementAt(index);
                  return ListTile(
                    dense: true,
                    leading: FutureImage(
                      image: player.picture!,
                      errorImageUri: 'assets/images/placeholder-player.png',
                      aspectRatio: 1 / 1,
                      borderRadius: BorderRadius.circular(100),
                      height: 42,
                      color: Colors.white,
                    ),
                    title: Text(player.nickname ?? player.name, style: Theme.of(context).textTheme.titleSmall),
                    subtitle: Text(player.country.name, style: Theme.of(context).textTheme.caption),
                    tileColor: Theme.of(context).colorScheme.surface,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PlayerView(player: player),
                        maintainState: false,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(height: 0),
              );
            }
          }

          if (players.isEmpty && examProvider.state == ProviderState.busy) {
            return const Center(child: CircularProgressIndicator());
          }
          // If nothing is found
          return Center(
            child: Wrap(direction: Axis.vertical, crossAxisAlignment: WrapCrossAlignment.center, children: [
              const Text('Não foram encontrados nenhuns jogadores'),
              ElevatedButton(onPressed: _loadPageData, child: const Text('Tentar novamente')),
            ]),
          );
        }),
      ),
    );
  }
}
