import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/exam_model.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/provider/exam_provider.dart';
import 'package:tg2/utils/exceptions.dart';

import '../../provider/player_provider.dart';
import 'package:tg2/views/widgets/header.dart';
import '../../utils/constants.dart';

// Widget used to manage a player's exam data
// It automatically populates all fields if an exam object is provided
// Depending on the existence of a non-null id, it knows when to either post or update the database.
class ExamModifyView extends StatefulWidget {
  const ExamModifyView({super.key, this.exam, required this.player, this.onComplete});

  final Exam? exam; // Default widget data
  final Player player; // Player information
  final VoidCallback? onComplete; // Player information

  @override
  State<ExamModifyView> createState() => _ExamModifyViewState();
}

class _ExamModifyViewState extends State<ExamModifyView> {
  final GlobalKey<FormState> _examFormKey = GlobalKey<FormState>();
  TextEditingController dateFieldController = TextEditingController();
  String? errorText;
  bool isLoading = false;

  DateTime? date;
  bool result = false;

  // Method to submit data onto the provider
  // If the exam object contains a non null id, it executes the PATCH method, or POST otherwise.
  Future _submitData() async {
    try {
      setState(() => isLoading = true);
      if (widget.exam!.id == null) {
        await Provider.of<ExamProvider>(context, listen: false)
            .post(Exam(widget.player, date!, result))
            .then((value) => Navigator.of(context).pop());
      } else {
        Exam exam = widget.exam!;
        exam
          ..date = date!
          ..result = result;
        await Provider.of<ExamProvider>(context, listen: false).patch(exam).then((value) => Navigator.of(context).pop());
      }
      widget.onComplete?.call();
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    // Check if default object exists
    if (widget.exam != null) {
      date = widget.exam!.date;
      result = widget.exam!.result;
      dateFieldController.text = DateFormat.yMd('pt_PT').format(date!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Center(
        child: Card(
          child: Consumer2<PlayerProvider, ExamProvider>(
            builder: (context, playerProvider, examProvider, child) {
              if (examProvider.state == ProviderState.ready) {
                return Form(
                  key: _examFormKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeaderWidget(
                          headerText: widget.exam == null ? 'Novo Exame' : 'Modificar Exame ${widget.exam!.id}',
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ############# Club #############
                                Expanded(
                                  child: CheckboxListTile(
                                    title: const Text("Passou?"),
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: Theme.of(context).colorScheme.secondary,
                                    value: result,
                                    enabled: !isLoading,
                                    onChanged: (bool? value) => setState(() => result = value!),
                                    controlAffinity: ListTileControlAffinity.leading,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: dateFieldController,
                                    readOnly: true,
                                    enabled: !isLoading,
                                    decoration: const InputDecoration(
                                      labelText: 'Data do Exame',
                                      border: OutlineInputBorder(),
                                    ),
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      List<Exam> _exams = examProvider.items.values
                                          .where((element) => element.player.id == widget.player.id)
                                          .toList();
                                      // The validator first checks if the field is null or empty
                                      // Then if a initial exam was provided, it checks if theres other (not including its own)
                                      // with the same date
                                      // If it's a new exam, only check for exams of the same date
                                      if (value == null || value.isEmpty) {
                                        return 'Campo necessário';
                                        // Checks an exam done by the player in the same date
                                      }
                                      if (widget.exam != null &&
                                          _exams.any((element) =>
                                              element.date.isAtSameMomentAs(date!) && element.id != widget.exam!.id)) {
                                        return 'Existe exame nesta data';
                                      } else if (widget.exam == null &&
                                          _exams.any((element) => element.date.isAtSameMomentAs(date!))) {
                                        return 'Existe exame nesta data';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onTap: () async {
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      final DateTime? result = await showDatePicker(
                                        context: context,
                                        locale: const Locale('pt', 'PT'),
                                        initialEntryMode: DatePickerEntryMode.calendar,
                                        initialDate: date ?? DateTime.now(),
                                        // Only dates after the player is 18.
                                        firstDate: DateUtils.addMonthsToMonthDate(widget.player.birthday, 216),
                                        lastDate: DateTime.now(),
                                      );
                                      if (result != null) {
                                        setState(() {
                                          date = result;
                                          dateFieldController.text = DateFormat.yMMMd('pt_PT').format(date!);
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
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
                                      if (_examFormKey.currentState!.validate()) {
                                        try {
                                          setState(() => isLoading = true);
                                          if (widget.exam == null) {
                                            examProvider.post(Exam(widget.player, date!, result)).then((value) {
                                              widget.onComplete?.call();
                                              Navigator.of(context).pop();
                                            });
                                          } else {
                                            Exam exam = widget.exam!;
                                            exam
                                              ..date = date!
                                              ..result = result;
                                            examProvider.patch(exam).then((value) {
                                              widget.onComplete?.call();
                                              Navigator.of(context).pop();
                                            });
                                          }
                                        } finally {
                                          setState(() => isLoading = false);
                                        }
                                      }
                                    },
                              child: isLoading ? const CircularProgressIndicator() : const Text('Criar Exame'),
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
    /*
    return AlertDialog(
      title: widget.exam == null ? const Text('Novo Exame') : Text('Modificar Exame ${exam.id}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: CheckboxListTile(
              title: const Text("Passou?"),
              contentPadding: EdgeInsets.zero,
              activeColor: Theme.of(context).colorScheme.secondary,
              value: exam.result,
              enabled: !isLoading,
              onChanged: (bool? value) => setState(() => exam.result = value!),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          Flexible(
            child: TextFormField(
              controller: dateFieldController,
              readOnly: true,
              enabled: !isLoading,
              decoration: InputDecoration(
                labelText: "Data",
                errorText: errorText,
                border: const OutlineInputBorder(),
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? result = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (result != null) {
                  setState(() {
                    errorText = null;
                    exam.date = result;
                    dateFieldController.text = DateFormat.yMd('pt_PT').format(exam.date);
                  });
                }
              },
            ),
          ),
        ],
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
    */
  }
}
