`timescale 1ns / 1ps

module RegistroSolicitudes(
		input wire clk,reset,

		input wire solicitud,pisoSolicitante,pisoActual,estadoAscensor,registroPiso,
		output reg [6:0] sseg,
		output reg [1:0] registroSalida
    );
	 
	 localparam[1:0] e0 = 2'b00,
						  e1 = 2'b01,
						  e2 = 2'b10,
						  e3 = 2'b11;
						  
	 reg[50:0] count;
	 reg[1:0] state_reg, state_next;
	 reg clk2;
	 
	 //initial begin state_reg = registroPiso;	 end			
	 
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
		
	//registra estado
	always @(posedge clk2, posedge reset)
		if(reset)
			state_reg <= registroPiso;
		else
			state_reg <= state_next;
			
	//proximo estado
	always @(posedge clk2) // la maquina de estados cambia en la transicion de clk2
		case(state_reg)
			e0: if(solicitud == 1'b1)
					begin	
//						sseg[6:0] <= 7'b1001111;
						state_next = e1;
						registroSalida <= 2'b01;
						
					end
				else if((pisoSolicitante == pisoActual) )
					begin
					//	sseg[6:0] <= 7'b1001111;
						state_next = e2;
						registroSalida <= 2'b10;
						
					end
			e1: if((pisoSolicitante == pisoActual) && (estadoAscensor == 1'b1) )
					begin	
				//		sseg[6:0] <= 7'b0010010;
						state_next = e0;
						registroSalida <= 2'b00;
					end
					
				 else if((pisoSolicitante == pisoActual) && (estadoAscensor == 1'b0) )
					begin
			//			sseg[6:0] <= 7'b1001111;
						state_next = e3;
						registroSalida <= 2'b11;
						
					end
				
			e2: if(solicitud == 1'b0)
					begin	
			//			sseg[6:0] <= 7'b0000110;
						state_next = e0;
						registroSalida <= 2'b00;
						
					end
				 else if(solicitud == 1'b1)
					begin
			//			sseg[6:0] <= 7'b0010010;
						state_next = e3;
						registroSalida <= 2'b11;
					end
				
					
			e3: if(solicitud == 1'b0)
					begin	
				//		sseg[6:0] <= 7'b0000001;
						state_next = e1;
						registroSalida <= 2'b01;
						
					end
					
				else if(pisoSolicitante == pisoActual)
					begin
			//			sseg[6:0] <= 7'b0010010;
						state_next = e2;
						registroSalida <= 2'b10;
					end
						
		endcase

endmodule

    
