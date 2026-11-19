// tb_cic3.v - self-checking testbench for rtl/cic3.v (Block 7).
// Run from blocks/07_Digital_CIC (see run_sim.sh).
// Plusargs: +STIM=<f6|ones|zeros>  +STRIDE=<clocks per modulator bit>
`timescale 1ns/1ps
module tb_cic3;
    parameter W = 20, R = 80, NOUT = 51, NBITS = 4080;

    reg clk = 0;
    always #5 clk = ~clk;

    reg rst = 1, din_valid = 0, din = 0;
    wire dout_valid;
    wire signed [W-1:0] dout;

    reg [0:0]   bmem [0:4095];
    reg [19:0]  gold [0:NOUT-1];   // fixed 20-bit golden: a too-narrow DUT must fail

    integer stride, i, j, errors, nout;
    reg [255:0] stim;

    cic3 #(.W(W), .R(R)) dut (.clk(clk), .rst(rst), .din_valid(din_valid), .din(din),
                              .dout_valid(dout_valid), .dout(dout));

    always @(posedge clk) begin
        if (dout_valid) begin
            if (nout < NOUT) begin
                if ($signed(dout) !== $signed(gold[nout])) begin
                    errors = errors + 1;
                    if (errors <= 5)
                        $display("MISMATCH out[%0d]: rtl=%0d golden=%0d", nout, dout, $signed(gold[nout]));
                end
            end
            nout = nout + 1;
        end
    end

    initial begin
        errors = 0; nout = 0;
        if (!$value$plusargs("STRIDE=%d", stride)) stride = 1;
        if (!$value$plusargs("STIM=%s", stim)) stim = "f6";
        if (stim == "f6") begin
            $readmemb("data/bitstream.mem", bmem);
            $readmemh("data/golden.mem", gold);
        end else if (stim == "ones") begin
            $readmemb("data/ones_bitstream.mem", bmem);
            $readmemh("data/ones_golden.mem", gold);
        end else begin
            $readmemb("data/zeros_bitstream.mem", bmem);
            $readmemh("data/zeros_golden.mem", gold);
        end
        repeat (4) @(posedge clk);
        rst <= 0;
        repeat (2) @(posedge clk);
        for (i = 0; i < NBITS; i = i + 1) begin
            din <= bmem[i];
            din_valid <= 1'b1;
            @(posedge clk);
            din_valid <= 1'b0;
            for (j = 1; j < stride; j = j + 1) @(posedge clk);
        end
        repeat (20) @(posedge clk);
        if (nout == NOUT && errors == 0)
            $display("PASS  stim=%0s stride=%0d : %0d outputs, 0 mismatches", stim, stride, nout);
        else
            $display("FAIL  stim=%0s stride=%0d : %0d outputs (expected %0d), %0d mismatches",
                     stim, stride, nout, NOUT, errors);
        $finish;
    end

    initial begin
        #200000000;
        $display("FAIL  timeout");
        $finish;
    end
endmodule
