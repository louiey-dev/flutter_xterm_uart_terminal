import 'package:flutter/material.dart';
import 'package:flutter_xterm_uart_terminal/config.dart';
import 'package:flutter_xterm_uart_terminal/screens/com_port_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        heightFactor: navigation_screen_height, child: ComScreen());
  }
}
