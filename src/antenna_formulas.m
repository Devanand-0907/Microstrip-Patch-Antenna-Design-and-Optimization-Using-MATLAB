function [W, eeff, Leff, dL, L, Wg, Lg] = antenna_formulas(fc, er, h)
    % ANTENNA_FORMULAS Calculations for Microstrip Patch Antenna Dimensions
    %
    % This function computes the physical and electrical design parameters of a
    % microstrip patch antenna based on the transmission line model.
    % 
    % Reference: 
    %   Constantine A. Balanis, "Antenna Theory: Analysis and Design", 
    %   John Wiley & Sons, Inc., Second Edition, 1996.
    %
    % Inputs:
    %   fc - Center frequency of operation (Hz), e.g., 2e9 for 2 GHz
    %   er - Relative dielectric constant of substrate (dimensionless), e.g., 4.4 for FR-4
    %   h  - Substrate thickness (meters), e.g., 1.6e-3 for 1.6 mm
    %
    % Outputs:
    %   W    - Physical patch width (m)
    %   eeff - Effective dielectric constant
    %   Leff - Effective electrical patch length (m)
    %   dL   - Fringing field length extension (m)
    %   L    - Physical patch length (m)
    %   Wg   - Ground plane width (m)
    %   Lg   - Ground plane length (m)

    % Speed of light in free space (m/s)
    c = 3e8; 

    % 1. Physical Width (W)
    % Derived from dominant TM10 mode excitation criteria for maximum radiation
    W = (c / (2 * fc)) * sqrt(2 / (er + 1));

    % 2. Effective Dielectric Constant (eeff)
    % Accounts for fringing fields in air above the dielectric substrate
    eeff = ((er + 1) / 2) + ((er - 1) / 2) * (1 + 12 * (h / W))^(-0.5);

    % 3. Effective Length (Leff)
    % The electrical length required for resonance at fc
    Leff = c / (2 * fc * sqrt(eeff));

    % 4. Length Extension (dL)
    % Empirical formula for edge extension due to capacitive fringing fields
    num = (eeff + 0.3) * ((W / h) + 0.264);
    den = (eeff - 0.258) * ((W / h) + 0.8);
    dL = 0.412 * h * (num / den);

    % 5. Actual Physical Length (L)
    % Compensates for fringing fields on both radiating edges
    L = Leff - 2 * dL;

    % 6. Ground Plane Dimensions (Wg, Lg)
    % Standard RF design guidelines dictate adding 6 * substrate height to each side
    Wg = W + 6 * h;
    Lg = L + 6 * h;
end
