import 'package:flutter/material.dart';
import 'package:flutter_xterm_uart_terminal/config.dart';

class WiFiScreen extends StatefulWidget {
  const WiFiScreen({super.key});

  @override
  State<WiFiScreen> createState() => _WiFiScreenState();
}

class _WiFiScreenState extends State<WiFiScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: navigation_screen_height,
      child: Column(
        children: [
          const Text("WiFi Screen"),
          ElevatedButton(onPressed: () {}, child: Text("Send")),
        ],
      ),
    );
  }
}
