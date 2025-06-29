package seq;
import seq_item::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALSU_reset_seq extends uvm_sequence #(ALSU_seq_item);
	`uvm_object_utils(ALSU_reset_seq)
	ALSU_seq_item seq_item1;

	function new(string name="ALSU_reset_seq");
	super.new(name);
endfunction : new

task body();
	seq_item1=ALSU_seq_item::type_id::create("seq_item1");
	start_item(seq_item1);
	seq_item1.rst=1;
	seq_item1.cin=0;
	seq_item1.red_op_A=0;
	seq_item1.red_op_B=0;
	seq_item1.bypass_A=0;
	seq_item1.bypass_B=0;
	seq_item1.direction=0;
	seq_item1.serial_in=0;
	seq_item1.opcode=0;
	seq_item1.A=0;
	seq_item1.B=0;
	finish_item(seq_item1);
	endtask : body	
endclass : ALSU_reset_seq


class ALSU_main_seq extends uvm_sequence #(ALSU_seq_item);
	`uvm_object_utils(ALSU_main_seq)
	ALSU_seq_item seq_item1;

	function new(string name="ALSU_reset_seq");
	super.new(name);
endfunction : new

task body();
	repeat(1000)begin
		seq_item1=ALSU_seq_item::type_id::create("seq_item1");
		start_item(seq_item1);
		assert(seq_item1.randomize());
		finish_item(seq_item1);
	end
endtask
	
endclass : ALSU_main_seq
endpackage : seq