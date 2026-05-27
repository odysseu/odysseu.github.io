// Global variable to store translations
let translations = {};

// Load translations from JSON file
async function loadTranslations() {
    try {
        const response = await fetch('js/content.json');
        if (!response.ok) {
            throw new Error('Failed to load translations');
        }
        translations = await response.json();
    } catch (error) {
        console.error('Error loading translations:', error);
        // Fallback to default translations
        translations = {
            en: {
                title: "Download My CV",
                subtitle: "Choose between simple or detailed versions",
                note: "Click on any preview image above to download the corresponding CV version in PDF",
                language: "en",
                version_simple: "Simple (1 page)",
                version_full: "Full (Detailed)"
            },
            fr: {
                title: "Télécharger mon CV",
                subtitle: "Choisissez entre les versions simple ou détaillée",
                note: "Cliquez sur une image pour télécharger le CV correspondant en PDF",
                language: "fr",
                version_simple: "Simple (1 page)",
                version_full: "Complète (Détails techniques)"
            }
        };
    }
}

// Update all elements with data-i18n attribute
function updateLanguageContent() {
    const selectedLanguage = document.querySelector('input[name="language"]:checked').value;
    const langCode = selectedLanguage === 'french' ? 'fr' : 'en';
    const t = translations[langCode];

    if (!t) {
        console.error('Translations not loaded for language:', langCode);
        return;
    }

    // Update HTML lang attribute
    document.documentElement.lang = langCode;

    // Update all elements with data-i18n attribute
    const elements = document.querySelectorAll('[data-i18n]');
    elements.forEach(el => {
        const key = el.getAttribute('data-i18n');
        if (t[key] !== undefined) {
            el.textContent = t[key];
        }
    });
}

function filterByLanguage() {
    const selectedLanguage = document.querySelector('input[name="language"]:checked').value;
    const languageGroups = document.querySelectorAll('.language-group');

    languageGroups.forEach(group => {
        if (group.dataset.language === selectedLanguage) {
            group.classList.remove('hidden');
        } else {
            group.classList.add('hidden');
        }
    });

    // Update text content based on language
    updateLanguageContent();
}

function toggleDarkMode() {
    document.body.classList.toggle('dark-mode');
    const isDark = document.body.classList.contains('dark-mode');
    localStorage.setItem('darkMode', isDark);
    updateDarkModeButton(isDark);
}

function updateDarkModeButton(isDark) {
    const btn = document.getElementById('darkModeBtn');
    if (btn) {
        btn.textContent = isDark ? '☀️' : '🌓';
    }
}

function downloadCV(version) {
    const link = document.createElement('a');
    const mappings = {
        'english_simple': { href: 'pdf/cv_english_simple.pdf', name: 'Ulysse_Boucherie_CV_English_Simple.pdf' },
        'english_full': { href: 'pdf/cv_english.pdf', name: 'Ulysse_Boucherie_CV_English_Full.pdf' },
        'french_simple': { href: 'pdf/cv_french_simple.pdf', name: 'Ulysse_Boucherie_CV_French_Simple.pdf' },
        'french_full': { href: 'pdf/cv_french.pdf', name: 'Ulysse_Boucherie_CV_French_Full.pdf' }
    };

    const mapping = mappings[version];
    link.href = mapping.href;
    link.download = mapping.name;

    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

// Initialize page
document.addEventListener('DOMContentLoaded', async () => {
    // Load translations first
    await loadTranslations();

    // Initialize language filter
    filterByLanguage();

    // Load dark mode preference from localStorage
    const savedDarkMode = localStorage.getItem('darkMode');
    if (savedDarkMode === 'true') {
        document.body.classList.add('dark-mode');
        updateDarkModeButton(true);
    } else {
        updateDarkModeButton(false);
    }
});
