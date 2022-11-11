// Imports
import 'dart:io';
import 'package:e3/pages/manager/manager.dart';
import 'package:e3/pages/reports.dart';
import 'dashboard.dart';

void menu(){
  dashboard();
  stdout.writeln("MENU");
  stdout.writeln("\t1. Relatórios");
  stdout.writeln("\t2. Dados");
  stdout.write("Insira o digito da opção desejada: ");
  try {
    String? option = stdin.readLineSync();
    switch(option) {
      case '1':
        reports();
        break;
      case '2':
        manager();
        break;
      default:
        stdout.writeln("Opção inválida!");
    }
  } catch (e) {
    stdout.writeln("Opção inválida!");
  }
  menu(); // Recursion until correct option
}
