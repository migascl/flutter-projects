// Imports
import 'dart:io';
import 'package:e3/models/insurer.dart';
import '../../models/entity.dart';
import '../../models/policy.dart';
import 'list.dart';
import 'add.dart';

// Data managing page, here the user chooses what data it wants to view or add
void manager(){
  stdout.writeln("\nDados");
  stdout.writeln("\t1. Entidades");
  stdout.writeln("\t2. Seguradoras");
  stdout.writeln("\t3. Apólices");
  stdout.write("Insira o digito da opção desejada: ");
  try {
    String? option = stdin.readLineSync();
    switch(option) {
      case '1':
        action(Entity);
        return;
      case '2':
        action(Insurer);
        return;
      case '3':
        action(Policy);
        return;
      case '':
        return;
      default:
        stdout.writeln("Opção inválida!");
    }
  } catch (e) {
    stdout.writeln("Opção inválida!");
  }
  manager();
}

void action(Type type){
  stdout.write("Listar (l) ou Adicionar (a):");
  try {
    String? action = stdin.readLineSync();
    switch(action) {
      case 'l':
        list(type);
        return;
      case 'a':
        add(type);
        return;
      case '':
        manager();
        return;
      default:
        stdout.writeln("Opção inválida!");
    }
  } catch (e) {
    stdout.writeln("Opção inválida!");
  }
  action(type);
}
