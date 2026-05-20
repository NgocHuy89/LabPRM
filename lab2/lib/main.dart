void main() {
  print("=================================");
  print("EXERCISE 1: BASIC SYNTAX & DATA TYPES");
  print("=================================");

  // String data type
  String name = "Huy";

  // Integer data type
  int age = 20;

  // Double data type
  double height = 1.72;

  // Boolean data type
  bool isStudent = true;

  // Print variables
  print("Name: $name");
  print("Age: $age");
  print("Height: $height");
  print("Student: $isStudent");

  print("\n=================================");
  print("EXERCISE 2: COLLECTIONS & OPERATORS");
  print("=================================");

  // List
  List<int> numbers = [1, 2, 3, 4, 5];
  numbers.add(6);

  // Set (cannot contain duplicates)
  Set<String> fruits = {"Apple", "Banana", "Orange"};
  fruits.add("Apple");

  // Map (key-value pair)
  Map<String, int> scores = {"Math": 90, "English": 85};

  // Operators
  int a = 10;
  int b = 3;

  print("Addition: ${a + b}");
  print("Subtraction: ${a - b}");
  print("Multiplication: ${a * b}");
  print("Division: ${a / b}");
  print("Modulus: ${a % b}");

  // Print collections
  print("Numbers List: $numbers");
  print("Fruits Set: $fruits");
  print("Scores Map: $scores");

  print("\n=================================");
  print("EXERCISE 3: CONTROL FLOW & FUNCTIONS");
  print("=================================");

  int score = 75;

  // if/else statement
  if (score >= 80) {
    print("Excellent");
  } else if (score >= 60) {
    print("Passed");
  } else {
    print("Failed");
  }

  // switch statement
  String grade = "A";

  switch (grade) {
    case "A":
      print("Very Good");
      break;
    case "B":
      print("Good");
      break;
    default:
      print("Average");
  }

  // for loop
  print("For Loop:");
  for (int i = 1; i <= 5; i++) {
    print(i);
  }

  // while loop
  print("While Loop:");
  int count = 1;
  while (count <= 3) {
    print(count);
    count++;
  }

  // Function call
  int result = square(5);
  print("Square of 5 = $result");

  print("\n=================================");
  print("EXERCISE 4: INTRO OOP");
  print("=================================");

  // Create objects
  Animal animal = Animal("Generic Animal");
  animal.sound();

  Dog dog = Dog("Buddy");
  dog.sound();

  print("\n=================================");
  print("LAB COMPLETED SUCCESSFULLY");
  print("=================================");
}

// Function to calculate square
int square(int number) {
  return number * number;
}

// Parent class
class Animal {
  String name;

  Animal(this.name);

  void sound() {
    print("$name makes a sound");
  }
}

// Child class using inheritance
class Dog extends Animal {
  Dog(String name) : super(name);

  @override
  void sound() {
    print("$name barks: Woof Woof!");
  }
}
