# Ulysse Boucherie - CV Website

A personal portfolio website for downloading CVs in English and French, with a responsive design, dark mode, and language filtering.

**Live Site:** [https://odysseu.github.io/](https://odysseu.github.io/)

---

## Features

- **Dual Language Support**: English and French CVs with language toggle
- **Multiple Versions**: Simple (1-page) and Full (detailed) versions for each language
- **Dark Mode**: Toggle between light and dark themes (persisted via localStorage)
- **Responsive Design**: Works on mobile, tablet, and desktop
- **Preview Images**: Visual previews of each CV version
- **Direct Download**: Click preview images to download PDFs
- **GitHub Profile Link**: Clickable profile picture linking to GitHub

---

## Project Structure

```
.
├── index.html              # Main webpage
├── favicon.ico             # Site favicon
├── circle_profile.png      # Profile picture
├── github_profile.jpg      # GitHub profile image (unused)
├── css/
│   └── styles.css          # All styles with CSS variables for theming
├── js/
│   └── script.js           # Interactive functionality
├── build_cv_website.sh     # Full build script (LaTeX + previews)
├── generate_cv_previews.py # Generate preview images from PDFs
├── cv_english_simple.tex   # English CV (1-page version)
├── cv_english_full.tex     # English CV (detailed version)
├── cv_french_simple.tex    # French CV (1-page version)
├── cv_french_full.tex      # French CV (detailed version)
├── *.pdf                   # Generated CV PDFs
└── *preview.png            # Generated preview images
```

---

## How the Site Works

### Frontend Architecture

```
index.html
    ├── css/styles.css
    │   ├── :root variables (light theme colors)
    │   ├── body.dark-mode variables (dark theme colors)
    │   ├── .container, .profile-picture, .cv-grid, etc.
    │   └── Responsive breakpoints
    └── js/script.js
        ├── filterByLanguage() - Shows/hides CVs by language
        ├── toggleDarkMode() - Toggles dark mode + saves preference
        ├── updateDarkModeButton() - Updates button icon
        └── downloadCV(version) - Triggers PDF download
```

### HTML Structure

- **Profile Section**: Profile picture (links to GitHub), title, subtitle
- **Theme Toggle**: Button in top-right corner
- **Language Tabs**: Radio buttons for English/French filtering
- **CV Grid**: Preview images organized by language, clickable to download
- **Note Section**: Instructions for users

### CSS Features

- CSS Custom Properties (variables) for easy theming
- Dark mode via `body.dark-mode` class
- Flexbox/Grid for responsive layouts
- Hover effects on CV preview cards
- Proper contrast for accessibility

### JavaScript Features

- **Language Filtering**: Uses `data-language` attributes and CSS `.hidden` class
- **Dark Mode Persistence**: Saves preference to `localStorage`
- **Dynamic Downloads**: Creates temporary `<a>` elements with `download` attribute
- **DOMContentLoaded**: Initializes language filter and dark mode on page load

---

## Build System

The site uses a automated build system to generate PDFs from LaTeX source files and create preview images.

### Build Process

```
1. LaTeX Compilation
   ├── cv_english_simple.tex → cv_english_simple.pdf
   ├── cv_english_full.tex → cv_english.pdf
   ├── cv_french_simple.tex → cv_french_simple.pdf
   └── cv_french_full.tex → cv_french.pdf

2. Preview Generation
   ├── cv_english.pdf → english_simple_cv_preview.png (200px wide)
   ├── cv_english.pdf → english_full_cv_preview.png (200px wide)
   ├── cv_french.pdf → french_simple_cv_preview.png (200px wide)
   └── cv_french.pdf → french_full_cv_preview.png (200px wide)

3. Static Site
   └── index.html references all generated files
```

### Running the Build

#### Full Build (LaTeX + Previews)
```bash
# Make executable (first time only)
chmod +x build_cv_website.sh

# Run full build
./build_cv_website.sh
```

#### Previews Only (if PDFs already exist)
```bash
python3 generate_cv_previews.py
```

#### Force Recompile (after .tex changes)
```bash
rm -f cv_*.pdf
./build_cv_website.sh
```

---

## Requirements

### LaTeX Compilation
- `pdflatex` - LaTeX compiler (part of TeX Live)
- Required LaTeX packages: `fontawesome`, `latexsym`, French language support

### Preview Generation
- `ghostscript` - PDF to image conversion
- Python 3 with `Pillow` library - Image resizing

### Installation (Ubuntu/Debian)
```bash
# LaTeX and required packages
sudo apt install texlive texlive-latex-extra texlive-fonts-extra texlive-lang-french

# Ghostscript for PDF to PNG conversion
sudo apt install ghostscript

# Python Pillow for image processing
pip install Pillow
```

---

## Deployment

This is a static site. Simply push to the `main` branch of this repository:

```bash
# After building
git add .
git commit -m "Update CVs and rebuild"
git push origin main
```

GitHub Pages will automatically serve the site from the root directory.

---

## Customization

### Updating CVs
1. Edit the `.tex` files (`cv_english_simple.tex`, etc.)
2. Run the build script: `./build_cv_website.sh`
3. Commit and push changes

### Adding a New CV Version
1. Create new `.tex` file
2. Add PDF generation to `build_cv_website.sh`
3. Add preview generation to `generate_cv_previews.py`
4. Add HTML element in `index.html` with proper `onclick` handler
5. Add mapping in `js/script.js` `downloadCV()` function

### Updating Styles
Edit `css/styles.css`:
- Light theme: Modify `:root` variables
- Dark theme: Modify `body.dark-mode` variables
- Layout: Adjust `.container`, `.cv-grid`, etc.

### Adding Language Support
1. Add new language `.tex` files
2. Update `build_cv_website.sh` and `generate_cv_previews.py`
3. Add radio button in `index.html`
4. Add corresponding `.language-group` div with `data-language` attribute
5. Add language mappings in `js/script.js`

---

## Troubleshooting

### LaTeX Compilation Fails
```
! LaTeX Error: File `fontawesome.sty' not found.
```
**Solution**: Install required packages:
```bash
sudo apt install texlive-latex-extra texlive-fonts-extra texlive-lang-french
```

### Ghostscript Not Found
```
gs: command not found
```
**Solution**: Install ghostscript:
```bash
sudo apt install ghostscript
```

### Pillow Not Installed
```
ModuleNotFoundError: No module named 'PIL'
```
**Solution**: Install Pillow:
```bash
pip install Pillow
```

### Build Succeeds but PDFs Missing
The build script will use existing PDFs if compilation fails. Check:
- LaTeX file paths are correct
- No syntax errors in `.tex` files
- All required LaTeX packages are installed

---

## Technical Details

### Preview Generation
- Uses ghostscript at 150 DPI for initial conversion
- Resizes to 200px width with aspect ratio preserved
- Uses LANCZOS resampling for quality
- Temporary files are automatically cleaned up

### PDF Compilation
- Runs `pdflatex` twice to resolve all references
- Uses `-interaction=nonstopmode` to prevent hanging on errors
- Falls back to existing PDFs if compilation fails

### Dark Mode
- CSS variables switch between light/dark color schemes
- Preference stored in `localStorage` with key `darkMode`
- Button icon changes between 🌓 (moon) and ☀️ (sun)

### Language Filtering
- Uses CSS `.hidden` class for hiding non-selected languages
- `data-language` attribute matches language selection
- Default: French selected on page load

### Download Functionality
- Creates temporary `<a>` element with `download` attribute
- Uses predefined filename mappings for each version
- Element is removed after triggering click event

---

## License

Personal portfolio project. Feel free to use as inspiration for your own CV website.
