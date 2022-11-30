void main(List<String> arguments) {
  // Variables
  const int start = 100;
  const int finish = 200;
  int sum = 0; // Sum of all prime numbers
  double avg = 0; // Average of prime numbers
  final list = <int>[]; // List of numbers

  // Fill list with whole numbers not including the start and finish values
  for (var i = start; i <= finish; i++) {
    if(i >= start && i <= finish) list.add(i);
  }

  print('Intervalo: ]$start, $finish[');
  // Loop that runs through the entire interval adding every prime number to sum
  list.forEach((element) {
    if(isPrime(element)) sum += element;
  });

  print('Soma: $sum');
  // Calculate average of prime numbers by dividing the sum with the number of elements of the interval
  avg = sum / (finish - start);
  print('Média: $avg');
}

// Algorithm to determine if a number is prime or not
bool isPrime(int num){
  if(num <= 1) return false; // Prime numbers have to be greater than 1
  // Initialize loop with i starting in 2, incrementing by 1, until num/i is greater than i
  for (var i = 2; i <= num / i; ++i) {
    // If i is a factor of num, num is not prime, returning false.
    if (num % i == 0) {
      return false;
    }
  }
  return true;
}
