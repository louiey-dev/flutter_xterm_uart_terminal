# flutter_xterm_uart_terminal

Flutter uart terminal app based on xterm package

## Getting Started

This app talk to device via uart interface on PC.</br>
App is written based on xterm package and get help from "www.perplexity.ai".</br>
Current code is one code base and will add screens and features to use for my own purpose.</br>
This app is talking to xterm via UART, not plink and so on.</br>


## Features

- uart open and send/receive via uart based on xterm
  - Uart open/close added based on xterm
  - it works as normal terminal app

## TODOs

- COM open error if exited from app without com port close
  - couldn't open com in this case and should reset com port (disconnect com port and re-insert)
- apply riverpod for state management
- add time stamp at log file
  - put time stamp at front of each line in log file
- Log start/stop button add
- screen overflow error fix in case of Settings screen smaller than screen height

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
- 2025.05.30
  - copy and paste on terminal window
    - added onSecondaryTapDown with terminalController
  - Log file is not close when com port closed
    - added close 
  - 