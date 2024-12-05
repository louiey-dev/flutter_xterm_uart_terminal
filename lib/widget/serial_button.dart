import 'package:flutter/material.dart';
import 'package:flutter_xterm_uart_terminal/screens/com_port_screen.dart';
import 'package:flutter_xterm_uart_terminal/screens/wifi_screen.dart';

Widget serialBtn(String btnName, String cmdStr) {
  return ElevatedButton(
    onPressed: () {
      serialSend("$cmdStr\n");
    },
    child: Text(btnName),
  );
}

Widget disConnectBtn(String btnName) {
  return ElevatedButton(
    onPressed: () {
      String id = profileId.text;
      String cmd =
          "luna-send -n 1 -f luna://com.webos.service.wifi/deleteprofile '{\"profileId\": $id}'";
      serialSend("$cmd\n");
    },
    child: Text(btnName),
  );
}

Widget connectBtn(String btnName) {
  return ElevatedButton(
    onPressed: () {
      String id = ssid.text;
      String pass = passwd.text;
      String cmd =
          "luna-send -f -n 1 luna://com.palm.wifi/connect '{\"ssid\":\"$id\", \"security\":{\"securityType\":\"psk\", \"simpleSecurity\": {\"passKey\":\"$pass\"}}}'";
      serialSend("$cmd\n");
    },
    child: Text(btnName),
  );
}

Widget getProfileId(String btnName) {
  return ElevatedButton(
    onPressed: () {
      String cmd = "luna-send -f -n 1 luna://com.palm.wifi/getprofilelist '{}'";
      serialSend("$cmd\n");
    },
    child: Text(btnName),
  );
}
