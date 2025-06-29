vlib work
vlog shift_reg.sv top.sv interface.sv enviroment.sv test.sv driver.sv config.sv agent.sv coverage_collector.sv monitor.sv scoreboard.sv seq_item.sv sequence.sv sequencer.sv +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave /top/shiftif/*
run 0
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/my_env/sb/correct_count \
sim:/uvm_root/uvm_test_top/my_env/sb/dataout_ref \
sim:/uvm_root/uvm_test_top/my_env/sb/error_count
run -all 