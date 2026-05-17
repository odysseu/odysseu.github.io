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

// Initialize with French selected by default
document.addEventListener('DOMContentLoaded', () => {
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
