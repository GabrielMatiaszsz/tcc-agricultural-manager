import 'package:flutter_test/flutter_test.dart';
import 'package:agriculturalmanager/main.dart';

void main() {
  testWidgets('Login screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Entrar'), findsOneWidget);
  });
}

