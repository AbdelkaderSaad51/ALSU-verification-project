package myenv;
import agent::*;
import scoreboard::*;
import coverage::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class alsu_env extends uvm_env;
`uvm_component_utils(alsu_env)
ALSU_agent agent1;
ALSU_scoreboard sb;
ALSU_coverage cv;

function new(string name= "alsu_env", uvm_component parent=null);
	 super.new(name,parent);
endfunction 

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	agent1=ALSU_agent::type_id::create("agent1",this);
	sb=ALSU_scoreboard::type_id::create("sb",this);
	cv=ALSU_coverage::type_id::create("cv",this);

endfunction 
function void connect_phase(uvm_phase phase);
    agent1.agt_ap.connect(sb.sb_export);
    agent1.agt_ap.connect(cv.cov_export);		
	endfunction

endclass : alsu_env
endpackage : myenv
