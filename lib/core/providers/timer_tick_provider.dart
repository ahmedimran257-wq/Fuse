import 'package:flutter_riverpod/flutter_riverpod.dart';

// One global heartbeat — 100ms (10fps) is smooth enough for countdown display
// while using ~3x less CPU than 30ms. All FuseTimerBar widgets share this tick.
final timerTickProvider = StreamProvider<int>((ref) {
  return Stream.periodic(const Duration(milliseconds: 100), (i) => i);
});
