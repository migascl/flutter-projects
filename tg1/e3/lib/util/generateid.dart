// ID generator method
// Generates an unique number identifier
// based on the sum of all the element's hashcodes in a list
// When detecting a string, it performs various operations with the intent
// to normalize its contents.

int generateID(List<dynamic> list){
  int result = 0;

  // List of letters with diacritics and without
  var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
  var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

  // Iterate through every element in the list
  list.forEach((e) {
    if(e.runtimeType == String){
      String str = e;
      // Iterate through every possible diacritic
      // and replace it with a non-diacritic in the string
      for(int i = 0; i < withDia.length; i++){
        str = str.replaceAll(withDia[i], withoutDia[i]);
      }
      // Remove all special spaces
      str = str.replaceAll(new RegExp(r'[^\w\s]+'),'');
      // Remove all white spaces
      str = str.replaceAll(' ', '');
      // Turn into lowercase
      str = str.toLowerCase();

      result += str.hashCode;
    } else {
      result += e.hashCode;
    }
  });
  return result;
}
