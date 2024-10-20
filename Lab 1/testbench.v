module alu_testbench(); 
  reg[31:0] A, B; 
  reg[2:0] control; 
  
  wire[31:0] result; 
  wire zero, overflow, carry, negative; 
  
  reg[31:0] expected_result; 
  reg ex_zero, ex_overflow, ex_carry, ex_negative; 
  reg[31:0] testvector[0:175];
  integer i; 
  
  alu test_unit(
    .a(A), 
    .b(B),
    .f(control),
    .result(result),
    .zero(zero),
    .overflow(overflow),
    .carry(carry), 
    .negative(negative)); 
    
  initial begin
  
    $readmemh("alu.tv", testvector); 
    for(i = 0; i < 175; i = i+8) begin
      control = testvector[i][2:0]; 
      A = testvector[i+1][31:0];
      B = testvector[i+2][31:0];
      expected_result = testvector[i+3][31:0]; 
      ex_zero = testvector[i+4][0]; 
      ex_overflow = testvector[i+5][0];  
      ex_carry = testvector[i+6][0]; 
      ex_negative = testvector[i+7][0];  
      
      #10;
    
      if((result == expected_result) && (zero == ex_zero) && (overflow == ex_overflow) && (carry == ex_carry) && (negative == ex_negative)) begin
        $display("Test passed");  
      end else begin 
        $display("Test failed");
        $display("Inputs - control: %b, A: %h, B: %h", control, A, B);  
        $display("Outputs - result: %h, zero: %b, overflow: %b, carry: %b, negative: %b", result, zero, overflow, carry, negative); 
        $display("Expected - result: %h, zero: %b, overflow: %b, carry: %b, negative: %b", expected_result, ex_zero, ex_overflow, ex_carry, ex_negative);  
      end 
    end
  end
endmodule  
