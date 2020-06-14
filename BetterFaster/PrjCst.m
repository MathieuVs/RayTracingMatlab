classdef PrjCst
   properties (Constant)
        MU_0 = 1.25663706e-6;
        freq = 26*1e9;
        pulsation = 2*pi*PrjCst.freq;
        C = 299792458.0;
        EPS_0 = 8.85418782e-12;
        beta = PrjCst.pulsation/PrjCst.C;
        lambda = PrjCst.C*2*pi / PrjCst.pulsation;
   end
end