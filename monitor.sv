package monitor;
import seq_item::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class ALSU_monitor extends  uvm_monitor;
	`uvm_component_utils(ALSU_monitor)
virtual alsu_if monitor_vif;
virtual alsu_if monitor_golden_vif;
ALSU_seq_item rsp_seq_item;
 uvm_analysis_port #(ALSU_seq_item) mon_ap;

function new(string name= "ALSU_monitor", uvm_component parent=null);
	super.new(name,parent);
endfunction
	
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	mon_ap=new("mon_ap",this);	
endfunction 


task run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
		rsp_seq_item=ALSU_seq_item::type_id::create("rsp_seq_item");
		@(negedge monitor_vif.clk)
		rsp_seq_item.rst=monitor_vif.rst;
		rsp_seq_item.cin=monitor_vif.cin;
		rsp_seq_item.red_op_A=monitor_vif.red_op_A;
		rsp_seq_item.red_op_B=monitor_vif.red_op_B;
		rsp_seq_item.bypass_A=monitor_vif.bypass_A;
		rsp_seq_item.bypass_B=monitor_vif.bypass_B;
		rsp_seq_item.direction=monitor_vif.direction;
		rsp_seq_item.serial_in=monitor_vif.serial_in;
		rsp_seq_item.opcode=monitor_vif.opcode;
		rsp_seq_item.A=monitor_vif.A;
		rsp_seq_item.B=monitor_vif.B;
		rsp_seq_item.leds=monitor_vif.leds;
		rsp_seq_item.out=monitor_vif.out;

        rsp_seq_item.out_golden=monitor_golden_vif.out;
        rsp_seq_item.leds_golden=monitor_golden_vif.leds;
        

		mon_ap.write(rsp_seq_item);
		`uvm_info("run_phase", rsp_seq_item.convert2string_stimulus(),UVM_HIGH)
	end
	
endtask : run_phase

endclass : ALSU_monitor
	
endpackage : monitor