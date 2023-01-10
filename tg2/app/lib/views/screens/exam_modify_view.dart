import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tg2/provider/exam_provider.dart';
import '../../models/exam_model.dart';
import '../../models/player_model.dart';

class ExamModifyView extends StatefulWidget {
  const ExamModifyView({super.key, this.exam, required this.player});

  final Exam? exam;
  final Player player;

  @override
  State<ExamModifyView> createState() => _ExamModifyViewState();
}

class _ExamModifyViewState extends State<ExamModifyView> {

  TextEditingController dateFieldController = TextEditingController();

  Exam exam = Exam.empty();

  @override
  void initState() {
    if(widget.exam == null) {
      exam.result = false;
      dateFieldController.text = "Clicar para Editar";
    } else {
      exam = widget.exam!;
      dateFieldController.text = "${exam.date.year}-${exam.date.month}-${exam.date.day}";
    }
    exam.player = widget.player;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.exam == null ? const Text('Novo Exame') : const Text('Modificar Exame'),
      content: Wrap(
        children: [
          CheckboxListTile(
            title: Text("Passou?"),
            value: exam.result,
            onChanged: (bool? value) => setState(() => exam.result = value!),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          TextFormField(
            controller: dateFieldController,
            decoration: const InputDecoration(
              labelText: "Data",
              border: OutlineInputBorder()
            ),
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              DateTime? result = await showDatePicker(
                context: context,
                initialDate:DateTime.now(),
                firstDate:DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (result != null) {
                setState(() {
                  exam.date = result;
                  dateFieldController.text = "${exam.date.year}-${exam.date.month}-${exam.date.day}";
                });
              }
            }
          )
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
          child: const Text('Guardar'),
          onPressed: () {
            if(exam.id == null) {
              Provider.of<ExamProvider>(context, listen: false).post(exam).then((value) => Navigator.of(context).pop());
            } else {
              Provider.of<ExamProvider>(context, listen: false).patch(exam).then((value) => Navigator.of(context).pop());
            }
          },
        ),
      ],
    );
  }
}