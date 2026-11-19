// tb_fir_comp.v - self-checking testbench for rtl/fir_comp.v (Block 8).
// Run from blocks/08_Digital_FIR (see run_sim.sh).
// Stimulus: data/fir_in.mem (impulse, +-full-scale steps, worst-case sign
// patterns, random, and the CIC output of closed-loop run f6), golden:
// data/fir_golden.mem from python/fir_ref.py.
// Plusargs: +STRIDE=<clocks between input samples, >= NTAP+2>  +OVR=1 (overrun test)
`timescale 1ns/1ps
module tb_fir_comp;
    parameter W_IN = 20, W_OUT = 21, NTAP = 21, NMAX = 4096;

    reg clk = 0;
    always #5 clk = ~clk;

    reg rst = 1, din_valid = 0;
    reg signed [W_IN-1:0] din = 0;
    wire dout_valid, overrun;
    wire signed [W_OUT-1:0] dout;

    reg [W_IN-1:0]  xin  [0:NMAX-1];
    reg [20:0]      gold [0:NMAX-1];   // fixed 21-bit golden, independent of W_OUT: a too-narrow DUT must fail

    integer stride, ovr, i, j, n, errors, nout;

    fir_comp #(.W_IN(W_IN), .W_OUT(W_OUT), .NTAP(NTAP)) dut (
        .clk(clk), .rst(rst), .din_valid(din_valid), .din(din),
        .dout_valid(dout_valid), .dout(dout), .overrun(overrun));

    always @(posedge clk) begin
        if (dout_valid) begin
            if (nout < n && $signed(dout) !== $signed(gold[nout])) begin
                errors = errors + 1;
                if (errors <= 5)
                    $display("MISMATCH out[%0d]: rtl=%0d golden=%0d", nout, dout, $signed(gold[nout]));
            end
            nout = nout + 1;
        end
    end

    initial begin
        errors = 0; nout = 0;
        if (!$value$plusargs("STRIDE=%d", stride)) stride = NTAP + 2;
        if (!$value$plusargs("OVR=%d", ovr)) ovr = 0;
        $readmemh("data/fir_in.mem", xin);      // padded with x words up to NMAX
        $readmemh("data/fir_golden.mem", gold);
        n = 0;
        while (n < NMAX && xin[n] !== {W_IN{1'bx}}) n = n + 1;

        repeat (4) @(posedge clk);
        rst <= 0;
        repeat (2) @(posedge clk);
        if (ovr) begin
            // two pulses too close together: the second one must be dropped and flagged
            din <= xin[0]; din_valid <= 1'b1; @(posedge clk);
            din_valid <= 1'b0; repeat (3) @(posedge clk);
            din <= xin[1]; din_valid <= 1'b1; @(posedge clk);
            din_valid <= 1'b0; repeat (NTAP + 4) @(posedge clk);
            if (overrun && nout == 1)
                $display("PASS  overrun test: second pulse dropped, overrun flag set");
            else
                $display("FAIL  overrun test: overrun=%0d outputs=%0d", overrun, nout);
            $finish;
        end
        for (i = 0; i < n; i = i + 1) begin
            din <= xin[i];
            din_valid <= 1'b1;
            @(posedge clk);
            din_valid <= 1'b0;
            for (j = 1; j < stride; j = j + 1) @(posedge clk);
        end
        repeat (NTAP + 4) @(posedge clk);
        if (nout == n && errors == 0 && !overrun)
            $display("PASS  stride=%0d : %0d outputs, 0 mismatches, no overrun", stride, nout);
        else
            $display("FAIL  stride=%0d : %0d outputs (expected %0d), %0d mismatches, overrun=%0d",
                     stride, nout, n, errors, overrun);
        $finish;
    end

    initial begin
        #500000000;
        $display("FAIL  timeout");
        $finish;
    end
endmodule
