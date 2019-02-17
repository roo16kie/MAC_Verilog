
`define DATA_NUM 249
`define CYCLE 10
`define PATTERN "pattern_in.txt"
`define EXPECT "out_answer.txt"
`timescale 1ns/10ps

module mac_tb ;

reg [3:0] in_a ,in_b ; 
reg in_valid_a,in_valid_b;
reg clk,reset ;
reg [3:0]count;
wire [10:0] mac_out ;

wire out_valid ;

reg [9:0]pattern_in[0:`DATA_NUM-1] ;

reg [10:0]ans[0:9] ;

/* 
reg out_valid_exp ;

reg [10:0] mac_out_exp ; */

mac u_mac (	.mac_out(mac_out),
			.out_valid(out_valid),
			.in_a(in_a),
			.in_b(in_b),
			.in_valid_a(in_valid_a),
			.in_valid_b(in_valid_b),
			.clk(clk),
			.reset(reset)
) ;

always begin #(`CYCLE/2) clk=~clk ; end  //clock generation

initial begin
$readmemb(`PATTERN,pattern_in) ;
$readmemb(`EXPECT,ans) ;
end


integer i ,err ,check;

initial begin
clk=1'b0 ;
err=0 ;
check=0;
count=0;
@(negedge clk) reset=1'b1 ;
#(`CYCLE*2) reset=1'b0 ;

@(negedge clk) ;

  for(i=0;i<`DATA_NUM;i=i+1) begin
    {in_a,in_b,in_valid_a,in_valid_b}=pattern_in[i] ;
//    {mac_out_exp,out_valid_exp}=ans[i] ;
    @(negedge clk) ;
//@(posedge clk) ;
    if(out_valid) 
	begin
	
		if(mac_out==ans[count])

			check=check+1;

		else begin
			err=err+1;
			$display($time,"Error at in_a=%b, in_b=%b, in_valid_a=%b, in_valid_b=%b",in_a,in_b,in_valid_a,in_valid_b) ;
			$display($time,"Expect   : mac_out=%b",ans[count]) ;
    		$display($time,"Your ans : mac_out=%b\n\n",mac_out) ;	
		end
		count = count+1;
    end
  end
end


initial
begin
   $dumpfile("mac.vcd");
   $dumpvars;
end


initial begin

#(`CYCLE*255) ;
if(err==0&&check==10) 
begin
$display("-------------------   mac check successfully   -------------------");
$display("            $$              ");
$display("           $  $");
$display("           $  $");
$display("          $   $");
$display("         $    $");
$display("$$$$$$$$$     $$$$$$$$");
$display("$$$$$$$              $");
$display("$$$$$$$              $");
$display("$$$$$$$              $");
$display("$$$$$$$              $");
$display("$$$$$$$              $");
$display("$$$$$$$$$$$$         $$");
$display("$$$$$      $$$$$$$$$$");
end
else if((err==0)&&(check!=10)) begin
$display("-----------   Oops! Something wrong with your code!   ------------");
end
else $display("-------------------   There are %d errors   -------------------", err);

$finish ;

end

endmodule




