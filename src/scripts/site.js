const reduceMotion = matchMedia('(prefers-reduced-motion: reduce)').matches;
const canHover = matchMedia('(hover: hover) and (pointer: fine)').matches;

// Fade-in cards as they scroll into view.
const revealer = new IntersectionObserver(
  (entries) => {
    for (const e of entries) {
      if (e.isIntersecting) {
        e.target.classList.add('is-in');
        revealer.unobserve(e.target);
      }
    }
  },
  { rootMargin: '0px 0px -8% 0px' }
);
document.querySelectorAll('.reveal').forEach((el) => revealer.observe(el));

// Only load a video's first frame once it is near the screen (keeps the page fast on phones).
const loader = new IntersectionObserver(
  (entries) => {
    for (const e of entries) {
      if (!e.isIntersecting) continue;
      const v = e.target;
      v.src = v.dataset.src;
      v.preload = 'metadata';
      loader.unobserve(v);
    }
  },
  { rootMargin: '300px 0px' }
);
document.querySelectorAll('video[data-src]').forEach((v) => loader.observe(v));

// Desktop: silent preview while hovering a video.
if (canHover && !reduceMotion) {
  document.querySelectorAll('.video-frame video').forEach((v) => {
    const frame = v.closest('.video-frame');
    frame.addEventListener('mouseenter', () => {
      if (!v.src) v.src = v.dataset.src;
      v.play().catch(() => {});
    });
    frame.addEventListener('mouseleave', () => v.pause());
  });
}

// Category filter chips.
const chips = document.querySelectorAll('.chip');
chips.forEach((chip) =>
  chip.addEventListener('click', () => {
    chips.forEach((c) => {
      c.classList.toggle('is-active', c === chip);
      c.setAttribute('aria-pressed', String(c === chip));
    });
    const f = chip.dataset.filter;
    document.querySelectorAll('.video-card').forEach((card) => {
      card.hidden = f !== 'all' && !JSON.parse(card.dataset.categories).includes(f);
    });
  })
);

// Lightbox for videos (with sound) and photos.
const box = document.querySelector('.lightbox');
const body = box.querySelector('.lightbox-body');
const open = (node) => {
  body.replaceChildren(node);
  box.showModal();
  document.documentElement.classList.add('no-scroll');
};
const close = () => {
  box.close();
};
box.addEventListener('close', () => {
  body.replaceChildren();
  document.documentElement.classList.remove('no-scroll');
});
box.querySelector('.lightbox-close').addEventListener('click', close);
box.addEventListener('click', (e) => {
  if (e.target === box) close();
});

document.querySelectorAll('.video-frame[data-video]').forEach((btn) =>
  btn.addEventListener('click', () => {
    btn.querySelector('video')?.pause();
    const v = document.createElement('video');
    v.src = btn.dataset.video;
    v.controls = true;
    v.autoplay = true;
    v.playsInline = true;
    v.setAttribute('aria-label', btn.dataset.title);
    open(v);
  })
);

document.querySelectorAll('[data-photo]').forEach((btn) =>
  btn.addEventListener('click', () => {
    const img = document.createElement('img');
    img.src = btn.dataset.photo;
    img.alt = btn.querySelector('img')?.alt || '';
    open(img);
  })
);

// Copy email button.
document.querySelectorAll('[data-copy]').forEach((btn) =>
  btn.addEventListener('click', async () => {
    try {
      await navigator.clipboard.writeText(btn.dataset.copy);
      const label = btn.textContent;
      btn.textContent = 'Copied!';
      setTimeout(() => (btn.textContent = label), 1600);
    } catch {
      window.location.href = `mailto:${btn.dataset.copy}`;
    }
  })
);
