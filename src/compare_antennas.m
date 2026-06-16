% COMPARE_ANTENNAS
% Automated Simulation and Comparative Analysis of Standard vs. E-Notch Antennas.
%
% This script runs simulations for both the Standard Rectangular Patch Antenna
% and the E-Notch Patch Antenna, overlaying their Return Loss (S11) and VSWR
% curves to visually demonstrate the performance enhancements.
%
% Project: Design of a Microstrip Patch Antenna Using MATLAB
% Course target: Zoho, Qualcomm, Intel, Texas Instruments, Nokia, Ericsson, Samsung R&D
% Placements & Placement Prep Package

clear; clc; close all;

% --- Design Specifications ---
fc = 2e9;                  % 2.0 GHz operating center frequency
er = 4.4;                  % Substrate Permittivity (FR-4)
h = 1.6e-3;                % Thickness: 1.6 mm
c = 3e8;

disp('==================================================================');
disp('   MICROSTRIP PATCH ANTENNA COMPARATIVE ANALYSIS SIMULATION TOOL  ');
disp('==================================================================');

% --- Calculations ---
[W, eeff, Leff, dL, L, Wg, Lg] = antenna_formulas(fc, er, h);

% Using Academic Report parameters
L_patch = 45.04e-3;
W_patch = 45.64e-3;
L_gp = 55.24e-3;
W_gp = 55.24e-3;

% --- Construct Standard Patch Antenna ---
disp('Configuring Standard Rectangular Patch...');
stdPatch = patchMicrostrip;
stdPatch.Length = L_patch;
stdPatch.Width = W_patch;
stdPatch.Height = h;
stdPatch.GroundPlaneLength = L_gp;
stdPatch.GroundPlaneWidth = W_gp;
stdPatch.Substrate = dielectric('Name', 'FR4', 'EpsilonR', er, 'LossTangent', 0.02);
stdPatch.FeedOffset = [-W_patch/4, 0];

% --- Construct E-Notch Patch Antenna ---
disp('Configuring E-Notch Patch (pcbStack)...');
mainRect = antenna.Rectangle('Length', L_patch, 'Width', W_patch, 'Center', [0, 0]);
notchL = 0.513 * L_patch;
notchW = 0.065 * W_patch;
yOffset = W_patch / 4;

n1 = antenna.Rectangle('Length', notchL, 'Width', notchW, 'Center', [L_patch/2 - notchL/2, yOffset]);
n2 = antenna.Rectangle('Length', notchL, 'Width', notchW, 'Center', [L_patch/2 - notchL/2, -yOffset]);
ePatchShape = mainRect - n1 - n2;

enotchAnt = pcbStack;
enotchAnt.BoardThickness = h;
enotchAnt.BoardShape = antenna.Rectangle('Length', L_gp, 'Width', W_gp);
enotchAnt.Layers = {ePatchShape, stdPatch.Substrate, antenna.Rectangle('Length', L_gp, 'Width', W_gp)};
enotchAnt.FeedLocations = [-W_patch/6, 0, 1, 3];
enotchAnt.FeedDiameter = 1.2e-3;

% --- Run Simulation Sweep ---
% 101 points sweep provides a balanced speed/resolution simulation
freqs = linspace(1.5e9, 2.5e9, 101);
freqsGHz = freqs * 1e-9;

disp('Simulating Standard Patch S-parameters...');
sStd = sparameters(stdPatch, freqs);
s11Std_dB = 20*log10(abs(squeeze(sStd.Parameters(1,1,:))));

disp('Simulating E-Notch Patch S-parameters...');
sEnotch = sparameters(enotchAnt, freqs);
s11Enotch_dB = 20*log10(abs(squeeze(sEnotch.Parameters(1,1,:))));

% Compute VSWR values
disp('Computing VSWR...');
vswrStd = vswr(stdPatch, freqs);
vswrEnotch = vswr(enotchAnt, freqs);

% --- Plotting Overlay Comparisons ---

% 1. S11 Overlay Plot
figure('Name', 'S11 Return Loss Comparison', 'Position', [100, 100, 800, 500]);
plot(freqsGHz, s11Std_dB, 'b--', 'LineWidth', 2.0); hold on;
plot(freqsGHz, s11Enotch_dB, 'r-', 'LineWidth', 2.0);
xlabel('Frequency (GHz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Return Loss S_{11} (dB)', 'FontSize', 12, 'FontWeight', 'bold');
title('Return Loss (S_{11}) Overlay Comparison', 'FontSize', 14, 'FontWeight', 'bold');
legend('Standard Rectangular Patch', 'E-Notch Patch', 'Location', 'best');
grid on;
ax = gca;
ax.FontSize = 10;
ax.LineWidth = 1.2;
yline(-10, 'k:', 'LineWidth', 1.5); % -10 dB reference line

% 2. VSWR Overlay Plot
figure('Name', 'VSWR Comparison', 'Position', [150, 150, 800, 500]);
plot(freqsGHz, vswrStd, 'b--', 'LineWidth', 2.0); hold on;
plot(freqsGHz, vswrEnotch, 'r-', 'LineWidth', 2.0);
xlabel('Frequency (GHz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('VSWR', 'FontSize', 12, 'FontWeight', 'bold');
title('Voltage Standing Wave Ratio (VSWR) Overlay Comparison', 'FontSize', 14, 'FontWeight', 'bold');
legend('Standard Rectangular Patch', 'E-Notch Patch', 'Location', 'best');
grid on;
ax = gca;
ax.FontSize = 10;
ax.LineWidth = 1.2;
yline(2.0, 'k:', 'LineWidth', 1.5); % VSWR = 2.0 reference line
ylim([1, 6]);

% --- Compute Key RF Metrics ---

% 1. Return Loss at 2 GHz (index closest to 2e9)
[~, idx2GHz] = min(abs(freqs - 2e9));
s11Std_2GHz = s11Std_dB(idx2GHz);
s11Enotch_2GHz = s11Enotch_dB(idx2GHz);
vswrStd_2GHz = vswrStd(idx2GHz);
vswrEnotch_2GHz = vswrEnotch(idx2GHz);

% 2. Bandwidth Calculations (S11 < -10 dB)
bwStdIdx = s11Std_dB < -10;
if any(bwStdIdx)
    bwStd_Hz = freqs(find(bwStdIdx, 1, 'last')) - freqs(find(bwStdIdx, 1, 'first'));
    ibwStd = (bwStd_Hz / 2e9) * 100;
else
    bwStd_Hz = 0;
    ibwStd = 0;
end

bwEnotchIdx = s11Enotch_dB < -10;
if any(bwEnotchIdx)
    bwEnotch_Hz = freqs(find(bwEnotchIdx, 1, 'last')) - freqs(find(bwEnotchIdx, 1, 'first'));
    ibwEnotch = (bwEnotch_Hz / 2e9) * 100;
else
    bwEnotch_Hz = 0;
    ibwEnotch = 0;
end

% --- Display Comparative Analysis Report ---
disp('==================================================================');
disp('                    RF PERFORMANCE REPORT SUMMARY                 ');
disp('==================================================================');
fprintf('Parameter                    | Standard Patch    | E-Notch Patch\n');
fprintf('-----------------------------+-------------------+----------------\n');
fprintf('Antenna Type                 | Rectangular       | E-Shaped Notched\n');
fprintf('Center Frequency             | 2.0 GHz           | 2.0 GHz\n');
fprintf('Dielectric Constant (er)     | 4.4 (FR-4)        | 4.4 (FR-4)\n');
fprintf('Substrate Height (h)         | 1.6 mm            | 1.6 mm\n');
fprintf('Feed Position Offset         | [-W/4, 0]         | [-W/6, 0]\n');
fprintf('Return Loss S11 at 2 GHz     | %.2f dB         | %.2f dB\n', s11Std_2GHz, s11Enotch_2GHz);
fprintf('VSWR at 2 GHz                | %.2f              | %.2f\n', vswrStd_2GHz, vswrEnotch_2GHz);
fprintf('Impedance Bandwidth (Hz)     | %.2f MHz         | %.2f MHz\n', bwStd_Hz*1e-6, bwEnotch_Hz*1e-6);
fprintf('Fractional Bandwidth (%%)     | %.2f%%            | %.2f%%\n', ibwStd, ibwEnotch);
fprintf('Bandwidth Expansion Factor   | Reference (1.0x)  | %.2fx\n', ibwEnotch / max(1e-3, ibwStd));
disp('==================================================================');

% --- Plot Radiation Patterns Side-by-Side ---
disp('Plotting comparative Radiation Patterns...');
figure('Name', 'Radiation Patterns', 'Position', [200, 200, 1000, 500]);
subplot(1,2,1);
pattern(stdPatch, fc);
title('Standard Patch - 2 GHz');

subplot(1,2,2);
pattern(enotchAnt, fc);
title('E-Notch Patch - 2 GHz');

disp('Comparative analysis simulation complete.');
