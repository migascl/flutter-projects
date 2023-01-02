// Library Imports
import 'package:flutter/material.dart';
import '../../models/exam_model.dart';

class ExamModifyView extends StatefulWidget {
  const ExamModifyView({super.key, this.exam});

  final Exam? exam;

  @override
  State<ExamModifyView> createState() => _ExamModifyViewState();
}

class _ExamModifyViewState extends State<ExamModifyView> {

  late int _playerID;
  late DateTime _date;
  late bool _result;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: (widget.exam == null) ? Text("Adicionar Exame") : Text("Modificar Exame ${widget.exam!.id}")),
      body: Container(),
    );
  }
}