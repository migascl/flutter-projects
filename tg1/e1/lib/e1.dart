void calculate(int start, int finish) {
  print('Intervalo: ]$start, $finish[');
  // Loop that runs through the entire interval checking if current number (i) its a prime number and add it to sum
  var sum = 0;
  for(var i = start; i <= finish; i++) {
    if(i % 2 == 1){
      sum += i;
    }
  }
  print('Soma: $sum');
  // Calculate average of prime numbers by dividing the sum with the number of elements of the interval
  var avg = sum / (finish - start);
  print('Média: $avg');
}
