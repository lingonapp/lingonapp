import 'package:flutter_test/flutter_test.dart';
import 'package:lingon/main.dart';

void main() {
  testWidgets('Shows a loading screen when starting app',
      (WidgetTester tester) async {
    await tester.pumpWidget(Main());
    expect(find.text('Loading'), findsOneWidget);
  });
}
