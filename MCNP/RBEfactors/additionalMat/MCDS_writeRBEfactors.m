%% Proton RBE
% Aerobic data taken from MCDS

DE_protons_DSB_aerobic = [1.000E-03 2.000E-03 3.000E-03 4.000E-03 5.000E-03 6.470E-03...
         7.500E-03 1.000E-02 2.000E-02 3.000E-02 4.000E-02 5.000E-02...
         6.000E-02 7.000E-02 8.000E-02 9.000E-02 1.000E-01 2.000E-01...
         3.000E-01 5.000E-01 9.000E-01 1.000E+00 1.100E+00 1.300E+00...
         1.500E+00 2.000E+00 2.500E+00 3.000E+00 3.500E+00 4.000E+00...
         5.000E+00 6.000E+00 7.500E+00 1.000E+01 1.500E+01 2.500E+01...
         5.000E+01 7.500E+01 1.000E+02 1.500E+02 2.000E+02 2.500E+02...
         5.000E+02 1.000E+03];
     
DF_protons_DSB_aerobic = [3.375E+00 3.367E+00 3.368E+00 3.363E+00 3.359E+00 3.352E+00...
         3.348E+00 3.340E+00 3.317E+00 3.290E+00 3.264E+00 3.242E+00...
         3.216E+00 3.193E+00 3.168E+00 3.143E+00 3.122E+00 2.889E+00...
         2.687E+00 2.370E+00 1.986E+00 1.916E+00 1.860E+00 1.760E+00...
         1.685E+00 1.542E+00 1.451E+00 1.386E+00 1.336E+00 1.297E+00...
         1.244E+00 1.204E+00 1.164E+00 1.123E+00 1.083E+00 1.051E+00...
         1.026E+00 1.016E+00 1.012E+00 1.004E+00 1.004E+00 1.003E+00...
         1.001E+00 9.995E-01];
     
writematrix([DE_protons_DSB_aerobic',  DF_protons_DSB_aerobic'], 'MCDS_protonRBE_DSB_aerobic.txt','Delimiter','tab');

% Anoxic data taken from MCDS

DE_protons_DSB_anoxic = [1.000E-03 2.000E-03 3.000E-03 4.000E-03 5.000E-03 6.470E-03...
         7.500E-03 1.000E-02 2.000E-02 3.000E-02 4.000E-02 5.000E-02...
         6.000E-02 7.000E-02 8.000E-02 9.000E-02 1.000E-01 2.000E-01...
         3.000E-01 5.000E-01 9.000E-01 1.000E+00 1.100E+00 1.300E+00...
         1.500E+00 2.000E+00 2.500E+00 3.000E+00 3.500E+00 4.000E+00...
         5.000E+00 6.000E+00 7.500E+00 1.000E+01 1.500E+01 2.500E+01...
         5.000E+01 7.500E+01 1.000E+02 1.500E+02 2.000E+02 2.500E+02...
         5.000E+02 1.000E+03];
     
DF_protons_DSB_anoxic = [9.805E+00 9.770E+00 9.775E+00 9.748E+00 9.739E+00 9.707E+00...
         9.697E+00 9.663E+00 9.543E+00 9.425E+00 9.298E+00 9.179E+00...
         9.041E+00 8.910E+00 8.764E+00 8.628E+00 8.481E+00 6.980E+00...
         5.626E+00 3.864E+00 2.490E+00 2.326E+00 2.198E+00 1.997E+00...
         1.860E+00 1.638E+00 1.518E+00 1.432E+00 1.370E+00 1.330E+00...
         1.261E+00 1.218E+00 1.175E+00 1.130E+00 1.086E+00 1.047E+00...
         1.026E+00 1.013E+00 1.011E+00 1.002E+00 1.002E+00 1.002E+00...
         9.993E-01 9.977E-01];
     
writematrix([DE_protons_DSB_anoxic',  DF_protons_DSB_anoxic'], 'MCDS_protonRBE_DSB_anoxic.txt','Delimiter','tab');

%% Electron RBE
% Aerobic data taken from MCDS

DE_electrons_DSB_aerobic = [1.000E-05 2.000E-05 3.000E-05 4.000E-05 5.000E-05 6.000E-05...
            7.000E-05 8.000E-05 9.000E-05 1.000E-04 2.000E-04 3.000E-04...
            4.000E-04 5.000E-04 6.000E-04 7.000E-04 8.000E-04 9.000E-04...
            1.000E-03 2.000E-03 3.000E-03 4.000E-03 5.000E-03 6.000E-03...
            7.000E-03 8.000E-03 9.000E-03 1.000E-02 2.000E-02 3.000E-02...
            4.000E-02 5.000E-02 6.000E-02 7.000E-02 8.000E-02 9.000E-02...
            1.000E-01 2.000E-01 3.000E-01 4.000E-01 5.000E-01 1.000E+00...
            1.000E+01 1.000E+02 1.500E+02 2.000E+02 3.000E+02 4.000E+02...
            5.000E+02 6.000E+02 8.000E+02 9.000E+02 1.000E+03];
     
DF_electrons_DSB_aerobic = [3.383E+00 3.353E+00 3.321E+00 3.278E+00 3.234E+00 3.190E+00...
            3.139E+00 3.091E+00 3.046E+00 3.001E+00 2.600E+00 2.319E+00...
            2.118E+00 1.966E+00 1.851E+00 1.759E+00 1.688E+00 1.627E+00...
            1.573E+00 1.314E+00 1.215E+00 1.162E+00 1.129E+00 1.111E+00...
            1.093E+00 1.082E+00 1.070E+00 1.062E+00 1.028E+00 1.015E+00...
            1.011E+00 1.007E+00 1.006E+00 1.002E+00 1.002E+00 1.002E+00...
            9.989E-01 9.959E-01 9.952E-01 9.945E-01 9.941E-01 9.921E-01...
            9.907E-01 9.943E-01 9.943E-01 9.943E-01 9.943E-01 9.943E-01...
            9.943E-01 9.943E-01 9.943E-01 9.943E-01 9.943E-01];
     
writematrix([DE_electrons_DSB_aerobic',  DF_electrons_DSB_aerobic'], 'MCDS_electronRBE_DSB_aerobic.txt','Delimiter','tab');

% Anoxic data taken from MCDS

DE_electrons_DSB_anoxic = [1.000E-05 2.000E-05 3.000E-05 4.000E-05 5.000E-05 6.000E-05...
            7.000E-05 8.000E-05 9.000E-05 1.000E-04 2.000E-04 3.000E-04...
            4.000E-04 5.000E-04 6.000E-04 7.000E-04 8.000E-04 9.000E-04...
            1.000E-03 2.000E-03 3.000E-03 4.000E-03 5.000E-03 6.000E-03...
            7.000E-03 8.000E-03 9.000E-03 1.000E-02 2.000E-02 3.000E-02...
            4.000E-02 5.000E-02 6.000E-02 7.000E-02 8.000E-02 9.000E-02...
            1.000E-01 2.000E-01 3.000E-01 4.000E-01 5.000E-01 1.000E+00...
            1.000E+01 1.000E+02 1.500E+02 2.000E+02 3.000E+02 4.000E+02...
            5.000E+02 6.000E+02 8.000E+02 9.000E+02 1.000E+03];
     
DF_electrons_DSB_anoxic = [9.833E+00 9.718E+00 9.584E+00 9.387E+00 9.168E+00 8.923E+00...
            8.635E+00 8.353E+00 8.057E+00 7.756E+00 5.120E+00 3.654E+00...
            2.886E+00 2.453E+00 2.185E+00 1.994E+00 1.875E+00 1.770E+00...
            1.687E+00 1.342E+00 1.231E+00 1.170E+00 1.137E+00 1.117E+00...
            1.095E+00 1.085E+00 1.069E+00 1.061E+00 1.029E+00 1.016E+00...
            1.009E+00 1.005E+00 1.001E+00 1.001E+00 1.000E+00 1.002E+00...
            9.969E-01 9.941E-01 9.945E-01 9.910E-01 9.933E-01 9.913E-01...
            9.887E-01 9.940E-01 9.940E-01 9.940E-01 9.940E-01 9.940E-01...
            9.940E-01 9.940E-01 9.940E-01 9.940E-01 9.940E-01];
     
writematrix([DE_electrons_DSB_anoxic',  DF_electrons_DSB_anoxic'], 'MCDS_electronRBE_DSB_anoxic.txt','Delimiter','tab');

%% Deuteron RBE
% Aerobic data taken from MCDS

DE_deuterons_DSB_aerobic = [1.000E-03 2.000E-03 3.000E-03 4.000E-03 5.000E-03 6.470E-03...
         7.500E-03 1.000E-02 2.000E-02 3.000E-02 4.000E-02 5.000E-02...
         6.000E-02 7.000E-02 8.000E-02 9.000E-02 1.000E-01 2.000E-01...
         3.000E-01 5.000E-01 9.000E-01 1.000E+00 1.100E+00 1.300E+00...
         1.500E+00 2.000E+00 2.500E+00 3.000E+00 3.500E+00 4.000E+00...
         5.000E+00 6.000E+00 7.500E+00 1.000E+01 1.500E+01 2.500E+01...
         5.000E+01 7.500E+01 1.000E+02 1.500E+02 2.000E+02 2.500E+02...
         5.000E+02 1.000E+03];
     
DF_deuterons_DSB_aerobic = [3.361E+00 3.360E+00 3.355E+00 3.352E+00 3.354E+00 3.346E+00...
         3.348E+00 3.344E+00 3.325E+00 3.316E+00 3.304E+00 3.286E+00...
         3.277E+00 3.262E+00 3.252E+00 3.241E+00 3.225E+00 3.106E+00...
         2.988E+00 2.771E+00 2.428E+00 2.359E+00 2.296E+00 2.189E+00...
         2.094E+00 1.908E+00 1.774E+00 1.678E+00 1.597E+00 1.534E+00...
         1.446E+00 1.375E+00 1.311E+00 1.235E+00 1.159E+00 1.097E+00...
         1.044E+00 1.028E+00 1.020E+00 1.009E+00 1.006E+00 1.003E+00...
         9.985E-01 9.967E-01];
     
writematrix([DE_deuterons_DSB_aerobic',  DF_deuterons_DSB_aerobic'], 'MCDS_deuteronRBE_DSB_aerobic.txt','Delimiter','tab');

% Anoxic data taken from MCDS

DE_deuterons_DSB_anoxic = [1.000E-03 2.000E-03 3.000E-03 4.000E-03 5.000E-03 6.470E-03...
         7.500E-03 1.000E-02 2.000E-02 3.000E-02 4.000E-02 5.000E-02...
         6.000E-02 7.000E-02 8.000E-02 9.000E-02 1.000E-01 2.000E-01...
         3.000E-01 5.000E-01 9.000E-01 1.000E+00 1.100E+00 1.300E+00...
         1.500E+00 2.000E+00 2.500E+00 3.000E+00 3.500E+00 4.000E+00...
         5.000E+00 6.000E+00 7.500E+00 1.000E+01 1.500E+01 2.500E+01...
         5.000E+01 7.500E+01 1.000E+02 1.500E+02 2.000E+02 2.500E+02...
         5.000E+02 1.000E+03];
     
DF_deuterons_DSB_anoxic = [9.754E+00 9.750E+00 9.727E+00 9.716E+00 9.724E+00 9.689E+00...
         9.697E+00 9.685E+00 9.610E+00 9.552E+00 9.498E+00 9.425E+00...
         9.378E+00 9.303E+00 9.251E+00 9.189E+00 9.126E+00 8.426E+00...
         7.689E+00 6.231E+00 4.173E+00 3.834E+00 3.555E+00 3.122E+00...
         2.805E+00 2.308E+00 2.021E+00 1.852E+00 1.728E+00 1.633E+00...
         1.508E+00 1.419E+00 1.338E+00 1.249E+00 1.167E+00 1.102E+00...
         1.047E+00 1.028E+00 1.016E+00 1.008E+00 1.004E+00 1.002E+00...
         9.973E-01 9.937E-01];
     
writematrix([DE_deuterons_DSB_anoxic',  DF_deuterons_DSB_anoxic'], 'MCDS_deuteronRBE_DSB_anoxic.txt','Delimiter','tab');


%% Triton RBE
% Aerobic data taken from MCDS

DE_tritons_DSB_aerobic = [1.000E-03 2.000E-03 3.000E-03 4.000E-03 5.000E-03 6.470E-03...
         7.500E-03 1.000E-02 2.000E-02 3.000E-02 4.000E-02 5.000E-02...
         6.000E-02 7.000E-02 8.000E-02 9.000E-02 1.000E-01 2.000E-01...
         3.000E-01 5.000E-01 9.000E-01 1.000E+00 1.100E+00 1.300E+00...
         1.500E+00 2.000E+00 2.500E+00 3.000E+00 3.500E+00 4.000E+00...
         5.000E+00 6.000E+00 7.500E+00 1.000E+01 1.500E+01 2.500E+01...
         5.000E+01 7.500E+01 1.000E+02 1.500E+02 2.000E+02 2.500E+02...
         5.000E+02 1.000E+03];
     
DF_tritons_DSB_aerobic = [3.362E+00 3.359E+00 3.360E+00 3.355E+00 3.357E+00 3.353E+00...
         3.354E+00 3.348E+00 3.336E+00 3.329E+00 3.318E+00 3.307E+00...
         3.302E+00 3.293E+00 3.282E+00 3.274E+00 3.267E+00 3.185E+00...
         3.107E+00 2.950E+00 2.673E+00 2.617E+00 2.556E+00 2.456E+00...
         2.363E+00 2.169E+00 2.022E+00 1.907E+00 1.812E+00 1.737E+00...
         1.619E+00 1.535E+00 1.443E+00 1.343E+00 1.237E+00 1.146E+00...
         1.072E+00 1.041E+00 1.030E+00 1.019E+00 1.012E+00 1.007E+00...
         1.001E+00 9.965E-01];
     
writematrix([DE_tritons_DSB_aerobic',  DF_tritons_DSB_aerobic'], 'MCDS_tritonRBE_DSB_aerobic.txt','Delimiter','tab');

% Anoxic data taken from MCDS

DE_tritons_DSB_anoxic = [1.000E-03 2.000E-03 3.000E-03 4.000E-03 5.000E-03 6.470E-03...
         7.500E-03 1.000E-02 2.000E-02 3.000E-02 4.000E-02 5.000E-02...
         6.000E-02 7.000E-02 8.000E-02 9.000E-02 1.000E-01 2.000E-01...
         3.000E-01 5.000E-01 9.000E-01 1.000E+00 1.100E+00 1.300E+00...
         1.500E+00 2.000E+00 2.500E+00 3.000E+00 3.500E+00 4.000E+00...
         5.000E+00 6.000E+00 7.500E+00 1.000E+01 1.500E+01 2.500E+01...
         5.000E+01 7.500E+01 1.000E+02 1.500E+02 2.000E+02 2.500E+02...
         5.000E+02 1.000E+03];
     
DF_tritons_DSB_anoxic = [9.755E+00 9.748E+00 9.750E+00 9.727E+00 9.732E+00 9.719E+00...
         9.724E+00 9.696E+00 9.651E+00 9.621E+00 9.570E+00 9.528E+00...
         9.490E+00 9.456E+00 9.401E+00 9.370E+00 9.325E+00 8.900E+00...
         8.430E+00 7.427E+00 5.593E+00 5.218E+00 4.865E+00 4.303E+00...
         3.843E+00 3.057E+00 2.600E+00 2.312E+00 2.098E+00 1.951E+00...
         1.763E+00 1.635E+00 1.505E+00 1.372E+00 1.255E+00 1.154E+00...
         1.073E+00 1.041E+00 1.030E+00 1.014E+00 1.011E+00 1.004E+00...
         9.995E-01 9.979E-01];
     
writematrix([DE_tritons_DSB_anoxic',  DF_tritons_DSB_anoxic'], 'MCDS_tritonRBE_DSB_anoxic.txt','Delimiter','tab');

%% 3He RBE
% Aerobic data taken from MCDS

DE_3He_DSB_aerobic = [1.000E-03 1.500E-03 2.000E-03 2.500E-03 3.000E-03 4.000E-03...
            5.000E-03 6.000E-03 7.000E-03 8.000E-03 9.000E-03 1.000E-02...
            1.250E-02 1.500E-02 1.750E-02 2.000E-02 2.250E-02 2.500E-02...
            2.750E-02 3.000E-02 3.500E-02 4.000E-02 4.500E-02 5.000E-02...
            5.500E-02 6.000E-02 6.500E-02 7.000E-02 7.500E-02 8.000E-02...
            8.500E-02 9.000E-02 9.500E-02 1.000E-01 1.250E-01 1.500E-01...
            1.750E-01 2.000E-01 2.250E-01 2.500E-01 2.750E-01 3.000E-01...
            3.500E-01 4.000E-01 4.500E-01 5.000E-01 5.500E-01 6.000E-01...
            6.500E-01 7.000E-01 7.500E-01 8.000E-01 8.500E-01 9.000E-01...
            9.500E-01 1.000E+00 1.250E+00 1.500E+00 1.750E+00 2.000E+00...
            2.250E+00 2.500E+00 2.750E+00 3.000E+00 3.500E+00 4.000E+00...
            4.500E+00 5.000E+00 5.500E+00 6.000E+00 6.500E+00 7.000E+00...
            7.500E+00 8.000E+00 8.500E+00 9.000E+00 9.500E+00 1.000E+01...
            1.250E+01 1.500E+01 1.750E+01 2.000E+01 2.500E+01 2.750E+01...
            3.000E+01 3.500E+01 4.000E+01 4.500E+01 5.000E+01 5.500E+01...
            6.000E+01 6.500E+01 7.000E+01 7.500E+01 8.000E+01 8.500E+01...
            9.000E+01 9.500E+01 1.000E+02 1.250E+02 1.500E+02 1.750E+02...
            2.000E+02 2.250E+02 2.500E+02 2.750E+02 3.000E+02 3.500E+02...
            3.750E+02 4.000E+02 4.500E+02 5.000E+02 5.500E+02 6.000E+02...
            6.500E+02 7.000E+02 7.500E+02 8.000E+02 8.500E+02 9.000E+02...
            9.500E+02 1.000E+03 2.000E+03 5.000E+03 7.500E+03 1.000E+04];
     
DF_3He_DSB_aerobic = [3.381E+00 3.380E+00 3.381E+00 3.380E+00 3.379E+00 3.380E+00...
            3.377E+00 3.379E+00 3.377E+00 3.377E+00 3.375E+00 3.375E+00...
            3.376E+00 3.376E+00 3.374E+00 3.374E+00 3.373E+00 3.373E+00...
            3.371E+00 3.372E+00 3.370E+00 3.369E+00 3.367E+00 3.368E+00...
            3.366E+00 3.365E+00 3.364E+00 3.362E+00 3.364E+00 3.362E+00...
            3.362E+00 3.362E+00 3.358E+00 3.357E+00 3.354E+00 3.347E+00...
            3.347E+00 3.339E+00 3.336E+00 3.332E+00 3.326E+00 3.323E+00...
            3.314E+00 3.305E+00 3.296E+00 3.288E+00 3.280E+00 3.269E+00...
            3.259E+00 3.251E+00 3.241E+00 3.230E+00 3.220E+00 3.210E+00...
            3.201E+00 3.192E+00 3.143E+00 3.094E+00 3.046E+00 2.995E+00...
            2.946E+00 2.900E+00 2.851E+00 2.808E+00 2.722E+00 2.645E+00...
            2.570E+00 2.502E+00 2.437E+00 2.376E+00 2.323E+00 2.271E+00...
            2.223E+00 2.178E+00 2.139E+00 2.100E+00 2.064E+00 2.031E+00...
            1.885E+00 1.777E+00 1.691E+00 1.624E+00 1.521E+00 1.482E+00...
            1.447E+00 1.392E+00 1.347E+00 1.313E+00 1.285E+00 1.261E+00...
            1.240E+00 1.223E+00 1.208E+00 1.195E+00 1.185E+00 1.175E+00...
            1.165E+00 1.156E+00 1.149E+00 1.120E+00 1.099E+00 1.087E+00...
            1.076E+00 1.067E+00 1.061E+00 1.054E+00 1.050E+00 1.044E+00...
            1.041E+00 1.038E+00 1.035E+00 1.029E+00 1.027E+00 1.026E+00...
            1.023E+00 1.022E+00 1.020E+00 1.020E+00 1.018E+00 1.018E+00...
            1.016E+00 1.015E+00 1.007E+00 1.004E+00 1.004E+00 1.000E+00];
     
writematrix([DE_3He_DSB_aerobic',  DF_3He_DSB_aerobic'], 'MCDS_3HeRBE_DSB_aerobic.txt','Delimiter','tab');

% Anoxic data taken from MCDS

DE_3He_DSB_anoxic = [1.000E-03 1.500E-03 2.000E-03 2.500E-03 3.000E-03 4.000E-03...
            5.000E-03 6.000E-03 7.000E-03 8.000E-03 9.000E-03 1.000E-02...
            1.250E-02 1.500E-02 1.750E-02 2.000E-02 2.250E-02 2.500E-02...
            2.750E-02 3.000E-02 3.500E-02 4.000E-02 4.500E-02 5.000E-02...
            5.500E-02 6.000E-02 6.500E-02 7.000E-02 7.500E-02 8.000E-02...
            8.500E-02 9.000E-02 9.500E-02 1.000E-01 1.250E-01 1.500E-01...
            1.750E-01 2.000E-01 2.250E-01 2.500E-01 2.750E-01 3.000E-01...
            3.500E-01 4.000E-01 4.500E-01 5.000E-01 5.500E-01 6.000E-01...
            6.500E-01 7.000E-01 7.500E-01 8.000E-01 8.500E-01 9.000E-01...
            9.500E-01 1.000E+00 1.250E+00 1.500E+00 1.750E+00 2.000E+00...
            2.250E+00 2.500E+00 2.750E+00 3.000E+00 3.500E+00 4.000E+00...
            4.500E+00 5.000E+00 5.500E+00 6.000E+00 6.500E+00 7.000E+00...
            7.500E+00 8.000E+00 8.500E+00 9.000E+00 9.500E+00 1.000E+01...
            1.250E+01 1.500E+01 1.750E+01 2.000E+01 2.500E+01 2.750E+01...
            3.000E+01 3.500E+01 4.000E+01 4.500E+01 5.000E+01 5.500E+01...
            6.000E+01 6.500E+01 7.000E+01 7.500E+01 8.000E+01 8.500E+01...
            9.000E+01 9.500E+01 1.000E+02 1.250E+02 1.500E+02 1.750E+02...
            2.000E+02 2.250E+02 2.500E+02 2.750E+02 3.000E+02 3.500E+02...
            4.000E+02 4.500E+02 5.000E+02 5.500E+02 6.000E+02 6.500E+02...
            7.000E+02 7.500E+02 8.000E+02 8.500E+02 9.000E+02 9.500E+02...
            1.000E+03 2.000E+03 5.000E+03 7.500E+03 1.000E+04];
     
DF_3He_DSB_anoxic = [9.827E+00 9.825E+00 9.826E+00 9.824E+00 9.821E+00 9.823E+00...
            9.814E+00 9.822E+00 9.817E+00 9.816E+00 9.811E+00 9.809E+00...
            9.813E+00 9.813E+00 9.798E+00 9.797E+00 9.795E+00 9.794E+00...
            9.788E+00 9.791E+00 9.788E+00 9.783E+00 9.777E+00 9.780E+00...
            9.773E+00 9.772E+00 9.760E+00 9.754E+00 9.758E+00 9.753E+00...
            9.753E+00 9.754E+00 9.743E+00 9.739E+00 9.721E+00 9.700E+00...
            9.692E+00 9.666E+00 9.647E+00 9.625E+00 9.610E+00 9.591E+00...
            9.555E+00 9.508E+00 9.472E+00 9.426E+00 9.383E+00 9.340E+00...
            9.291E+00 9.250E+00 9.196E+00 9.143E+00 9.095E+00 9.033E+00...
            8.986E+00 8.939E+00 8.659E+00 8.358E+00 8.046E+00 7.723E+00...
            7.402E+00 7.083E+00 6.775E+00 6.480E+00 5.895E+00 5.395E+00...
            4.943E+00 4.544E+00 4.212E+00 3.922E+00 3.667E+00 3.451E+00...
            3.260E+00 3.094E+00 2.953E+00 2.835E+00 2.717E+00 2.620E+00...
            2.258E+00 2.036E+00 1.878E+00 1.767E+00 1.612E+00 1.558E+00...
            1.511E+00 1.438E+00 1.385E+00 1.342E+00 1.309E+00 1.283E+00...
            1.257E+00 1.238E+00 1.224E+00 1.208E+00 1.196E+00 1.184E+00...
            1.174E+00 1.165E+00 1.156E+00 1.127E+00 1.100E+00 1.088E+00...
            1.078E+00 1.068E+00 1.061E+00 1.055E+00 1.049E+00 1.044E+00...
            1.037E+00 1.035E+00 1.028E+00 1.025E+00 1.024E+00 1.020E+00...
            1.021E+00 1.019E+00 1.019E+00 1.016E+00 1.015E+00 1.014E+00...
            1.016E+00 1.004E+00 1.003E+00 1.003E+00 9.996E-01];
     
writematrix([DE_3He_DSB_anoxic',  DF_3He_DSB_anoxic'], 'MCDS_3HeRBE_DSB_anoxic.txt','Delimiter','tab');

%% Alpha RBE
% Aerobic data taken from MCDS

DE_alphas_DSB_aerobic = [1.000E-03 1.500E-03 2.000E-03 2.500E-03 3.000E-03 4.000E-03...
            5.000E-03 6.000E-03 7.000E-03 8.000E-03 9.000E-03 1.000E-02...
            1.250E-02 1.500E-02 1.750E-02 2.000E-02 2.250E-02 2.500E-02...
            2.750E-02 3.000E-02 3.500E-02 4.000E-02 4.500E-02 5.000E-02...
            5.500E-02 6.000E-02 6.500E-02 7.000E-02 7.500E-02 8.000E-02...
            8.500E-02 9.000E-02 9.500E-02 1.000E-01 1.250E-01 1.500E-01...
            1.750E-01 2.000E-01 2.250E-01 2.500E-01 2.750E-01 3.000E-01...
            3.500E-01 4.000E-01 4.500E-01 5.000E-01 5.500E-01 6.000E-01...
            6.500E-01 7.000E-01 7.500E-01 8.000E-01 8.500E-01 9.000E-01...
            9.500E-01 1.000E+00 1.250E+00 1.500E+00 1.750E+00 2.000E+00...
            2.250E+00 2.500E+00 2.750E+00 3.000E+00 3.500E+00 4.000E+00...
            4.500E+00 5.000E+00 5.500E+00 6.000E+00 6.500E+00 7.000E+00...
            7.500E+00 8.000E+00 8.500E+00 9.000E+00 9.500E+00 1.000E+01...
            1.250E+01 1.500E+01 1.750E+01 2.000E+01 2.500E+01 2.750E+01...
            3.000E+01 3.500E+01 4.000E+01 4.500E+01 5.000E+01 5.500E+01...
            6.000E+01 6.500E+01 7.000E+01 7.500E+01 8.000E+01 8.500E+01...
            9.000E+01 9.500E+01 1.000E+02 1.250E+02 1.500E+02 1.750E+02...
            2.000E+02 2.250E+02 2.500E+02 2.750E+02 3.000E+02 3.500E+02...
            3.750E+02 4.000E+02 4.500E+02 5.000E+02 5.500E+02 6.000E+02...
            6.500E+02 7.000E+02 7.500E+02 8.000E+02 8.500E+02 9.000E+02...
            9.500E+02 1.000E+03 2.000E+03 5.000E+03 7.500E+03 1.000E+04];
     
DF_alphas_DSB_aerobic = [3.381E+00 3.379E+00 3.381E+00 3.380E+00 3.378E+00 3.379E+00...
            3.378E+00 3.377E+00 3.378E+00 3.378E+00 3.377E+00 3.377E+00...
            3.377E+00 3.376E+00 3.374E+00 3.375E+00 3.375E+00 3.373E+00...
            3.371E+00 3.372E+00 3.372E+00 3.370E+00 3.371E+00 3.370E+00...
            3.367E+00 3.368E+00 3.369E+00 3.365E+00 3.365E+00 3.366E+00...
            3.365E+00 3.364E+00 3.362E+00 3.362E+00 3.358E+00 3.355E+00...
            3.352E+00 3.349E+00 3.345E+00 3.342E+00 3.338E+00 3.334E+00...
            3.329E+00 3.323E+00 3.317E+00 3.309E+00 3.303E+00 3.294E+00...
            3.289E+00 3.283E+00 3.276E+00 3.270E+00 3.263E+00 3.253E+00...
            3.247E+00 3.239E+00 3.204E+00 3.165E+00 3.129E+00 3.092E+00...
            3.055E+00 3.018E+00 2.979E+00 2.945E+00 2.869E+00 2.804E+00...
            2.739E+00 2.679E+00 2.622E+00 2.567E+00 2.513E+00 2.466E+00...
            2.417E+00 2.373E+00 2.332E+00 2.291E+00 2.255E+00 2.222E+00...
            2.070E+00 1.948E+00 1.852E+00 1.774E+00 1.654E+00 1.607E+00...
            1.566E+00 1.500E+00 1.444E+00 1.402E+00 1.367E+00 1.338E+00...
            1.311E+00 1.288E+00 1.271E+00 1.254E+00 1.240E+00 1.224E+00...
            1.216E+00 1.204E+00 1.195E+00 1.158E+00 1.131E+00 1.115E+00...
            1.100E+00 1.088E+00 1.079E+00 1.072E+00 1.067E+00 1.057E+00...
            1.053E+00 1.051E+00 1.044E+00 1.041E+00 1.037E+00 1.031E+00...
            1.032E+00 1.029E+00 1.027E+00 1.027E+00 1.024E+00 1.022E+00...
            1.020E+00 1.020E+00 1.010E+00 1.004E+00 1.004E+00 1.002E+00];
     
writematrix([DE_alphas_DSB_aerobic',  DF_alphas_DSB_aerobic'], 'MCDS_alphaRBE_DSB_aerobic.txt','Delimiter','tab');

% Anoxic data taken from MCDS

DE_alphas_DSB_anoxic = [1.000E-03 1.500E-03 2.000E-03 2.500E-03 3.000E-03 4.000E-03...
            5.000E-03 6.000E-03 7.000E-03 8.000E-03 9.000E-03 1.000E-02...
            1.250E-02 1.500E-02 1.750E-02 2.000E-02 2.250E-02 2.500E-02...
            2.750E-02 3.000E-02 3.500E-02 4.000E-02 4.500E-02 5.000E-02...
            5.500E-02 6.000E-02 6.500E-02 7.000E-02 7.500E-02 8.000E-02...
            8.500E-02 9.000E-02 9.500E-02 1.000E-01 1.250E-01 1.500E-01...
            1.750E-01 2.000E-01 2.250E-01 2.500E-01 2.750E-01 3.000E-01...
            3.500E-01 4.000E-01 4.500E-01 5.000E-01 5.500E-01 6.000E-01...
            6.500E-01 7.000E-01 7.500E-01 8.000E-01 8.500E-01 9.000E-01...
            9.500E-01 1.000E+00 1.250E+00 1.500E+00 1.750E+00 2.000E+00...
            2.250E+00 2.500E+00 2.750E+00 3.000E+00 3.500E+00 4.000E+00...
            4.500E+00 5.000E+00 5.500E+00 6.000E+00 6.500E+00 7.000E+00...
            7.500E+00 8.000E+00 8.500E+00 9.000E+00 9.500E+00 1.000E+01...
            1.250E+01 1.500E+01 1.750E+01 2.000E+01 2.500E+01 2.750E+01...
            3.000E+01 3.500E+01 4.000E+01 4.500E+01 5.000E+01 5.500E+01...
            6.000E+01 6.500E+01 7.000E+01 7.500E+01 8.000E+01 8.500E+01...
            9.000E+01 9.500E+01 1.000E+02 1.250E+02 1.500E+02 1.750E+02...
            2.000E+02 2.250E+02 2.500E+02 2.750E+02 3.000E+02 3.500E+02...
            3.750E+02 4.000E+02 4.500E+02 5.000E+02 5.500E+02 6.000E+02...
            6.500E+02 7.000E+02 7.500E+02 8.000E+02 8.500E+02 9.000E+02...
            9.500E+02 1.000E+03 2.000E+03 5.000E+03 7.500E+03 1.000E+04];
     
DF_alphas_DSB_anoxic = [9.826E+00 9.820E+00 9.828E+00 9.823E+00 9.818E+00 9.821E+00...
            9.819E+00 9.815E+00 9.818E+00 9.820E+00 9.815E+00 9.816E+00...
            9.817E+00 9.814E+00 9.808E+00 9.810E+00 9.799E+00 9.794E+00...
            9.789E+00 9.792E+00 9.792E+00 9.785E+00 9.788E+00 9.786E+00...
            9.778E+00 9.781E+00 9.782E+00 9.772E+00 9.772E+00 9.773E+00...
            9.761E+00 9.758E+00 9.752E+00 9.753E+00 9.742E+00 9.723E+00...
            9.713E+00 9.705E+00 9.685E+00 9.677E+00 9.653E+00 9.642E+00...
            9.619E+00 9.592E+00 9.563E+00 9.530E+00 9.501E+00 9.467E+00...
            9.442E+00 9.402E+00 9.372E+00 9.344E+00 9.303E+00 9.264E+00...
            9.226E+00 9.191E+00 8.996E+00 8.787E+00 8.574E+00 8.344E+00...
            8.114E+00 7.871E+00 7.627E+00 7.388E+00 6.912E+00 6.457E+00...
            6.015E+00 5.619E+00 5.255E+00 4.925E+00 4.619E+00 4.357E+00...
            4.119E+00 3.898E+00 3.713E+00 3.543E+00 3.389E+00 3.250E+00...
            2.740E+00 2.405E+00 2.190E+00 2.030E+00 1.816E+00 1.736E+00...
            1.676E+00 1.582E+00 1.507E+00 1.455E+00 1.405E+00 1.372E+00...
            1.339E+00 1.313E+00 1.293E+00 1.274E+00 1.258E+00 1.240E+00...
            1.230E+00 1.221E+00 1.210E+00 1.167E+00 1.137E+00 1.121E+00...
            1.101E+00 1.088E+00 1.079E+00 1.074E+00 1.067E+00 1.059E+00...
            1.054E+00 1.049E+00 1.042E+00 1.039E+00 1.035E+00 1.031E+00...
            1.033E+00 1.027E+00 1.026E+00 1.027E+00 1.023E+00 1.022E+00...
            1.020E+00 1.019E+00 1.006E+00 1.002E+00 1.002E+00 1.000E+00];
     
writematrix([DE_alphas_DSB_anoxic',  DF_alphas_DSB_anoxic'], 'MCDS_alphaRBE_DSB_anoxic.txt','Delimiter','tab');

%% Lithium-7 RBE
% Aerobic data taken from MCDS

DE_lithium_DSB_aerobic = [1.000E-03 1.000E-02 1.000E-01 2.000E-01 3.000E-01 5.000E-01...
            9.000E-01 1.000E+00 1.100E+00 1.300E+00 1.500E+00 2.000E+00...
            2.500E+00 3.000E+00 3.500E+00 4.000E+00 5.000E+00 6.000E+00...
            7.500E+00 1.000E+01 1.500E+01 2.500E+01 3.500E+01 5.000E+01...
            1.000E+02 2.000E+02 3.000E+02 4.000E+02 5.000E+02 7.500E+02...
            1.000E+03 2.000E+03 3.000E+03 4.000E+03 5.000E+03 7.500E+03...
            1.000E+04 2.000E+04 3.000E+04 4.000E+04 5.000E+04 7.500E+04...
            1.000E+05];
     
DF_lithium_DSB_aerobic = [3.387E+00 3.385E+00 3.380E+00 3.378E+00 3.375E+00 3.369E+00...
            3.358E+00 3.354E+00 3.351E+00 3.345E+00 3.338E+00 3.325E+00...
            3.306E+00 3.291E+00 3.275E+00 3.256E+00 3.217E+00 3.183E+00...
            3.127E+00 3.030E+00 2.845E+00 2.540E+00 2.310E+00 2.066E+00...
            1.655E+00 1.371E+00 1.263E+00 1.201E+00 1.165E+00 1.115E+00...
            1.090E+00 1.050E+00 1.038E+00 1.032E+00 1.026E+00 1.022E+00...
            1.020E+00 1.016E+00 1.015E+00 1.015E+00 1.015E+00 1.016E+00...
            1.016E+00];
     
writematrix([DE_lithium_DSB_aerobic',  DF_lithium_DSB_aerobic'], 'MCDS_lithiumRBE_DSB_aerobic.txt','Delimiter','tab');

% Anoxic data taken from MCDS

DE_lithium_DSB_anoxic = [1.000E-03 1.000E-02 1.000E-01 2.000E-01 3.000E-01 5.000E-01...
            9.000E-01 1.000E+00 1.100E+00 1.300E+00 1.500E+00 2.000E+00...
            2.500E+00 3.000E+00 3.500E+00 4.000E+00 5.000E+00 6.000E+00...
            7.500E+00 1.000E+01 1.500E+01 2.500E+01 3.500E+01 5.000E+01...
            1.000E+02 2.000E+02 3.000E+02 4.000E+02 5.000E+02 7.500E+02...
            1.000E+03 2.000E+03 3.000E+03 4.000E+03 5.000E+03 7.500E+03...
            1.000E+04 2.000E+04 3.000E+04 4.000E+04 5.000E+04 7.500E+04...
            1.000E+05];
     
DF_lithium_DSB_anoxic = [9.844E+00 9.838E+00 9.824E+00 9.817E+00 9.801E+00 9.783E+00...
            9.743E+00 9.720E+00 9.713E+00 9.685E+00 9.653E+00 9.596E+00...
            9.522E+00 9.447E+00 9.368E+00 9.274E+00 9.076E+00 8.880E+00...
            8.558E+00 7.958E+00 6.734E+00 4.763E+00 3.603E+00 2.726E+00...
            1.812E+00 1.409E+00 1.283E+00 1.213E+00 1.173E+00 1.121E+00...
            1.090E+00 1.051E+00 1.038E+00 1.032E+00 1.026E+00 1.019E+00...
            1.018E+00 1.016E+00 1.014E+00 1.013E+00 1.014E+00 1.014E+00...
            1.015E+00];
     
writematrix([DE_lithium_DSB_anoxic',  DF_lithium_DSB_anoxic'], 'MCDS_lithiumRBE_DSB_anoxic.txt','Delimiter','tab');
