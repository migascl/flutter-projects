void main(List<String> arguments) {
  // Variables
  int start = 100;
  int finish = 200;

  print('Intervalo: ]$start, $finish[');
  var sum = 0;
  // Loop that runs through the entire interval adding every prime number to sum
  for (var i = start; i <= finish; i++) {
    if(isPrime(i)) sum += i;
  }
  print('Soma: $sum');
  // Calculate average of prime numbers by dividing the sum with the number of elements of the interval
  var avg = sum / (finish - start);
  print('Média: $avg');
}

// Algorithm to determine if a number is prime or not
bool isPrime(int num){
  // Initialize loop with i starting in 2, incrementing by 1, until num/i is greater than i
  for (var i = 2; i <= num / i; ++i) {
    // If i is a factor of num, num is not prime, returning false.
    if (num % i == 0) {
      return false;
    }
  }
  return true;
}
