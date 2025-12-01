<template>
    <canvas ref="canvas" class="particle-canvas" aria-hidden="true"></canvas>
</template>

<script>
export default {
    name: 'ParticleBackground',
    props: {
        theme: {
            type: String,
            default: 'night'
        }
    },
    data() {
        return {
            canvas: null,
            ctx: null,
            coreParticles: [],
            effectParticles: [],
            ripples: [],
            animationId: null,
            boundAnimate: null,
            resizeHandler: null,
            mouseMoveHandler: null,
            mouseLeaveHandler: null,
            clickHandler: null,
            motionHandler: null,
            lastTimestamp: 0,
            mouse: {
                x: 0,
                y: 0,
                active: false
            },
            mouseTimer: null,
            resizeObserver: null,
            mediaQuery: null,
            reduceMotion: false,
            attractionTargets: new Set()
        };
    },
    mounted() {
        if (typeof window === 'undefined') {
            return;
        }
        this.setupMotionPreference();
        this.initCanvas();
    },
    beforeDestroy() {
        this.destroyCanvas();
    },
    watch: {
        theme() {
            this.refreshPalette();
        }
    },
    methods: {
        setupMotionPreference() {
            this.mediaQuery = window.matchMedia('(prefers-reduced-motion: reduce)');
            this.reduceMotion = this.mediaQuery.matches;
            this.motionHandler = this.handleMotionPreference.bind(this);
            if (this.mediaQuery.addEventListener) {
                this.mediaQuery.addEventListener('change', this.motionHandler);
            } else {
                this.mediaQuery.addListener(this.motionHandler);
            }
        },
        handleMotionPreference(event) {
            this.reduceMotion = event.matches;
            this.resetScene();
        },
        initCanvas() {
            this.canvas = this.$refs.canvas;
            if (!this.canvas) {
                return;
            }
            this.ctx = this.canvas.getContext('2d');
            this.setCanvasSize();
            this.resizeHandler = this.setCanvasSize.bind(this);
            this.mouseMoveHandler = this.handleMouseMove.bind(this);
            this.mouseLeaveHandler = this.handleMouseLeave.bind(this);
            this.clickHandler = this.handleClick.bind(this);
            window.addEventListener('resize', this.resizeHandler);
            window.addEventListener('mousemove', this.mouseMoveHandler);
            window.addEventListener('mouseleave', this.mouseLeaveHandler);
            window.addEventListener('click', this.clickHandler);
            this.createParticles();
            this.lastTimestamp = performance.now();
            this.boundAnimate = this.animate.bind(this);
            this.animationId = requestAnimationFrame(this.boundAnimate);
        },
        destroyCanvas() {
            cancelAnimationFrame(this.animationId);
            window.removeEventListener('resize', this.resizeHandler);
            window.removeEventListener('mousemove', this.mouseMoveHandler);
            window.removeEventListener('mouseleave', this.mouseLeaveHandler);
            window.removeEventListener('click', this.clickHandler);
            if (this.mediaQuery) {
                if (this.mediaQuery.removeEventListener) {
                    this.mediaQuery.removeEventListener('change', this.motionHandler);
                } else {
                    this.mediaQuery.removeListener(this.motionHandler);
                }
            }
            if (this.mouseTimer) {
                clearTimeout(this.mouseTimer);
            }
        },
        setCanvasSize() {
            if (!this.canvas) return;
            this.canvas.width = window.innerWidth;
            this.canvas.height = window.innerHeight;
        },
        resetScene() {
            this.coreParticles = [];
            this.effectParticles = [];
            this.ripples = [];
            this.createParticles();
        },
        createParticles() {
            const count = this.reduceMotion ? 80 : 150;
            const palette = this.currentPalette();
            for (let i = 0; i < count; i += 1) {
                this.coreParticles.push(this.buildParticle({
                    color: palette[Math.floor(Math.random() * palette.length)]
                }));
            }
        },
        buildParticle(overrides = {}) {
            const speedBase = this.reduceMotion ? 0.2 : 0.5;
            return {
                x: overrides.x !== undefined ? overrides.x : Math.random() * this.canvas.width,
                y: overrides.y !== undefined ? overrides.y : Math.random() * this.canvas.height,
                vx: overrides.vx !== undefined ? overrides.vx : (Math.random() - 0.5) * speedBase,
                vy: overrides.vy !== undefined ? overrides.vy : (Math.random() - 0.5) * speedBase,
                size: overrides.size !== undefined ? overrides.size : (Math.random() * 3) + 2,
                color: overrides.color || '#6366f1',
                opacity: overrides.opacity !== undefined ? overrides.opacity : 0.7,
                life: overrides.life || null,
                maxLife: overrides.maxLife || null,
                isFollower: overrides.isFollower || false
            };
        },
        spawnFollowerParticles(x, y) {
            const count = this.reduceMotion ? 1 : 3;
            for (let i = 0; i < count; i += 1) {
                this.effectParticles.push(this.buildParticle({
                    x,
                    y,
                    size: (Math.random() * 2) + 2,
                    color: '#38bdf8',
                    opacity: 1,
                    vx: (Math.random() - 0.5) * 0.6,
                    vy: (Math.random() - 0.5) * 0.6,
                    life: 500,
                    maxLife: 500,
                    isFollower: true
                }));
            }
        },
        handleMouseMove(event) {
            const rect = this.canvas.getBoundingClientRect();
            this.mouse.x = event.clientX - rect.left;
            this.mouse.y = event.clientY - rect.top;
            this.mouse.active = true;
            if (this.mouseTimer) {
                clearTimeout(this.mouseTimer);
            }
            this.mouseTimer = setTimeout(() => {
                this.mouse.active = false;
                this.attractionTargets.clear();
            }, 1200);
            this.spawnFollowerParticles(this.mouse.x, this.mouse.y);
            this.pickAttractionTargets();
        },
        handleMouseLeave() {
            this.mouse.active = false;
            this.attractionTargets.clear();
        },
        handleClick(event) {
            const rect = this.canvas.getBoundingClientRect();
            const x = event.clientX - rect.left;
            const y = event.clientY - rect.top;
            const layers = this.reduceMotion ? 1 : 3;
            for (let i = 0; i < layers; i += 1) {
                this.ripples.push({
                    x,
                    y,
                    radius: 0,
                    alpha: 0.8 - (i * 0.2),
                    growth: 15 - (i * 2)
                });
            }
        },
        pickAttractionTargets() {
            if (!this.mouse.active) {
                this.attractionTargets.clear();
                return;
            }
            const samples = this.coreParticles
                .map((particle, index) => ({
                    particle,
                    index,
                    distance: Math.hypot(this.mouse.x - particle.x, this.mouse.y - particle.y)
                }))
                .sort((a, b) => a.distance - b.distance)
                .slice(0, 10);
            this.attractionTargets = new Set(samples.map(item => item.index));
        },
        applyAttraction(particle) {
            if (!this.mouse.active) return;
            const dx = this.mouse.x - particle.x;
            const dy = this.mouse.y - particle.y;
            const distance = Math.max(Math.hypot(dx, dy), 0.001);
            const force = this.reduceMotion ? 0.0006 : 0.0015;
            particle.vx += (dx / distance) * force * 16;
            particle.vy += (dy / distance) * force * 16;
        },
        animate() {
            this.animationId = requestAnimationFrame(this.boundAnimate);
            const now = performance.now();
            const delta = now - this.lastTimestamp;
            this.lastTimestamp = now;
            this.drawFrame(delta);
        },
        drawFrame(delta) {
            if (!this.ctx) return;
            this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
            const activeParticles = [...this.coreParticles, ...this.effectParticles];
            activeParticles.forEach((particle, index) => {
                if (this.attractionTargets.has(index)) {
                    this.applyAttraction(particle);
                }
                this.updateParticle(particle, delta);
                this.drawParticle(particle);
            });
            this.effectParticles = this.effectParticles.filter(p => !p.life || p.life > 0);
            this.drawConnections(activeParticles);
            this.drawRipples(delta);
        },
        updateParticle(particle, delta) {
            particle.x += particle.vx * delta * 0.06;
            particle.y += particle.vy * delta * 0.06;
            if (particle.x < 0 || particle.x > this.canvas.width) {
                particle.vx *= -1;
            }
            if (particle.y < 0 || particle.y > this.canvas.height) {
                particle.vy *= -1;
            }
            if (particle.life !== null) {
                particle.life -= delta;
                particle.opacity = Math.max(particle.life / (particle.maxLife || 1), 0);
                if (particle.life <= 0) {
                    particle.dead = true;
                }
            }
        },
        drawParticle(particle) {
            this.ctx.beginPath();
            this.ctx.fillStyle = this.applyAlpha(particle.color, particle.opacity);
            this.ctx.arc(particle.x, particle.y, particle.size, 0, Math.PI * 2);
            this.ctx.fill();
        },
        drawConnections(particles) {
            for (let i = 0; i < particles.length; i += 1) {
                for (let j = i + 1; j < particles.length; j += 1) {
                    const p1 = particles[i];
                    const p2 = particles[j];
                    const distance = Math.hypot(p1.x - p2.x, p1.y - p2.y);
                    if (distance < 100) {
                        this.ctx.strokeStyle = this.applyAlpha('#ffffff', 0.05 * (1 - distance / 100));
                        this.ctx.lineWidth = 0.5;
                        this.ctx.beginPath();
                        this.ctx.moveTo(p1.x, p1.y);
                        this.ctx.lineTo(p2.x, p2.y);
                        this.ctx.stroke();
                    }
                }
            }
        },
        drawRipples(delta) {
            this.ripples = this.ripples.filter(ripple => ripple.alpha > 0);
            this.ripples.forEach(ripple => {
                ripple.radius += ripple.growth * (delta / 16.6);
                ripple.alpha -= 0.01 * (delta / 16.6);
                if (ripple.alpha <= 0) {
                    ripple.alpha = 0;
                }
                this.ctx.beginPath();
                this.ctx.strokeStyle = this.applyAlpha('#7dd3fc', ripple.alpha);
                this.ctx.lineWidth = 2;
                this.ctx.arc(ripple.x, ripple.y, ripple.radius, 0, Math.PI * 2);
                this.ctx.stroke();
            });
        },
        applyAlpha(color, alpha) {
            if (color.startsWith('#')) {
                const hex = color.replace('#', '');
                const normalized = hex.length === 3 ? hex.split('').map(ch => ch + ch).join('') : hex;
                const bigint = parseInt(normalized, 16);
                const r = (bigint >> 16) & 255;
                const g = (bigint >> 8) & 255;
                const b = bigint & 255;
                return `rgba(${r}, ${g}, ${b}, ${alpha})`;
            }
            if (color.startsWith('rgba')) {
                const body = color.slice(5, -1).split(',').slice(0, 3).map(part => part.trim()).join(', ');
                return `rgba(${body}, ${alpha})`;
            }
            if (color.startsWith('rgb(')) {
                const body = color.slice(4, -1);
                return `rgba(${body}, ${alpha})`;
            }
            return color;
        },
        refreshPalette() {
            const palette = this.currentPalette();
            this.coreParticles.forEach(particle => {
                particle.color = palette[Math.floor(Math.random() * palette.length)];
            });
        },
        currentPalette() {
            if (this.theme === 'day') {
                return ['#5c6ac4', '#7b87f8'];
            }
            return ['#6366f1', '#8b5cf6'];
        }
    }
};
</script>

<style scoped>
.particle-canvas {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    z-index: 0;
    mix-blend-mode: lighten;
}

@media (prefers-reduced-motion: reduce) {
    .particle-canvas {
        opacity: 0.6;
        mix-blend-mode: normal;
    }
}
</style>
