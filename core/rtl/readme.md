# **Core implementation documentationgit**
## Adder

32 bit carry look ahead adder

## ALU

3 inputs 

1 output 

### operations supported

ops: ![ops](https://github.com/ursonor99/Capstone/blob/323b50f3e6700b7afaceb022eeed8e48097d68cd/bin/alu%20operations.png)

(to be filled)

## Regs (Register File) 
* supports pipelining .
* can read 2 registers (rs1,rs2) simultaneously.
* direct 0 read if address is 0.
* handles reading and writing to same reg conflict by passing through rd_data.


### Inputs
i_clk  
i_rst_n  
i_rs1_addr  
i_rs2_addr  
i_rd_addr  
i_rd_data  
i_write_en  



### Outputs
o_rs1_data  
o_rs2_data  

## Program Counter 

pending....




### ram 1
2 ports 0 and 1.
port 0 has data_0 address_0 to write
port 1 has data_1 address_1 to read
write needs clock and read doesn't need clock signal
ram1_tb is the test bench 



