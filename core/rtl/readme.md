# **Core implementation documentationg**
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






## ram_2
storing and loading data into the memory{total now 32 bits of 256 words are stored }\
ram_wdat=data to be written into memory\
ram_we=write enable\
ram_type=4 bits to select whether its  Half read/write,byte read/write..\
        *ram_type=1111 we=1 write full word\
        *ram_type=1111 re=1 read full word\
        *ram_type=0011 we=1 write half word\
        *ram_type=0011 re=1 read half word\
        *ram_type=0001 we=1 write byte word\
        *ram_type=0001 re=1 read byte word\
ram_rd_store=enable to display stored value(not necessary just to check)\
ram_rd_load=enable to display loaded value(not necessary ,just to check)\
ram_addr=address into which read/write operation is done\
ram_dout=output display \
ram_re=read enable\
data_reg=register that has loaded value.



