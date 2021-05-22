# **Uart**
Serial Interface to upload the intructions to the APU core

## Issues faced
1. Not compatible with newer versions of Xilinx Vivado HLS.
2. The Tx is unreliable (guess: mismatch in conversion and case statement based SMs need revision)
3. The Rx wouldnt accept multiple test

## Pending Work
1. Create a Fifo buffer on the Rx side to save the data and also switch between address and data path.
2. The fifo will directly communicate with the other modules, control signals like is_write etc have to be created for proper memory access, besides the data paths.