
module alu(input [31:0] a, b, 
           input [2:0] f, 
           output [31:0] result, 
           output zero, 
           output overflow, 
           output carry, 
           output negative); 
           
          wire [31:0] adder_b; 
          wire [31:0] and_result; 
          wire [31:0] or_result; 
          wire [31:0] sum; 
          wire [31:0]slt; 
          wire cout; 
          
          assign adder_b = f[0] ? ~b : b;  
          assign and_result = a & b; 
          assign or_result = a | b; 
          assign {cout, sum} = a + adder_b + f[0]; 
          assign slt[31:1] = 0; 
          assign slt[0] = overflow ^ sum[31]; 
          
          assign result = (f[2] & f[0]) ? slt : (f[1] ? (f[0]? or_result : and_result) : (f[0]? sum : sum)); 
          assign zero = &(~result); 
          assign overflow = (~(f[0] ^ b[31] ^ a[31]) & (a[31] ^ sum[31]) & (~f[1])); 
          assign carry = (~f[1] & ~f[2]) & cout; 
          assign negative = result[31];
endmodule
