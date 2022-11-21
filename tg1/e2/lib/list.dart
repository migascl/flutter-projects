// Libraries
import 'dart:math';

List<int> generateList() {
  // Initialize the interval of possible lengths of the list
  int intervalStart = 90;
  int intervalFinish = 150;
  // Calculate the length of the list
  // Since Random() can't generate a random value within a given range,
  // it's calculated within the range of number of elements in the list (intervalFinish - intervalStart)
  // and added the base length afterwards (intervalStart)
  int length = intervalStart + Random().nextInt(intervalFinish - intervalStart);
  List<int> list = List<int>.filled(length, 0); // Initialize final list with the length calculated above with no values
  // Fill the list with random numbers from 0 to 500
  for (var i = 0; i < list.length; i++) {
    list[i] = Random().nextInt(500);
  }
  return list; // Return list
}

// Creates a map with the keys of the maximum and minimum value of the list
Map<String, int> getMinMax(List<int> list) {
  List<int> output = List<int>.from(list); // Create mutable copy of the input
  output.sort(); // Sort the list in ascending order to determine highest and lowest value
  // Return the minimum and maximum number in the list into a Map
  return {
    'min' : output.first,
    'max': output.last
  };
}

// Calculate the range of the list by subtracting the
int getRange(List<int> list) {
  List<int> tempList = List<int>.from(list); // Create mutable copy of the input
  Map<String, int> output = getMinMax(tempList); // Get Minimum and Max values of the list
  return output['max']! - output['min']!;
}

// Sort the list in descending order and return all odd numbers
List<int> getOdds(List<int> list) {
  List<int> output = List<int>.from(list); // Create mutable copy of the input
  output.sort((b, a) => a.compareTo(b)); // Order list in descending order
  // Run through entire list, verify if each element is even and remove them from the list
  for(var i = 0; i < output.length; i++){
    if(output[i] % 2 == 0) {
      output.removeAt(i);
    }
  }
  return output;
}
