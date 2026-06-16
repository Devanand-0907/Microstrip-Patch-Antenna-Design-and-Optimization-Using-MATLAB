# Mathematical Modeling of Microstrip Patch Antennas

This document outlines the analytical formulas and mathematical modeling techniques used to design the **Standard Rectangular Microstrip Patch Antenna** and the optimized **E-Notch Microstrip Patch Antenna** operating at $f_c = 2.0\text{ GHz}$.

The modeling is based on the classical **Transmission Line Model**, which represents the microstrip patch as a parallel-plate transmission line with radiating slots at both ends.

---

## 1. Transmission Line Model Equations

### 1.1 Physical Width of the Patch ($W$)
The width $W$ of the patch affects the input impedance, radiation efficiency, and bandwidth. To ensure high radiation efficiency, $W$ is calculated as:

$$W = \frac{c}{2 f_c} \sqrt{\frac{2}{\epsilon_r + 1}}$$

Where:
* $c = 3 \times 10^8\text{ m/s}$ (speed of light in free space)
* $f_c = 2.0 \times 10^9\text{ Hz}$ (center frequency)
* $\epsilon_r = 4.4$ (relative dielectric constant of FR-4 substrate)

For our parameters:
$$W = \frac{3 \times 10^8}{2 \times 2.0 \times 10^9} \sqrt{\frac{2}{4.4 + 1}} = 0.075 \sqrt{0.37037} \approx 45.64\text{ mm}$$

---

### 1.2 Effective Dielectric Constant ($\epsilon_{eff}$)
Because the fields fringe into the air above the substrate, the patch behaves as though it resides in a homogeneous medium with a lower effective dielectric constant:

$$\epsilon_{eff} = \frac{\epsilon_r + 1}{2} + \frac{\epsilon_r - 1}{2} \left[1 + 12\frac{h}{W}\right]^{-1/2}$$

Where:
* $h = 1.6\text{ mm}$ (substrate thickness)
* $W = 45.64\text{ mm}$ (patch width)

Substituting our values:
$$\frac{h}{W} = \frac{1.6}{45.64} \approx 0.03506$$
$$\epsilon_{eff} = \frac{4.4 + 1}{2} + \frac{4.4 - 1}{2} \left[1 + 12(0.03506)\right]^{-0.5} = 2.7 + 1.7(1.4207)^{-0.5} \approx 4.13$$

---

### 1.3 Effective Length of the Patch ($L_{eff}$)
The electrical length of the patch required to establish resonance at the dominant $TM_{10}$ mode is given by:

$$L_{eff} = \frac{c}{2 f_c \sqrt{\epsilon_{eff}}}$$

Substituting our values:
$$L_{eff} = \frac{3 \times 10^8}{2 \times 2.0 \times 10^9 \sqrt{4.126}} \approx 36.92\text{ mm}$$

---

### 1.4 Fringing Length Extension ($\Delta L$)
Capacitive loading at the patch edges makes the antenna appear electrically longer than its physical dimensions. This length extension is empirically calculated using the Bahl & Bhartia formulation:

$$\Delta L = 0.412 \cdot h \frac{(\epsilon_{eff} + 0.3) \left(\frac{W}{h} + 0.264\right)}{(\epsilon_{eff} - 0.258) \left(\frac{W}{h} + 0.8\right)}$$

Substituting our values:
$$\frac{W}{h} = \frac{45.64}{1.6} = 28.525$$
$$\Delta L = 0.412 \times 1.6 \times \frac{(4.13 + 0.3) (28.525 + 0.264)}{(4.13 - 0.258) (28.525 + 0.8)} \approx 0.74\text{ mm}$$

---

### 1.5 Physical Length of the Patch ($L$)
The actual physical length $L$ of the patch is obtained by subtracting the fringing length extensions from both ends:

$$L = L_{eff} - 2\Delta L$$

Substituting our values:
$$L = 36.92 - 2(0.74) \approx 35.44\text{ mm}$$

*Note: In the academic project report table, the physical length is listed as $45.04\text{ mm}$. Our simulation scripts support both the theoretical length ($35.44\text{ mm}$) and the report value ($45.04\text{ mm}$) for comparative analysis.*

---

### 1.6 Ground Plane Dimensions ($L_g$, $W_g$)
To prevent significant degradation of radiation patterns and minimize backward radiation, the ground plane must extend beyond the patch boundary by at least $6h$ on all sides:

$$L_g = L + 6h \approx 35.44 + 6(1.6) \approx 45.04\text{ mm}$$
$$W_g = W + 6h \approx 45.64 + 6(1.6) \approx 55.24\text{ mm}$$

*Note: The academic project report uses a symmetrical ground plane of $55.24\text{ mm} \times 55.24\text{ mm}$ which matches the maximum calculated dimension ($W_g$).*

---

## 2. RF Performance Equations

### 2.1 Reflection Coefficient ($\Gamma$) and S11 Parameter
The reflection coefficient $\Gamma$ measures the ratio of the reflected wave amplitude to the incident wave amplitude at the antenna feed point:

$$\Gamma = \frac{Z_{in} - Z_0}{Z_{in} + Z_0}$$

Where:
* $Z_{in}$ is the input impedance of the antenna patch.
* $Z_0$ is the characteristic impedance of the feed line (typically $50\ \Omega$).

The return loss ($S_{11}$) in decibels (dB) is:

$$S_{11}\text{ (dB)} = 20 \log_{10} |\Gamma|$$

An antenna is considered successfully matched when $S_{11} \le -10\text{ dB}$, representing less than 10% reflected power.

---

### 2.2 Voltage Standing Wave Ratio (VSWR)
The VSWR represents the ratio of the maximum voltage to the minimum voltage along the transmission feed line:

$$VSWR = \frac{1 + |\Gamma|}{1 - |\Gamma|}$$

* For a perfect match ($\Gamma = 0$), $VSWR = 1$.
* An acceptable match is typically $VSWR \le 2.0$ (S11 $\le -9.54\text{ dB}$).
* For high-performance systems (e.g., aerospace, telecom), a $VSWR \le 1.5$ (S11 $\le -14\text{ dB}$) is preferred.

---

## 3. E-Notch Slot Physics
The E-notch modification involves etching two symmetric notches out of the radiating patch. This geometrical adjustment affects the antenna in three main ways:

1. **Current Path Modification:** The notches force the surface currents to flow around the slot boundaries, increasing the effective electrical length of the antenna. This allows the patch to resonate at a lower frequency for a given physical size.
2. **Additional Resonance Modes:** The slots introduce secondary slot resonances close to the main patch resonance, creating a dual-resonance frequency response.
3. **Impedance Bandwidth Expansion:** By adjusting the notch length ($L_n$) and width ($W_n$), the input impedance can be tuned to match $50\ \Omega$ across a wider frequency range, expanding the fractional bandwidth from standard values (~2-3%) to optimized values (~5-6%).

The notch scaling factors applied in the report are:
* **Notch Length ($L_n$):** $0.513 \times L$
* **Notch Width ($W_n$):** $0.065 \times W$
