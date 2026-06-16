% DESIGN_ENOTCH_PATCH
% Design, Simulation, and Analysis of an E-Notch Microstrip Patch Antenna.
%
% This script uses the MATLAB Antenna Toolbox to model an E-Notch patch antenna
% operating at 2 GHz using FR-4 substrate. The custom E-Notch geometry is
% constructed using constructive solid geometry (CSG) subtraction within a
% pcbStack object.
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
    
    % Notch dimensions (Report page 43: Notch Length = 0.513 * L, Notch Width = 0.065 * W)
    notchLength = 0.513 * L_patch; % ~23.10 mm
    notchWidth = 0.065 * W_patch;  % ~2.97 mm
    
    feedOffset = [-W_patch/6, 0];  % Report page 43: [-W/6, 0] = [-7.61e-3, 0]
    disp('=== DESIGNING E-NOTCH PATCH ANTENNA (ACADEMIC REPORT VALUES) ===');
else
    L_patch = L;           % Derived: 35.44 mm
    W_patch = W;           % Derived: 45.64 mm
    L_gp = Lg;             % Derived: L + 6h (~45.04 mm)
    W_gp = Wg;             % Derived: W + 6h (~55.24 mm)
    
    notchLength = 0.513 * L_patch;
    notchWidth = 0.065 * W_patch;
    
    feedOffset = [-W_patch/6, 0];
    disp('=== DESIGNING E-NOTCH PATCH ANTENNA (FORMULA-DERIVED VALUES) ===');
end

% Typical notch center offsets along the non-radiating edges (Y-axis)
% Placing them symmetrically at +/- Y_offset. Let's space them W_patch/4 apart.
yNotchOffset = W_patch / 4; 

% --- Display Configuration Details ---
fprintf('Patch Width (W):          %.4f mm\n', W_patch * 1e3);
fprintf('Patch Length (L):         %.4f mm\n', L_patch * 1e3);
fprintf('Notch Length (Ln):        %.4f mm\n', notchLength * 1e3);
fprintf('Notch Width (Wn):         %.4f mm\n', notchWidth * 1e3);
fprintf('Notch Y-Spacing:          %.4f mm\n', yNotchOffset * 2 * 1e3);
fprintf('Ground Plane Width (Wg):  %.4f mm\n', W_gp * 1e3);
fprintf('Ground Plane Length (Lg): %.4f mm\n', L_gp * 1e3);
fprintf('Probe Feed Offset [x, y]: [%.4f, %.4f] mm\n', feedOffset(1)*1e3, feedOffset(2)*1e3);
fprintf('--------------------------------------------------\n');

% --- Construct the Custom E-Notch Geometry ---
% Main Patch Rectangle (centered at [0,0])
mainPatch = antenna.Rectangle('Length', L_patch, 'Width', W_patch, 'Center', [0, 0]);

% Symmetric notches carved from the right radiating edge (X = L_patch/2)
notch1 = antenna.Rectangle('Length', notchLength, 'Width', notchWidth, ...
                           'Center', [L_patch/2 - notchLength/2, yNotchOffset]);
notch2 = antenna.Rectangle('Length', notchLength, 'Width', notchWidth, ...
                           'Center', [L_patch/2 - notchLength/2, -yNotchOffset]);

% Boolean subtraction to create the E-shape
topMetalPatch = mainPatch - notch1 - notch2;

% --- Build PCB Stack Antenna Object ---
enotchAntenna = pcbStack;
enotchAntenna.Name = 'E-Notch Microstrip Patch Antenna';
enotchAntenna.BoardThickness = h;
enotchAntenna.BoardShape = antenna.Rectangle('Length', L_gp, 'Width', W_gp);

% Set layers: 1: Top Metal (Patch), 2: Dielectric Substrate, 3: Ground Plane
groundPlane = antenna.Rectangle('Length', L_gp, 'Width', W_gp);
substrateObj = dielectric('Name', 'FR4', 'EpsilonR', er, 'LossTangent', 0.02);

enotchAntenna.Layers = {topMetalPatch, substrateObj, groundPlane};

% Set Feed Probe location and dimensions
% Connection between Layer 1 (Patch) and Layer 3 (Ground)
enotchAntenna.FeedLocations = [feedOffset(1), feedOffset(2), 1, 3];
enotchAntenna.FeedDiameter = 1.2e-3;

% --- 1. Visualize Geometry ---
figure('Name', 'E-Notch Geometry');
show(enotchAntenna);
title('E-Notch Microstrip Patch Antenna Structure');

% --- 2. Run Frequency Sweep & Compute S11 ---
% 301 points sweep as specified in report parameter table (page 43)
freqRange = linspace(1.5e9, 2.5e9, 301); 
fprintf('Computing Scattering Parameters (S11) from 1.5 to 2.5 GHz (301 points)...\n');
s = sparameters(enotchAntenna, freqRange);

figure('Name', 'E-Notch S11');
rfplot(s);
title('S_{11} Return Loss Parameter (dB) - E-Notch');
grid on;

% --- 3. Compute VSWR ---
vswr_vals = vswr(enotchAntenna, freqRange);

figure('Name', 'E-Notch VSWR');
plot(freqRange * 1e-9, vswr_vals, 'LineWidth', 2.0, 'Color', [0.8500, 0.3250, 0.0980]);
xlabel('Frequency (GHz)');
ylabel('VSWR');
title('Voltage Standing Wave Ratio (VSWR) - E-Notch');
grid on;
ylim([1, 10]);

% --- 4. Plot 3D Radiation Pattern ---
fprintf('Computing 3D Radiation Pattern at 2 GHz...\n');
figure('Name', '3D Radiation Pattern');
pattern(enotchAntenna, fc);
title(sprintf('3D Radiation Pattern - E-Notch Patch at %.2f GHz', fc*1e-9));

disp('E-Notch patch simulation completed.');
