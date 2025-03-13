import 'package:flutter/material.dart';
import 'package:flutter_xterm_uart_terminal/config.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      heightFactor: navigation_screen_height,
      child: Text("Chart Screen"),
    );
  }
}
