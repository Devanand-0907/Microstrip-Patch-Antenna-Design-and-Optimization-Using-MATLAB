# Design and Bandwidth Optimization of a Microstrip Patch Antenna Using MATLAB

[![MATLAB](https://img.shields.io/badge/MATLAB-R2023a%20%2B-blue.svg?logo=mathworks&logoColor=white)](https://www.mathworks.com/products/matlab.html)
[![Antenna Toolbox](https://img.shields.io/badge/MATLAB-Antenna%20Toolbox-orange.svg)](https://www.mathworks.com/products/antenna.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![RF Engineering](https://img.shields.io/badge/Domain-RF%20%26%20Wireless-purple.svg)](#)
[![Placement Ready](https://img.shields.io/badge/Target-Qualcomm%20%7C%20Intel%20%7C%20TI-red.svg)](#)

A comprehensive engineering simulation and optimization suite comparing a **Standard Rectangular Microstrip Patch Antenna** and an optimized **E-Notch Microstrip Patch Antenna** operating at $2.0\text{ GHz}$. Designed for low-profile, cost-effective wireless communication applications (such as Wi-Fi, Bluetooth, and IoT) on a 1.6 mm FR-4 glass-epoxy substrate.

---

## Table of Contents
1. [Project Overview](#1-project-overview)
2. [Executive Summary](#2-executive-summary)
3. [Problem Statement](#3-problem-statement)
4. [Objectives](#4-objectives)
5. [Project Architecture](#5-project-architecture)
6. [Design Methodology](#6-design-methodology)
7. [Mathematical Modeling](#7-mathematical-modeling)
8. [Antenna Design Parameters](#8-antenna-design-parameters)
9. [MATLAB Implementation Details](#9-matlab-implementation-details)
10. [Simulation Workflow](#10-simulation-workflow)
11. [Technology Stack](#11-technology-stack)
12. [Features and Innovations](#12-features-and-innovations)
13. [Comparative Analysis](#13-comparative-analysis)
14. [Results and Performance Evaluation](#14-results-and-performance-evaluation)
15. [Scattering Parameter (S11) Analysis](#15-scattering-parameter-s11-analysis)
16. [VSWR Analysis](#16-vswr-analysis)
17. [Radiation Pattern Analysis](#17-radiation-pattern-analysis)
18. [Bandwidth Improvement Discussion](#18-bandwidth-improvement-discussion)
19. [Key Findings](#19-key-findings)
20. [Practical Applications](#20-practical-applications)
21. [Future Enhancements](#21-future-enhancements)
22. [Research Contributions](#22-research-contributions)
23. [Installation Guide](#23-installation-guide)
24. [How to Run the MATLAB Project](#24-how-to-run-the-matlab-project)
25. [Folder Structure](#25-folder-structure)
26. [Screenshots & Figure Placeholders](#26-screenshots--figure-placeholders)
27. [Detailed Results Tables](#27-detailed-results-tables)
28. [References](#28-references)
29. [License](#29-license)
30. [Authors](#30-authors)
31. [Acknowledgements](#31-acknowledgements)

---

## 1. Project Overview
This repository hosts the code, design formulations, and simulation setups for the analysis and optimization of microstrip patch antennas (MPAs) using the **MATLAB Antenna Toolbox**. The project introduces a comparative framework between a baseline rectangular patch and a geometrically modified **E-Notch** patch antenna, both tuned to resonance at $2.0\text{ GHz}$. The E-notch design incorporates slot-loading techniques to modify top-layer current paths, introducing secondary slot resonances to overcome the inherent narrow bandwidth constraints of conventional planar antennas.

---

## 2. Executive Summary
This work systematically analyzes the performance of a conventional rectangular patch antenna and compares it with a modified E-notched patch antenna. The antennas are simulated on a $1.6\text{ mm}$ thick FR-4 substrate ($\epsilon_r = 4.4, \tan\delta = 0.02$). By utilizing constructive solid geometry, two symmetric notches of dimensions $L_n = 0.513 \times L$ and $W_n = 0.065 \times W$ are etched into the patch. 

Simulation results verify that the E-notch design dramatically improves the impedance match at resonance, shifting the return loss ($S_{11}$) from **$-11.0\text{ dB}$** (standard) to **$-27.50\text{ dB}$** (E-notch) at $2.0\text{ GHz}$, while minimizing the VSWR to **$1.088$** (only 0.18% reflected power). This project demonstrates a cost-effective path to designing wideband, high-efficiency antennas suitable for highly integrated, low-profile consumer wireless systems.

---

## 3. Problem Statement
Traditional microstrip patch antennas (MSAs) are widely used due to their low profile, ease of printed circuit board (PCB) integration, and lightweight properties. However, their physical structure acts as a high-Q cavity resonator, which inherently suffers from:
*   **Narrow Bandwidth:** Typically $2\% - 3\%$, limiting their use in broadband networks.
*   **Low Gain:** Restricted due to surface wave excitation and dielectric losses in thin substrates.
*   **Impedance Mismatches:** High susceptibility to reflection losses when fed directly by standard $50\ \Omega$ coaxial cables.

These limitations make conventional patches unsuitable for high-speed, multi-band modern wireless protocols unless geometric optimizations are introduced.

---

## 4. Objectives
The primary objectives of this engineering project are:
1.  **Analytical Modeling:** Derive the exact physical dimensions ($W, L, L_g, W_g$) of a rectangular patch antenna operating at $2.0\text{ GHz}$ using transmission line theory.
2.  **Geometric Modification:** Implement an E-notch slotting technique to expand the operating bandwidth and improve return loss.
3.  **Feed Optimization:** Evaluate impedance matching performance by contrasting a coaxial probe offset of $-W/4$ (standard rectangular) with $-W/6$ (E-notch).
4.  **Full-Wave Electromagnetic Simulation:** Compute S-parameters ($S_{11}$), VSWR, and 3D Radiation Patterns in MATLAB to validate design assumptions.
5.  **Comparative Performance Mapping:** Conduct parametric comparisons between simulated results and mathematical predictions.

---

## 5. Project Architecture
The engineering workflow follows a modular structural layout from mathematical formulation to full-wave simulation:

```
  +-----------------------------------------------------------+
  |              1. RF Technical Specifications               |
  |     (Target: 2.0 GHz, Substrate: FR-4, Thickness: 1.6mm)  |
  +------------------------------+----------------------------+
                                 |
                                 v
  +-----------------------------------------------------------+
  |             2. Analytical Modeling (Balanis)              |
  |   (Calculates W, L, Leff, eeff, Ground Plane dimensions)  |
  +------------------------------+----------------------------+
                                 |
                                 v
  +------------------------------+----------------------------+
  |            3. MATLAB CAD Geometry Construction            |
  |     - Standard: patchMicrostrip                           |
  |     - E-Notch: pcbStack (CSG Boolean: Main - 2 Notches)   |
  +------------------------------+----------------------------+
                                 |
                                 v
  +------------------------------+----------------------------+
  |             4. Full-Wave EM Simulation Solver             |
  |      (Method of Moments (MoM) surface mesh evaluation)    |
  +------------------------------+----------------------------+
                                 |
        +------------------------+------------------------+
        |                                                 |
        v                                                 v
  +-----+------------------------+                  +-----+------------------------+
  |   5a. Standard Rectangular   |                  |       5b. E-Notch Patch      |
  |   - Feed Offset: [-W/4, 0]   |                  |   - Feed Offset: [-W/6, 0]   |
  |   - Return Loss: -11 dB      |                  |   - Return Loss: -27.50 dB   |
  |   - VSWR: ~1.8               |                  |   - VSWR: 1.088              |
  +-----+------------------------+                  +-----+------------------------+
        |                                                 |
        +------------------------+------------------------+
                                 |
                                 v
  +------------------------------+----------------------------+
  |           6. Parameter Optimization Plotting              |
  |         (Overlay S11, VSWR, Radiation Gain Pattern)        |
  +-----------------------------------------------------------+
```

---

## 6. Design Methodology
The development is executed in three distinct stages:
1.  **Theoretical Computation:** Utilizing standard transmission line formulations to resolve primary dimension constants.
2.  **Solid Geometry Modeling:** The top metallization layer of the E-notch is generated by subtracting two symmetric rectangular notch profiles from the radiating edge. The centers of the notches are placed along the Y-axis at $Y = \pm W/4$.
3.  **Method of Moments (MoM) Simulation:** The structures are meshed and solved in the frequency domain. S-parameter sweeps are evaluated from $1.5\text{ GHz}$ to $2.5\text{ GHz}$ with an optimized mesh structure to capture fine field variations near the slot corners.

---

## 7. Mathematical Modeling
The dimensions of the standard patch antenna are resolved using the transmission line model.

### 7.1 Patch Width ($W$)
To support efficient radiation, the patch width is computed as:

$$W = \frac{c}{2 f_c} \sqrt{\frac{2}{\epsilon_r + 1}}$$

For $c = 3 \times 10^8\text{ m/s}$, $f_c = 2.0\text{ GHz}$, and $\epsilon_r = 4.4$:
$$W = \frac{3 \times 10^8}{2 \times 2 \times 10^9} \sqrt{\frac{2}{4.4 + 1}} \approx 45.64\text{ mm}$$

### 7.2 Effective Dielectric Constant ($\epsilon_{eff}$)
Accounting for fringing fields in air:

$$\epsilon_{eff} = \frac{\epsilon_r + 1}{2} + \frac{\epsilon_r - 1}{2} \left[1 + 12\frac{h}{W}\right]^{-1/2}$$

Substituting $h = 1.6\text{ mm}$ and $W = 45.64\text{ mm}$:
$$\epsilon_{eff} \approx 4.13$$

### 7.3 Effective Length ($L_{eff}$)
$$L_{eff} = \frac{c}{2 f_c \sqrt{\epsilon_{eff}}} \approx 36.92\text{ mm}$$

### 7.4 Fringing Extension ($\Delta L$) and Physical Length ($L$)
$$\Delta L = 0.412 \cdot h \frac{(\epsilon_{eff} + 0.3) \left(\frac{W}{h} + 0.264\right)}{(\epsilon_{eff} - 0.258) \left(\frac{W}{h} + 0.8\right)} \approx 0.74\text{ mm}$$

$$L = L_{eff} - 2\Delta L \approx 35.44\text{ mm}$$

*Design Note: The project report uses $L = 45.04\text{ mm}$ as its physical length, which is validated alongside the theoretical $35.44\text{ mm}$ value in our scripts.*

---

## 8. Antenna Design Parameters

The physical dimensions computed and simulated for both systems are summarized below:

| Parameter | Mathematical Formula / Source | Standard Rectangular | E-Notch Patch |
| :--- | :--- | :--- | :--- |
| **Center Frequency ($f_c$)** | Target Specification | $2.0\text{ GHz}$ | $2.0\text{ GHz}$ |
| **Permittivity ($\epsilon_r$)** | Substrate Choice | $4.4\text{ (FR-4)}$ | $4.4\text{ (FR-4)}$ |
| **Substrate Height ($h$)** | Substrate Thickness | $1.6\text{ mm}$ | $1.6\text{ mm}$ |
| **Patch Width ($W$)** | $W = \frac{c}{2f_c}\sqrt{\frac{2}{\epsilon_r+1}}$ | $45.64\text{ mm}$ | $45.64\text{ mm}$ |
| **Patch Length ($L$)** | $L = L_{eff} - 2\Delta L$ | $45.04\text{ mm}$ (Report) | $45.04\text{ mm}$ (Report) |
| **Ground Plane ($W_g \times L_g$)**| Ground Boundary Sizing | $55.24 \times 55.24\text{ mm}$ | $55.24 \times 55.24\text{ mm}$ |
| **Feed Point Location** | Coaxial Probe Offset | $[-W/4, 0] = [-11.41, 0]$ | $[-W/6, 0] = [-7.61, 0]$ |
| **Notch Length ($L_n$)** | $0.513 \times L$ | N/A | $23.10\text{ mm}$ |
| **Notch Width ($W_n$)** | $0.065 \times W$ | N/A | $2.97\text{ mm}$ |

---

## 9. MATLAB Implementation Details
The simulation scripts utilize object-oriented scripting supported by the MATLAB Antenna Toolbox:
*   `patchMicrostrip`: Used to instantiate the standard rectangular patch. It provides properties to configure the length, width, substrate material, and feed offsets directly.
*   `antenna.Rectangle`: Standard shapes used for CAD creation. By subtracting rectangles, we define the top layer of the E-notch antenna.
*   `pcbStack`: The custom layering framework. This stack maps the E-notch top metal layer, the dielectric slab, and the solid ground plane together, assigning feed probes between layer 1 and layer 3.
*   `sparameters`: Solves the electromagnetic structure over a frequency range using the Method of Moments solver.
*   `pattern`: Computes and visualizes the radiation pattern, calculating peak directivity and gain in dBi.

---

## 10. Simulation Workflow
The solver steps implemented in the scripts include:
1.  **Board Construction:** Define dielectric properties ($\epsilon_r = 4.4$, $\tan\delta = 0.02$) and compile the PCB stack.
2.  **Meshing Control:** Generate a triangular surface mesh. Points near the notch corners are automatically refined to prevent computational errors from high field concentrations.
3.  **Solver Execution:** Solve the surface currents at each frequency step.
4.  **Data Extraction:** Write return loss and VSWR data vectors to the workspace for comparative plotting.

---

## 11. Technology Stack
*   **Core Environment:** MATLAB (R2023a or newer recommended).
*   **Toolboxes:**
    *   Antenna Toolbox (for geometric modeling and EM solver).
    *   RF System Toolbox (for sparameters manipulation and RF plotting).
*   **Version Control:** Git.

---

## 12. Features and Innovations
*   **E-Shape Geometry:** Extends the physical flow path of surface currents, artificially increasing the electrical length of the antenna.
*   **Coupled Dual Resonance:** The slots create a secondary resonance loop at a higher frequency ($2.2\text{ GHz} - 2.42\text{ GHz}$). When placed close to the main $2.0\text{ GHz}$ resonance, the peaks merge to expand the operating bandwidth.
*   **Tuned Probe Feed Offset:** Relocating the feed point to $[-W/6, 0]$ optimizes the impedance matching of the complex E-notch patch, dropping the reflection coefficient to an outstanding $0.0422$.

---

## 13. Comparative Analysis
A side-by-side comparison of the standard and proposed system:

```
        Standard Rectangular Patch                   E-Notch Patch
      +-----------------------------+       +-----------------------------+
      |                             |       |      | |             | |    |
      |                             |       |  Ln  | |             | |    |
      |              x              |       |      | |      x      | |    |
      |          Feed[-W/4,0]       |       |      +-+             +-+    |
      |                             |       |          Feed[-W/6,0]       |
      |                             |       |  <Wn>                     |
      +-----------------------------+       +-----------------------------+
               Width (W)                             Width (W)
```

| Feature | Standard Rectangular Patch | E-Notch Patch Antenna |
| :--- | :--- | :--- |
| **Geometry** | Solid Rectangular Patch | E-Shaped (Double-notch) Patch |
| **Resonant Frequency** | Single resonance near $2.0\text{ GHz}$ | Dual/Multi-band resonance ($2.0\text{ GHz} - 2.4\text{ GHz}$) |
| **Return Loss ($S_{11}$)** | $-11.0\text{ dB}$ (Acceptable matching) | **$-27.50\text{ dB}$** (Excellent matching) |
| **VSWR at 2 GHz** | $\approx 1.8$ | **$1.088$** (Near-ideal) |
| **Reflected Power** | $\approx 8.2\%$ | **$0.18\%$** (Negligible) |
| **Bandwidth (S11 < -10dB)**| Narrow ($\approx 2\%$) | Expanded Broadband ($\approx 5\% - 6.9\%$) |
| **Design Complexity** | Low (Straightforward design) | Moderate (Requires notch optimization) |

---

## 14. Results and Performance Evaluation
The simulation models are analyzed using three key performance indicators: scattering parameters ($S_{11}$), Voltage Standing Wave Ratio (VSWR), and 3D radiation patterns.

---

## 15. Scattering Parameter (S11) Analysis
The return loss ($S_{11}$) measures reflected signal power. 
*   **Standard Patch:** Dips to about **$-11.0\text{ dB}$** at $2.0\text{ GHz}$, satisfying the basic limit ($S_{11} \le -10\text{ dB}$) but leaving the system susceptible to minor environmental shifts.
*   **E-Notch Patch:** Exhibits a deep resonance of **$-27.50\text{ dB}$** at $2.0\text{ GHz}$. It also maintains secondary return loss dips of **$-21.40\text{ dB}$** at $2.20\text{ GHz}$, and **$-24.10\text{ dB}$** at $2.42\text{ GHz}$, verifying a multi-resonance wideband operational state.

---

## 16. VSWR Analysis
The VSWR measures voltage stand waves resulting from mismatches:
*   **Standard Patch:** A VSWR of $\approx 1.8$ is obtained at $2.0\text{ GHz}$, representing a transmission efficiency of $91.8\%$.
*   **E-Notch Patch:** VSWR drops to **$1.088$** at $2.0\text{ GHz}$ (99.82% efficiency), **$1.20$** at $2.20\text{ GHz}$ (99.09% efficiency), and **$1.14$** at $2.42\text{ GHz}$ (99.48% efficiency), proving stable matching.

---

## 17. Radiation Pattern Analysis
The 3D radiation pattern demonstrates directional coverage:
*   Both antennas maintain a stable **broadside radiation pattern**, with the main lobe pointing along the Z-axis perpendicular to the patch surface.
*   The peak directivity gain is approximately **$5.37\text{ dBi}$** at $2.0\text{ GHz}$.
*   The radiation pattern remains stable across the expanded operating band, indicating that the introduction of notches does not distort the directional characteristics.

---

## 18. Bandwidth Improvement Discussion
In a standard microstrip patch, the bandwidth is constrained by the thickness of the dielectric. Since thick substrates are costly and introduce surface waves, physical slot-loading is preferred. The E-notch slot acts as an impedance tuner. By introducing capacitance and inductance at the patch edges, it offsets the input impedance variations across a larger frequency range. This merges multiple resonance bands, achieving a **fractional bandwidth increase of over 150%** relative to the standard rectangular design.

---

## 19. Key Findings
1.  **Impedance Matching:** Moving the feed point from $-W/4$ to $-W/6$ in the presence of E-notches provides a superior impedance match to a $50\ \Omega$ feed line.
2.  **Reflected Power Minimization:** The reflected power of the E-notch antenna is reduced to only **0.18%**, preventing heat dissipation and potential damage to transmitter circuit components.
3.  **Stability of FR-4:** Despite its higher loss tangent ($\tan\delta = 0.02$), FR-4 is shown to be a viable substrate for low-cost wideband prototypes when combined with slot-loading.

---

## 20. Practical Applications
*   **WLAN / Wi-Fi Networks:** Operates efficiently in the $2.4\text{ GHz}$ IEEE 802.11 b/g/n bands.
*   **Bluetooth Communications:** Low-profile, high-efficiency structure ideal for Bluetooth-enabled consumer IoT devices.
*   **RFID Systems:** Suitable for UHF RFID readers and tracking transponders.
*   **ISM Band Applications:** Operates in the license-free Industrial, Scientific, and Medical bands.

---

## 21. Future Enhancements
*   **Rogers RT/duroid Substrates:** Transitioning design from FR-4 to low-loss polytetrafluoroethylene (PTFE) based Rogers substrates ($\epsilon_r = 2.2, \tan\delta = 0.0009$) to boost gain and radiation efficiency.
*   **Sub-6 GHz 5G Scaling:** Re-scaling the antenna parameters to operate at the $3.5\text{ GHz}$ and $6.0\text{ GHz}$ bands for 5G cellular communication.
*   **Defected Ground Structures (DGS):** Etching slots into the ground plane to further suppress surface waves and improve front-to-back ratios.
*   **Active Tuning:** Integrating varactor diodes inside the notches to dynamically tune the resonant frequency.

---

## 22. Research Contributions
*   **Analytical Verification:** Verification of Bahl-Bhartia approximations for fringing fields on FR-4 substrates.
*   **Parametric Optimization:** Documentation of current distributions around notch boundaries, showing the physical mechanisms behind wideband slot-coupling.
*   **Open-Source RF Modeling:** Providing a clean, fully-runnable MATLAB simulation framework to serve as a baseline for academic research.

---

## 23. Installation Guide
To clone and run this project, make sure you have Git and MATLAB installed.

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/Devanand-0907/Microstrip-Patch-Antenna-Design-and-Optimization-Using-MATLAB.git
    cd Microstrip-Patch-Antenna-Design-and-Optimization-Using-MATLAB
    ```
2.  **Open MATLAB:** Launch MATLAB (R2023a or newer recommended).
3.  **Add to Path:** Add the `src/` folder to your MATLAB path.

---

## 24. How to Run the MATLAB Project
You can execute individual antenna designs or run the automated comparison:

*   **To run the Standard Rectangular Patch simulation:**
    Open `src/design_standard_patch.m` in MATLAB and click **Run**.
*   **To run the E-Notch Patch simulation:**
    Open `src/design_enotch_patch.m` in MATLAB and click **Run**.
*   **To generate the comparative overlay plots and performance tables:**
    Open `src/compare_antennas.m` and click **Run**. S11 and VSWR curves will be plotted side-by-side and a performance report will print to the command window.

---

## 25. Folder Structure
```
├── src/
│   ├── antenna_formulas.m     # Design dimension calculations
│   ├── design_standard_patch.m # Standard rectangular patch simulation
│   ├── design_enotch_patch.m   # E-notch patch simulation
│   └── compare_antennas.m     # Comparative sweeps & overlay plots
├── docs/
│   ├── mathematical_modeling.md # Analytical math derivations
│   └── images/                # Placeholders for generated graphs
├── career_assets/
│   ├── placement_kit.md       # ATS resume, LinkedIn & interview scripts
│   └── recruiter_brief.md     # Recruiter competency mapping guide
├── LICENSE                    # MIT License
├── .gitignore                 # MATLAB file exclusions
└── README.md                  # Project documentation (This file)
```

---

## 26. Screenshots & Figure Placeholders
*Placeholders for user-generated simulation plots. When running the scripts, export the generated MATLAB figures to `docs/images/` to update these files:*

*   **Standard Patch Structure Layout:**
    `![Standard Patch Geometry](docs/images/std_geometry.png)`
*   **E-Notch Patch Structure Layout:**
    `![E-Notch Geometry](docs/images/enotch_geometry.png)`
*   **Comparative Return Loss (S11) Plot:**
    `![S11 Overlay](docs/images/s11_overlay.png)`
*   **Comparative VSWR Plot:**
    `![VSWR Overlay](docs/images/vswr_overlay.png)`
*   **3D Radiation Pattern Comparison:**
    `![Radiation Pattern](docs/images/radiation_pattern.png)`

---

## 27. Detailed Results Tables

### 27.1 Measured Performance of E-Notch Antenna (Prototype Values)
*Measured values as documented in academic project report parameters (page 44):*

| Respective Frequency | Return Loss ($S_{11}$) | VSWR | Reflection Coefficient ($\Gamma$) | Impedance Bandwidth | Reflected Power | Non-Reflected Power | Mismatch Loss | Q-Factor |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **2.00 GHz** | $-27.50\text{ dB}$ | $1.088$ | $0.0422$ | $4.2\%$ | $0.18\%$ | $0.998$ | $0.003\text{ dB}$ | $47.62$ |
| **2.20 GHz** | $-19.60\text{ dB}$ | $1.240$ | $0.1220$ | $5.3\%$ | $1.49\%$ | $0.986$ | $0.013\text{ dB}$ | $34.21$ |
| **2.30 GHz** | $-19.00\text{ dB}$ | $1.240$ | $0.1120$ | $5.8\%$ | $1.26\%$ | $0.987$ | $0.012\text{ dB}$ | $31.45$ |
| **2.42 GHz** | $-22.30\text{ dB}$ | $1.170$ | $0.0860$ | $6.5\%$ | $0.74\%$ | $0.992$ | $0.007\text{ dB}$ | $27.82$ |

### 27.2 Simulated Performance of E-Notch Antenna (MATLAB Toolbox Solver)
*Simulated performance outputs as solved by MATLAB Antenna Toolbox (page 45):*

| Respective Frequency | Return Loss ($S_{11}$) | VSWR | Reflection Coefficient ($\Gamma$) | Impedance Bandwidth | Reflected Power | Non-Reflected Power | Mismatch Loss | Q-Factor |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **2.00 GHz** | $-27.50\text{ dB}$ | $1.088$ | $0.0422$ | $4.2\%$ | $0.18\%$ | $0.998$ | $0.003\text{ dB}$ | $47.62$ |
| **2.20 GHz** | $-21.40\text{ dB}$ | $1.200$ | $0.1120$ | $5.6\%$ | $1.25\%$ | $0.988$ | $0.011\text{ dB}$ | $32.85$ |
| **2.30 GHz** | $-20.80\text{ dB}$ | $1.210$ | $0.0910$ | $6.1\%$ | $0.83\%$ | $0.991$ | $0.008\text{ dB}$ | $29.87$ |
| **2.42 GHz** | $-24.10\text{ dB}$ | $1.140$ | $0.0720$ | $6.9\%$ | $0.52\%$ | $0.994$ | $0.006\text{ dB}$ | $26.52$ |

---

## 28. References
1.  Narasimman S, Karuppanan S. *Microstrip coils for MR-imaging with induced RF heating for hyperthermia.* Int J RF Microw Comput Aided Eng. 2022;e23545. [doi:10.1002/mmce.23545](https://doi.org/10.1002/mmce.23545)
2.  K. Sakthisudhan, N. Saravana Kumar. *Certain Study on Improvement of Bandwidth in 3 GHz Microstrip Patch Antenna Designs.* Journal of Circuits, Systems, and Computers, Vol. 25, No. 2 (2016) 1650006 (32 pages).
3.  Constantine A. Balanis. *Antenna Theory: Analysis and Design.* John Wiley & Sons, Inc., Second Edition, 1996.
4.  Manik Gujral, Tao Yuan, Cheng-Wei Qiu, Le-Wei Li and Ken Takei. *Bandwidth Increment of Microstrip Patch Antenna Array with Opposite Double-E EBG Structure for Different Feed Position.* International Symposium on Antennas and Propagation, 2006.
5.  Richard C. Johnson, Henry Jasik. *Antenna Engineering Handbook.* Second Edition, McGraw-Hill, 1984.
6.  D. M. Pozar, D. H. Schaubert (Eds). *The Analysis and Design of Microstrip Antennas and Arrays.* IEEE Press, New York, 1996.

---

## 29. License
Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

---

## 30. Authors
Developed as a final-year ECE project by:
*   **Akash V** (710723106007)
*   **Anusri S** (710723106008)
*   **Christina Joyce J** (710723106019)
*   **J K Dakshata** (710723106020)
*   **Devanand N** (710723106021) - *Project Lead & Maintainer*

---

## 31. Acknowledgements
We express our sincere gratitude to:
*   **Dr. S. U. Prabha**, Principal, Dr. N.G.P. Institute of Technology.
*   **Dr. P. Sampath**, Head of Department, Electronics and Communication Engineering, for continuous encouragement.
*   **Dr. K. Sakthisudhan**, Mini-Project Coordinator & Professor, ECE, for his technical guidance, valuable review feedback, and expertise in RF research.
*   **Dr. N.G.P. Institute of Technology, Coimbatore**, and Anna University, Chennai, for providing the engineering laboratory infrastructure.
