import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/exam_model.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/provider/exam_provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/utils/dateutils.dart';
import 'package:tg2/utils/exceptions.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/models/contract_model.dart';

import '../../models/position_model.dart';
import '../widgets/futureimage.dart';

// Widget used to manage a player's exam data
// It automatically populates all fields if an exam object is provided
// Depending on the existence of a non-null id, it knows when to either post or update the database.
class ContractAddView extends StatefulWidget {
  const ContractAddView({super.key, this.club, this.player});

  final Club? club; // Player information
  final Player? player; // Player information

  @override
  State<ContractAddView> createState() => _ContractAddView();
}

class _ContractAddView extends State<ContractAddView> {
  final GlobalKey<FormState> _contractFormKey = GlobalKey<FormState>();

  TextEditingController numberFieldController = TextEditingController();
  TextEditingController dateFieldController = TextEditingController();
  bool isLoading = false;

  Player? _player;
  Club? _club;
  int? _number;
  Position? _position;
  DateTimeRange? _period;
  Map<String, dynamic>? _document;

  // Method to submit data onto the provider
  // If the exam object contains a non null id, it executes the PATCH method, or POST otherwise.
  Future _submitData() async {
    try {
      setState(() => isLoading = true);
      await Provider.of<ContractProvider>(context, listen: false)
          .post(Contract(_player!, _club!, _number!, _position!, _period!, {"nif": 21808312913}))
          .then((value) => Navigator.of(context).pop());
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    print("ContractAdd/V: Initialized State!");
    _club = widget.club;
    _player = widget.player;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("ContractAdd/V: Building...");
    return AlertDialog(
      title: const Text('Novo Contrato'),
      content: Consumer2<ClubProvider, PlayerProvider>(
        builder: (context, clubProvider, playerProvider, child) {
          if (clubProvider.state == ProviderState.ready &&
              playerProvider.state == ProviderState.ready) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<int>(
                  hint: const Text("Clube"),
                  value: _club?.id,
                  onChanged: widget.club == null
                      ? (int? value) => setState(() {
                            _player = playerProvider.items.values
                                .singleWhere((element) => element.id == value);
                          })
                      : null,
                  items: clubProvider.items.values.map<DropdownMenuItem<int>>((Club value) {
                    return DropdownMenuItem<int>(
                      value: value.id,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          FutureImage(
                            image: value.picture!,
                            errorImageUri: 'assets/images/placeholder-club.png',
                            height: 32,
                            aspectRatio: 1 / 1,
                          ),
                          Text(value.name),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                DropdownButton<int>(
                  hint: const Text("Jogador"),
                  value: _player?.id,
                  onChanged: widget.player == null
                      ? (int? value) => setState(() {
                            _player = playerProvider.items.values
                                .singleWhere((element) => element.id == value);
                          })
                      : null,
                  items: playerProvider.items.values.map<DropdownMenuItem<int>>((Player value) {
                    return DropdownMenuItem<int>(
                      value: value.id,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          FutureImage(
                            image: value.picture!,
                            errorImageUri: 'assets/images/placeholder-player.png',
                            height: 32,
                            aspectRatio: 1 / 1,
                          ),
                          Text(value.nickname ?? value.name),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    Flexible(
                      child: DropdownButton<Position>(
                        hint: Text("Posição"),
                        value: _position,
                        onChanged: (Position? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            _position = value;
                          });
                        },
                        items: Position.values.map<DropdownMenuItem<Position>>((Position value) {
                          return DropdownMenuItem<Position>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: numberFieldController,
                        enabled: !isLoading,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          labelText: "Número da Camisóla",
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (String? value) {
                          if (value != null) {
                            _number = int.tryParse(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: TextFormField(
                    controller: dateFieldController,
                    readOnly: true,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: "Período do Contrato",
                      border: const OutlineInputBorder(),
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final DateTimeRange? result = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(1970, 1, 1),
                        lastDate: DateTime.now(),
                        currentDate: DateTime.now(),
                      );
                      if (result != null) {
                        setState(() {
                          _period = result;
                          dateFieldController.text = DateUtilities().toYMD(_period!.start) +
                              " a " +
                              DateUtilities().toYMD(_period!.end);
                        });
                      }
                    },
                  ),
                ),
              ],
            );
          }
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erro"),
              duration: Duration(seconds: 5),
            ),
          );
          return Container();
        },
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : () => _submitData(),
          child: isLoading ? const CircularProgressIndicator() : const Text('Guardar'),
        ),
      ],
    );
  }
}
