import 'package:android_dev/core/db/app_database.dart';
import 'package:android_dev/core/db/database_provider.dart';
import 'package:android_dev/main.dart';
import 'package:drift/native.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Network images fail with HTTP 400 in tests; those errors are expected, so drain them.
Future<void> settle(WidgetTester tester) async {
  await tester.pumpAndSettle();
  while (tester.takeException() != null) {}
}

void main() {
  testWidgets('login screen first, sign up opens the home tab, logout returns', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MainApp(),
      ),
    );
    await settle(tester);
    expect(find.text('Log in'), findsOneWidget);

    await tester.tap(find.text("Don't have an account? Sign up"));
    await settle(tester);
    await tester.enterText(find.byKey(const Key('username')), 'anna');
    await tester.enterText(find.byKey(const Key('email')), 'anna@mail.com');
    await tester.enterText(find.byKey(const Key('password')), 'secret1');
    await tester.enterText(find.byKey(const Key('confirm')), 'secret1');
    await tester.tap(find.text('Sign up'));
    await settle(tester);
    expect(find.text('Instagram'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await settle(tester);
    await tester.tap(find.byTooltip('Log out'));
    await settle(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Log out'));
    await settle(tester);
    expect(find.text('Log in'), findsOneWidget);

    // Dispose the tree so Drift can cancel its stream timers before the test ends.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    while (tester.takeException() != null) {}
  });
}
