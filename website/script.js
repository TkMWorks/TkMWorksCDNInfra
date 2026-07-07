// Subtle nav shadow once the user scrolls past the hero
const nav = document.querySelector('.nav');
window.addEventListener('scroll', () => {
  if (window.scrollY > 12) {
    nav.style.borderBottomColor = 'var(--steel-dim)';
  } else {
    nav.style.borderBottomColor = 'var(--line)';
  }
}, { passive: true });
