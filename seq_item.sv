package seq_item;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ALSU_seq_item extends  uvm_sequence_item;
	`uvm_object_utils(ALSU_seq_item)
rand logic  rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
rand bit [2:0] opcode;
rand logic signed [5:0] A, B;
logic [15:0] leds, leds_golden;
logic signed [5:0] out, out_golden;

localparam MAXPOS = 3 , ZERO = 0 , MAXNEG = -4;


function new(string name="ALSU_seq_item");
	super.new(name);
endfunction : new

function string convert2string_stimulus();
	return $sformatf("rst=0b%0b ,cin=0b%0b ,red_op_A=0b%0b , red_op_B=0b%0b ,bypass_A=0b%0b ,bypass_B=0b%0b , direction=0b%0b ,serial_in=0b%0b ,opcode=0b%0b ,A=0b%0b ,B=0b%0b ",rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in , opcode,A ,B);
endfunction

constraint for_reset {
		rst dist {0:/95,1:/5};	
		}


		constraint for_A_and_B{
		//for addition and multiplication
		if (opcode == 3'b010 || opcode == 3'b011){
		A dist {MAXPOS:/25 , ZERO:/25 , MAXNEG:/25 };
		B dist {MAXPOS:/25 , ZERO:/25 , MAXNEG:/25 };	
		}
		
		// for red_op_A
		else if ((opcode == 3'b000 || opcode == 3'b001) && red_op_A==1 ){
		A dist {3'b100:/25 , 3'b010:/25 , 3'b001:/25};
		B == 0 ;	
		}

		// for red_op_B
		else if ((opcode == 3'b000 || opcode == 3'b001) && red_op_B==1){
		B dist {3'b100:/25 , 3'b010:/25 , 3'b001:/25};
		A == 0 ;
		}
		}



		constraint for_opcode {
		opcode dist {[0:5]:/95 , [6:7]:/5 };
		}


		constraint bypasses {
		bypass_A dist {0:/90 , 1:/10};
		bypass_B dist {0:/90 , 1:/10};
		}




endclass : ALSU_seq_item





endpackage : seq_item