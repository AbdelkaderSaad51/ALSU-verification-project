package driver;
import seq_item::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ALSU_driver extends  uvm_driver #(ALSU_seq_item);
	`uvm_component_utils(ALSU_driver)
	virtual alsu_if driver_vif;
	virtual alsu_if driver_golden_vif;
	ALSU_seq_item stim_seq_item;

	function new(string name= "ALSU_driver", uvm_component parent=null);
	 super.new(name,parent);
endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
		stim_seq_item=ALSU_seq_item::type_id::create("stim_seq_item");
		seq_item_port.get_next_item(stim_seq_item);
		driver_vif.rst=stim_seq_item.rst;
		driver_vif.cin=stim_seq_item.cin;
		driver_vif.red_op_A=stim_seq_item.red_op_A;
		driver_vif.red_op_B=stim_seq_item.red_op_B;
		driver_vif.bypass_A=stim_seq_item.bypass_A;
		driver_vif.bypass_B=stim_seq_item.bypass_B;
		driver_vif.direction=stim_seq_item.direction;
		driver_vif.serial_in=stim_seq_item.serial_in;
		driver_vif.opcode=stim_seq_item.opcode;
		driver_vif.A=stim_seq_item.A;
		driver_vif.B=stim_seq_item.B;


        driver_golden_vif.rst=stim_seq_item.rst;
		driver_golden_vif.cin=stim_seq_item.cin;
		driver_golden_vif.red_op_A=stim_seq_item.red_op_A;
		driver_golden_vif.red_op_B=stim_seq_item.red_op_B;
		driver_golden_vif.bypass_A=stim_seq_item.bypass_A;
		driver_golden_vif.bypass_B=stim_seq_item.bypass_B;
		driver_golden_vif.direction=stim_seq_item.direction;
		driver_golden_vif.serial_in=stim_seq_item.serial_in;
		driver_golden_vif.opcode=stim_seq_item.opcode;
		driver_golden_vif.A=stim_seq_item.A;
		driver_golden_vif.B=stim_seq_item.B;
        




		@(negedge driver_vif.clk);
		seq_item_port.item_done();
		`uvm_info("run_phase", stim_seq_item.convert2string_stimulus(),UVM_HIGH)
	end
endtask : run_phase
endclass : ALSU_driver	
endpackage : driver