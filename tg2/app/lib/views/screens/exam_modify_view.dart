import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/exam_model.dart';
import 'package:tg2/models/player_model.dart';
import 'package:tg2/provider/exam_provider.dart';
import 'package:tg2/utils/dateutils.dart';
import 'package:tg2/utils/exceptions.dart';

// Widget used to manage a player's exam data
// It automatically populates all fields if an exam object is provided
// Depending on the existence of a non-null id, it knows when to either post or update the database.
class ExamModifyView extends StatefulWidget {
  const ExamModifyView({super.key, this.initialValue, required this.player});

  final Exam? initialValue; // Default widget data
  final Player player; // Player information

  @override
  State<ExamModifyView> createState() => _ExamModifyViewState();
}

class _ExamModifyViewState extends State<ExamModifyView> {
  TextEditingController dateFieldController = TextEditingController();
  String? errorText;
  bool isLoading = false;

  Exam exam = Exam.empty();

  // Method to submit data onto the provider
  // If the exam object contains a non null id, it executes the PATCH method, or POST otherwise.
  Future<void> _submitData() async {
    if (dateFieldController.text.isEmpty) {
      setState(() => errorText = "Campo necessário!");
      return;
    }
    try {
      setState(() => isLoading = true);
      if (exam.id == null) {
        await Provider.of<ExamProvider>(context, listen: false)
            .post(exam)
            .then((value) => Navigator.of(context).pop());
      } else {
        await Provider.of<ExamProvider>(context, listen: false)
            .patch(exam)
            .then((value) => Navigator.of(context).pop());
      }
    } on DuplicateException {
      setState(() => errorText = "Jogador já fez exame nesta data.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    // Check if default object exists
    if (widget.initialValue == null) {
      exam.result = false;
    } else {
      exam = widget.initialValue!;
      dateFieldController.text = DateUtilities().toYMD(exam.date);
    }
    exam.player = widget.player;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.initialValue == null
          ? const Text('Novo Exame')
          : Text('Modificar Exame ${exam.id}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: CheckboxListTile(
              title: const Text("Passou?"),
              contentPadding: EdgeInsets.zero,
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
                    dateFieldController.text = DateUtilities().toYMD(exam.date);
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
  }
}
