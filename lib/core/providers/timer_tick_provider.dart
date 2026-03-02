import 'package:flutter_riverpod/flutter_riverpod.dart';

// One global heartbeat running at 30ms to maintain the buttery smooth blur
final timerTickProvider = StreamProvider<int>((ref) {
  return Stream.periodic(const Duration(milliseconds: 30), (i) => i);
});
