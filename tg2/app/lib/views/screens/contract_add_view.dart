import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/provider/club_provider.dart';
import 'package:tg2/provider/contract_provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/utils/constants.dart';
import 'package:tg2/models/club_model.dart';
import 'package:tg2/models/contract_model.dart';
import 'package:tg2/models/position_model.dart';
import 'package:tg2/views/widgets/futureimage.dart';

import 'package:tg2/views/widgets/header.dart';

// Widget used to manage a player's exam data
// It automatically populates all fields if an exam object is provided
// Depending on the existence of a non-null id, it knows when to either post or update the database.
class ContractAddView extends StatefulWidget {
  const ContractAddView({super.key, this.club, this.player, this.onComplete});

  final Club? club; // Player information
  final Player? player; // Player information
  final VoidCallback? onComplete; // Player information

  @override
  State<ContractAddView> createState() => _ContractAddView();
}

class _ContractAddView extends State<ContractAddView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateFieldController = TextEditingController();
  bool isLoading = false; // Flag used to disable all interactions when the submition process is active

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
          .post(Contract(_player!, _club!, _number!, _position!, _period!, _document!))
          .then((value) {
        widget.onComplete?.call();
        Navigator.of(context).pop();
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    print('ContractAdd/V: Initialized State!');
    _club = widget.club;
    _player = widget.player;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('ContractAdd/V: Building...');
    return Container(
      margin: const EdgeInsets.all(16),
      child: Center(
        child: Card(
          child: Consumer3<PlayerProvider, ClubProvider, ContractProvider>(
            builder: (context, playerProvider, clubProvider, contractProvider, child) {
              if (contractProvider.state == ProviderState.ready) {
                // A form is used to validate data before submitting, the form validates the following:
                // - All fields must be populated
                // - A player can't have more than 1 active contract
                // - Shirt numbers must be unique within a club
                // - A contract can't be more than 5 years
                return Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeaderWidget(
                          headerText: 'Novo Contrato',
                          child: Column(
                            children: [
                              // ############# Club #############
                              DropdownButtonFormField<int>(
                                decoration: const InputDecoration(
                                  labelText: 'Clube',
                                  border: OutlineInputBorder(),
                                ),
                                isExpanded: true,
                                value: _club?.id,
                                onChanged: widget.club == null
                                    ? (int? value) => setState(() {
                                          _club = clubProvider.items.values.singleWhere((element) => element.id == value);
                                        })
                                    : null,
                                // The validator checks if the field is null or empty
                                validator: (value) => value == null ? 'Campo necessário' : null,
                                // New contracts can only be made by currently playing clubs
                                items: clubProvider.items.values
                                    .where((element) => element.playing)
                                    .map<DropdownMenuItem<int>>((Club value) {
                                  return DropdownMenuItem<int>(
                                    value: value.id,
                                    child: Row(
                                      children: [
                                        FutureImage(
                                          image: value.picture!,
                                          errorImageUri: 'assets/images/placeholder-club.png',
                                          height: 32,
                                          aspectRatio: 1 / 1,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(value.name, overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                              // ############# Player #############
                              DropdownButtonFormField<int>(
                                decoration: const InputDecoration(
                                  labelText: 'Jogador',
                                  border: OutlineInputBorder(),
                                ),
                                isExpanded: true,
                                value: _player?.id,
                                onChanged: widget.player == null
                                    ? (int? value) => setState(() {
                                          _player =
                                              playerProvider.items.values.singleWhere((element) => element.id == value);
                                        })
                                    : null,
                                validator: (value) => value == null ? 'Campo necessário' : null,
                                items: playerProvider.items.values.map<DropdownMenuItem<int>>((Player value) {
                                  return DropdownMenuItem<int>(
                                    value: value.id,
                                    child: Row(
                                      children: [
                                        FutureImage(
                                          image: value.picture!,
                                          errorImageUri: 'assets/images/placeholder-player.png',
                                          height: 32,
                                          aspectRatio: 1 / 1,
                                          borderRadius: BorderRadius.circular(100),
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(value.name, overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ############# Position #############
                                  Expanded(
                                    child: DropdownButtonFormField<Position>(
                                      decoration: const InputDecoration(
                                        labelText: 'Posição',
                                        border: OutlineInputBorder(),
                                      ),
                                      isExpanded: true,
                                      value: _position,
                                      onChanged: (Position? value) => setState(() => _position = value),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (value) => value == null ? 'Campo necessário' : null,
                                      items: Position.values.map<DropdownMenuItem<Position>>((Position value) {
                                        return DropdownMenuItem<Position>(
                                          value: value,
                                          child: Text(value.name),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // ############# Shirt Number #############
                                  Expanded(
                                    child: TextFormField(
                                      enabled: !isLoading,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      // The validator first checks if the field is null or empty
                                      // Then checks if there are any active contracts using the same shirt number
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Campo necessário';
                                        } else if (contractProvider.items.values
                                            .where((element) => element.club.id == _club!.id && element.active)
                                            .any((element) => element.number == _number)) {
                                          return 'Número em uso pelo clube.';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        labelText: 'Número da Camisola',
                                        border: OutlineInputBorder(),
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
                              const SizedBox(height: 16),
                              // ############# Period #############
                              TextFormField(
                                controller: dateFieldController,
                                readOnly: true,
                                enabled: !isLoading,
                                decoration: InputDecoration(
                                  labelText: 'Período do Contrato',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      _period = null;
                                      dateFieldController.text = '';
                                    },
                                    icon: const Icon(Icons.clear),
                                  ),
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  // The validator first checks if the field is null or empty
                                  // Then checks if the contract period is longer than 5 years
                                  // Finally checks to see if the new contract is starting while the player
                                  // already has another contract active
                                  if (value == null || value.isEmpty) {
                                    return 'Campo necessário';
                                  } else if (_period!.end.difference(_period!.start).compareTo(
                                          DateUtils.addMonthsToMonthDate(_period!.start, 60).difference(_period!.start)) ==
                                      1) {
                                    return 'Contratos têm duração máxima de 5 anos';
                                  } else if (contractProvider.items.values.any((element) =>
                                      element.player.id == _player!.id && _period!.start.isBefore(element.period.end))) {
                                    return 'Jogador atualmente contratado neste periodo';
                                  } else {
                                    return null;
                                  }
                                },
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  final DateTimeRange? result = await showDateRangePicker(
                                    context: context,
                                    locale: const Locale('pt', 'PT'),
                                    initialEntryMode: DatePickerEntryMode.input,
                                    initialDateRange: _period,
                                    // Only dates after the player has turned 18
                                    firstDate: widget.player != null
                                        ? DateUtils.addMonthsToMonthDate(widget.player!.birthday, 216)
                                        : DateTime(1970, 1, 1),
                                    lastDate: DateTime(2100, 1, 1),
                                    currentDate: DateTime.now(),
                                  );
                                  if (result != null) {
                                    setState(() {
                                      _period = result;
                                      dateFieldController.text =
                                          '${DateFormat.yMMMd('pt_PT').format(_period!.start)} - ${DateFormat.yMMMd('pt_PT').format(_period!.end)}';
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              // ############# Document #############
                              TextFormField(
                                enabled: !isLoading,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                // The validator checks if the field is null or empty
                                validator: (value) => value == null || value.isEmpty ? 'Campo necessário' : null,
                                decoration: const InputDecoration(
                                  labelText: 'Número de Identificação',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (String? value) {
                                  if (value != null) {
                                    _document = {'nif': int.tryParse(value)};
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                              child: const Text('Cancelar'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) _submitData();
                                    },
                              child: isLoading ? const CircularProgressIndicator() : const Text('Criar Contrato'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
