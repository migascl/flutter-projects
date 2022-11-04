// Libraries
import 'dart:io';
import 'list.dart';

// Menu console
void menu(list) {
  print("----------------------------------------------------");
  print("Conjunto: $list");
  print("Menu:");
  print("\t1. Maior e menor elemento do conjunto.");
  print("\t2. Amplitude do conjunto.");
  print("\t3. Listagem dos números impares em ordem decrescente.");
  print("Escreva o número da opção desejada: ");
  // Receives input from the user, and catches any type error
  try {
    int? option = int.parse(stdin.readLineSync()!);
    switch(option) {
      case 1:
        print("\nMaior e menor elemento:");
        Map<String, int> result = getMinMax(list);
        print("\tMenor: ${result['min']}");
        print("\tMaior: ${result['max']}");
        break;
      case 2:
        print("\nAmplitude do conjunto: ${getRange(list)}");
        break;
      case 3:
        print("\nLista dos números ímpares em ordem decrescente:");
        print(getOdds(list));
        break;
      default:
        print("Opção inválida!");
    }
  } catch (e) {
    print("Opção inválida!");
  }
  // User prompt to go back to menu
  print("\nPrima Enter para voltar ao menu.");
  stdin.readLineSync();
  menu(list);
}
