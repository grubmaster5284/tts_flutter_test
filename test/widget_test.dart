// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tts_flutter_test/main.dart';
import 'package:tts_flutter_test/audio_playback/presentation/widgets/audio_player_widget.dart';

void main() {
  testWidgets('App loads and displays audio player page', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope (required for Riverpod) and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Wait for any async initialization to complete
    await tester.pumpAndSettle();

    // Verify that the app bar title is displayed
    expect(find.text('Audio Player Test'), findsOneWidget);
    
    // Verify that the "Load Audio" section is displayed (may appear multiple times)
    expect(find.text('Load Audio'), findsWidgets);
    
    // Verify that the audio player widget is present
    expect(find.byType(AudioPlayerWidget), findsWidgets);
  });
}
