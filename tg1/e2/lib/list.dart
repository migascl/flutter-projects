// Libraries
import 'dart:math';

class MyList {
  // Variables
  static const int _start = 90; // Minimum size of the list
  static const int _finish = 150; // Maximum size of the list
  final List<int> _list;

  // Factory constructor
  factory MyList() {
    // Calculate the length of the list
    // Since Random() can't generate a random value within a given range,
    // it's calculated within the range of number of elements in the list (intervalFinish - intervalStart)
    // and added the base length afterwards (intervalStart)
    int length = _start + Random().nextInt(_finish - _start);
    List<int> tempList = List<int>.filled(length, 0); // Initialize final list with the length calculated above with no values
    // Fill the list with random numbers from 0 to 500
    for (var i = 0; i < tempList.length; i++) {
      tempList[i] = Random().nextInt(999);
    }
    tempList.sort(); // Sort in ascending order
    return MyList._internal(tempList);
  }
  MyList._internal(this._list);

  // Getters
  List<int> get list => _list;
  int get max => _list.last; // Max value of the list
  int get min => _list.first; // Min value of the list
  int get size => _list.length; // Size of the list
  int get range => (max - min); // Range of the list

  // Sort the list in descending order and return all odd numbers
  List<int> oddsInDescOrder(){
    List<int> output = List<int>.from(_list); // Create mutable copy of the input
    output.sort((b, a) => a.compareTo(b)); // Order list in descending order
    output.removeWhere((element) => element.isEven); // Remove every even number from the list
    return output;
  }

  @override
  String toString() {
    return _list.toString();
  }
}
