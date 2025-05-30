import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_xterm_uart_terminal/screens/com_port_screen.dart';
import 'package:xterm/xterm.dart';

late Terminal terminal;
final terminalController = TerminalController();

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
    return Expanded(
      flex: 1,
      child: TerminalView(
        terminal,
        controller: terminalController,
        onSecondaryTapDown: (details, offset) async {
          final selection = terminalController.selection;
          if (selection != null) {
            // 선택 영역이 있으면 복사
            final text = terminal.buffer.getText(selection);
            terminalController.clearSelection();
            await Clipboard.setData(ClipboardData(text: text));
          } else {
            // 선택 영역이 없으면 붙여넣기
            final data = await Clipboard.getData('text/plain');
            final text = data?.text;
            if (text != null) {
              terminal.paste(text);
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    mSp?.close();
    super.dispose();
  }
}
