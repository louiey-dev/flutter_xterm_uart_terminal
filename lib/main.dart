import 'package:flutter/material.dart';
import 'package:flutter_xterm_uart_terminal/screens/bluetooth_screen.dart';
import 'package:flutter_xterm_uart_terminal/screens/serial_terminal_screen.dart';
import 'package:flutter_xterm_uart_terminal/screens/settings_screen.dart';
import 'package:flutter_xterm_uart_terminal/screens/wifi_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      color: Colors.blue,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        title: 'Flutter Xterm Uart Terminal',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.lightBlue,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const SerialTerminal(),
          IndexedStack(
            index: _selectedIndex,
            children: const [
              // Add screen here
              SettingScreen(),
              WiFiScreen(),
              BluetoothScreen(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.link), label: "Setting"),
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: "WiFi"),
          BottomNavigationBarItem(icon: Icon(Icons.bluetooth), label: "BT"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        // fixedColor: Colors.lightBlue,
        onTap: _onItemTapped,
      ),
    );
  }
}
