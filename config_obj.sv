package myconfig;
import uvm_pkg::*;
`include "uvm_macros.svh"
	class alsu_config_obj extends uvm_object;
	`uvm_object_utils(alsu_config_obj)

    
	function new(string name="alsu_config_obj");
		super.new(name);
	endfunction : new
 

 virtual alsu_if alsu_config_vif;
 virtual alsu_if alsu_golden_config_vif;
endclass : alsu_config_obj
endpackage : myconfig



