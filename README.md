### speedrun MBR

This starts reading the keyboard, expects [0-9,A-F] in groups of two, and writes a byte to memory for every time you hit space. When you hit Enter, it will jump to your hex code. Hopefully, you wrote yourself a way to write more code, maybe set up GDT/IDT, jump to P-mode, etc.

The point is for you to get from here to a working OS without crashing the box in the shortest time possible, maybe do something cool like PXE boot or start Linux or something. I got bored and wanted to see how far I could get with this. The answer is going to be a video eventually.

Btw, this writes the first 666 bytes to the screen so you can see what you're doing, but it's up to you to keep yourself on-screen or figure out how to make that unimportant. The number 666 just happens to be 80 cols * 25 lines / (2 nibbles + 1 space) = 2000 / 3 = 666.
