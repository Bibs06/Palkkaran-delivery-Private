import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier for OTP Timer
class OTPTimerNotifier extends StateNotifier<int> {
  Timer? _timer;

  OTPTimerNotifier() : super(60); // Initial time is 60 seconds

  void startTimer() {
    // Reset timer if already running
    _timer?.cancel();
    state = 60; // Reset to 60 seconds

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state > 0) {
        state = state - 1; // Reduce time by 1 second
      } else {
        timer.cancel(); // Stop the timer at 0
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    state = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Provider for OTP Timer
final otpTimerProvider = StateNotifierProvider<OTPTimerNotifier, int>(
  (ref) => OTPTimerNotifier(),
);
