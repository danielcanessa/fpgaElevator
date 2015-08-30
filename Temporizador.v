`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:28:49 08/24/2015 
// Design Name: 
// Module Name:    Temporizador 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Temporizador(
	input restart,start_timer,clk,peso_excesivo,bloqueo_activado, //entradas
	output reg t_expired, //salidas
	output reg [6:0] sseg
   );
	
	
	//Estas variables se encargan de realizar la division de frecuencia
	reg[50:0] count;
	reg[1:0] state_reg, state_next;
	reg clk2;
	
	//Estas variables se encargan de verificar el comportamiento del temporizador
	reg[3:0] countValue;
	parameter terminalCount = 5;
	 
	 //divisor de reloj de 100 MHz a 1 Hz
	 always @(posedge clk)
		begin
			if(count == 51'd50_000_000)
				begin
					count<= 0;
					clk2 <= ~clk2;
				end
			else
				begin
					count <= count + 1;
				end
		end
	
	
	//Se encarga del funcionamiento del temporizador
	always@(posedge clk2)
		begin
		t_expired <= 0;
		countValue <= 0;
		sseg[6:0] <= 7'b0000001;
		if(restart)
			countValue <= 0;
			
		else if((peso_excesivo) || (bloqueo_activado))
					sseg[6:0] <= 7'b0000001;
		else 
			begin
				if(start_timer) begin
					if(countValue == terminalCount - 1)
						begin
						t_expired <= 1;
						sseg[6:0] <= 7'b0000110;
						end
					else
						countValue <= countValue + 1;
				   end
				end
			end
			
			
		
				

endmodule
