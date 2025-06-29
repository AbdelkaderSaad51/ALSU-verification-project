package scoreboard;
import seq_item::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALSU_scoreboard extends  uvm_scoreboard;
	`uvm_component_utils(ALSU_scoreboard)
	uvm_analysis_export #(ALSU_seq_item) sb_export;
	uvm_tlm_analysis_fifo #(ALSU_seq_item) sb_fifo;
    ALSU_seq_item seq_item_sb;
    
    // virtual alsu_if golden_intf;
    int error_count=0; int correct_count=0;

    function  new(string name="ALSU_scoreboard",uvm_component parent=null);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sb_fifo=new("sb_fifo",this);
		sb_export=new("sb_export",this);
		seq_item_sb=ALSU_seq_item::type_id::create("seq_item_sb");	
	endfunction 


	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		sb_export.connect(sb_fifo.analysis_export);
	endfunction 

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			sb_fifo.get(seq_item_sb);
			
			if(seq_item_sb.out != seq_item_sb.out_golden || seq_item_sb.leds != seq_item_sb.leds_golden    )begin
				`uvm_error("run_phase",$sformatf("comparison failed,Transaction received by the Dut:%s while the refernce out:0b%b",seq_item_sb.convert2string_stimulus(), seq_item_sb.out_golden));
		         error_count++;
	end
             else begin
	         `uvm_info("run_phase",$sformatf("correct alu out:%s", seq_item_sb.convert2string_stimulus()),UVM_HIGH);
	           correct_count++;
    end
			
	end
	endtask : run_phase
	
	
endclass : ALSU_scoreboard
	
endpackage : scoreboard