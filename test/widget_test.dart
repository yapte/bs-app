import 'package:bs_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders spa themed home page', (WidgetTester tester) async {
    await tester.pumpWidget(const BigSaltsApp());

    expect(find.text('\u0421\u041F\u0410'), findsOneWidget);
    expect(
      find.text(
        '\u0414\u043E\u0431\u0440\u043E '
        '\u043F\u043E\u0436\u0430\u043B\u043E\u0432\u0430\u0442\u044C',
      ),
      findsOneWidget,
    );

    await tester.drag(find.byType(ListView), const Offset(0, -420));
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u041F\u043E\u0441\u043B\u0435\u0434\u043D\u0438\u0435 '
        '\u043D\u043E\u0432\u043E\u0441\u0442\u0438',
      ),
      findsOneWidget,
    );

    await tester.drag(find.byType(ListView), const Offset(0, -620));
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u041F\u043E\u043F\u0443\u043B\u044F\u0440\u043D\u044B\u0435 '
        '\u0443\u0441\u043B\u0443\u0433\u0438',
      ),
      findsOneWidget,
    );
  });
}
