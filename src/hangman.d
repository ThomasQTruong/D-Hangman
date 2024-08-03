module src.hangman;

import std.file;
import std.stdio;
import std.string;
import std.random;
import std.array;
import std.algorithm;
import std.ascii;



string TEXT_LIST = "../words.txt";  // File that contains the list of texts to guess.
int INCORRECT_COUNT;                    // Amount of incorrect guesses.


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
    
    char[] guesses;
    INCORRECT_COUNT = 0;
    int gameStatus;
    do {
      // [DEMO] This is one way to print and is very simple.
      writeln("Text: ");
      // [DEMO] This is a second way to print.
      displayText.writeln;
      writeln();

      // Ask user to guess.
      writeln("Enter the letter you want to guess.");
      write("Guess: ");
      // Get user's line of input and only extract 1st character as lower case.
      char guess = std.ascii.toLower(readln()[0]);
      writeln();

      // Proccess user's guess.
      int validCode = validGuess(text, guess, guesses);
      switch (validCode) {
        case 1:  // Valid guess.
          revealLetter(text, guess, displayText);
        case 0:  // Invalid guess.
          // [DEMO] Simple array insertion.
          guesses ~= guess;
          break;
        case -1:  // Not alphabetical.
            // Can insert print here.
          break;
        case -2:  // Duplicate guess.
          // Can insert print here.
          break;
        default:
          break;
      }

      // Display human and guesses.
      writeln();
      printHuman(INCORRECT_COUNT);
      printGuesses(guesses);
      
      gameStatus = gameEnded(text, displayText);
    } while (gameStatus == 0);

    // Display game info.
    if (gameStatus == 1) {
      writeln("You won! :D");
    } else {
      writeln("You lost! ;(");
    }
    // [DEMO] Can also print format.
    writef("The answer was: %s\n", text);

    // Ask if user wants to play again.
    writeln("\nDo you want to play again? <y/n>");
    write("Input: ");
    char playAgain = std.ascii.toLower(readln()[0]);
    writeln("\n======================\n");

    // User did not input yes.
    if (playAgain != 'y') {
      done = true;
    }
  } while(!done);

  // User quit.
  writeln("Goodbye!");
}


char[] generateDisplay(string text) {
  char[] displayText = new char[text.length];

  // [DEMO] Can use for each instead of a traditional for loop, no datatype for i = auto by default.
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


int validGuess(string text, char letter, char[] guesses) {
  // Is not a letter, cannot guess.
  if (!letter.isAlpha) {
    return -1;
  }
  // Duplicate guess.
  if (guesses.canFind(letter)) {  // [DEMO] Easy array check.
    return -2;
  }
  // Incorrect guess.
  if (!text.toLower().canFind(letter)) {
    ++INCORRECT_COUNT;
    return 0;
  }

  return 1;
}


void revealLetter(string text, char letter, char[] displayText) {
  string lowercaseText = text.toLower();

  // For every letter of the text.
  foreach (i; 0 .. text.length) {
    // Letter matches.
    if (lowercaseText[i] == letter) {
      // Is lowercase letter since matched.
      if (text[i] == letter) {
        displayText[i] = letter;
      } else {  // Is uppercase, convert letter to uppercase.
        displayText[i] = std.ascii.toUpper(letter);
      }
    }
  }
}


void printHuman(int amount) {
  // Draw head.
  if (amount >= 1) {
    writeln("Human:");
    writeln(" o ");
  }
  // Draw body/arms.
  if (amount == 2) {
    writeln(" | ");
  } else if (amount == 3) {
    writeln("/|");
  } else if (amount >= 4) {
    writeln("/|\\");
  }
  // Draw legs.
  if (amount == 5) {
    writeln("/");
  } else if (amount == 6) {
    writeln("/ \\");
  }
}


void printGuesses(char[] guesses) {
  size_t length = guesses.length;

  // Nothing to print yet.
  if (length == 0) {
    return;
  }

  write("Guesses: [");
  // [DEMO] Another example of foreach loop, specifying i's datatype here.
  foreach (int i, char guess; guesses) {
    write(guess);
    if (i < length - 1) {
      write(", ");
    }
  }
  writeln("]");
}


int gameEnded(string text, char[] displayText) {
  // Fully guessed the word/phrase.
  if (text == displayText) {
    return 1;
  }
  // Human fully drawn, lost!
  if (INCORRECT_COUNT >= 6) {
    return 2;
  }
  // Still on-going.
  return 0;
}
