#!/bin/bash

# Comprehensive script to build CV website with simple and full versions
# Usage: ./build_cv_website.sh

# Check if LaTeX is installed, if not install minimal required packages
echo "=== Checking LaTeX Installation ==="
if ! command -v pdflatex &> /dev/null; then
    echo "LaTeX not found. Installing minimal TeX Live with required packages..."
    sudo apt update
    sudo apt install -y texlive texlive-latex-extra texlive-fonts-extra texlive-lang-french
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install TeX Live packages. Please install manually with:"
        echo "   sudo apt install texlive texlive-latex-extra texlive-fonts-extra texlive-lang-french"
        exit 1
    fi
    echo "✓ TeX Live installed successfully"
else
    echo "✓ LaTeX is already installed"
fi

echo "=== Building CV Website ==="

# Step 1: Compile LaTeX files to PDF
echo "1. Compiling LaTeX files..."

# Define all CV versions with their corresponding output PDF names
# Format: tex_file:pdf_output
declare -A CV_MAP=(
    ["tex/cv_english_full.tex"]="pdf/cv_english.pdf"
    ["tex/cv_english_simple.tex"]="pdf/cv_english_simple.pdf"
    ["tex/cv_french_full.tex"]="pdf/cv_french.pdf"
    ["tex/cv_french_simple.tex"]="pdf/cv_french_simple.pdf"
)

for tex_file in "${!CV_MAP[@]}"; do
    pdf_output="${CV_MAP[$tex_file]}"
    
    if [ -f "$tex_file" ]; then
        echo "  - Compiling ${tex_file} -> ${pdf_output}..."
        
        # Remove existing PDF to ensure clean rebuild and overwrite
        rm -f "$pdf_output"
        echo "    Removed old ${pdf_output}"
        
        # Get base name for -jobname option
        pdf_basename="$(basename "$pdf_output" .pdf)"
        
        echo "    Running pdflatex (first pass)..."
        pdflatex -interaction=nonstopmode -jobname="$pdf_basename" "$tex_file" > /dev/null 2>&1
        
        echo "    Running pdflatex (second pass for references)..."
        pdflatex -interaction=nonstopmode -jobname="$pdf_basename" "$tex_file" > /dev/null 2>&1
        
        if [ -f "$pdf_output" ]; then
            echo "  ✓ ${pdf_output} generated successfully (old version was overwritten)"
        else
            echo "  ✗ ${tex_file} compilation failed - no PDF generated"
        fi
    else
        echo "  ⚠ ${tex_file} not found, skipping"
    fi
done

# Step 2: Clean up LaTeX temporary files
echo "2. Cleaning up LaTeX temporary files..."
rm -f *.aux *.log *.out *.toc *.lof *.lot

# Step 3: Generate preview images from PDFs
echo "3. Generating preview images..."
python3 generate_cv_previews.py

echo "=== Build Complete ==="
echo "Generated files:"
all_files=("pdf/cv_english_simple.pdf" "pdf/cv_english.pdf" "pdf/cv_french_simple.pdf" "pdf/cv_french.pdf" "previews/english_simple_cv_preview.png" "previews/english_full_cv_preview.png" "previews/french_simple_cv_preview.png" "previews/french_full_cv_preview.png")

for file in "${all_files[@]}"; do
    if [ -f "$file" ]; then
        size=$(du -h "$file" | cut -f1)
        echo "  ✓ $file ($size)"
    else
        echo "  ⚠ $file (missing)"
    fi
done

echo ""
echo "PDFs and preview images generated. Make sure index.html exists and references the preview images."
