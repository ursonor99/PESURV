# **Uart**
Serial Interface to upload the intructions to the APU core


## Pending Work
1. Create a Fifo buffer on the Rx side to save the data and also switch between address and data path.
2. The fifo will directly communicate with the other modules, control signals like is_write etc have to be created for proper memory access, besides the data paths.