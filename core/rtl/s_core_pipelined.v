`timescale 1ns / 1ps
`include "GLOBALS.v"



module s_core_pipelined(
input wire clk ,
input wire rst_n,

////pc


//input wire[31:0] i_pc_instr_start_addr,


////instr_mem

//input wire[31:0] inst_mem_addr,
//input wire[31:0] inst_mem_data,


////regs

//input wire[4:0] load_reg_addr,
//input wire[31:0] load_reg_data,

//input wire setup,

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
wire[31:0] inst_mem_addr;
wire[31:0] inst_mem_data;
wire[31:0] inst_rom_out;

assign instrom_write_en=0;
assign inst_mem_data =0;
assign inst_mem_addr=0;
///////////////reg///////////////////////
wire[4:0] rs1_addr;
wire[4:0] rs2_addr;
wire[4:0]  rd_addr;
wire[31:0] rd_data;
wire wb_reg_write_en;//ctrl
wire[31:0] rs1_data;
wire[31:0] rs2_data;

wire reg_rd_ctrl;//ctrl
//input wire[4:0] load_reg_addr, //ext
//input wire[31:0] load_reg_data, //ext


/////////////////////imm/////////////////////////

wire[31:0] imm_out;
///////////////////////////////////////predicted branch address adder ////////////////
wire[32:0] cla_branch_pred_out;
wire[31:0] pred_branch_addr;

////////////////////alu/////////////////////////
wire [31:0 ] ALU_input_1;
wire [31:0 ] ALU_input_2;
wire[4:0] ALU_operator;
wire[31:0] ALU_out;
wire ALU_br_cond;

/////////////////////////control////////////////////////
wire BR_OR_RETURN_select;
wire addr_sel;
wire op1_select;
wire op2_select;
wire reg_write_en;//ctrl
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
/////////////////////pipeline wires///////////////////////////////
wire branch_predict;
wire hazard_detection;

///////trap

wire[1:0] trap;



/////////////////////////////pipeline////////////////////////////////////
//////////////stage1///////////////
reg [64:0]if_id_reg;// pc : if_id_reg[63:32]  // instr :if_id_reg[31:0]
wire [64:0]if_wire_value;
assign if_wire_value[64:0]={pc_out[31:0],inst_rom_out[31:0]};
 

/////////////////////////stage2////////////////////
reg [182:0]id_ex_reg; //id_ex_reg[63:32]  // instr :id_ex_reg[31:0] // rs1_data :id_ex_reg[:64]
wire [182:0]id_wire_value;
wire [21:0]id_control_values={wb_reg_write_en,ALU_operator[4:0],reg_write_en,br_type[1:0],ram_write_en ,ram_read_en ,ram_type[3:0],ram_sign,op1_select,op2_select,BR_OR_RETURN_select,addr_sel,writeback_sel[1:0]};
assign id_wire_value[182:0]={imm_out,id_control_values[21:0],branch_predict,rs2_data[31:0],rs1_data[31:0],if_id_reg[63:32],if_id_reg[31:0]};

///////////////////////stage3////////////////////
reg [169:0]ex_mem_reg;
wire [169:0]ex_wire_value;
wire [9:0]ex_control_values={id_ex_reg[150],id_ex_reg[141] ,id_ex_reg[140] ,id_ex_reg[139:136],id_ex_reg[135],id_ex_reg[130:129]};
assign ex_wire_value[169:0]={ex_control_values[9:0],adder_out[31:0],ALU_out[31:0],id_ex_reg[127:96],id_ex_reg[63:32],id_ex_reg[31:0]};


 
 //////////////////////////////////stage4/////////////////////
 reg [162:0]mem_wb_reg;
 wire[162:0]mem_wire_value;
 assign mem_wire_value[162:0]={ex_mem_reg[127:96],ex_mem_reg[169],ex_mem_reg[161:160],ex_mem_reg[159:128],ram_data_out[31:0],ex_mem_reg[63:32],ex_mem_reg[31:0]};
  



///trap handeling
assign trap = o_memory_address_misaligned==1 ? `MEM_MISALIGN:
              inst_rom_out[6:2] == 5'b11100 && inst_rom_out[14:12]==3'b000 && inst_rom_out[31:20]==12'b000000000000 ?`E_CALL :
              inst_rom_out[6:2] == 5'b11100 && inst_rom_out[14:12]==3'b000 && inst_rom_out[31:20]==12'b000000000001 ?`E_BREAK :2'b11;

////////////////////////////////////////////////////////////
///////////////////instruction fetch///////////////////////
///////////////////////////////////////////////////////////


//pc//////////////////////////////////


pc uut_pc (clk,
        rst_n,
//        i_pc_stall,
        trap,
        i_pc_is_branch_true,
        i_pc_branch_addr,
//        i_pc_writing_first_addr,
//        i_pc_instr_start_addr,
        pc_out
//        o_branch_address_misaligned
);







//instr mem//////////////////////////////////

inst_ram1 uut_inst(
clk,
instrom_pc_in,
//instrom_read_en,//CTRL
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



//reg//////////////////////////////


regs uut_reg (clk,
            rst_n,
            rs1_addr,
            rs2_addr,
            rd_addr,
            rd_data,
            wb_reg_write_en,
            rs1_data,
            rs2_data);
assign wb_reg_write_en = mem_wb_reg[130];
assign rs1_addr=if_id_reg[19:15];
assign rs2_addr=if_id_reg[24:20];

assign rd_addr=if_id_reg[11:7]; 

assign rd_data = rd_writeback; 

//IMM GEN/////////////////////////////////


IMM_OP uut_imm_gen (if_id_reg[31:0],imm_out);

///////////////////////////////////////predicted branch address adder ////////////////
//wire[32:0] cla_branch_pred_out;   already declared
//wire[31:0] pred_branch_addr;
carry_lookahead_adder uut_adder2(.i_add1(imm_out),.i_add2(if_id_reg[63:32]),.o_result(cla_branch_pred_out));
assign pred_branch_addr=cla_branch_pred_out[31:0];


//Ctrl

//input wire setup

control uut_ctrl ( 
if_id_reg[31:0],
//setup,
ALU_operator,
reg_write_en,
//instrom_write_en,
//instrom_read_en,
br_type,
//i_pc_stall,
//i_pc_writing_first_addr,
ram_write_en ,
ram_read_en ,
ram_type,
ram_sign,
op1_select,
op2_select,
BR_OR_RETURN_select,
addr_sel,
writeback_sel
//reg_rd_ctrl
 );


////////////////////////////////////////////////////////////
/////////////////////////EXECUTE////////////////////////////
////////////////////////////////////////////////////////////


//ALU//////////////////////////////
                                //ALU op
alu uut_alu(.i_alu_operator(id_ex_reg[149:145]),.i_alu_operand_1(ALU_input_1),.i_alu_operand_2(ALU_input_2),.o_alu_output(ALU_out),.o_alu_br_cond(ALU_br_cond));





// Adder //////////////////

                                                               //pc
carry_lookahead_adder uut_adder1(.i_add1(adder_in_1),.i_add2(id_ex_reg[63:32]),.o_result(cla_adder_out));



assign adder_out=cla_adder_out[31:0];







////BRANCH////////////////////////////////////
                                                 //br_type
branch uut_branch (br_cond_in , br_jump_addr , id_ex_reg[143:142] ,br_is_branching, br_addr) ;

//branch assigns
assign br_cond_in = ALU_br_cond;

assign i_pc_is_branch_true = br_is_branching;
assign i_pc_branch_addr = br_addr; 

///////muxes//////////////////////////////////

wire [1:0]forward_mux1;
wire [1:0]forward_mux2;
wire [31:0]mux1_output;
wire [31:0]mux2_output;
                                            //rs1                //pc
assign mux1_output = id_ex_reg[134]==1 ? id_ex_reg[95:64] : id_ex_reg[63:32] ;
assign ALU_input_1=(forward_mux1==2'b00)?mux1_output:
                   (forward_mux1==2'b10)?ex_mem_reg[127:96]:
                   (forward_mux1==2'b01)?rd_writeback:
                   (forward_mux1==2'b11)?ex_mem_reg[159:128]
                                         :32'b0;


                                    //rs2                   //imm out
assign mux2_output = id_ex_reg[133]==1 ? id_ex_reg[127:96] : id_ex_reg[182:150] ;
assign ALU_input_2=(forward_mux2==2'b00)?mux2_output:
                   (forward_mux2==2'b10)?ex_mem_reg[95:64]:
                   (forward_mux2==2'b01)?rd_writeback:
                   (forward_mux2==2'b11)?ex_mem_reg[191:160]
                                         :32'b0;




//return address or br addr select
assign adder_in_1 = id_ex_reg[132]==1 ? id_ex_reg[182:150] : 32'h00000004 ; 



assign br_jump_addr = id_ex_reg[131]==1 ? adder_out : ALU_out;




////////////////////////////////////////////////////////////
/////////////////////////MEMORY////////////////////////////
////////////////////////////////////////////////////////////

assign ram_write_data_in = ex_mem_reg[95:64] ; 
assign ram_addr = ex_mem_reg[127:96] ;

/////////RAM 

ram_2 uut_ram(
    clk,
    ram_write_data_in,
    ex_mem_reg[168],//writeen
    ex_mem_reg[166:163],//type
    ex_mem_reg[162],//sign
    ram_addr,
    //ram_dout,
    ex_mem_reg[167],//read en
    ram_data_out ,
    o_memory_address_misaligned
    );
    
    

////////////////////////////////////////////////////////////
/////////////////////////WRITEBACK//////////////////////////
////////////////////////////////////////////////////////////
  
    

                                    

/////writeback///

assign rd_writeback = mem_wb_reg[129:128] == `WB_RET_ADDR ? mem_wb_reg[127:96]    ://ret addr adder_out
                     mem_wb_reg[129:128] == `WB_ALU_OUT  ? mem_wb_reg[162:131]     :
                      mem_wb_reg[129:128] == `WB_LOAD_DATA? mem_wb_reg[95:64] : 32'b0 ;












//pc out 
assign o_pc=pc_out;


//instr out 
assign o_inst_data=inst_rom_out;

// reg adress inputs

assign o_rs1_data=rs1_data ;
assign o_rs2_data= rs2_data ;




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





//pipelining
always@(posedge clk,negedge rst_n)
begin
    if (rst_n==0)
    begin
        if_id_reg<=0;
        id_ex_reg<=0;
        ex_mem_reg<=0;
        mem_wb_reg<=0;
        
    end
    else if(hazard_detection)
        begin
        id_ex_reg<=0;
        if_id_reg<=if_id_reg;
        end
    //if(branch_predict)
        //begin
        //o_pc=cla_adder_out;
      else if(branch_predict)
            begin
            //pc_wire
            end
      else if(id_ex_reg[181]==0 && br_is_branching==1'b1 && id_ex_reg[6:0]==`OPCODE_BRANCH )
            begin
            id_ex_reg<=0;
            //pc
            end
      else if(id_ex_reg[181]==1 && br_is_branching==1'b0 && id_ex_reg[6:0]==`OPCODE_BRANCH )
            begin
            id_ex_reg<=0;
            //pc=id_ex_reg[63:32]+4'b0100;
            end
          else
            begin
            if_id_reg<=if_wire_value;
            id_ex_reg<=id_wire_value;
            end
         ex_mem_reg<=ex_wire_value;
         mem_wb_reg<=mem_wire_value;
         

end
endmodule



module forwrding(
    input wire [4:0]ID_EX_rs2,
    input wire [4:0]ID_EX_rs1,
    input wire  [6:0]ex_mem_opcode,
    input wire  ex_mem_REG_write_en,
    input wire  mem_wb_REG_write_en,
    input wire [31:0]ex_mem_Alu_out,
    input wire [31:0] mem_wb_out,
    input wire [4:0]EX_MEM_rd,
    input wire [4:0]MEM_WB_rd,
    output wire [1:0]forward_mux1,
    output wire [1:0]forward_mux2
    
    );
    //forwarding unit
    assign forward_mux1=(ex_mem_REG_write_en==1'b1 && EX_MEM_rd!=5'b0 && ex_mem_opcode==`OPCODE_OP || ex_mem_opcode==`OPCODE_OP_IMM  && EX_MEM_rd==ID_EX_rs1 )?2'b10:
                       (mem_wb_REG_write_en==1'b1  &&  MEM_WB_rd!=5'b0 &&  MEM_WB_rd==ID_EX_rs1)?2'b01:
                       (ex_mem_REG_write_en==1'b1 && MEM_WB_rd!=5'b0 &&  ex_mem_opcode==`OPCODE_JAL || ex_mem_opcode==`OPCODE_JALR && MEM_WB_rd==ID_EX_rs1 )?2'b11:
                       2'b00;
                       
                       
    
   assign forward_mux2=(ex_mem_REG_write_en==1'b1 && EX_MEM_rd!=5'b0 && ex_mem_opcode==`OPCODE_OP || ex_mem_opcode==`OPCODE_OP_IMM  && EX_MEM_rd==ID_EX_rs2 )?2'b10:
                       (mem_wb_REG_write_en==1'b1  &&  MEM_WB_rd!=5'b0 &&  MEM_WB_rd==ID_EX_rs2)?2'b01:
                       (ex_mem_REG_write_en==1'b1 && MEM_WB_rd!=5'b0 &&  ex_mem_opcode==`OPCODE_JAL || ex_mem_opcode==`OPCODE_JALR && MEM_WB_rd==ID_EX_rs2 )?2'b11:
                       2'b00;
                      

endmodule




module branch_prediction(
input wire [1:0]br_taken,
input wire [6:0]branch_op,
input wire [6:0]Aluop,
output wire branch_bit,
output wire  branch_predict
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
    
    assign branch_predict=(br_predict==2'b00 || br_predict==2'b01)?1'b1:1'b0;
                          
//    if(br_predict==2'b00 || br_predict==2'b01)
//       // =cla_adder_out[31:0];
//    else if(br_predict==2'b10 || br_predict==2'b11)
//         //o_pc=o_pc+4'b0100;
//    end
endmodule






module hazard_detection(
input wire [31:0] ID_EX_rd,
input wire [31:0] IF_ID_rs1,
input wire [31:0] IF_ID_rs2,
input wire [6:0]  IF_ID_opcode,
input wire [6:0] opcode,
output reg [64:0] ID_EX,
output wire  hazard_detection
);

assign hazard_detection=(IF_ID_opcode==opcode && ( ID_EX_rd==IF_ID_rs1 || ID_EX_rd==IF_ID_rs2 ))?1'b1:1'b0;
     
endmodule 


