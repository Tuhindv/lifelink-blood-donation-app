
import 'package:flutter_test/flutter_test.dart';
import 'package:lifelink/main.dart';

void main() {
  testWidgets('LifeLink home screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const LifeLinkApp());

    expect(find.text('LifeLink'), findsNWidgets(2));
    expect(find.text('Find Blood Donors'), findsOneWidget);
    expect(find.text('Become a Donor'), findsOneWidget);
  });
}
