module PrimeNumberGenerator (
    input wire iClk,               // Clock signal
    input wire iReset_n,           // Active-low reset
    input wire iChip_select_n,     // Chip select
    input wire iWrite_n,           // Write signal
    input wire [31:0] iData,       // Data input
    input wire [2:0] address,      // Address for function selection
    output reg [31:0] oData        // Data output
);
    // Function selector
    localparam FUNC_ADDER       = 3'b000;
    localparam FUNC_MULTIPLIER  = 3'b001;
    localparam FUNC_PRIME_GEN   = 3'b010;

    // Internal Registers for Adder
    reg [31:0] p1, p2;

    // Internal Registers for Multiplier
    reg [31:0] m1, m2;

    // Internal Registers for Prime Number Generator
    reg [9:0] max;
    reg [31:0] primes [0:255];
    integer i, j;
    reg is_prime;

    always @(posedge iClk or negedge iReset_n) begin
        if (!iReset_n) begin
            // Reset all states
            p1 <= 0; p2 <= 0;
            m1 <= 0; m2 <= 0;
            max <= 0;
            oData <= 0;
            for (i = 0; i < 256; i = i + 1) primes[i] <= 0;
        end else begin
            if (!iChip_select_n && !iWrite_n) begin
                // Handle write operations
                case (address)
                    FUNC_ADDER: begin
                        if (address[1:0] == 2'b00) p1 <= iData; // Write to p1
                        if (address[1:0] == 2'b01) p2 <= iData; // Write to p2
                    end
                    FUNC_MULTIPLIER: begin
                        if (address[1:0] == 2'b00) m1 <= iData; // Write to m1
                        if (address[1:0] == 2'b01) m2 <= iData; // Write to m2
                    end
                    FUNC_PRIME_GEN: begin
                        if (address[1:0] == 2'b00) begin
                            max <= iData[9:0]; // Write max value
                            // Generate prime numbers
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
                        end
                    end
                endcase
            end else begin
                // Handle read operations
                case (address)
                    FUNC_ADDER: oData <= p1 + p2; // Perform addition
                    FUNC_MULTIPLIER: oData <= m1 * m2; // Perform multiplication
                    FUNC_PRIME_GEN: begin
                        if (address[1:0] == 2'b01) begin
                            oData <= primes[iData[7:0]]; // Read specific prime by index
                        end
                    end
                endcase
            end
        end
    end
endmodule
