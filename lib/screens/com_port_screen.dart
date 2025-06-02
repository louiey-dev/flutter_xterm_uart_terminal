import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_xterm_uart_terminal/screens/serial_terminal_screen.dart';
import 'package:flutter_xterm_uart_terminal/utils/log_file_control.dart';
import 'package:flutter_xterm_uart_terminal/utils/utils.dart';

import 'package:gif/gif.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

List<SerialPort> portList = [];
SerialPort? mSp;

final TextEditingController logFileNameController = TextEditingController();

bool serialSend(String cmd) {
  try {
    if (mSp == null) {
      utils.e("mSp is null");
      return false;
    }
    mSp!.write(utf8.encode(cmd));
  } catch (ex) {
    utils.e(ex.toString());
    return false;
  }
  return true;
}

class ComScreen extends StatefulWidget {
  const ComScreen({super.key});

  @override
  State<ComScreen> createState() => _ComScreenState();
}

class _ComScreenState extends State<ComScreen> with TickerProviderStateMixin {
  int menuBaudrate = 115200;
  String openButtonText = 'N/A';
  List<int> baudRate = [3800, 9600, 115200, 1500000];

  SerialPortReader? reader;

  final _cmdList = ['pwd', 'ls -al', 'tail -F /var/log/legacy-log'];
  var _selectedValue = 'pwd';
  // final _logFileList = ['DateTime', ''];

  String logStartStopText = 'Log Start';
  bool _isPlaying = false;
  late GifController _gifController;
  @override
  void initState() {
    _gifController = GifController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    utils.log("disposed");
    // Close the SerialPortReader stream if it exists
    reader?.close();
    utils.log("Serial reader closed");

    // Close the SerialPort if it is open
    if (mSp != null && mSp!.isOpen) {
      mSp!.close();
    }
    // Optionally set mSp to null if you want to fully release the reference
    mSp = null;
    utils.log("Serial port closed");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    openButtonText = mSp == null
        ? 'N/A'
        : mSp!.isOpen
            ? 'Close'
            : 'Open';

    // logStartStopText = _isPlaying ? 'Log Stop' : 'Log Start';
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              _comPort(),
              const SizedBox(width: 20),
              Flexible(
                child: DropdownButton(
                  // hint: const Text("Select Command"),
                  value: _selectedValue,
                  items: _cmdList.map(
                    (value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 20),
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    serialSend("$_selectedValue\n");
                  },
                  child: const Text("Send"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              // const SizedBox(width: 20),
              // const Text("Log file input = "),
              const SizedBox(width: 20),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: logFileNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'input log file name',
                    labelText: 'Log file name',
                    prefixIcon: Icon(Icons.save_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  if (_isPlaying) {
                    _gifController.stop();
                    _isPlaying = false;
                    utils.log("GIF stopped, $logStartStopText");
                    logStartStopText = "Log Start";
                    logFileClose(); // Close the log file
                  } else {
                    _gifController.repeat();
                    _isPlaying = true;
                    utils.log("GIF started, $logStartStopText");
                    logFileOpen();
                    logStartStopText = "Log Stop";
                  }

                  setState(() {});
                },
                child: Text(logStartStopText),
              ),
              const SizedBox(width: 10),
              Gif(
                width: 50.0,
                height: 50.0,
                image: const AssetImage('assets/images/duck.gif'),
                // image: const AssetImage('assets/images/matrix_rain.gif'),
                controller: _gifController,
                autostart: Autostart.no,
              ),
              // const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  _initPort() {
    setState(() {
      var i = 0;

      portList.clear();

      if (SerialPort.availablePorts.isEmpty) {
        utils.e("There is no available ports");
        return;
      }

      for (final name in SerialPort.availablePorts) {
        final sp = SerialPort(name);
        utils.log('[${++i}] $name');
        utils.log('\tDescription: ${sp.description ?? ''}');
        utils.log('\tManufacturer: ${sp.manufacturer}');
        utils.log('\tSerial Number: ${sp.serialNumber}');
        utils.log('\tProduct ID: 0x${sp.productId?.toRadixString(16) ?? 00}');
        utils.log('\tVendor ID: 0x${sp.vendorId?.toRadixString(16) ?? 00}');

        portList.add(sp);
      }
      if (portList.isNotEmpty) {
        mSp = portList.first;
      }
    });
  }

  void changedDropDownItem(SerialPort sps) {
    setState(() {
      mSp = sps;
    });
  }

  _comConfig() {
    try {
      SerialPortConfig config = mSp!.config;
      // config.baudRate = 115200;
      config.baudRate = menuBaudrate;
      config.parity = 0;
      config.bits = 8;
      config.cts = 0;
      config.rts = 0;
      config.stopBits = 1;
      config.xonXoff = 0;
      mSp!.config = config;

      utils.log("baudrate : $menuBaudrate");
      // inputController.text = configCmd;
    } catch (ex) {
      utils.log(ex.toString());
    }
  }

  _comClose() {
    if (mSp!.isOpen) {
      mSp!.close();
      utils.log('${mSp!.name} closed!');
      reader!.close();
      // mSp!.dispose();
    } else {
      utils.e("COM port is not open, cannot close it.");
    }
  }

  _comOpen() {
    if (mSp!.isOpen) {
      mSp!.close();
      utils.log('${mSp!.name} closed!');
      reader!.close();
      // mSp!.dispose();
    } else {
      if (mSp!.open(mode: SerialPortMode.readWrite)) {
        _comConfig();

        if (mSp!.isOpen) {
          utils.log('${mSp!.name} opened!');
        } else {
          utils.e("mSP open error\n");
          return;
        }

        terminal.onOutput = (data) {
          mSp!.write(Uint8List.fromList(data.codeUnits));
        };

        _readSerialData();
      } else {
        utils.e("COM port open error\n");
        mSp!.close();
      }
    }
  }

  void _readSerialData() {
    try {
      reader = SerialPortReader(mSp!, timeout: 1000);
      reader!.stream.listen((data) {
        String str = String.fromCharCodes(data);
        terminal.write(str);
        if (lfc != null) {
          lfc?.update(str);
        }
      });
    } catch (ex) {
      utils.e("Error reading serial data: $ex");
    }
  }

  _comPort() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            // louiey, 2025-05-29. COM port list
            DropdownButton(
              hint: const Text("Select COM port"),
              // menuMaxHeight: 0.5,
              value: mSp,
              items: portList.map((item) {
                return DropdownMenuItem(
                    value: item, child: Text("${item.name}"));
              }).toList(),
              onChanged: (e) {
                setState(() {
                  changedDropDownItem(e as SerialPort);
                  utils.log("Selected port : ${e.name}");
                });
              },
            ),

            const SizedBox(width: 20.0),
            // louiey, 2025-05-29. Baudrate list
            DropdownButton(
              hint: const Text("Select Baudrate"),
              value: menuBaudrate,
              items: baudRate.map((value) {
                return DropdownMenuItem(
                    value: value, child: Text(value.toString()));
              }).toList(),
              onChanged: (e) {
                setState(() {
                  menuBaudrate = e!;
                });
                utils.showSnackbar(context, menuBaudrate.toString());
                utils.log("Baudrate set to $menuBaudrate");
              },
            ),
            const SizedBox(width: 20.0),
            ElevatedButton(
              onPressed: () {
                _initPort();
              },
              child: const Text("COM"),
            ),
            const SizedBox(width: 20.0),
            ElevatedButton(
              // louiey, 2025-05-30. Com Open/Close
              onPressed: () {
                if (mSp == null) {
                  utils.e("port is null");
                  return;
                }

                if (mSp!.isOpen) {
                  _comClose();

                  // louiey, 2025-06-02. check whether logging is enabled
                  if (lfc != null) {
                    bool? flag = lfc?.isLogging;
                    if (flag == true) {
                      lfc?.close();
                    }
                  }

                  utils.log("Logging file closed");
                } else {
                  _comOpen();
                }

                setState(() {});
              },
              child: Text(openButtonText),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ],
    );
  }
}
