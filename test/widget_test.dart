import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuse/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ProviderScope(child: App()));

    // Basic check to see if the app loads.
    // The initial route is /signin, which has a Text 'FUSE'
    expect(find.text('FUSE'), findsOneWidget);
  });
}
