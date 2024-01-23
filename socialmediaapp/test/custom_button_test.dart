import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialmediaapp/components/signin/custom_button.dart';
import 'package:integration_test/integration_test.dart';


void main() {
  testWidgets('CustomButton has correct text and responds to tap', (WidgetTester tester) async {
    bool wasPressed = false;
    await tester.pumpWidget(MaterialApp(
      home: CustomButton(
        text: 'Tap Me',
        onPressed: () => wasPressed = true,
        color: Colors.blue,
        textColor: Colors.white,
      ),
    ));

    // Verify the button text.
    expect(find.text('Tap Me'), findsOneWidget);

    // Tap the button and verify it works.
    await tester.tap(find.byType(CustomButton));
    expect(wasPressed, isTrue);

    // Check button color and shape.
    final ElevatedButton elevatedButton = tester.widget(find.byType(ElevatedButton));
    expect(elevatedButton.style!.backgroundColor, MaterialStateProperty.all(Colors.blue));
    expect(
      elevatedButton.style!.shape,
      MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  });
}
