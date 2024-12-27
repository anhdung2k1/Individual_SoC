module PrimeNumberGenerator_Avalon (
    input wire clk,                  // Clock signal
    input wire reset_n,              // Active-low reset
    input wire write,                // Avalon-MM write signal
    input wire [1:0] address,        // Address for write or read operations
    input wire [31:0] writedata,     // Data to write (max value)
    output reg [31:0] readdata,      // Data to read (prime numbers)
    output reg [1:0] response,       // Write response signal
    output reg writeresponsevalid,   // Write response valid signal
    output reg done                  // Completion flag
);
    reg [9:0] max;                   // Maximum range for primes
    reg [31:0] primes [0:255];       // Array to store primes
    integer i, j;
    reg is_prime;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            max <= 0;
            done <= 0;
            readdata <= 0;
            response <= 2'b00; // Default response
            writeresponsevalid <= 0;
            for (i = 0; i < 256; i = i + 1) primes[i] <= 0;
        end else if (write) begin
            if (address == 2'b00) begin
                max <= writedata[9:0]; // Write max value
                response <= 2'b00; // Success
                writeresponsevalid <= 1;
            end else begin
                response <= 2'b01; // Error
                writeresponsevalid <= 1;
            end
        end else if (done == 0) begin
            j = 0;
            for (i = 2; i <= max; i = i + 1) begin
                is_prime = 1;
                for (j = 2; j * j <= i; j = j + 1) begin
                    if (i % j == 0) begin
                        is_prime = 0;
                        break;
                    end
                end
                if (is_prime) begin
                    primes[j] <= i;
                    j = j + 1;
                end
            end
            done <= 1;
        end else if (address == 2'b01) begin
            readdata <= primes[writedata]; // Read prime number by index
        end
    end
endmodule
