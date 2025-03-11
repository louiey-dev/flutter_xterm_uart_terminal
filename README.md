# flutter_xterm_uart_terminal

Flutter uart terminal app based on xterm package

## Getting Started

This app talk to device via uart interface on PC.</br>
App is written based on xterm package and get help from "www.perplexity.ai".</br>
Current code is one code base and will add screens and features to use for my own purpose.</br>

## Features

- uart open and send/receive via uart based on xterm
  - Uart open/close added based on xterm
  - it works as normal terminal app

## TODOs

- Separate screens
  - ~~COM control screen~~
- ~~Log file handler~~
  - Optimized with timer handler
  - periodically check log buffer and save log file

## History

- 2024.12.02
  - First commit
  - it works normally like as terminal app
  - uart tx/rx on xterm is working
- 2024.12.04
  - Separate screens
  - Bottom navigation bar added to change mode from settings/bluetooth/wifi
  - Serial terminal screen separated
- 2024.12.05
  - Added some buttons to control via uart
- 2025.03.11
  - Log feature added
  - Use timer to log to file and saved resources
  - Log file handler added
