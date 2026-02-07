import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_frontend/app/app.dart';

void main() {
  testWidgets('App builds', (WidgetTester tester) async {
    // Build the app widget
    await tester.pumpWidget(const App());

    // Basic sanity check: the App widget exists
    expect(find.byType(App), findsOneWidget);
  });
}