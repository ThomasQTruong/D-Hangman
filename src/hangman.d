module src.hangman;

import std.file;
import std.stdio;
import std.string;
import std.random;
import std.array;
import std.algorithm;


// File that contains the list of texts to guess.
string TEXT_LIST = "../words.txt";


void main() {
  // Seed the random number generator.
  auto RNG = Random(unpredictableSeed);

  // Extract the texts from the file into an array.
  string fileContent = readText(TEXT_LIST);
  string[] texts = fileContent.splitLines();  // [DEMO] Simple reading into an array.

  writeln("Welcome to Hangman!");

  bool done = false;
  do {
    // Randomly select a text.
    string text = choice(texts, RNG);  // [DEMO] Easily choose random from array.

    // [DEMO] Strings are immutable so we use char[] instead.
    char[] displayText = generateDisplay(text);
    
    int guessCount = 0;
    bool gameEnded = false;
    do {
      // [DEMO] This is one way to print and is very simple.
      writeln("Text: ");
      // [DEMO] This is a second way to print.
      displayText.writeln;

      // Ask user to guess.
      writeln("Enter the letter you want to guess.");
      write("Guess: ");
      char guess = readln()[0];
      writeln();
    } while (!gameEnded);
  } while(!done);
}


char[] generateDisplay(string text) {
  char[] displayText = new char[text.length];

  // Can use for each instead of a traditional for loop.
  foreach (i; 0 .. text.length) {
    switch (text[i]) {
      // Cases where we would want to keep the same characters.
      case ' ':
      case '/':
      case '-':
      case '\'':
      case ',':
      case '.':
        displayText[i] = text[i];
        break;

      // Normal character, proceed with masking it.
      default:
        displayText[i] = '_';
    }
  }

  return displayText;
}
