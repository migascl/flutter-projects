// Libraries
import 'dart:io';
import 'list.dart';

// Menu console
void menu(list) {
  stdout.writeln("\n-----------------------------------------------------------------------------------------------------------");
  stdout.writeln("Conjunto: $list");
  stdout.writeln("Menu:");
  stdout.writeln("\t1. Maior e menor elemento do conjunto.");
  stdout.writeln("\t2. Amplitude do conjunto.");
  stdout.writeln("\t3. Listagem dos números impares em ordem decrescente.");
  stdout.write("Escreva o número da opção desejada: ");
  // Receives input from the user, and catches any type error
  try {
    int? option = int.parse(stdin.readLineSync()!);
    switch(option) {
      case 1:
        stdout.writeln("\nMaior e menor elemento:");
        Map<String, int> result = getMinMax(list);
        stdout.writeln("\tMenor: ${result['min']}");
        stdout.writeln("\tMaior: ${result['max']}");
        break;
      case 2:
        stdout.writeln("\nAmplitude do conjunto: ${getRange(list)}");
        break;
      case 3:
        stdout.writeln("\nLista dos números ímpares em ordem decrescente:");
        print(getOdds(list));
        break;
      default:
        stdout.writeln("Opção inválida!");
    }
  } catch (e) {
    stdout.writeln("Opção inválida!");
  }
  // User prompt to go back to menu
  stdout.write("\nPrima Enter para voltar ao menu.");
  stdin.readLineSync();
  menu(list);
}
