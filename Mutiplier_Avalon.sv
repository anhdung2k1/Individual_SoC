module Multiplier_Avalon (
    input wire clk,                // Clock signal
    input wire reset_n,            // Active-low reset
    input wire write,              // Avalon-MM write signal
    input wire [1:0] address,      // Address to select operand (p1/p2)
    input wire [31:0] writedata,   // Write data for operands
    output reg [31:0] product,     // Product output
    output reg [1:0] response,     // Write response signal
    output reg writeresponsevalid, // Write response valid signal
    output reg done                // Operation done flag
);
    reg [31:0] p1;                 // First operand
    reg [31:0] p2;                 // Second operand

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            p1 <= 0;
            p2 <= 0;
            product <= 0;
            response <= 2'b00;      // Default response: OK
            writeresponsevalid <= 0;
            done <= 0;
        end else if (write) begin
            case (address)
                2'b00: p1 <= writedata;  // Write to p1
                2'b01: p2 <= writedata;  // Write to p2
            endcase
            response <= 2'b00; // Indicate success
            writeresponsevalid <= 1; // Valid write response
            done <= 0;         // Reset done flag
        end else if (!done) begin
            product <= p1 * p2; // Perform multiplication
            done <= 1;          // Set done flag
        end else begin
            writeresponsevalid <= 0; // Clear response flag
        end
    end
endmodule
