import 'package:flutter_test/flutter_test.dart';

import 'package:kasirin/main.dart';

void main() {
  testWidgets('App boots and shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const KasirinApp());

    expect(find.text('Login Screen'), findsOneWidget);
  });
}
