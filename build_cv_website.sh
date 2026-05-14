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

# Define all CV versions
CV_VERSIONS=("english_simple" "english_full" "french_simple" "french_full")

for version in "${CV_VERSIONS[@]}"; do
    tex_file="cv_${version}.tex"
    if [ -f "$tex_file" ]; then
        echo "  - Compiling ${tex_file}..."
        echo "    Running pdflatex (first pass)..."
        if pdflatex -interaction=nonstopmode "$tex_file"; then
            echo "    Running pdflatex (second pass for references)..."
            if pdflatex -interaction=nonstopmode "$tex_file"; then
                echo "  ✓ cv_${version}.pdf generated successfully"
            else
                echo "  ⚠ ${tex_file} second pass failed, but first pass succeeded"
            fi
        else
            echo "  ✗ ${tex_file} compilation failed"
            if [ -f "cv_${version}.pdf" ]; then
                echo "  ℹ Using existing cv_${version}.pdf file"
            else
                echo "  ⚠ No cv_${version}.pdf available"
            fi
        fi
    else
        echo "  ⚠ ${tex_file} not found, skipping"
    fi
done

# Step 2: Generate preview images from PDFs
echo "2. Generating preview images..."
python3 generate_cv_previews.py

echo "=== Build Complete ==="
echo "Generated files:"
all_files=("cv_english_simple.pdf" "cv_english.pdf" "cv_french_simple.pdf" "cv_french.pdf" "english_simple_cv_preview.png" "english_full_cv_preview.png" "french_simple_cv_preview.png" "french_full_cv_preview.png")

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
