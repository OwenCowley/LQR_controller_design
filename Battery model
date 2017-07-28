function [voltage, cell_voltage]= LiPo(load)

%================================Constants=================================

delta_t = 0.004;
max_current = 20;                % maximum current per motor             (A)
aux_current = 0.100;                % current of auxillary components       (A)        
capacity = 1.8;                   % LiPo current capacity                 (Ah)                                 
cells = 3;                          % LiPo cell count

%==========================================================================

persistent discharge;

if isempty(discharge)
    discharge = 0;
end

current = sum(max_current .* load.^2) + aux_current;
discharge = current * (delta_t / 3600) + discharge;

discharge_capacity = discharge / capacity;

if (0 < discharge_capacity) && (discharge_capacity <=0.20)
    cell_voltage = -14.029*discharge_capacity^3 + 16.975*discharge_capacity^2 - 5.3339*discharge_capacity + 4.2;
elseif (0.20 < discharge_capacity) && (discharge_capacity < 0.70)
    cell_voltage = -0.2*discharge_capacity + 3.74;
else
    cell_voltage = -48*discharge_capacity^3 + 89.6*discharge_capacity^2 - 55.08*discharge_capacity + 14.716;
end

if cell_voltage < (5 / cells)
    cell_voltage = 0;
end

supply_voltage = cells * cell_voltage;
voltage = supply_voltage .* load;
