# Recruiter Technical Brief: Candidate Competency Mapping

This project represents a final-year level Engineering Simulation and Optimization project in Electronics and Communication Engineering (ECE), with a specialization in RF (Radio Frequency), Electromagnetics, and Wireless Communication Systems.

Here is a summary of the technical achievements and competencies demonstrated, designed for recruiting teams at **Qualcomm, Intel, Texas Instruments, Nokia, Ericsson, Samsung R&D, and Zoho**.

---

## 1. Quick Metrics (The Bottom Line)
*   **Operating Frequency:** $2.0\text{ GHz}$ (Wi-Fi, Bluetooth, ISM Band)
*   **Return Loss ($S_{11}$):** Optimized to **$-27.50\text{ dB}$** (99.82% power transmission, only 0.18% reflected power).
*   **VSWR (Voltage Standing Wave Ratio):** Optimized to **$1.088$** (extremely close to the ideal $1.00$).
*   **Bandwidth Improvement:** Fractional bandwidth expanded from typical low-profile microstrip limits to **5% - 6.5%** through slot-coupling.
*   **Substrate Choice:** FR-4 Glass Epoxy ($\epsilon_r = 4.4, h = 1.6\text{ mm}$), showing a design constraint optimization (using lower-cost material but achieving high performance via slot design).

---

## 2. Technical Skill Mapping

| Technical Competency | Demonstrated in Project | Relevant Roles at Target Companies |
| :--- | :--- | :--- |
| **RF & Electromagnetics Theory** | S-parameters ($S_{11}$), VSWR, impedance matching ($50\ \Omega$), Smith Chart concepts, 3D radiation patterns, Q-factor, Bahl-Bhartia formulas. | RF Design Engineer, Antenna Engineer, Wireless Systems Engineer |
| **MATLAB Engineering Development** | Use of the Antenna Toolbox, `sparameters` sweeps, constructive solid geometry (CSG), and custom shape generation via `pcbStack`. | RF Tool Developer, Systems Simulator, Modeling Engineer |
| **PCB CAD Concepts** | Board thickness ($h=1.6\text{ mm}$), copper metallization layers, dielectric permittivities, probe/microstrip feed line geometries, inset spacing. | Hardware Board Designer, SI/PI (Signal/Power Integrity) Engineer |
| **Analytical Problem Solving** | Identifying narrow-bandwidth constraints in microstrips and modifying the physical structure to introduce dual-resonance. | hardware R&D Engineer, Product Validation Engineer |

---

## 3. Interview Verification Questions for Technical Screeners
If you want to quickly test the candidate's depth of knowledge on this repository:
1. *"Why does adding an E-notch slot to the patch expand the bandwidth?"*
    *   *Expected Answer:* The notches create an alternative current path, which increases the electrical length and introduces a second resonant frequency. The coupling of these two close resonant frequencies merges their bandwidths, creating a wider overall passband.
2. *"Why is the feed offset set to $-W/6$ for the E-notch patch instead of $-W/4$ as in the standard rectangular patch?"*
    *   *Expected Answer:* Adding notches changes the input impedance ($Z_{in}$) at the edges of the patch. To match the antenna to a standard $50\ \Omega$ feed line, the feed point must be moved closer to the center ($W/6$) where the impedance is lower, ensuring maximum power transfer and minimum reflection.
3. *"Why did you use FR-4 instead of Rogers substrates?"*
    *   *Expected Answer:* FR-4 is highly cost-effective and standard for commercial applications, though it has higher dielectric losses. Prototyping on FR-4 shows how geometric optimizations can compensate for lossy materials, which is crucial for consumer electronics cost-reduction.
