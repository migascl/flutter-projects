import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/models/exam_model.dart';

import '../../models/player_model.dart';
import '../../provider/exam_provider.dart';
import '../../utils/dateutils.dart';
import '../../utils/exceptions.dart';

class ExamModifyView extends StatefulWidget {
  const ExamModifyView({super.key, this.initialValue, required this.player});

  final Exam? initialValue;
  final Player player;

  @override
  State<ExamModifyView> createState() => _ExamModifyViewState();
}

class _ExamModifyViewState extends State<ExamModifyView> {
  TextEditingController dateFieldController = TextEditingController();
  String? errorText;

  Exam exam = Exam.empty();

  Future<void> _insertData() async {
    if (dateFieldController.text.isEmpty) {
      setState(() => errorText = "Campo necessário!");
      return;
    }
    // If exam id is null, it means we're adding a new exam, updating otherwise.
    try {
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
    }
  }

  @override
  void initState() {
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
              onChanged: (bool? value) => setState(() => exam.result = value!),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          Flexible(
            child: TextFormField(
              controller: dateFieldController,
              readOnly: true,
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
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
            child: const Text('Guardar'), onPressed: () => _insertData()),
      ],
    );
  }
}
