import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:myapp/main.dart'; // Pastikan import ini mengarah ke main.dart Anda


void main() {
  testWidgets('Counter value smoke test', (WidgetTester tester) async {
    // UBAH: Dari 'MyApp()' menjadi 'MomindApp()'
    await tester.pumpWidget(const MomindApp());


    // Sisa kode test di bawahnya biarkan tetap sama...
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);


    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();


    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}



