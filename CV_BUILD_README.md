# CV Website Build System

This directory contains a build system for generating a CV download website with preview functionality. The system now supports **Simple** and **Full** versions for both English and French CVs.

## File Structure

### Source Files (LaTeX)
- `cv_english_simple.tex` - Simple English CV (1 page, concise)
- `cv_english_full.tex` - Full English CV (detailed with technical insights)
- `cv_french_simple.tex` - Simple French CV (1 page, concise)
- `cv_french_full.tex` - Full French CV (detailed with technical insights)

### Generated Files
- `cv_english_simple.pdf` - Simple English CV
- `cv_english.pdf` - Full English CV
- `cv_french_simple.pdf` - Simple French CV
- `cv_french.pdf` - Full French CV
- `english_simple_cv_preview.png` - Preview image for Simple English CV
- `english_full_cv_preview.png` - Preview image for Full English CV
- `french_simple_cv_preview.png` - Preview image for Simple French CV
- `french_full_cv_preview.png` - Preview image for Full French CV
- `index.html` - Web interface with download buttons

## CV Versions

### Simple Version
- Concise 1-page CV
- High-level overview of experience and skills
- Suitable for quick review

### Full Version
- Detailed multi-page CV
- For each project/experience, includes:
  - **Languages Used**: Programming and scripting languages
  - **Tools/Packages**: Frameworks, libraries, and tools
  - **Challenges**: Key difficulties encountered
  - **Actions**: Specific actions taken and solutions implemented
- Suitable for technical review and in-depth evaluation

## Build Scripts

### Main Build Script
```bash
./build_cv_website.sh
```

This script performs all steps:
1. Compiles all LaTeX files to PDF (simple and full versions)
2. Generates preview images from PDFs
3. Creates the HTML interface with all 4 versions

### Preview Generation Only
```bash
python3 generate_cv_previews.py
```

Regenerates just the preview images from existing PDFs.

## GitHub Actions CI/CD

The `.github/workflows/ci.yml` file automatically:
1. Triggers on push to `main` branch when `.tex` files change
2. Compiles all CV versions (simple and full) in a TeX Live container
3. Generates preview images
4. Updates the HTML interface
5. Commits and pushes the generated files back to the repository
6. Deploys to GitHub Pages

## Requirements

- `pdflatex` - For LaTeX compilation
- `ghostscript` - For PDF to image conversion
- `Python 3` with `Pillow` library - For image processing

## Usage

### Quick Start

1. **Make scripts executable** (first time only):
   ```bash
   chmod +x build_cv_website.sh
   ```

2. **Run the full build**:
   ```bash
   ./build_cv_website.sh
   ```

3. **Open the result**:
   ```bash
   # Option 1: Use Python's built-in HTTP server
   python3 -m http.server 8000
   # Then open http://localhost:8000 in your browser
   
   # Option 2: Open directly in browser
   xdg-open index.html  # Linux
   open index.html      # Mac
   start index.html     # Windows
   ```

### Advanced Usage

**Update previews only** (if you only modified PDFs, not LaTeX sources):
```bash
python3 generate_cv_previews.py
```

**Force recompile LaTeX** (if you modified .tex files):
```bash
# Remove existing PDFs to force recompilation
rm -f cv_*.pdf
./build_cv_website.sh
```

**Compile a specific version**:
```bash
pdflatex -interaction=nonstopmode cv_english_full.tex
pdflatex -interaction=nonstopmode cv_english_full.tex
```

**Check generated files**:
```bash
ls -lh cv_*_simple.pdf cv_*_full.pdf *_cv_preview.png index.html
```

## HTML Features

- Responsive design that works on mobile and desktop
- Clickable preview images that trigger PDF downloads
- Clean, modern interface with hover effects
- Organized by language (English/Français) and version (Simple/Full)
- Automatic download with proper filenames
- Backwards compatible with old CV filenames

## Notes

- If LaTeX compilation fails (e.g., missing packages), the script will use existing PDF files
- Preview images are generated at 200px width with proper aspect ratio
- The HTML interface is self-contained with no external dependencies
- The CI/CD pipeline automatically builds and deploys on changes to `.tex` files
