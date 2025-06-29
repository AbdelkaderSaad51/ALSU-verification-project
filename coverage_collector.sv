package coverage;
import seq_item::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALSU_coverage extends uvm_component;
	`uvm_component_utils(ALSU_coverage)
	uvm_analysis_export #(ALSU_seq_item) cov_export;
	uvm_tlm_analysis_fifo #(ALSU_seq_item) cov_fifo;

	ALSU_seq_item seq_item_coverage;
	localparam MAXPOS = 3 , ZERO = 0 , MAXNEG = -4;

	covergroup cg ;
		A_cp : coverpoint seq_item_coverage.A {
		bins data_0 = {0};
		bins data_max = {MAXPOS};
		bins data_min = {MAXNEG};
		bins data_default = default ;
		bins data_walkingones = {1 , 2 , -4};
		}
		B_cp : coverpoint seq_item_coverage.B {
		bins data_0 = {0};
		bins data_max = {MAXPOS};
		bins data_min = {MAXNEG};
		bins data_default = default ;
		bins data_walkingones = {1 , 2 , -4};
		}
		ALU_cp : coverpoint seq_item_coverage.opcode {
		bins Bins_shift[] = {[4:5]};
		bins Bins_arith[] = {[2:3]};
		bins Bins_bitwise[] = {[0:1]};
		bins Bins_invalid ={6 , 7};
		
		}

		cin_cp : coverpoint seq_item_coverage.cin ;

		shift_in_cp : coverpoint seq_item_coverage.serial_in ;

		direction_cp : coverpoint seq_item_coverage.direction ;

		red_op_A_cp : coverpoint seq_item_coverage.red_op_A;
		red_op_B_cp : coverpoint seq_item_coverage.red_op_B;

		endgroup : cg

	function  new(string name="ALSU_coverage",uvm_component parent=null);
		super.new(name,parent);
		cg=new();
	endfunction : new


	function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	cov_fifo=new("cov_fifo",this);
	cov_export=new("cov_export",this);
endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	cov_export.connect(cov_fifo.analysis_export);
	
endfunction

task run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
		cov_fifo.get(seq_item_coverage);
		cg.sample();
	end
endtask : run_phase
endclass : ALSU_coverage
	
endpackage : coverage