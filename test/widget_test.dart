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
    await tester.tap(
      find.text(
        '\u041F\u041E\u041B\u0423\u0427\u0418\u0422\u042C '
        '\u041A\u041E\u0414',
      ),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNWidgets(2));

    await tester.enterText(find.byType(TextField).last, '123456');
    await tester.pumpAndSettle();

    expect(
      find.text('\u041F\u0440\u043E\u0444\u0438\u043B\u044C'),
      findsWidgets,
    );
    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.tap(
      find.text('\u0420\u0430\u0441\u043F\u0438\u0441\u0430\u043D\u0438\u0435'),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        '14 \u0438\u044E\u043D\u044F, '
        '\u043F\u044F\u0442\u043D\u0438\u0446\u0430',
      ),
      findsOneWidget,
    );

    await tester.tap(
      find
          .text(
            '\u0412\u0430\u043A\u0443\u0443\u043C\u043D\u044B\u0439 '
            '\u0433\u0438\u0434\u0440\u043E\u043C\u0430\u0441\u0441'
            '\u0430\u0436',
          )
          .first,
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u041A\u0430\u043A '
        '\u043F\u043E\u0434\u0433\u043E\u0442\u043E\u0432\u0438'
        '\u0442\u044C\u0441\u044F',
      ),
      findsOneWidget,
    );

    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    await tester.tap(
      find.text('\u041F\u0440\u043E\u0444\u0438\u043B\u044C').last,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('\u0412\u044B\u0439\u0442\u0438'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        '\u0414\u0435\u0439\u0441\u0442\u0432\u0438\u0442'
        '\u0435\u043B\u044C\u043D\u043E '
        '\u0432\u044B\u0439\u0442\u0438?',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('\u0414\u0430'));
    await tester.pumpAndSettle();

    expect(find.text('\u0412\u0445\u043E\u0434'), findsOneWidget);
  });
}
