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
    return Row(
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
                serialBtn("luna scan",
                    "luna-send -f -n 1 luna://com.palm.wifi/findnetworks '{\"subscribe\": true}'"),
                myWidth(10),
                serialBtn("Vbus reset",
                    "luna-send -f -n 1 luna://com.webos.service.micomservice/resetWifiVbus '{}'"),
                myWidth(10),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                serialBtn("find p2p",
                    "luna-send -f -n 1 luna://com.palm.wifi/p2p/getpeers '{\"subscribe\": true}'"),
                myWidth(10),
                serialBtn("sw reset",
                    "echo 1 > /sys/devices/platform/usb/18050000.xhci_top/usb1/1-1/remove"),
                myWidth(10),
                myWidth(10),
                serialBtn("WiFi Diag",
                    "luna-send -f -n 1 luna://com.webos.service.wifi/getwifidiagnostics ' {\"subscribe\": true}'"),
                myWidth(10),
                serialBtn("ifconfig", "ifconfig"),
                myWidth(10),
              ],
            )
          ],
        ),
        myWidth(40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myHeight(10),
            Row(
              children: [
                myWidth(10),
                SizedBox(
                  height: 40,
                  width: 160,
                  child: TextField(
                    controller: ssid,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "ssid",
                    ),
                  ),
                ),
                myWidth(10),
                SizedBox(
                  height: 40,
                  width: 160,
                  child: TextField(
                    controller: passwd,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "password",
                    ),
                  ),
                ),
              ],
            ),
            myHeight(10),
            Row(
              children: [
                myWidth(10),
                connectBtn("Connect"),
                myWidth(10),
                getProfileId("get id"),
                myWidth(10),
                disConnectBtn("DisCon"),
                myWidth(10),
                SizedBox(
                  height: 40,
                  width: 100,
                  child: TextField(
                    controller: profileId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "profile id",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
