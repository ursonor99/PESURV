# **Uart**
Serial Interface to upload the intructions to the APU core


## Pending Work as of ESA
1. Create a Fifo buffer on the Rx side to save the data and also switch between address and data path.
	+Parametrized Fifo created currently one word long, extendable.
	+Integration with Tx and Rx underway, decided to include parity checks to reduce possibilty of error.
2. The fifo will directly communicate with the other modules, control signals like is_write etc have to be created for proper memory access, besides the data paths.
	+Creating a decoder for each word, needs discussions to properly integrate with data / control flow.
	
	
