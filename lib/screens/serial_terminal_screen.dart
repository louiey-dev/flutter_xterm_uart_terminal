import 'package:flutter/material.dart';
import 'package:flutter_xterm_uart_terminal/screens/com_port_screen.dart';
import 'package:xterm/xterm.dart';

late Terminal terminal;

class SerialTerminal extends StatefulWidget {
  const SerialTerminal({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SerialTerminalState createState() => _SerialTerminalState();
}

class _SerialTerminalState extends State<SerialTerminal> {
  @override
  void initState() {
    super.initState();
    terminal = Terminal();

    // Listen to terminal output, // louiey
    terminal.onOutput = (data) {
      setState(() {});
    };
    // _initSerialPort();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: 1, child: TerminalView(terminal));
  }

  @override
  void dispose() {
    mSp?.close();
    super.dispose();
  }
}
