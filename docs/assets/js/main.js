/* main.js — gviolato.com */

(function () {
  'use strict';

  // -------------------------------------------------------------------------
  // Hamburger nav toggle
  // -------------------------------------------------------------------------
  const toggle = document.getElementById('nav-toggle');
  const navLinks = document.getElementById('nav-links');

  if (toggle && navLinks) {
    toggle.addEventListener('click', function () {
      const open = navLinks.classList.toggle('open');
      toggle.classList.toggle('open', open);
      toggle.setAttribute('aria-expanded', String(open));
    });

    // Close menu when a link is clicked
    navLinks.querySelectorAll('a').forEach(function (a) {
      a.addEventListener('click', function () {
        navLinks.classList.remove('open');
        toggle.classList.remove('open');
        toggle.setAttribute('aria-expanded', 'false');
      });
    });
  }

  // -------------------------------------------------------------------------
  // Profile photo fallback
  // -------------------------------------------------------------------------
  const profileImg = document.getElementById('profile-img');
  if (profileImg) {
    profileImg.addEventListener('error', function () {
      const circle = document.getElementById('photo-circle');
      if (circle) {
        circle.innerHTML = '<div class="photo-initials"><span>GV</span></div>';
      }
    });
  }

  // -------------------------------------------------------------------------
  // Contact form — Apps Script webhook submission
  // -------------------------------------------------------------------------
  const WEBHOOK_URL = 'https://script.google.com/macros/s/AKfycbxDqZS0DRZbqehe61NyqywGRwHlhYBxbQcitIpWGnCbRVoPxFT9JbXu8fukn6dF-lMhHQ/exec';

  const form = document.getElementById('contact-form');
  const msgEl = document.getElementById('form-message');
  const submitBtn = document.getElementById('form-submit');

  if (form) {
    form.addEventListener('submit', async function (e) {
      e.preventDefault();

      submitBtn.disabled = true;
      submitBtn.textContent = 'Sending…';
      msgEl.className = 'form-message';
      msgEl.textContent = '';

      const data = Object.fromEntries(new FormData(form).entries());

      try {
        const res = await fetch(WEBHOOK_URL, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(data),
        });

        const json = await res.json();

        if (json.result === 'ok') {
          msgEl.classList.add('success');
          msgEl.textContent = 'Thank you — your message has been sent. I will be in touch shortly.';
          form.reset();
          if (typeof turnstile !== 'undefined') {
            turnstile.reset();
          }
        } else {
          throw new Error(json.error || 'Submission failed');
        }
      } catch (err) {
        msgEl.classList.add('error');
        msgEl.textContent =
          'Something went wrong. Please try again later.';
      } finally {
        submitBtn.disabled = false;
        submitBtn.textContent = 'Send Message';
      }
    });
  }
})();
