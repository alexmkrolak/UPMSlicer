<div align="center">

<img alt="Mosso Slicer logo" src="resources/images/MossoSlicer_192px.png" width="192">

# Mosso Slicer

An OrcaSlicer-based local slicer for selected WASP filament and pellet printers.

[Repository](https://github.com/alexmkrolak/UPMSlicer) · [Report an issue](https://github.com/alexmkrolak/UPMSlicer/issues) · [OrcaSlicer upstream](https://github.com/OrcaSlicer/OrcaSlicer)

</div>

## Included catalogue

Mosso Slicer intentionally exposes only:

- WASP 3MT HDP XL with 2, 3, and 5 mm nozzles.
- WASP 4070 with 0.4, 0.8, and 1 mm nozzles.
- WASP 60100 HDP with 1 and 2 mm nozzles.
- Polymaker PETG 20GF - Copy, Generic PLA, and Generic PETG.

The 3MT profile includes its 1000 mm diameter by 1000 mm cylindrical volume, front exclusion area, two heater zones, Firecap command, purge routine, and OctoPrint address. The API key remains a per-user secret and is not stored in this repository or installer.

Expert settings are always visible, the first-run setup wizard is skipped, thumbnails are disabled, and Orca/Bambu account, cloud-storage, cloud-preset, and cloud-plugin services are disabled. Projects and presets remain on the local computer.

These are controlled test profiles. Review generated G-code and validate the 4070 and 60100 heater/start/end sequences on the exact controllers before production use.

## Running a local Windows build

After building and installing locally, run:

```powershell
& "C:\Users\Acer Nitro\Documents\ChatGPT\UPMSlicer\build\MossoSlicer\mosso-slicer.exe"
```

Mosso Slicer stores its settings separately from OrcaSlicer in `%APPDATA%\MossoSlicer`.

## Building on Windows

Use Visual Studio 2026 with the Desktop development with C++ workload, CMake, and Git. In Developer PowerShell for Visual Studio:

```powershell
cd "C:\Users\Acer Nitro\Documents\ChatGPT\UPMSlicer"
.\build_release_vs2026.bat
```

To rebuild only the slicer after its dependencies are available:

```powershell
.\build_release_vs2026.bat slicer
```

The installed build is placed in `build\MossoSlicer`. To create a shareable installer after a successful build:

```powershell
cd "C:\Users\Acer Nitro\Documents\ChatGPT\UPMSlicer"
cmake --build build --config Release --target package
```

The generated file is named `MossoSlicer_Windows_Installer_V<version>_x64.exe` in the `build` folder.

## Licence and upstream

Mosso Slicer is based on [OrcaSlicer](https://github.com/OrcaSlicer/OrcaSlicer), which is based on Bambu Studio, PrusaSlicer, and Slic3r. It retains the upstream copyright notices and is distributed under the GNU Affero General Public License, version 3. See [LICENSE.txt](LICENSE.txt) for licence terms and upstream acknowledgements.
