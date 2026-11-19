// cic3.v - sinc^3 CIC decimator for a 1-bit sigma-delta bitstream (Block 7).
//
// din = 1 -> +1, din = 0 -> -1. One din_valid pulse per modulator bit.
// Output = sum over the sinc^3 window, DC gain R^3 (512000 for R = 80),
// signed W-bit two's complement. W = 20 holds +-512000 without overflow.
// Integrators and combs wrap around (modular arithmetic), as in a standard
// Hogenauer CIC. No multipliers. Bit-exact against python/cic_ref.py.
//
// Timing note: the three integrators are chained in one clock cycle
// (i1 -> i2 -> i3, three W-bit adders). The combs are registered, one per
// cycle, and need decimated samples at least 4 clock cycles apart.
module cic3 #(
    parameter W = 20,
    parameter R = 80
)(
    input  wire                clk,
    input  wire                rst,        // synchronous, active high
    input  wire                din_valid,  // one pulse per modulator bit
    input  wire                din,        // 1 -> +1, 0 -> -1
    output reg                 dout_valid, // one pulse per decimated sample
    output reg signed [W-1:0]  dout
);
    localparam CW = $clog2(R);

    reg signed [W-1:0] i1, i2, i3;      // integrators
    reg signed [W-1:0] d1, d2, d3;      // comb delays
    reg signed [W-1:0] s0, c1, c2;      // comb pipeline
    reg [CW-1:0]       cnt;
    reg                v0, v1, v2;

    wire signed [W-1:0] x   = din ? {{(W-1){1'b0}}, 1'b1} : {W{1'b1}};
    wire signed [W-1:0] i1n = i1 + x;
    wire signed [W-1:0] i2n = i2 + i1n;
    wire signed [W-1:0] i3n = i3 + i2n;

    always @(posedge clk) begin
        v0 <= 1'b0; v1 <= 1'b0; v2 <= 1'b0; dout_valid <= 1'b0;
        if (rst) begin
            i1 <= 0; i2 <= 0; i3 <= 0;
            d1 <= 0; d2 <= 0; d3 <= 0;
            s0 <= 0; c1 <= 0; c2 <= 0; dout <= 0;
            cnt <= 0;
        end else begin
            if (din_valid) begin
                i1 <= i1n; i2 <= i2n; i3 <= i3n;
                if (cnt == R-1) begin
                    cnt <= 0;
                    s0  <= i3n;
                    v0  <= 1'b1;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
            // comb 1
            if (v0) begin
                c1 <= s0 - d1;  d1 <= s0;  v1 <= 1'b1;
            end
            // comb 2
            if (v1) begin
                c2 <= c1 - d2;  d2 <= c1;  v2 <= 1'b1;
            end
            // comb 3
            if (v2) begin
                dout <= c2 - d3;  d3 <= c2;  dout_valid <= 1'b1;
            end
        end
    end
endmodule
