package agent;
import sequencer::*;
import seq_item::*;
import driver::*;
import monitor::*;
import myconfig::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALSU_agent extends  uvm_agent;
	`uvm_component_utils(ALSU_agent)
 ALSU_sequencer sqr;
 ALSU_driver driver1;
 ALSU_monitor monitor1;
 alsu_config_obj obj;

 uvm_analysis_port #(ALSU_seq_item) agt_ap;

	function new(string name= "ALSU_agent", uvm_component parent=null);
	 super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(alsu_config_obj)::get(this, "", "INTERFACE",obj))
	 `uvm_fatal("build_phase","unable to get config object")
	sqr=ALSU_sequencer::type_id::create("sqr",this);
	driver1=ALSU_driver::type_id::create("driver1",this);
	monitor1=ALSU_monitor::type_id::create("monitor1",this);
	agt_ap=new("agt_ap",this);
endfunction 

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	driver1.driver_vif=obj.alsu_config_vif;
	monitor1.monitor_vif=obj.alsu_config_vif;
    driver1.driver_golden_vif=obj.alsu_golden_config_vif;
    monitor1.monitor_golden_vif=obj.alsu_golden_config_vif;

	driver1.seq_item_port.connect(sqr.seq_item_export);
	monitor1.mon_ap.connect(agt_ap);
endfunction 
	
endclass : ALSU_agent
endpackage : agent
