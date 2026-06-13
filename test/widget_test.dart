import 'package:bs_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('navigates from splash to login and home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BigSaltsApp());
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u0414\u043E\u0431\u0440\u043E '
        '\u043F\u043E\u0436\u0430\u043B\u043E\u0432\u0430\u0442\u044C',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('\u0412\u041E\u0419\u0422\u0418'));
    await tester.pumpAndSettle();

    expect(find.text('\u0412\u0445\u043E\u0434'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '9066395242');
    await tester.enterText(find.byType(TextField).last, '123456');
    await tester.tap(find.text('\u0412\u041E\u0419\u0422\u0418'));
    await tester.pumpAndSettle();

    expect(
      find.text('\u041F\u0440\u043E\u0444\u0438\u043B\u044C'),
      findsWidgets,
    );
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
