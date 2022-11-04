// Libraries
import 'dart:math';

List<int> generateList() {
  // Initialize the interval of possible lengths of the list
  var intervalStart = 90;
  var intervalFinish = 150;
  // Calculate the length of the list
  // Since Random() can't generate a random value within a given range,
  // it's calculated within the range of number of elements in the list (intervalFinish - intervalStart)
  // and added the base length afterwards (intervalStart)
  var length = intervalStart + Random().nextInt(intervalFinish - intervalStart);
  var list = List<int>.filled(length, 0); // Initialize final list with the length calculated above with no values
  // Fill the list with random numbers from 0 to 500
  for (var i = 0; i < list.length; i++) {
    list[i] = Random().nextInt(500);
  }
  return list; // Return list
}
