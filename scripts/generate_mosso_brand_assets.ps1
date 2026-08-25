# Generates the Mosso Slicer raster and Windows icon assets from the official
# flat Mosso mark. Brand colours come from the supplied identity guide:
# Anthracite #2F3234 and Verde Lime #BBD800.

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$repoRoot = Split-Path $PSScriptRoot -Parent
$outputDirectory = Join-Path $repoRoot 'resources\images'

function New-RoundedRectanglePath {
    param([System.Drawing.RectangleF]$Rectangle, [float]$Radius)

    $diameter = $Radius * 2
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $path.AddArc($Rectangle.X, $Rectangle.Y, $diameter, $diameter, 180, 90)
    $path.AddArc($Rectangle.Right - $diameter, $Rectangle.Y, $diameter, $diameter, 270, 90)
    $path.AddArc($Rectangle.Right - $diameter, $Rectangle.Bottom - $diameter, $diameter, $diameter, 0, 90)
    $path.AddArc($Rectangle.X, $Rectangle.Bottom - $diameter, $diameter, $diameter, 90, 90)
    $path.CloseFigure()
    return $path
}

function New-MossoGlyphPath {
    # Vector geometry extracted from the supplied flat-colour Mosso artwork.
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $path.StartFigure()
    $path.AddLine(759.301, 420.675, 754.960, 420.675)
    $path.AddBezier(754.960, 420.675, 718.713, 420.675, 689.224, 391.185, 689.224, 354.938)
    $path.AddLine(689.224, 354.938, 689.224, 216.487)
    $path.AddBezier(689.224, 216.487, 689.224, 209.270, 683.352, 203.397, 676.135, 203.397)
    $path.AddLine(676.135, 203.397, 674.944, 203.397)
    $path.AddBezier(674.944, 203.397, 667.727, 203.397, 661.855, 209.270, 661.855, 216.487)
    $path.AddLine(661.855, 216.487, 661.855, 353.202)
    $path.AddBezier(661.855, 353.202, 661.855, 390.079, 631.854, 420.079, 594.978, 420.079)
    $path.AddLine(594.978, 420.079, 594.383, 420.079)
    $path.AddBezier(594.383, 420.079, 557.507, 420.079, 527.507, 390.079, 527.507, 353.202)
    $path.AddLine(527.507, 353.202, 527.507, 216.487)
    $path.AddBezier(527.507, 216.487, 527.507, 209.270, 521.635, 203.397, 514.417, 203.397)
    $path.AddBezier(514.417, 203.397, 507.200, 203.397, 501.328, 209.270, 501.328, 216.487)
    $path.AddLine(501.328, 216.487, 501.328, 354.578)
    $path.AddBezier(501.328, 354.578, 501.328, 390.696, 471.944, 420.079, 435.827, 420.079)
    $path.AddLine(435.827, 420.079, 431.251, 420.079)
    $path.AddBezier(431.251, 420.079, 416.399, 420.079, 404.358, 408.038, 404.358, 393.185)
    $path.AddBezier(404.358, 393.185, 404.358, 378.333, 416.399, 366.292, 431.251, 366.292)
    $path.AddLine(431.251, 366.292, 435.827, 366.292)
    $path.AddBezier(435.827, 366.292, 442.286, 366.292, 447.542, 361.037, 447.542, 354.578)
    $path.AddLine(447.542, 354.578, 447.542, 216.487)
    $path.AddBezier(447.542, 216.487, 447.542, 179.611, 477.542, 149.610, 514.417, 149.610)
    $path.AddBezier(514.417, 149.610, 551.293, 149.610, 581.294, 179.611, 581.294, 216.487)
    $path.AddLine(581.294, 216.487, 581.294, 353.202)
    $path.AddBezier(581.294, 353.202, 581.294, 360.419, 587.166, 366.292, 594.383, 366.292)
    $path.AddLine(594.383, 366.292, 594.978, 366.292)
    $path.AddBezier(594.978, 366.292, 602.197, 366.292, 608.068, 360.419, 608.068, 353.202)
    $path.AddLine(608.068, 353.202, 608.068, 216.487)
    $path.AddBezier(608.068, 216.487, 608.068, 179.611, 638.069, 149.610, 674.944, 149.610)
    $path.AddLine(674.944, 149.610, 676.135, 149.610)
    $path.AddBezier(676.135, 149.610, 713.010, 149.610, 743.011, 179.611, 743.011, 216.487)
    $path.AddLine(743.011, 216.487, 743.011, 354.938)
    $path.AddBezier(743.011, 354.938, 743.011, 361.528, 748.371, 366.888, 754.960, 366.888)
    $path.AddLine(754.960, 366.888, 759.301, 366.888)
    $path.AddBezier(759.301, 366.888, 774.153, 366.888, 786.194, 378.929, 786.194, 393.782)
    $path.AddBezier(786.194, 393.782, 786.194, 408.634, 774.153, 420.675, 759.301, 420.675)
    $path.CloseFigure()
    return $path
}

function New-MossoLogoBitmap {
    param([int]$Size, [switch]$Grayscale, [switch]$Transparent)

    $bitmap = [System.Drawing.Bitmap]::new($Size, $Size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.Clear([System.Drawing.Color]::Transparent)

    $anthracite = [System.Drawing.Color]::FromArgb(255, 47, 50, 52)
    $lime = if ($Grayscale) { [System.Drawing.Color]::FromArgb(255, 210, 210, 210) } else { [System.Drawing.Color]::FromArgb(255, 187, 216, 0) }

    if (-not $Transparent) {
        $margin = [float]($Size * 0.025)
        $rectangle = [System.Drawing.RectangleF]::new($margin, $margin, $Size - 2 * $margin, $Size - 2 * $margin)
        $backgroundPath = New-RoundedRectanglePath -Rectangle $rectangle -Radius ([float]($Size * 0.18))
        $backgroundBrush = [System.Drawing.SolidBrush]::new($anthracite)
        $graphics.FillPath($backgroundBrush, $backgroundPath)
        $backgroundBrush.Dispose()
        $backgroundPath.Dispose()
    }

    $glyphPath = New-MossoGlyphPath
    $sourceWidth = 381.836
    $sourceHeight = 271.065
    $targetWidth = $Size * $(if ($Transparent) { 0.86 } else { 0.70 })
    $scale = [float]($targetWidth / $sourceWidth)
    $targetHeight = $sourceHeight * $scale
    $targetX = ($Size - $targetWidth) / 2
    $targetY = ($Size - $targetHeight) / 2
    $matrix = [System.Drawing.Drawing2D.Matrix]::new($scale, 0, 0, $scale, [float]($targetX - 404.358 * $scale), [float]($targetY - 149.610 * $scale))
    $glyphPath.Transform($matrix)
    $glyphBrush = [System.Drawing.SolidBrush]::new($lime)
    $graphics.FillPath($glyphBrush, $glyphPath)

    $glyphBrush.Dispose()
    $matrix.Dispose()
    $glyphPath.Dispose()
    $graphics.Dispose()
    return $bitmap
}

function Write-MossoPng {
    param([string]$Name, [int]$Size, [switch]$Grayscale, [switch]$Transparent)
    $bitmap = New-MossoLogoBitmap -Size $Size -Grayscale:$Grayscale -Transparent:$Transparent
    try { $bitmap.Save((Join-Path $outputDirectory $Name), [System.Drawing.Imaging.ImageFormat]::Png) }
    finally { $bitmap.Dispose() }
}

function Write-MossoIcon {
    param([string]$Path)
    $sizes = @(16, 24, 32, 48, 64, 128, 256)
    $images = @()
    foreach ($size in $sizes) {
        $bitmap = New-MossoLogoBitmap -Size $size
        $stream = [System.IO.MemoryStream]::new()
        $bitmap.Save($stream, [System.Drawing.Imaging.ImageFormat]::Png)
        $images += ,$stream.ToArray()
        $stream.Dispose()
        $bitmap.Dispose()
    }

    $file = [System.IO.File]::Create($Path)
    $writer = [System.IO.BinaryWriter]::new($file)
    try {
        $writer.Write([uint16]0); $writer.Write([uint16]1); $writer.Write([uint16]$sizes.Count)
        $offset = 6 + 16 * $sizes.Count
        for ($index = 0; $index -lt $sizes.Count; $index++) {
            $encodedSize = if ($sizes[$index] -eq 256) { 0 } else { $sizes[$index] }
            $writer.Write([byte]$encodedSize); $writer.Write([byte]$encodedSize)
            $writer.Write([byte]0); $writer.Write([byte]0)
            $writer.Write([uint16]1); $writer.Write([uint16]32)
            $writer.Write([uint32]$images[$index].Length); $writer.Write([uint32]$offset)
            $offset += $images[$index].Length
        }
        foreach ($image in $images) { $writer.Write($image) }
    }
    finally { $writer.Dispose(); $file.Dispose() }
}

Write-MossoPng -Name 'MossoSlicer_32px.png' -Size 32
Write-MossoPng -Name 'MossoSlicer_128px.png' -Size 128
Write-MossoPng -Name 'MossoSlicer_192px.png' -Size 192
Write-MossoPng -Name 'MossoSlicer_192px_transparent.png' -Size 192 -Transparent
Write-MossoPng -Name 'MossoSlicer_192px_grayscale.png' -Size 192 -Grayscale
Write-MossoPng -Name 'MossoSlicer.png' -Size 192
Write-MossoIcon -Path (Join-Path $outputDirectory 'MossoSlicer.ico')
Copy-Item (Join-Path $outputDirectory 'MossoSlicer.ico') (Join-Path $outputDirectory 'MossoSlicer-mac_256px.ico') -Force

Write-Host 'Generated Mosso Slicer PNG and ICO assets.'
