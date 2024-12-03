import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final int durationInSeconds;
  final VoidCallback onTimeUp;

  const TimerWidget({
    Key? key,
    required this.durationInSeconds,
    required this.onTimeUp,
  }) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int timeRemaining;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timeRemaining = widget.durationInSeconds;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeRemaining > 0) {
          timeRemaining--;
        } else {
          timer.cancel();
          widget.onTimeUp();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.timer, color: Colors.red),
        SizedBox(width: 8),
        Text(
          "$timeRemaining seconds",
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      ],
    );
  }
}
