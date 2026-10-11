module vending_machine_rupee (
    input wire clk,
    input wire reset,
    input wire coin_1r,   // ₹1 coin input
    input wire coin_2r,   // ₹2 coin input
    input wire coin_5r,   // ₹5 coin input
    output reg dispense   // Goes high when item is released
);

    // State Encoding for accumulated amount (0 to 9 Rupees)
    parameter S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4;
    parameter S5 = 4'd5, S6 = 4'd6, S7 = 4'd7, S8 = 4'd8, S9 = 4'd9;

    reg [3:0] current_state, next_state;

    // 1. Sequential Logic: State Memory
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // 2. Combinational Logic: Next State and Dispense Output
    always @(*) begin
        // Default assignments to prevent latch creation
        next_state = current_state;
        dispense = 1'b0;

        case (current_state)
            S0: begin
                if (coin_5r)      next_state = S5;
                else if (coin_2r) next_state = S2;
                else if (coin_1r) next_state = S1;
            end

            S1: begin
                if (coin_5r)      next_state = S6;
                else if (coin_2r) next_state = S3;
                else if (coin_1r) next_state = S2;
            end

            S2: begin
                if (coin_5r)      next_state = S7;
                else if (coin_2r) next_state = S4;
                else if (coin_1r) next_state = S3;
            end

            S3: begin
                if (coin_5r)      next_state = S8;
                else if (coin_2r) next_state = S5;
                else if (coin_1r) next_state = S4;
            end

            S4: begin
                if (coin_5r)      next_state = S9;
                else if (coin_2r) next_state = S6;
                else if (coin_1r) next_state = S5;
            end

            S5: begin
                if (coin_5r) begin
                    dispense = 1'b1; next_state = S0; // ₹5 + ₹5 = ₹10
                end else if (coin_2r) next_state = S7;
                else if (coin_1r)     next_state = S6;
            end

            S6: begin
                if (coin_5r) begin
                    dispense = 1'b1; next_state = S0; // ₹6 + ₹5 = ₹11
                end else if (coin_2r) next_state = S8;
                else if (coin_1r)     next_state = S7;
            end

            S7: begin
                if (coin_5r) begin
                    dispense = 1'b1; next_state = S0; // ₹7 + ₹5 = ₹12
                end else if (coin_2r) next_state = S9;
                else if (coin_1r)     next_state = S8;
            end

            S8: begin
                if (coin_5r) begin
                    dispense = 1'b1; next_state = S0; // ₹8 + ₹5 = ₹13
                end else if (coin_2r) begin
                    dispense = 1'b1; next_state = S0; // ₹8 + ₹2 = ₹10
                end else if (coin_1r) next_state = S9;
            end

            S9: begin
                if (coin_5r) begin
                    dispense = 1'b1; next_state = S0; // ₹9 + ₹5 = ₹14
                end else if (coin_2r) begin
                    dispense = 1'b1; next_state = S0; // ₹9 + ₹2 = ₹11
                end else if (coin_1r) begin
                    dispense = 1'b1; next_state = S0; // ₹9 + ₹1 = ₹10
                end
            end

            default: begin
                next_state = S0;
                dispense = 1'b0;
            end
        endcase
    end

endmodule
