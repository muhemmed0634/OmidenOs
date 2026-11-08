// Omiden OS Website JavaScript

let currentLang = 'en';
let keybindsData = [];
let wallpapersData = [];
let releaseData = {};

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    loadData();
    initLanguage();
    initSmoothScroll();
});

// Load all data
async function loadData() {
    try {
        // Load keybinds
        const keybindsResponse = await fetch('data/keybinds.json');
        keybindsData = await keybindsResponse.json();
        showKeybinds('hyprland');
        
        // Load wallpapers
        const wallpapersResponse = await fetch('data/wallpapers.json');
        wallpapersData = await wallpapersResponse.json();
        showWallpapers('normal');
        
        // Load release info
        const releaseResponse = await fetch('data/release.json');
        releaseData = await releaseResponse.json();
        displayRelease();
    } catch (error) {
        console.error('Error loading data:', error);
    }
}

// Language functions
function initLanguage() {
    const savedLang = localStorage.getItem('language') || 'en';
    setLanguage(savedLang);
}

function setLanguage(lang) {
    currentLang = lang;
    localStorage.setItem('language', lang);
    
    // Update active button
    document.querySelectorAll('.lang-toggle button').forEach(btn => {
        btn.classList.remove('active');
    });
    document.getElementById(`lang-${lang}`).classList.add('active');
    
    // Update all translatable elements
    document.querySelectorAll('[data-en]').forEach(el => {
        const text = el.getAttribute(`data-${lang}`);
        if (text) {
            if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
                el.placeholder = text;
            } else {
                el.textContent = text;
            }
        }
    });
    
    // Reload dynamic content with new language
    if (keybindsData.length > 0) showKeybinds(document.querySelector('.wm-tab.active')?.dataset.wm || 'hyprland');
}

// Keybinds functions
function showKeybinds(wm) {
    // Update active tab
    document.querySelectorAll('.wm-tab').forEach(tab => {
        tab.classList.remove('active');
    });
    event?.target?.classList.add('active');
    
    const container = document.getElementById('keybinds-container');
    if (!container) return;
    
    const bindKey = wm === 'hyprland' ? 'hyprland_bind' : 'i3_bind';
    const filtered = keybindsData.filter(kb => kb[bindKey]);
    
    container.innerHTML = filtered.map(kb => `
        <div class="keybind-card">
            <div class="keybind-keys">${kb[bindKey]}</div>
            <div class="keybind-description">${kb[`description_${currentLang}`] || kb.description_en}</div>
        </div>
    `).join('');
}

// Wallpapers functions
function showWallpapers(type) {
    // Update active tab
    document.querySelectorAll('.wallpaper-tab').forEach(tab => {
        tab.classList.remove('active');
    });
    event?.target?.classList.add('active');
    
    const container = document.getElementById('wallpapers-container');
    if (!container) return;
    
    const wallpapers = wallpapersData[type] || [];
    
    if (wallpapers.length === 0) {
        container.innerHTML = `<p style="text-align: center; grid-column: 1/-1;">No wallpapers available in this category</p>`;
        return;
    }
    
    container.innerHTML = wallpapers.map(wall => `
        <div class="wallpaper-card" onclick="openWallpaper('${wall.path}')">
            <img src="${wall.path}" alt="${wall.name}" loading="lazy">
        </div>
    `).join('');
}

function openWallpaper(path) {
    window.open(path, '_blank');
}

// Release info
function displayRelease() {
    const versionEl = document.getElementById('release-version');
    const dateEl = document.getElementById('release-date');
    const linkEl = document.getElementById('download-link');
    
    if (releaseData.version) {
        versionEl.textContent = `Version ${releaseData.version}`;
        dateEl.textContent = `Released: ${releaseData.date}`;
        linkEl.href = releaseData.download_url || '#';
    } else {
        versionEl.textContent = 'Coming Soon';
        dateEl.textContent = '';
        linkEl.style.display = 'none';
    }
}

// Smooth scroll
function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

// Make functions global
window.setLanguage = setLanguage;
window.showKeybinds = showKeybinds;
window.showWallpapers = showWallpapers;
window.openWallpaper = openWallpaper;
