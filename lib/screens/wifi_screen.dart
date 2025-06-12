import 'package:flutter/material.dart';
import 'package:flutter_xterm_uart_terminal/config.dart';
import 'package:flutter_xterm_uart_terminal/widget/serial_button.dart';

final ssid = TextEditingController();
final passwd = TextEditingController();
final profileId = TextEditingController();

class WiFiScreen extends StatefulWidget {
  const WiFiScreen({super.key});

  @override
  State<WiFiScreen> createState() => _WiFiScreenState();
}

class _WiFiScreenState extends State<WiFiScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Column(
            children: [
              myHeight(10),
              Row(
                children: [
                  myWidth(20),
                  serialBtn("iw link", "iw wlan0 link"),
                  myWidth(10),
                  serialBtn("iw scan", "iw wlan0 scan &"),
                  myWidth(10),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
          myWidth(40),
        ],
      ),
    );
  }
}
