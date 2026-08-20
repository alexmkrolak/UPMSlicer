# UPMSlicer — WASP 3MT HDP XL profile (v1)

This initial UPMSlicer fork adds a profile-only configuration for the WASP 3MT HDP XL pellet delta printer. It does not change OrcaSlicer firmware support or printer-control code.

## Machine envelope

- 1000 mm usable diameter and 1000 mm height, centred on XY origin.
- The front 100 mm strip (`Y=-500` through `Y=-400`) is excluded by clipping the printable polygon and by a matching exclusion polygon.
- Available nozzle variants: 2, 3, and 5 mm.

## Validated source values

The supplied 5 mm-bead reference G-code used a 3 mm nozzle, 5 mm extrusion width, 1.2 mm layer height, 40–60 mm/s printing, 1500 mm/s² nominal acceleration, 250 °C nozzle, 240 °C barrel, and 70 °C Firecap chamber. Those values are the 3 mm default baseline.

## G-code and connection

The start sequence deliberately mirrors the reference machine: `M140` Firecap chamber; `M104`/`M109 T0` nozzle; `M104`/`M109 T1` barrel; `M106` fan; then `G28`.

The profile uses Marlin-flavoured G-code based on the known commands, but does not emit acceleration or firmware configuration commands because the controller has not identified itself via `M115`. Confirm the firmware before enabling any firmware-specific options. Configure the OctoPrint address and API key locally in the slicer rather than committing the private printer endpoint to the profile.

## Before production printing

Dry-run every generated start/end sequence on the printer with extrusion disabled, then validate extrusion multiplier, the 2 mm and 5 mm nozzle layer/line widths, barrel temperatures, maximum flow, and safe homing behaviour. The v1 profile has no automatic purge move or retraction: those require a machine-validated routine.
