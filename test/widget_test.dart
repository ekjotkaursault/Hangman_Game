import 'package:flutter_test/flutter_test.dart';
import 'package:guess_the_word/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Load the app widget
    await tester.pumpWidget(const GuessWordApp());

    // Verify that the title text appears on screen
    expect(find.text('Guess The Word'), findsOneWidget);
  });
}
