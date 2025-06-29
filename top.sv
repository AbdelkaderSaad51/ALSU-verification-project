import alsu_test::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module top();
bit clk;

initial begin
	forever
	#1 clk=~clk;
end 


alsu_if alsuif(clk);
alsu_if ALSU_intf_golden(clk);
ALSU DUT(alsuif);
ALSU_Golden DUT2(.clk(ALSU_intf_golden.clk), .rst(ALSU_intf_golden.rst), .cin(ALSU_intf_golden.cin), .red_op_A(ALSU_intf_golden.red_op_A), .red_op_B(ALSU_intf_golden.red_op_B), .bypass_A(ALSU_intf_golden.bypass_A), .bypass_B(ALSU_intf_golden.bypass_B), .direction(ALSU_intf_golden.direction), .serial_in(ALSU_intf_golden.serial_in), .opcode(ALSU_intf_golden.opcode), .A(ALSU_intf_golden.A), .B(ALSU_intf_golden.B), .leds(ALSU_intf_golden.leds), .out(ALSU_intf_golden.out));
initial begin
	uvm_config_db#(virtual alsu_if)::set(null, "uvm_test_top", "INTERFACE",alsuif);
	uvm_config_db#(virtual alsu_if)::set(null, "uvm_test_top", "Golden",ALSU_intf_golden);
	run_test("alsu_test");
end
endmodule 