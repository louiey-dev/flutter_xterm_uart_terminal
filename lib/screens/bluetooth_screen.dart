import 'package:flutter/material.dart';
import 'package:flutter_xterm_uart_terminal/config.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      heightFactor: navigation_screen_height,
      child: Text("Bluetooth Screen"),
    );
  }
}
