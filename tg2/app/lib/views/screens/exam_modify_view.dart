import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/exam_model.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/provider/exam_provider.dart';
import 'package:tg2/provider/player_provider.dart';
import 'package:tg2/views/widgets/header.dart';

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
  final GlobalKey<FormState> examFormKey = GlobalKey<FormState>();
  TextEditingController dateFieldController = TextEditingController();
  String? errorText;
  bool isLoading = false;

  DateTime? date;
  bool result = false;

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
              return Form(
                key: examFormKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HeaderWidget(
                        headerText: widget.exam == null ? 'Novo Exame' : 'Modificar Exame ${widget.exam!.id}',
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // RESULT
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
                            // DATE
                            Expanded(
                              child: TextFormField(
                                controller: dateFieldController,
                                readOnly: true,
                                enabled: !isLoading,
                                decoration: const InputDecoration(
                                  labelText: 'Data do Exame',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  List<Exam> exams = examProvider.data.values
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
                                      exams.any((element) =>
                                          element.date.isAtSameMomentAs(date!) && element.id != widget.exam!.id)) {
                                    return 'Existe exame nesta data';
                                  } else if (widget.exam == null &&
                                      exams.any((element) => element.date.isAtSameMomentAs(date!))) {
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
                                    if (examFormKey.currentState!.validate()) {
                                      try {
                                        setState(() => isLoading = true);
                                        if (widget.exam == null) {
                                          await examProvider.post(Exam(widget.player, date!, result)).then((value) {
                                            widget.onComplete?.call();
                                            Navigator.of(context).pop();
                                          });
                                        } else {
                                          Exam exam = widget.exam!;
                                          exam
                                            ..date = date!
                                            ..result = result;
                                          await examProvider.patch(exam).then((value) {
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
            },
          ),
        ),
      ),
    );
  }
}
