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
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:tg2/views/widgets/header.dart';

import '../../utils/api/api_service.dart';

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
  TextEditingController shirtnumberFieldController = TextEditingController();
  TextEditingController dateFieldController = TextEditingController();
  TextEditingController fileFieldController = TextEditingController();
  bool isLoading = false; // Flag used to disable all interactions when the submition process is active

  Player? player;
  Club? club;
  int? shirtnumber;
  Position? position;
  DateTimeRange? period;
  PlatformFile? passportFile;

  // Method to submit data onto the provider
  // If the exam object contains a non null id, it executes the PATCH method, or POST otherwise.
  Future submitData() async {}

  @override
  void initState() {
    print('ContractAdd/V: Initialized State!');
    club = widget.club;
    player = widget.player;
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
              return Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeaderWidget(
                          headerText: 'Novo Contrato',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // CLUB
                              DropdownButtonFormField<int>(
                                decoration: const InputDecoration(
                                  labelText: 'Clube',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                isExpanded: true,
                                value: club?.id,
                                onChanged: widget.club == null
                                    ? (int? value) => setState(() {
                                          club = clubProvider.data.values.singleWhere((element) => element.id == value);
                                        })
                                    : null,
                                // The validator checks if the field is null or empty
                                validator: (value) => value == null ? 'Campo necessário' : null,
                                // New contracts can only be made by currently playing clubs
                                items: clubProvider.data.values.map<DropdownMenuItem<int>>((Club value) {
                                  return DropdownMenuItem<int>(
                                    value: value.id,
                                    child: Row(
                                      children: [
                                        FutureImage(
                                          image: value.logo,
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
                              // PLAYER
                              DropdownButtonFormField<int>(
                                decoration: const InputDecoration(
                                  labelText: 'Jogador',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                isExpanded: true,
                                value: player?.id,
                                onChanged: widget.player == null
                                    ? (int? value) => setState(() {
                                          player = playerProvider.data.values.singleWhere((element) => element.id == value);
                                        })
                                    : null,
                                validator: (value) => value == null ? 'Campo necessário' : null,
                                items: playerProvider.data.values.map<DropdownMenuItem<int>>((Player value) {
                                  return DropdownMenuItem<int>(
                                    value: value.id,
                                    child: Row(
                                      children: [
                                        FutureImage(
                                          image: value.picture,
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
                                  // POSITION
                                  Expanded(
                                    child: DropdownButtonFormField<Position>(
                                      decoration: const InputDecoration(
                                        labelText: 'Posição',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                      isExpanded: true,
                                      value: position,
                                      onChanged: (Position? value) => setState(() => position = value),
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
                                  // SHIRT NUMBER
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
                                        } else if (contractProvider.data.values
                                            .where((element) => element.club.id == club!.id && element.active)
                                            .any((element) => element.shirtNumber == shirtnumber)) {
                                          return 'Número em uso pelo clube.';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        labelText: 'Número da Camisola',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                      onChanged: (String? value) {
                                        if (value != null) {
                                          shirtnumber = int.tryParse(value);
                                          shirtnumberFieldController.text = shirtnumber.toString();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // PERIOD
                              TextFormField(
                                controller: dateFieldController,
                                readOnly: true,
                                enabled: !isLoading,
                                decoration: InputDecoration(
                                  labelText: 'Período do Contrato',
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      period = null;
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
                                  } else if (period!.end.difference(period!.start).compareTo(
                                          DateUtils.addMonthsToMonthDate(period!.start, 60).difference(period!.start)) ==
                                      1) {
                                    return 'Contratos têm duração máxima de 5 anos';
                                  } else if (contractProvider.data.values.any((element) =>
                                      element.player.id == player!.id && period!.start.isBefore(element.period.end))) {
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
                                    initialDateRange: period,
                                    // Only dates after the player has turned 18
                                    firstDate: widget.player != null
                                        ? DateUtils.addMonthsToMonthDate(widget.player!.birthday, 216)
                                        : DateTime(1970, 1, 1),
                                    lastDate: DateTime(2100, 1, 1),
                                    currentDate: DateTime.now(),
                                  );
                                  if (result != null) {
                                    setState(() {
                                      period = result;
                                      dateFieldController.text =
                                          '${DateFormat.yMMMd('pt_PT').format(period!.start)} - ${DateFormat.yMMMd('pt_PT').format(period!.end)}';
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              // DOCUMENT
                              // It gets the local file path of a picture
                              TextFormField(
                                controller: fileFieldController,
                                readOnly: true,
                                enabled: !isLoading,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  labelText: 'Passaporte',
                                  helperText: 'Tamanho máx: ~10MB',
                                  suffixIcon: IconButton(
                                    color: Theme.of(context).colorScheme.primary,
                                    tooltip: 'Carregar foto',
                                    onPressed: () async {
                                      var result = await FilePicker.platform.pickFiles();
                                      if (result != null) {
                                        setState(() {
                                          passportFile = result.files.first;
                                          fileFieldController.text = passportFile!.name;
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.upload),
                                  ),
                                ),
                                validator: (value) {
                                  if (passportFile == null) {
                                    return 'É necessário fornecer um passaporte';
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
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => isLoading = true);
                                        try {
                                          await contractProvider
                                              .post(
                                                  Contract(player!, club!, shirtnumber!, position!, period!,
                                                      '${DateTime.now().microsecondsSinceEpoch}.png'),
                                                  passportFile!)
                                              .then((value) {
                                            widget.onComplete?.call();
                                            Navigator.of(context).pop();
                                          });
                                        } finally {
                                          setState(() => isLoading = false);
                                        }
                                      }
                                    },
                              child: isLoading ? const CircularProgressIndicator() : const Text('Criar Contrato'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
