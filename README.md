## How to Setup Project

### Run these Commands in CMD prompt one by one within this directory:
- "C:\Xilinx\Vivado\2019.1\settings64.bat" && vivado -mode tcl
    - Find your specific path for settings64.bat   
- source PZ_PZP201_PRO_NO_OS.tcl

### Open the new folder PZ_PZP201_PRO_NO_OS, open the vivado project, generate the bitstream.

### After bitstream generation
- In Vivado, export hardware, then launch SDK
- In SDK, click File/New/Application Project
- Put a descriptive project name (say "test"), click Next
- Choose Empty Application, clikc Finish
- Copy the files in sdk_source folder, paste them into test/src folder.
