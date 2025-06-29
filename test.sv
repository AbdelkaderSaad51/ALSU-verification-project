package alsu_test;
import seq::*;
import myenv::*;
import myconfig::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class alsu_test extends uvm_test;
`uvm_component_utils(alsu_test)

alsu_env this_enviroment;
alsu_config_obj alsu_config_obj_test;
ALSU_reset_seq reset_seq;
ALSU_main_seq main_seq;

function new(string name="alsu_test",uvm_component parent=null);
	  super.new(name,parent);
endfunction 

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
    this_enviroment=alsu_env::type_id::create("this_enviroment",this);
    alsu_config_obj_test=alsu_config_obj::type_id::create("alsu_config_obj",this);
    main_seq=ALSU_main_seq::type_id::create("main_seq");
    reset_seq=ALSU_reset_seq::type_id::create("reset_seq");


    if(!uvm_config_db#(virtual alsu_if)::get(this, "", "INTERFACE",alsu_config_obj_test.alsu_config_vif))
    `uvm_fatal("build_phase","TEST - unable to get the VF from the uvm_config_db")

    uvm_config_db#(alsu_config_obj)::set(this, "*", "INTERFACE",alsu_config_obj_test);

    if(!uvm_config_db#(virtual alsu_if)::get(this, "", "Golden", alsu_config_obj_test.alsu_golden_config_vif ))
    `uvm_fatal("build_phase","TEST - unable to get the VF from the uvm_config_db")

    uvm_config_db#(alsu_config_obj)::set(this, "*", "Golden", alsu_config_obj_test);
endfunction : build_phase


task run_phase(uvm_phase phase);
	super.run_phase(phase);
	phase.raise_objection(this);
	`uvm_info("run_phase","Reset asserted",UVM_LOW);
    reset_seq.start(this_enviroment.agent1.sqr);
    `uvm_info("run_phase","Stimulus Generation Started",UVM_LOW);
    main_seq.start(this_enviroment.agent1.sqr);
    phase.drop_objection(this);
endtask : run_phase

endclass : alsu_test
endpackage 













