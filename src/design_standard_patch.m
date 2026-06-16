% DESIGN_STANDARD_PATCH
% Design, Simulation, and Analysis of a Standard Rectangular Microstrip Patch Antenna.
%
% This script uses the MATLAB Antenna Toolbox to model a standard rectangular 
% microstrip patch antenna operating at 2 GHz using FR-4 substrate.
% It validates the return loss (S11), VSWR, and 3D radiation pattern.
%
% Project: Design of a Microstrip Patch Antenna Using MATLAB
% Course target: Zoho, Qualcomm, Intel, Texas Instruments, Nokia, Ericsson, Samsung R&D
% Placements & Placement Prep Package

clear; clc; close all;

% --- Design Specifications ---
fc = 2e9;                  % Resonant frequency: 2.0 GHz
er = 4.4;                  % Relative dielectric constant of substrate (FR-4)
h = 1.6e-3;                % Substrate height: 1.6 mm

% --- Dimension Calculation ---
% Calculate the theoretical dimensions using the Transmission Line Model
[W, eeff, Leff, dL, L, Wg, Lg] = antenna_formulas(fc, er, h);

% --- Toggle Report vs. Theoretical Parameters ---
% Set to true to match the values reported in the academic project report, 
% or false to use the mathematically derived theoretical values.
useReportValues = true; 

if useReportValues
    L_patch = 45.04e-3;    % Report page 36: 45.04 mm
    W_patch = 45.64e-3;    % Report page 36: 45.64 mm
    L_gp = 55.24e-3;       % Report page 36: 55.24 mm
    W_gp = 55.24e-3;       % Report page 36: 55.24 mm
    feedOffset = [-W_patch/4, 0]; % Typical probe offset [-11.41e-3, 0]
    disp('=== DESIGNING STANDARD PATCH ANTENNA (ACADEMIC REPORT VALUES) ===');
else
    L_patch = L;           % Derived: 35.44 mm
    W_patch = W;           % Derived: 45.64 mm
    L_gp = Lg;             % Derived: L + 6h (~45.04 mm)
    W_gp = Wg;             % Derived: W + 6h (~55.24 mm)
    feedOffset = [-W_patch/4, 0];
    disp('=== DESIGNING STANDARD PATCH ANTENNA (FORMULA-DERIVED VALUES) ===');
end

% --- Display Configuration Details ---
fprintf('Patch Width (W):          %.4f mm\n', W_patch * 1e3);
fprintf('Patch Length (L):         %.4f mm\n', L_patch * 1e3);
fprintf('Effective Permittivity:   %.4f\n', eeff);
fprintf('Ground Plane Width (Wg):  %.4f mm\n', W_gp * 1e3);
fprintf('Ground Plane Length (Lg): %.4f mm\n', L_gp * 1e3);
fprintf('Probe Feed Offset [x, y]: [%.4f, %.4f] mm\n', feedOffset(1)*1e3, feedOffset(2)*1e3);
fprintf('--------------------------------------------------\n');

% --- Construct the Antenna Object ---
antennaObject = patchMicrostrip;
antennaObject.Length = L_patch;
antennaObject.Width = W_patch;
antennaObject.Height = h;
antennaObject.GroundPlaneLength = L_gp;
antennaObject.GroundPlaneWidth = W_gp;

% Define dielectric substrate (FR-4 Epoxy)
substrateObj = dielectric('Name', 'FR4', 'EpsilonR', er, 'LossTangent', 0.02);
antennaObject.Substrate = substrateObj;

% Set probe feeding point
antennaObject.FeedOffset = feedOffset;

% --- 1. Visualize Geometry ---
figure('Name', 'Antenna Geometry');
show(antennaObject);
title('Standard Rectangular Patch Antenna Structure');

% --- 2. Run Frequency Sweep & Compute S11 ---
freqRange = linspace(1.5e9, 2.5e9, 51); % 51 points as per project specification
fprintf('Computing Scattering Parameters (S11) from 1.5 to 2.5 GHz...\n');
s = sparameters(antennaObject, freqRange);

figure('Name', 'S11 Return Loss');
rfplot(s);
title('S_{11} Return Loss Parameter (dB)');
grid on;

% --- 3. Compute VSWR ---
vswr_vals = vswr(antennaObject, freqRange);

figure('Name', 'VSWR Graph');
plot(freqRange * 1e-9, vswr_vals, 'LineWidth', 2.0, 'Color', [0.0, 0.4470, 0.7410]);
xlabel('Frequency (GHz)');
ylabel('VSWR');
title('Voltage Standing Wave Ratio (VSWR)');
grid on;
ylim([1, 10]);

% --- 4. Plot 3D Radiation Pattern ---
fprintf('Computing 3D Radiation Pattern at 2 GHz...\n');
figure('Name', '3D Radiation Pattern');
pattern(antennaObject, fc);
title(sprintf('3D Radiation Pattern - Standard Patch at %.2f GHz', fc*1e-9));

disp('Standard patch simulation completed.');
