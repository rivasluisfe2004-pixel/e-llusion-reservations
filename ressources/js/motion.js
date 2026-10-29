// E-LLUSION v2 — petites animations, sans librairie
(function () {
    var calme = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    // Lien actif dans la navbar
    var page = location.pathname.split('/').pop() || 'index.php';
    document.querySelectorAll('.navbar__links a').forEach(function (a) {
        if (a.getAttribute('href').split('/').pop() === page) a.classList.add('is-active');
    });

    // Titres glitch : le texte est recopié pour les calques ::before / ::after
    document.querySelectorAll('.hero__title, .expo-hero__title').forEach(function (t) {
        t.classList.add('glitch');
        t.setAttribute('data-text', t.textContent);
    });

    // Barre de progression + navbar compacte
    var barre = document.createElement('div');
    barre.className = 'scroll-progress';
    document.body.appendChild(barre);
    var nav = document.querySelector('.navbar');
    function auScroll() {
        var max = document.documentElement.scrollHeight - innerHeight;
        barre.style.setProperty('--progress', max > 0 ? scrollY / max : 0);
        if (nav) nav.classList.toggle('is-scrolled', scrollY > 30);
    }
    addEventListener('scroll', auScroll, { passive: true });
    auScroll();

    // Halo qui suit la souris dans le hero
    var hero = document.querySelector('.hero');
    if (hero && !calme) {
        hero.addEventListener('mousemove', function (e) {
            var r = hero.getBoundingClientRect();
            hero.style.setProperty('--mx', (e.clientX - r.left) + 'px');
            hero.style.setProperty('--my', (e.clientY - r.top) + 'px');
        });
    }

    if (!('IntersectionObserver' in window)) return;

    // Apparition au scroll, en décalé entre éléments voisins
    var cibles = '.section-label, .section-title, .salle-card, .info-card, .oeuvre, .salle-concept, ' +
                 '.concept__media, .exposition__text, .contact__card, .contact__info, .cta-banner, ' +
                 '.aftermovie__player, .form-step, .contact-card';
    var obsReveal = new IntersectionObserver(function (entrees) {
        entrees.forEach(function (e) {
            if (e.isIntersecting) {
                e.target.classList.add('is-visible');
                obsReveal.unobserve(e.target);
            }
        });
    }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });

    if (!calme) {
        document.querySelectorAll(cibles).forEach(function (el) {
            if (el.closest('.hero')) return;
            var freres = Array.prototype.filter.call(el.parentNode.children, function (s) { return s.matches(cibles); });
            el.style.setProperty('--delay', Math.min(freres.indexOf(el), 4) * 0.08 + 's');
            el.classList.add('reveal');
            obsReveal.observe(el);
        });
    }

    // Vidéos : lecture seulement quand elles sont à l'écran
    var obsVideo = new IntersectionObserver(function (entrees) {
        entrees.forEach(function (e) {
            var v = e.target;
            if (e.isIntersecting && !calme) {
                var p = v.play();
                if (p) p.catch(function () {});
                v.parentNode.classList.add('is-playing');
            } else {
                v.pause();
                v.parentNode.classList.remove('is-playing');
            }
        });
    }, { threshold: 0.35 });
    document.querySelectorAll('video[data-autoplay]').forEach(function (v) { obsVideo.observe(v); });
})();
