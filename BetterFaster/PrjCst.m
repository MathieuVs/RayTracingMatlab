classdef PrjCst
   properties (Constant)
        MU_0 = 1.25663706e-6;
        pulsation = 2*3.141593*5e9;
        C = 299792458.0;
        EPS_0 = 8.85418782e-12;
        beta = PrjCst.pulsation/PrjCst.C;
   end
end