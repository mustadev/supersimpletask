// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:supersimpletask/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // await tester.pumpWidget(SuperSimpleTask());

    // // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
    final File f = File("../assets/testfile");
  if (f.existsSync()){
    print("file ${f.path} exist");
    print("file content: ${f.readAsStringSync()} ");
  }else {
    f.createSync();
    print("file content after creation: ${f.readAsStringSync()} ");
  }
  });

  
}
