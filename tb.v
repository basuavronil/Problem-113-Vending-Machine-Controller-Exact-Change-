`timescale 1ns / 1ps

module tb_vending_machine_rupee;

    // Testbench signals
    reg clk;
    reg reset;
    reg coin_1r;
    reg coin_2r;
    reg coin_5r;
    wire dispense;

    // Instantiate the Unit Under Test (UUT)
    vending_machine_rupee uut (
        .clk(clk),
        .reset(reset),
        .coin_1r(coin_1r),
        .coin_2r(coin_2r),
        .coin_5r(coin_5r),
        .dispense(dispense)
    );

    // 1. Clock Generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    // 2. Monitor Statement: Prints changes to the console
    initial begin
        $timeformat(-9, 0, " ns", 6);
        $display("Time     | Reset | Coin_1R | Coin_2R | Coin_5R | Dispense");
        $display("---------------------------------------------------------");
        $monitor("%t |   %b   |    %b    |    %b    |    %b    |    %b", 
                 $time, reset, coin_1r, coin_2r, coin_5r, dispense);
    end

    // 3. Waveform Dump Setup
    initial begin
        $dumpfile("vending_machine.vcd");
        $dumpvars(0, tb_vending_machine_rupee);
    end

    // 4. Test Stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        coin_1r = 0;
        coin_2r = 0;
        coin_5r = 0;

        // Hold reset for 20ns
        #20;
        reset = 0;
        #10;

        // Test Scenario 1: Insert ₹2 + ₹2 + ₹2 + ₹2 + ₹2 = ₹10
        #10; coin_2r = 1; #10; coin_2r = 0; // Balance: 2
        #10; coin_2r = 1; #10; coin_2r = 0; // Balance: 4
        #10; coin_2r = 1; #10; coin_2r = 0; // Balance: 6
        #10; coin_2r = 1; #10; coin_2r = 0; // Balance: 8
        #10; coin_2r = 1; #10; coin_2r = 0; // Balance: 10 -> Dispense!

        #20;

        // Test Scenario 2: Insert ₹5 + ₹5 = ₹10 (Direct hit)
        #10; coin_5r = 1; #10; coin_5r = 0; // Balance: 5
        #10; coin_5r = 1; #10; coin_5r = 0; // Balance: 10 -> Dispense!

        #20;

        // Test Scenario 3: Hitting S9 and adding a ₹1 coin (₹9 + ₹1 = ₹10)
        #10; coin_5r = 1; #10; coin_5r = 0; // Balance: 5
        #10; coin_2r = 1; #10; coin_2r = 0; // Balance: 7
        #10; coin_2r = 1; #10; coin_2r = 0; // Balance: 9 (State S9)
        #10; coin_1r = 1; #10; coin_1r = 0; // Balance: 10 -> Dispense!

        #40;
        $finish;
    end

endmodule
