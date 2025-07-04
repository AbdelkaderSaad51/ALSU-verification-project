module ALSU(alsu_if alsuif);
parameter INPUT_PRIORITY = "alsuif.A";
parameter FULL_ADDER = "ON";


reg cin_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
reg [2:0] opcode_reg;
reg signed[5:0] A_reg , B_reg;

wire invalid_red_op, invalid_opcode, invalid;

assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & (opcode_reg[1] | opcode_reg[2]);
assign invalid_opcode = opcode_reg[1] & opcode_reg[2];
assign invalid = invalid_red_op | invalid_opcode;

always @(posedge alsuif.clk or posedge alsuif.rst) begin
  if(alsuif.rst) begin
     cin_reg <= 0;
     red_op_B_reg <= 0;
     red_op_A_reg <= 0;
     bypass_B_reg <= 0;
     bypass_A_reg <= 0;
     direction_reg <= 0;
     serial_in_reg <= 0;
     opcode_reg <= 0;
     A_reg <= 0;
     B_reg <= 0;
  end else begin
     cin_reg <= alsuif.cin;
     red_op_B_reg <= alsuif.red_op_B;
     red_op_A_reg <= alsuif.red_op_A;
     bypass_B_reg <= alsuif.bypass_B;
     bypass_A_reg <= alsuif.bypass_A;
     direction_reg <= alsuif.direction;
     serial_in_reg <= alsuif.serial_in;
     opcode_reg <= alsuif.opcode;
     A_reg <= alsuif.A;
     B_reg <= alsuif.B;
  end
end

always @(posedge alsuif.clk or posedge alsuif.rst) begin
  if(alsuif.rst) begin
     alsuif.leds <= 0;
  end else begin
      if (invalid)
        alsuif.leds <= ~alsuif.leds;
      else
        alsuif.leds <= 0;
  end
end

always @(posedge alsuif.clk or posedge alsuif.rst) begin
  if(alsuif.rst) begin
    alsuif.out <= 0;
  end
  else begin
    if (invalid) 
        alsuif.out <= 0;
    else if (bypass_A_reg && bypass_B_reg)
      alsuif.out <= (INPUT_PRIORITY == "alsuif.A")? A_reg: B_reg;
    else if (bypass_A_reg)
      alsuif.out <= A_reg;
    else if (bypass_B_reg)
      alsuif.out <= B_reg;
    else begin
        case (opcode_reg)
          3'h0: begin 
            if (red_op_A_reg && red_op_B_reg)
              alsuif.out = (INPUT_PRIORITY == "alsuif.A")? |A_reg: |B_reg;
            else if (red_op_A_reg) 
              alsuif.out <= |A_reg;
            else if (red_op_B_reg)
              alsuif.out <= |B_reg;
            else 
              alsuif.out <= A_reg | B_reg;
          end
          3'h1: begin
            if (red_op_A_reg && red_op_B_reg)
              alsuif.out <= (INPUT_PRIORITY == "alsuif.A")? ^A_reg: ^B_reg;
            else if (red_op_A_reg) 
              alsuif.out <= ^A_reg;
            else if (red_op_B_reg)
              alsuif.out <= ^B_reg;
            else 
              alsuif.out <= A_reg ^ B_reg;
          end
          3'h2: alsuif.out <= A_reg + B_reg + cin_reg;
          3'h3: alsuif.out <= A_reg * B_reg;
          3'h4: begin
            if (direction_reg)
              alsuif.out <= {alsuif.out[4:0], serial_in_reg};
            else
              alsuif.out <= {serial_in_reg, alsuif.out[5:1]};
          end
          3'h5: begin
            if (direction_reg)
              alsuif.out <= {alsuif.out[4:0], alsuif.out[5]};
            else
              alsuif.out <= {alsuif.out[0], alsuif.out[5:1]};
          end
        endcase
    end 
  end
end

endmodule