// Simple Dart test
// Run with: dart test

import 'package:flutter_application_1/main.dart';

void main() {
  // Test the square function
  assert(square(5) == 25, 'square(5) should be 25');
  assert(square(0) == 0, 'square(0) should be 0');
  assert(square(10) == 100, 'square(10) should be 100');

  print('✓ All tests passed!');

  // Test Animal class
  Animal animal = Animal("Cat");
  animal.sound(); // Should print: Cat makes a sound

  // Test Dog class (inheritance)
  Dog dog = Dog("Buddy");
  dog.sound(); // Should print: Buddy barks: Woof Woof!

  print('✓ OOP tests passed!');
}
