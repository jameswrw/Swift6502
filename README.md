# Swift6502

A Swift package that implements all opcodes for a MOS 6502 processor.

Swift6502 comes with its own unit tests, but also passes Klaus Dormann's comprehensive [6502 functional tests](https://github.com/Klaus2m5/6502_65C02_functional_tests). It has not been tested on Klaus Dormann's invalid decimal tests, nor his 65C02 extended opcode tests, and I would expect those to fail. This shouldn't affect well behaved 6502 code, and may well be catered for some time in the future.

Swift6502 is only the CPU core. There are hooks for I/O, but no devices are provided. It's up to client code to provide and hook up devices such as a keyboard and display.

I wrote [AppleOne](https://github.com/jameswrw/AppleOne/tree/main), an Apple I emulator for macOS as a test harness for the 6502 core. It is much more a test harness than fully fledged emulator, so don't expect too much from it. However, WozMon and and Apple Integer BASIC appear to work.