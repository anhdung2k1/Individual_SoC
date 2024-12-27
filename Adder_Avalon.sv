module Adder_Avalon (
    input wire clk,              // Clock signal
    input wire reset_n,          // Active-low reset
    input wire write,            // Avalon-MM write signal
    input wire [1:0] address,    // Address signal to differentiate inputs
    input wire [31:0] writedata, // Data for p1 or p2
    output reg [31:0] readdata,  // Sum output
    output reg [1:0] response,   // Write response signal
    output reg writeresponsevalid, // Write response valid signal
    output reg done              // Operation done flag
);
    reg [31:0] p1;               // First operand
    reg [31:0] p2;               // Second operand

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            p1 <= 0;
            p2 <= 0;
            readdata <= 0;
            response <= 2'b00;   // Default response
            writeresponsevalid <= 0;
            done <= 0;
        end else if (write) begin
            case (address)
                2'b00: p1 <= writedata;  // Write to p1
                2'b01: p2 <= writedata;  // Write to p2
            endcase
            response <= 2'b00;  // Indicate success
            writeresponsevalid <= 1; // Write response is valid
            done <= 0;         // Reset done flag
        end else if (!done) begin
            readdata <= p1 + p2; // Perform addition
            done <= 1;          // Set done flag
        end else begin
            writeresponsevalid <= 0; // Clear response valid after transaction
        end
    end
endmodule
