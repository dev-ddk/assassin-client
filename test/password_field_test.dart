// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:assassin_client/main.dart';
import 'package:assassin_client/widgets/password.dart';

void main() {
  testWidgets('Show Hide Password', (WidgetTester tester) async {
    // Build our app and trigger a frame.

    const hint = "Password";

    await tester.pumpWidget(const AssassinApp());

    //No icons when text is not focused
    expect(find.byIcon(PasswordToggleField.iconHide), findsNothing);
    expect(find.byIcon(PasswordToggleField.iconShow), findsNothing);

    await tester.tap(find.widgetWithText(TextField, hint));
    await tester.pump();

    expect(find.byIcon(PasswordToggleField.iconHide), findsOneWidget);
    expect(find.byIcon(PasswordToggleField.iconShow), findsNothing);

    // Tap the 'show' icon and trigger a frame.
    await tester.tap(find.byIcon(PasswordToggleField.iconHide));
    await tester.pump();

    expect(find.byIcon(PasswordToggleField.iconHide), findsNothing);
    expect(find.byIcon(PasswordToggleField.iconShow), findsOneWidget);
  });
}
