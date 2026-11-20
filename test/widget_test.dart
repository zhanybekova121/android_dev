import 'package:android_dev/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app starts on the home tab', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MainApp()));

    await tester.pump();
    tester.takeException(); // Image.network fails with 400 in tests
    expect(find.text('Instagram'), findsOneWidget);

    // Dispose the tree so Drift can cancel its stream timers before the test ends.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
