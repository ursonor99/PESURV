`timescale 1ns / 1ps
`include "GLOBALS.v"



module s_core_pipelined(
input wire clk ,
input wire rst_n,

//pc


input wire[31:0] i_pc_instr_start_addr,


//instr_mem

input wire[31:0] inst_mem_addr,
input wire[31:0] inst_mem_data,


//regs

input wire[4:0] load_reg_addr,
input wire[31:0] load_reg_data,

input wire setup,

output wire[31:0] o_pc,
output wire[31:0] o_inst_data,
output wire[31:0] o_rs1_data,
output wire[31:0] o_rs2_data,
output wire[31:0] o_imm_out,
output wire[31:0] o_ALU_out,
output wire[31:0] o_adder_out,
output wire o_ALU_br_cond,
output wire[31:0] o_br_jump_addr,
output wire[31:0] o_RAM_data_out,
output wire[1:0] o_writeback_sel,
output wire[31:0] o_rd_writeback
);


///wire///////////////////////////////////////////
///pc/////////////////////////////////////////////
wire i_pc_stall;   //ctrl
wire i_pc_writing_first_addr;//ctrl
wire i_pc_is_branch_true;//branch ctrl
wire[31:0] i_pc_branch_addr;
//i_pc_instr_start_addr,
wire[31:0] pc_out;
wire o_branch_address_misaligned;

//////////instr mem/////////////////////////////////
wire instrom_read_en;//ctrl
wire instrom_write_en;//ctrl
wire[31:0] instrom_pc_in;
//input wire[31:0] inst_mem_addr,
//input wire[31:0] inst_mem_data,
wire[31:0] inst_rom_out;

///////////////reg///////////////////////
wire[4:0] rs1_addr;
wire[4:0] rs2_addr;
wire[4:0]  rd_addr;
wire[31:0] rd_data;
wire reg_write_en;//ctrl
wire[31:0] rs1_data;
wire[31:0] rs2_data;

wire reg_rd_ctrl;//ctrl
//input wire[4:0] load_reg_addr, //ext
//input wire[31:0] load_reg_data, //ext


/////////////////////imm/////////////////////////
wire[31:0] imm_out;

////////////////////alu/////////////////////////
wire [31:0 ] ALU_input_1;
wire [31:0 ] ALU_input_2;
wire[4:0] ALU_operator;
wire[31:0] ALU_out;
wire ALU_br_cond;


////////////////////carry look ahead adder//////////////////////////
wire[31:0] adder_in_1;
wire[32:0] cla_adder_out;
//pc_out
wire[31:0] adder_out;

/////////////////////////branch////////////////////////////////////////

wire[31:0] br_jump_addr ;
wire br_cond_in ;
wire[1:0] br_type ;  // ctrl 
wire br_is_branching ;
wire[31:0] br_addr ; 

////memory/////////////////////////////////////

wire[31:0] ram_write_data_in;
wire ram_write_en ; //ctrl
wire[3:0] ram_type ;//ctrl
wire[31:0] ram_addr ;
wire ram_read_en ;//ctrl
wire[31:0] ram_data_out ;
wire ram_sign ;//ctrl
wire o_memory_address_misaligned;


/////////////////////writeback///////////////////////////////
wire[1:0] writeback_sel;
wire[31:0] rd_writeback;

/////////////////////////////pipeline////////////////////////////////////

reg [64:0]if_id_reg;
wire [64:0]if_wire_value;
assign if_wire_value[64:0]={pc_out[31:0],inst_rom_out[31:0]};
 


reg [64:0]id_ex;
wire [64:0]id_wire_value;
assign if_wire_value[64:0]={pc_out[31:0],inst_rom_out[31:0]};




//assign ID_EX=ID_EX;
////////////////////////////////////////////////////////////
///////////////////instruction fetch///////////////////////
///////////////////////////////////////////////////////////


//pc//////////////////////////////////

pc uut_pc (clk,
        rst_n,
        i_pc_stall,
        i_pc_is_branch_true,
        i_pc_branch_addr,
        i_pc_writing_first_addr,
        i_pc_instr_start_addr,
        pc_out,
        o_branch_address_misaligned);






//instr mem//////////////////////////////////

inst_ram1 uut_inst(
clk,
instrom_pc_in,
instrom_read_en,//CTRL
inst_rom_out, ///// OUT
instrom_write_en,//CTRL
inst_mem_addr, /// EXT
inst_mem_data   /// EXT
);


//instr in  
assign instrom_pc_in=pc_out;







////////////////////////////////////////////////////////////
///////////////////instruction decode///////////////////////
///////////////////////////////////////////////////////////

carry_lookahead_adder uut_adder(.i_add1(adder_in_1),.i_add2(pc_out),.o_result(cla_adder_out));



assign rs1_addr=inst_rom_out[19:15];
assign rs2_addr=inst_rom_out[24:20];

//reg//////////////////////////////


regs uut_reg (clk,
            rst_n,
            rs1_addr,
            rs2_addr,
            rd_addr,
            rd_data,
            reg_write_en,
            rs1_data,
            rs2_data);



//IMM GEN/////////////////////////////////


IMM_OP uut_imm_gen (inst_rom_out,imm_out);

//Ctrl

//input wire setup

control uut_ctrl ( 
inst_rom_out,
setup,
ALU_operator,
reg_write_en,
instrom_write_en,
instrom_read_en,
br_type,
i_pc_stall,
i_pc_writing_first_addr,
ram_write_en ,
ram_read_en ,
ram_type,
ram_sign,
op1_select,
op2_select,
BR_OR_RETURN_select,
addr_sel,
writeback_sel,
reg_rd_ctrl
 );

 


////////////////////////////////////////////////////////////
/////////////////////////EXECUTE////////////////////////////
////////////////////////////////////////////////////////////


//ALU//////////////////////////////

alu uut_alu(.i_alu_operator(ALU_operator),.i_alu_operand_1(ALU_input_1),.i_alu_operand_2(ALU_input_2),.o_alu_output(ALU_out),.o_alu_br_cond(ALU_br_cond));





// Adder //////////////////


carry_lookahead_adder uut_adder1(.i_add1(adder_in_1),.i_add2(pc_out),.o_result(cla_adder_out));



assign adder_out=cla_adder_out[31:0];







////BRANCH////////////////////////////////////

branch uut_branch (br_cond_in , br_jump_addr , br_type ,br_is_branching, br_addr) ;

//branch assigns
assign br_cond_in = ALU_br_cond;

assign i_pc_is_branch_true = br_is_branching;
assign i_pc_branch_addr = br_addr; 

///////muxes//////////////////////////////////
wire op1_select;
assign ALU_input_1 = op1_select==1 ? rs1_data : pc_out ;

wire op2_select;
assign ALU_input_2 = op2_select==1 ? rs2_data : imm_out ;

wire BR_OR_RETURN_select;
//return address or br addr select
assign adder_in_1 = BR_OR_RETURN_select==1 ? imm_out : 32'h00000004 ; 


wire addr_sel;
assign br_jump_addr = addr_sel==1 ? adder_out : ALU_out;




////////////////////////////////////////////////////////////
/////////////////////////MEMORY////////////////////////////
////////////////////////////////////////////////////////////

assign ram_write_data_in = rs2_data ; 
assign ram_addr = ALU_out ;

/////////RAM 

ram_2 uut_ram(
    clk,
    ram_write_data_in,
    ram_write_en,
    ram_type,
    ram_sign,
    ram_addr,
    //ram_dout,
    ram_read_en,
    ram_data_out ,
    o_memory_address_misaligned
    );
    
    

////////////////////////////////////////////////////////////
/////////////////////////WRITEBACK//////////////////////////
////////////////////////////////////////////////////////////
  
    

                                    

/////writeback///

assign rd_writeback = writeback_sel == `WB_RET_ADDR ? adder_out    :
                      writeback_sel == `WB_ALU_OUT  ? ALU_out      :
                      writeback_sel == `WB_LOAD_DATA? ram_data_out : 32'b0 ;












//pc out 
assign o_pc=pc_out;


//instr out 
assign o_inst_data=inst_rom_out;

// reg adress inputs

assign o_rs1_data=rs1_data ;
assign o_rs2_data= rs2_data ;

// select btw load addr  and  rd addr
assign rd_addr= reg_rd_ctrl==1?load_reg_addr : inst_rom_out[11:7]; //ext
// select btw load data and writeback
assign rd_data = reg_rd_ctrl==1?load_reg_data:rd_writeback; //ext

//alu
assign o_ALU_out = ALU_out;
assign o_ALU_br_cond=ALU_br_cond;





//ram
assign o_RAM_data_out = ram_data_out;


//imm gen
assign o_imm_out = imm_out ;
//wb
assign o_rd_writeback = rd_writeback;
assign o_writeback_sel=writeback_sel;

assign o_adder_out = adder_out;
assign o_br_jump_addr = br_addr ;


endmodule


module forwrding(
    input wire [31:0]ID_EX_rs2,
    input wire [31:0]ID_EX_rs1,
    input wire [6:0]Aluop,
    input wire [6:0]EX_MEM_op,
    input wire [6:0]MEM_WB_op,
    input wire [31:0]EX_MEM_rd,
    input wire [31:0]MEM_WB_rd,
    output wire [1:0]forward_rs1,
    output wire [1:0]forward_rs2
    
    );
    //forwarding unit
    assign forward_rs1=(Aluop==EX_MEM_op && (EX_MEM_rd!=5'b0 && EX_MEM_rd==ID_EX_rs1))?2'b10:
                       (Aluop==MEM_WB_op && (MEM_WB_rd!=5'b0  && MEM_WB_rd==ID_EX_rs1))?2'b01:
                       2'b00;
                       
                       
    
   assign forward_rs2=(Aluop==EX_MEM_op && (EX_MEM_rd!=5'b0 && EX_MEM_rd==ID_EX_rs2))?2'b10:
                       (Aluop==MEM_WB_op && (MEM_WB_rd!=5'b0  && MEM_WB_rd==ID_EX_rs1))?2'b01:
                       2'b00;
                      
   
                       
    
    
    
endmodule




module branch_prediction(
input wire [1:0]br_taken,
input wire [6:0]branch_op,
input wire [6:0]Aluop,
output wire branch_bit,
input wire [32:0]cla_adder_out,
output wire [31:0] o_pc
);

//wire [1:0]branch_predict;        /00 01 branch 10 11 branch no            taken =11 not taken =00
//assign branch_predict=branch_pred;
    reg [1:0]br_predict;
    always@(*)
    begin
    if(br_predict==2'b00 && (br_taken==2'b11 || br_taken==2'b01) && branch_op==Aluop)
        br_predict=2'b00;
    else if(br_predict==2'b00 && br_taken==2'b00 && branch_op==Aluop)
        br_predict=2'b01;
     else if(br_predict==2'b01 && br_taken==2'b11 && branch_op==Aluop)
        br_predict=2'b00;
     else if(br_predict==2'b01 && br_taken==2'b00 && branch_op==Aluop)
        br_predict=2'b10;
     else if(br_predict==2'b10 && br_taken==2'b11 && branch_op==Aluop)
        br_predict=2'b01;
     else if(br_predict==2'b10 && br_taken==2'b11 && branch_op==Aluop)
        br_predict=2'b10;
     else if(br_predict==2'b10 && br_taken==2'b00 && branch_op==Aluop)
        br_predict=2'b11;
     else if(br_predict==2'b11 && br_taken==2'b11 && branch_op==Aluop)
        br_predict=2'b10;
     else if(br_predict==2'b11 && br_taken==2'b00 && branch_op==Aluop)
        br_predict=2'b11;
     
     end
    
    always@(*)
    begin
//    if(br_predict==2'b00 || br_predict==2'b01)
//       // =cla_adder_out[31:0];
//    else if(br_predict==2'b10 || br_predict==2'b11)
//         //o_pc=o_pc+4'b0100;
    end
endmodule



module hazard_detection(
input wire [31:0] ID_EX_rd,
input wire [31:0] IF_ID_rs1,
input wire [31:0] IF_ID_rs2,
input wire [6:0]  IF_ID_opcode,
input wire [6:0] opcode,
//input reg [64:0] if_id_reg,
output reg [64:0] ID_EX,
output wire [31:0] pc_out
);
always@(*)
begin
//if(IF_ID_opcode==opcode && ( ID_EX_rd==IF_ID_rs1 || ID_EX_rd==IF_ID_rs2 ))
//  ID_EX[63:0]=64'b0;
  
end 
endmodule 
