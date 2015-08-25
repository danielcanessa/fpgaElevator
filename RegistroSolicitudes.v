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










Version 2
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:34:31 08/24/2015 
// Design Name: 
// Module Name:    RegistroSolicitudes 
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
module RegistroSolicitudes(
		input wire clk,reset,
		input wire solicitud,estadoAscensor,
		input wire [2:0] pisoSolicitante,
		input wire [2:0] pisoActual,
		input wire [1:0] registroPiso,
		output reg [6:0] sseg,
		output reg [3:0] an,
		output reg [1:0] registroSalida
    );
	 
	 localparam[1:0] e0 = 2'b00,
						  e1 = 2'b01,
						  e2 = 2'b10,
						  e3 = 2'b11;
						  
	 reg[50:0] count;
	 reg[1:0] state_reg, state_next;
	 reg clk2;
	 
	 initial begin state_reg = registroPiso;	end			
	 

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
			
			
	always @(registroSalida)
		begin
			an[3:0] <= 4'b1110;				
			if(registroSalida==e0) begin
				sseg[6:0] <= 7'b0000001;		
			end
			else if (registroSalida==e1) begin
				sseg[6:0] <= 7'b1001111;		
			end
			else if (registroSalida==e2) begin
				sseg[6:0] <= 7'b0010010;		
			end
			else begin
				sseg[6:0] <= 7'b0000110;		
			end
		end
		
	always @(state_reg)
		begin
			an[3:0] <= 4'b1110;				
			if(state_reg==e0) begin
				registroSalida <= 2'b00;		
			end
			else if (state_reg==e1) begin
				registroSalida <= 2'b01;		
			end
			else if (state_reg==e2) begin
				registroSalida <= 2'b10;		
			end
			else begin
				registroSalida <= 2'b11;		
			end
		end

	
	//proximo estado
	always @(posedge clk2) // la maquina de estados cambia en la transicion de clk2
		case(state_reg)
			e0: if(solicitud == 1'b1)
					begin	
//						sseg[6:0] <= 7'b1001111;
						state_next = e1;
						
						
					end
				else if(pisoSolicitante == pisoActual & estadoAscensor==0) //Tener cuidado con que con este caso la puerta del ascensor se debe de abrir
					begin
					//	sseg[6:0] <= 7'b1001111;
						state_next = e2;
												
					end
				else 
					begin
						state_next = e0;
										
					end					
			e1: if(pisoSolicitante == pisoActual & estadoAscensor == 1'b1)
					begin	
				//		sseg[6:0] <= 7'b0010010;
						state_next = e0;
					
					end
					
				 else if(pisoSolicitante == pisoActual & estadoAscensor == 1'b0)
					begin
			//			sseg[6:0] <= 7'b1001111;
						state_next = e3;
						
						
					end
				 else 
					begin
						state_next = e1;
												
					end	
					
			e2: if(solicitud == 1'b0)
					begin	
			//			sseg[6:0] <= 7'b0000110;
						state_next = e0;
						
						
					end
				 else if(solicitud == 1'b1)
					begin
			//			sseg[6:0] <= 7'b0010010;
						state_next = e3;
						
					end
				else 
					begin
						state_next = e2;
													
					end						
			e3: if(solicitud == 1'b0)
					begin	
				//		sseg[6:0] <= 7'b0000001;
						state_next = e1;
						
						
					end
					
				else if(pisoSolicitante == pisoActual & estadoAscensor == 1'b1)
					begin
			//			sseg[6:0] <= 7'b0010010;
						state_next = e2;
						
					end
				else 
					begin
						state_next = e3;
													
					end		
						
		endcase

endmodule

    



Version 2

module RegistroSolicitudes(
		input wire clk,reset,
		input wire cambiarEstadoAscensor,bajar,subir,
		input wire [2:0] pisoSolicitante,
		input wire [2:0] pisoActual,
		input wire [1:0] registroPiso,
		output reg [6:0] sseg,
		output reg [3:0] an,
		output reg [1:0] registroSalida
    );
	 
	 localparam[1:0] e0 = 2'b00,
						  e1 = 2'b01,
						  e2 = 2'b10,
						  e3 = 2'b11;
						  
	 reg[50:0] count;
	 reg[1:0] state_reg, state_next;
	 reg clk2;
	 reg  solicitud;
	 reg estadoAscensor;
	 
	 initial begin state_reg = registroPiso;	end			
	 
	 always @(posedge cambiarEstadoAscensor)
		begin	
			if(estadoAscensor == 1'b1)
				estadoAscensor <= 1'b0;
			else
				estadoAscensor <= 1'b1;
		end
			
	 always @(subir, bajar)
		begin		
			if(subir==1)			
				begin			
					solicitud <= 1'b1;
				end	
			else if (bajar==1)
				begin 
					solicitud <= 1'b0;
				end			
		end
	
		
		
		
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
			
			
	always @(registroSalida)
		begin
			an[3:0] <= 4'b1110;				
			if(registroSalida==e0) begin
				sseg[6:0] <= 7'b0000001;		
			end
			else if (registroSalida==e1) begin
				sseg[6:0] <= 7'b1001111;		
			end
			else if (registroSalida==e2) begin
				sseg[6:0] <= 7'b0010010;		
			end
			else begin
				sseg[6:0] <= 7'b0000110;		
			end
		end
		
	always @(state_reg)
		begin
			an[3:0] <= 4'b1110;				
			if(state_reg==e0) begin
				registroSalida <= 2'b00;		
			end
			else if (state_reg==e1) begin
				registroSalida <= 2'b01;		
			end
			else if (state_reg==e2) begin
				registroSalida <= 2'b10;		
			end
			else begin
				registroSalida <= 2'b11;		
			end
		end

	
	//proximo estado
	always @(posedge clk2) // la maquina de estados cambia en la transicion de clk2
		case(state_reg)
			e0: if(solicitud == 1'b1)
					begin	
//						sseg[6:0] <= 7'b1001111;
						state_next = e1;
						
						
					end
				else if(pisoSolicitante == pisoActual & estadoAscensor==0) //Tener cuidado con que con este caso la puerta del ascensor se debe de abrir
					begin
					//	sseg[6:0] <= 7'b1001111;
						state_next = e2;
												
					end
				else 
					begin
						state_next = e0;
										
					end					
			e1: if(pisoSolicitante == pisoActual & estadoAscensor == 1'b1)
					begin	
				//		sseg[6:0] <= 7'b0010010;
						state_next = e0;
					
					end
					
				 else if(pisoSolicitante == pisoActual & estadoAscensor == 1'b0)
					begin
			//			sseg[6:0] <= 7'b1001111;
						state_next = e3;
						
						
					end
				 else 
					begin
						state_next = e1;
												
					end	
					
			e2: if(solicitud == 1'b0)
					begin	
			//			sseg[6:0] <= 7'b0000110;
						state_next = e0;
						
						
					end
				 else if(solicitud == 1'b1)
					begin
			//			sseg[6:0] <= 7'b0010010;
						state_next = e3;
						
					end
				else 
					begin
						state_next = e2;
													
					end						
			e3: if(solicitud == 1'b0)
					begin	
				//		sseg[6:0] <= 7'b0000001;
						state_next = e1;
						
						
					end
					
				else if(pisoSolicitante == pisoActual & estadoAscensor == 1'b1)
					begin
			//			sseg[6:0] <= 7'b0010010;
						state_next = e2;
						
					end
				else 
					begin
						state_next = e3;
													
					end		
						
		endcase

endmodule


----------------------------------------------------------------

## Clock signal
NET "clk"            LOC = "V10" | IOSTANDARD = "LVCMOS33";   #Bank = 2, pin name = IO_L30N_GCLK0_USERCCLK,            Sch name = GCLK
Net "clk" TNM_NET = sys_clk_pin;
TIMESPEC TS_sys_clk_pin = PERIOD sys_clk_pin 100000 kHz;

		
# Switches
NET "registroPiso<1>"          LOC = "T10" | IOSTANDARD = "LVCMOS33";   #Bank = 2, Pin name = IO_L29N_GCLK2,                     Sch name = SW0
NET "registroPiso<0>"          LOC = "T9"  | IOSTANDARD = "LVCMOS33";   #Bank = 2, Pin name = IO_L32P_GCLK29,                    Sch name = SW1
NET "pisoSolicitante<2>"          LOC = "V9"  | IOSTANDARD = "LVCMOS33";   #Bank = 2, Pin name = IO_L32N_GCLK28,                    Sch name = SW2
NET "pisoSolicitante<1>"          LOC = "M8"  | IOSTANDARD = "LVCMOS33";   #Bank = 2, Pin name = IO_L40P,                           Sch name = SW3
NET "pisoSolicitante<0>"          LOC = "N8"  | IOSTANDARD = "LVCMOS33";   #Bank = 2, Pin name = IO_L40N,                           Sch name = SW4
NET "pisoActual<2>"          LOC = "U8"  | IOSTANDARD = "LVCMOS33";   #Bank = 2, Pin name = IO_L41P,                           Sch name = SW5
NET "pisoActual<1>"          LOC = "V8"  | IOSTANDARD = "LVCMOS33";   #Bank = 2, Pin name = IO_L41N_VREF,                      Sch name = SW6
NET "pisoActual<0>"          LOC = "T5"  | IOSTANDARD = "LVCMOS33";   #Bank = MISC, Pin name = IO_L48N_RDWR_B_VREF_2,          Sch name = SW7


# Buttons
NET "cambiarEstadoAscensor"         LOC = "B8"  | IOSTANDARD = "LVCMOS33";   #Bank = 0, Pin name = IO_L33P,                           Sch name = BTNS
NET "reset"         LOC = "A8"  | IOSTANDARD = "LVCMOS33";   #Bank = 0, Pin name = IO_L33N,                           Sch name = BTNU
NET "bajar"         LOC = "C9"  | IOSTANDARD = "LVCMOS33";   #Bank = 0, Pin name = IO_L34N_GCLK18,                    Sch name = BTND
NET "subir"         LOC = "D9"  | IOSTANDARD = "LVCMOS33";   #Bank = 0, Pin name = IO_L34P_GCLK19,                    Sch name = BTNR


## 7 segment display
NET "sseg<6>"         LOC = "T17" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L51P_M1DQ12,                    Sch name = CA
NET "sseg<5>"         LOC = "T18" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L51N_M1DQ13,                    Sch name = CB
NET "sseg<4>"         LOC = "U17" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L52P_M1DQ14,                    Sch name = CC
NET "sseg<3>"         LOC = "U18" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L52N_M1DQ15,                    Sch name = CD
NET "sseg<2>"         LOC = "M14" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L53P,                           Sch name = CE
NET "sseg<1>"         LOC = "N14" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L53N_VREF,                      Sch name = CF
NET "sseg<0>"         LOC = "L14" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L61P,                           Sch name = CG


NET "an<0>"          LOC = "N16" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L50N_M1UDQSN,                   Sch name = AN0
NET "an<1>"          LOC = "N15" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L50P_M1UDQS,                    Sch name = AN1
NET "an<2>"          LOC = "P18" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L49N_M1DQ11,                    Sch name = AN2
NET "an<3>"          LOC = "P17" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L49P_M1DQ10,                    Sch name = AN3   

Version 3

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:34:31 08/24/2015 
// Design Name: 
// Module Name:    RegistroSolicitudes 
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
module RegistroSolicitudes(
		input wire clk,reset,
		input wire cambiarEstadoAscensor,bajar,subir,
		input wire [2:0] pisoSolicitante,
		input wire [2:0] pisoActual,
		input wire [1:0] registroPiso,
		output reg [6:0] sseg,
		output reg [3:0] an,
		output reg [1:0] registroSalida
    );
	 
	 localparam[1:0] e0 = 2'b00,
						  e1 = 2'b01,
						  e2 = 2'b10,
						  e3 = 2'b11;
						  
	 reg[50:0] count;
	 reg[1:0] state_reg, state_next;
	 reg clk2;
	 reg  solicitud;
	 reg estadoAscensor;
	 
	 initial begin state_reg = registroPiso;	end			
	 
	 always @(posedge cambiarEstadoAscensor)
		begin	
			if(estadoAscensor == 1'b1)
				estadoAscensor <= 1'b0;
			else
				estadoAscensor <= 1'b1;
		end
			
	 always @(subir, bajar)
		begin		
			if(subir==1)			
				begin			
					solicitud <= 1'b1;
				end	
			else if (bajar==1)
				begin 
					solicitud <= 1'b0;
				end			
		end
	
		
		
		
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
			
			
	always @(registroSalida)
		begin
			an[3:0] <= 4'b1110;				
			if(registroSalida==e0) begin
				sseg[6:0] <= 7'b0000001;		
			end
			else if (registroSalida==e1) begin
				sseg[6:0] <= 7'b1001111;		
			end
			else if (registroSalida==e2) begin
				sseg[6:0] <= 7'b0010010;		
			end
			else begin
				sseg[6:0] <= 7'b0000110;		
			end
		end
		
	always @(state_reg)
		begin
			an[3:0] <= 4'b1110;				
			if(state_reg==e0) begin
				registroSalida <= 2'b00;		
			end
			else if (state_reg==e1) begin
				registroSalida <= 2'b01;		
			end
			else if (state_reg==e2) begin
				registroSalida <= 2'b10;		
			end
			else begin
				registroSalida <= 2'b11;		
			end
		end

	
	//proximo estado
	always @(posedge clk2) // la maquina de estados cambia en la transicion de clk2
		case(state_reg)
			e0: if(solicitud == 1'b1)
					begin	
//						sseg[6:0] <= 7'b1001111;
						state_next = e1;
						
						
					end
				else if(pisoSolicitante == pisoActual & estadoAscensor==0) //Tener cuidado con que con este caso la puerta del ascensor se debe de abrir
					begin
					//	sseg[6:0] <= 7'b1001111;
						state_next = e2;
												
					end
				else 
					begin
						state_next = e0;
										
					end					
			e1: if(pisoSolicitante == pisoActual & estadoAscensor == 1'b1)
					begin	
				//		sseg[6:0] <= 7'b0010010;
						state_next = e0;
					
					end
					
				 else if(pisoSolicitante == pisoActual & estadoAscensor == 1'b0)
					begin
			//			sseg[6:0] <= 7'b1001111;
						state_next = e3;
						
						
					end
				 else 
					begin
						state_next = e1;
												
					end	
					
			e2: if(solicitud == 1'b0)
					begin	
			//			sseg[6:0] <= 7'b0000110;
						state_next = e0;
						
						
					end
				 else if(solicitud == 1'b1)
					begin
			//			sseg[6:0] <= 7'b0010010;
						state_next = e3;
						
					end
				else 
					begin
						state_next = e2;
													
					end						
			e3: if(solicitud == 1'b0)
					begin	
				//		sseg[6:0] <= 7'b0000001;
						state_next = e1;
						
						
					end
					
				else if(pisoSolicitante == pisoActual & estadoAscensor == 1'b1)
					begin
			//			sseg[6:0] <= 7'b0010010;
						state_next = e2;
						
					end
				else 
					begin
						state_next = e3;
													
					end		
						
		endcase

endmodule



## Clock signal
NET "clk"            LOC = "V10" | IOSTANDARD = "LVCMOS33";   #Bank = 2, pin name = IO_L30N_GCLK0_USERCCLK,            Sch name = GCLK
Net "clk" TNM_NET = sys_clk_pin;
TIMESPEC TS_sys_clk_pin = PERIOD sys_clk_pin 100000 kHz;

		
# Switches
NET "registroPiso<1>"          LOC = "T10" | IOSTANDARD = "LVCMOS33";   #Bank = 2, Pin name = IO_L29N_GCLK2,                     Sch name = SW0
NET "registroPiso<0>"          LOC = "T9"  | IOSTANDARD = "LVCMOS33";   #Bank = 2, Pin name = IO_L32P_GCLK29,                    Sch name = SW1
NET "pisoSolicitante<2>"          LOC = "V9"  | IOSTANDARD = "LVCMOS33";   #Bank = 2, Pin name = IO_L32N_GCLK28,                    Sch name = SW2
NET "pisoSolicitante<1>"          LOC = "M8"  | IOSTANDARD = "LVCMOS33";   #Bank = 2, Pin name = IO_L40P,                           Sch name = SW3
NET "pisoSolicitante<0>"          LOC = "N8"  | IOSTANDARD = "LVCMOS33";   #Bank = 2, Pin name = IO_L40N,                           Sch name = SW4
NET "pisoActual<2>"          LOC = "U8"  | IOSTANDARD = "LVCMOS33";   #Bank = 2, Pin name = IO_L41P,                           Sch name = SW5
NET "pisoActual<1>"          LOC = "V8"  | IOSTANDARD = "LVCMOS33";   #Bank = 2, Pin name = IO_L41N_VREF,                      Sch name = SW6
NET "pisoActual<0>"          LOC = "T5"  | IOSTANDARD = "LVCMOS33";   #Bank = MISC, Pin name = IO_L48N_RDWR_B_VREF_2,          Sch name = SW7


# Buttons
NET "cambiarEstadoAscensor"         LOC = "D9"  | IOSTANDARD = "LVCMOS33";   #Bank = 0, Pin name = IO_L33P,                           Sch name = BTNS
NET "reset"         LOC = "C4"  | IOSTANDARD = "LVCMOS33";   #Bank = 0, Pin name = IO_L33N,                           Sch name = BTNU
NET "bajar"         LOC = "C9"  | IOSTANDARD = "LVCMOS33";   #Bank = 0, Pin name = IO_L34N_GCLK18,                    Sch name = BTND
NET "subir"         LOC = "A8"  | IOSTANDARD = "LVCMOS33";   #Bank = 0, Pin name = IO_L34P_GCLK19,                    Sch name = BTNR


## 7 segment display
NET "sseg<6>"         LOC = "T17" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L51P_M1DQ12,                    Sch name = CA
NET "sseg<5>"         LOC = "T18" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L51N_M1DQ13,                    Sch name = CB
NET "sseg<4>"         LOC = "U17" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L52P_M1DQ14,                    Sch name = CC
NET "sseg<3>"         LOC = "U18" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L52N_M1DQ15,                    Sch name = CD
NET "sseg<2>"         LOC = "M14" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L53P,                           Sch name = CE
NET "sseg<1>"         LOC = "N14" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L53N_VREF,                      Sch name = CF
NET "sseg<0>"         LOC = "L14" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L61P,                           Sch name = CG


NET "an<0>"          LOC = "N16" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L50N_M1UDQSN,                   Sch name = AN0
NET "an<1>"          LOC = "N15" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L50P_M1UDQS,                    Sch name = AN1
NET "an<2>"          LOC = "P18" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L49N_M1DQ11,                    Sch name = AN2
NET "an<3>"          LOC = "P17" | IOSTANDARD = "LVCMOS33";   #Bank = 1, Pin name = IO_L49P_M1DQ10,                    Sch name = AN3   


















    
    
    
