// Imports
import 'dart:io';
import 'package:e3/models/policy.dart';
import 'package:e3/pages/manager/manager.dart';
import 'package:e3/pages/reports.dart';
import 'dashboard.dart';

void menu(){
  while(true) {
    dashboard();
    stdout.writeln("MENU");
    stdout.writeln("\t1. Dados");
    if(Policy.cache.isNotEmpty) stdout.writeln("\t2. Relatórios");
    stdout.writeln("\t3. Sair");
    stdout.write("Insira o digito da opção desejada: ");
    try {
      String? option = stdin.readLineSync();
      switch(option) {
        case '1':
          manager();
          break;
        case '2':
          if(Policy.cache.isNotEmpty) reports();
          break;
        case '3':
          return;
        default:
          stdout.writeln("Opção inválida!");
      }
    } catch (e) {
      stdout.writeln("Opção inválida!");
    }
  } // Recursion until correct option
}
