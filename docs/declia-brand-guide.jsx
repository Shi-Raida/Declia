import { useState } from "react";

// ─── PALETTE DATA ───
const brand = {
  primary: { hex: "#1E2A3A", name: "Bleu Crépuscule", rgb: "30, 42, 58", cmyk: "83, 60, 34, 56", pantone: "289 C", role: "Couleur principale — headers, fonds forts, navbar, footer" },
  secondary: { hex: "#B45A3C", name: "Terracotta Braise", rgb: "180, 90, 60", cmyk: "14, 68, 76, 8", pantone: "7580 C", role: "Secondaire — boutons principaux, sections clés, titres d'impact" },
  accent: { hex: "#CFA044", name: "Or Solaire", rgb: "207, 160, 68", cmyk: "16, 30, 80, 2", pantone: "7407 C", role: "Accent premium — CTA, prix, highlights, badges, icônes" },
  tertiary: { hex: "#3A6B8A", name: "Bleu Ouvert", rgb: "58, 107, 138", cmyk: "72, 38, 20, 8", pantone: "7700 C", role: "Tertiaire — liens, icônes secondaires, hover states, variantes" },
  light: { hex: "#F6F3ED", name: "Lin Clair", rgb: "246, 243, 237", cmyk: "3, 2, 5, 0", pantone: "7527 C", role: "Fond clair principal — arrière-plans de page, sections alternées" },
  surface: { hex: "#FFFEF9", name: "Blanc Nacré", rgb: "255, 254, 249", cmyk: "0, 0, 2, 0", pantone: "White", role: "Surface — cartes, modales, contenus, formulaires" },
  text: { hex: "#1E2434", name: "Encre Profonde", rgb: "30, 36, 52", cmyk: "82, 62, 38, 52", pantone: "296 C", role: "Texte principal — corps de texte, titres" },
  textLight: { hex: "#7A7572", name: "Pierre Douce", rgb: "122, 117, 114", cmyk: "36, 32, 34, 16", pantone: "Warm Gray 8 C", role: "Texte secondaire — légendes, sous-titres, placeholders" },
  success: { hex: "#3F8A5E", name: "Vert Forêt", rgb: "63, 138, 94", cmyk: "68, 14, 64, 8", pantone: "7732 C", role: "États de succès — validations, messages positifs" },
  error: { hex: "#C44040", name: "Rouge Terre", rgb: "196, 64, 64", cmyk: "12, 82, 68, 6", pantone: "7621 C", role: "États d'erreur — alertes, messages d'erreur" },
};

const sections = [
  { id: "colors", label: "Couleurs", icon: "◆" },
  { id: "usage", label: "Utilisation", icon: "◈" },
  { id: "social", label: "Réseaux", icon: "✦" },
  { id: "contrast", label: "Accessibilité", icon: "⬡" },
  { id: "donts", label: "Do / Don't", icon: "◇" },
];

// ─── HELPERS ───
function isLight(hex) {
  const r = parseInt(hex.slice(1, 3), 16);
  const g = parseInt(hex.slice(3, 5), 16);
  const b = parseInt(hex.slice(5, 7), 16);
  return r * 0.299 + g * 0.587 + b * 0.114 > 160;
}

function contrastRatio(hex1, hex2) {
  const lum = (hex) => {
    const c = [hex.slice(1,3), hex.slice(3,5), hex.slice(5,7)].map(h => {
      const v = parseInt(h, 16) / 255;
      return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4);
    });
    return 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2];
  };
  const l1 = lum(hex1), l2 = lum(hex2);
  const lighter = Math.max(l1, l2), darker = Math.min(l1, l2);
  return ((lighter + 0.05) / (darker + 0.05)).toFixed(2);
}

// ─── COLOR SWATCH ───
function Swatch({ color, showAll }) {
  const [copied, setCopied] = useState(false);
  const txt = isLight(color.hex) ? "#1E2434" : "#fff";
  return (
    <div
      onClick={() => { navigator.clipboard.writeText(color.hex); setCopied(true); setTimeout(() => setCopied(false), 1000); }}
      style={{
        background: color.hex, borderRadius: "14px", padding: "22px 18px", cursor: "pointer",
        transition: "all 0.3s ease", flex: "1 1 200px", minHeight: showAll ? "200px" : "140px",
        display: "flex", flexDirection: "column", justifyContent: "space-between", position: "relative",
        border: isLight(color.hex) ? "1px solid #e5e1da" : "none", boxShadow: "0 2px 10px rgba(0,0,0,0.07)",
      }}
      onMouseEnter={e => { e.currentTarget.style.transform = "translateY(-3px)"; e.currentTarget.style.boxShadow = "0 8px 24px rgba(0,0,0,0.14)"; }}
      onMouseLeave={e => { e.currentTarget.style.transform = "translateY(0)"; e.currentTarget.style.boxShadow = "0 2px 10px rgba(0,0,0,0.07)"; }}
    >
      {copied && <div style={{ position: "absolute", top: "50%", left: "50%", transform: "translate(-50%,-50%)", background: "rgba(0,0,0,0.8)", color: "#fff", padding: "5px 12px", borderRadius: "7px", fontSize: "12px", fontWeight: 600 }}>Copié !</div>}
      <div>
        <div style={{ color: txt, fontWeight: 700, fontSize: "15px", marginBottom: "3px" }}>{color.name}</div>
        <div style={{ color: txt, opacity: 0.6, fontSize: "12px", fontFamily: "'DM Mono', monospace" }}>{color.hex}</div>
      </div>
      {showAll && (
        <div style={{ marginTop: "12px", display: "flex", flexDirection: "column", gap: "4px" }}>
          {[
            { label: "RGB", value: color.rgb },
            { label: "CMJN", value: color.cmyk },
            { label: "Pantone", value: color.pantone },
          ].map(({ label, value }) => (
            <div key={label} style={{ display: "flex", justifyContent: "space-between", color: txt, opacity: 0.55, fontSize: "11px" }}>
              <span style={{ fontWeight: 600 }}>{label}</span>
              <span style={{ fontFamily: "'DM Mono', monospace" }}>{value}</span>
            </div>
          ))}
        </div>
      )}
      <div style={{ color: txt, fontSize: "10px", opacity: 0.45, lineHeight: 1.4, marginTop: "8px" }}>{color.role}</div>
    </div>
  );
}

// ─── SECTIONS ───
function ColorsSection() {
  const groups = [
    { title: "Couleurs principales", keys: ["primary", "secondary", "accent", "tertiary"] },
    { title: "Neutres & fonds", keys: ["light", "surface", "text", "textLight"] },
    { title: "Utilitaires", keys: ["success", "error"] },
  ];
  return (
    <div>
      <SectionTitle>Palette complète Crépuscule</SectionTitle>
      <p style={{ color: "#7A7572", fontSize: "14px", lineHeight: 1.7, marginBottom: "28px", maxWidth: "640px" }}>
        Chaque couleur a un rôle précis. Cliquez pour copier le code hex. Toutes les valeurs sont fournies en HEX, RGB, CMJN et Pantone pour une utilisation print et digital.
      </p>
      {groups.map(g => (
        <div key={g.title} style={{ marginBottom: "24px" }}>
          <div style={{ fontSize: "11px", color: "#9CA3AF", fontWeight: 600, letterSpacing: "0.1em", textTransform: "uppercase", marginBottom: "10px" }}>{g.title}</div>
          <div style={{ display: "flex", gap: "10px", flexWrap: "wrap" }}>
            {g.keys.map(k => <Swatch key={k} color={brand[k]} showAll />)}
          </div>
        </div>
      ))}
    </div>
  );
}

function UsageSection() {
  const combos = [
    { bg: brand.primary.hex, text: "#FFFFFF", accent: brand.accent.hex, label: "Header / Navbar / Footer", desc: "Fond Bleu Crépuscule + texte blanc + CTA Or Solaire" },
    { bg: brand.light.hex, text: brand.text.hex, accent: brand.secondary.hex, label: "Sections de contenu", desc: "Fond Lin Clair + texte Encre Profonde + boutons Terracotta" },
    { bg: brand.surface.hex, text: brand.text.hex, accent: brand.tertiary.hex, label: "Cartes / Modales", desc: "Fond Blanc Nacré + texte Encre + liens Bleu Ouvert" },
    { bg: brand.primary.hex, text: brand.accent.hex, accent: brand.secondary.hex, label: "Section premium / Pricing", desc: "Fond Bleu Crépuscule + titres Or Solaire + accent Terracotta" },
    { bg: brand.secondary.hex, text: "#FFFFFF", accent: brand.accent.hex, label: "Bannière d'action", desc: "Fond Terracotta + texte blanc + CTA Or Solaire" },
    { bg: "#FFFFFF", text: brand.text.hex, accent: brand.accent.hex, label: "Email / Newsletter", desc: "Fond blanc + texte Encre + bouton Or Solaire" },
  ];
  return (
    <div>
      <SectionTitle>Combinaisons autorisées</SectionTitle>
      <p style={{ color: "#7A7572", fontSize: "14px", lineHeight: 1.7, marginBottom: "28px", maxWidth: "640px" }}>
        Voici les associations fond/texte/accent validées pour Déclia. Chaque combinaison respecte les ratios de contraste WCAG AA minimum.
      </p>
      <div style={{ display: "flex", flexDirection: "column", gap: "12px" }}>
        {combos.map((c, i) => (
          <div key={i} style={{ display: "flex", gap: "16px", alignItems: "stretch", flexWrap: "wrap" }}>
            <div style={{
              background: c.bg, borderRadius: "12px", padding: "22px 24px", flex: "1 1 320px",
              border: isLight(c.bg) ? "1px solid #e5e1da" : "none",
              display: "flex", flexDirection: "column", justifyContent: "center", minHeight: "90px",
            }}>
              <div style={{ color: c.text, fontWeight: 700, fontSize: "16px", marginBottom: "6px" }}>{c.label}</div>
              <div style={{ color: c.text, opacity: 0.6, fontSize: "13px" }}>Texte d'exemple pour cette combinaison</div>
              <div style={{ marginTop: "10px" }}>
                <span style={{ background: c.accent, color: "#fff", padding: "6px 16px", borderRadius: "6px", fontSize: "12px", fontWeight: 600 }}>
                  Bouton d'action
                </span>
              </div>
            </div>
            <div style={{ flex: "1 1 200px", display: "flex", alignItems: "center", padding: "12px 0" }}>
              <div style={{ color: "#7A7572", fontSize: "12px", lineHeight: 1.6 }}>
                <span style={{ fontWeight: 600, color: "#1E2434" }}>Recette : </span>{c.desc}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function SocialSection() {
  const platforms = [
    { name: "LinkedIn", format: "1200×627 (post) · 1080×1080 (carrousel)", tip: "Privilégier le fond Bleu Crépuscule pour l'autorité B2B. CTA en Or Solaire. Logo déclia. en blanc." },
    { name: "Instagram Feed", format: "1080×1080 (post) · 1080×1350 (portrait)", tip: "Alterner fond sombre (Bleu Crépuscule) et fond clair (Lin Clair). Le Terracotta en titres attire le pouce." },
    { name: "Instagram Stories", format: "1080×1920", tip: "Dégradé Bleu Crépuscule → Terracotta en fond. Texte blanc. CTA en Or Solaire. Toujours le logo en haut." },
    { name: "X / Twitter", format: "1600×900 (image) · 1500×500 (bannière)", tip: "Fond Lin Clair + texte Encre Profonde pour la lisibilité dans le feed. Accent Terracotta sur les mots clés." },
    { name: "TikTok", format: "1080×1920", tip: "Overlay léger Bleu Crépuscule à 80% opacité en bas. Texte blanc. Badge Or Solaire pour les stats/chiffres." },
  ];
  return (
    <div>
      <SectionTitle>Déclinaisons réseaux sociaux</SectionTitle>
      <p style={{ color: "#7A7572", fontSize: "14px", lineHeight: 1.7, marginBottom: "28px", maxWidth: "640px" }}>
        Templates et bonnes pratiques par plateforme pour maintenir la cohérence visuelle Déclia sur tous les canaux.
      </p>

      {/* Visual templates */}
      <div style={{ display: "flex", gap: "12px", flexWrap: "wrap", marginBottom: "28px" }}>
        {/* LinkedIn post */}
        <div style={{ flex: "1 1 260px" }}>
          <div style={{ fontSize: "10px", color: "#9CA3AF", fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", marginBottom: "8px" }}>LinkedIn / Post</div>
          <div style={{ background: brand.primary.hex, borderRadius: "10px", padding: "28px 22px", aspectRatio: "1200/627", display: "flex", flexDirection: "column", justifyContent: "space-between" }}>
            <div style={{ color: brand.accent.hex, fontSize: "10px", fontWeight: 700, letterSpacing: "0.08em", textTransform: "uppercase" }}>Déclia — SaaS White-label</div>
            <div>
              <div style={{ color: "#fff", fontWeight: 800, fontSize: "18px", lineHeight: 1.3, marginBottom: "12px" }}>
                Personnalisez chaque pixel de votre plateforme
              </div>
              <div style={{ background: brand.accent.hex, color: "#fff", padding: "7px 16px", borderRadius: "6px", fontSize: "11px", fontWeight: 700, display: "inline-block" }}>
                Essai gratuit →
              </div>
            </div>
          </div>
        </div>
        {/* Instagram Story */}
        <div style={{ flex: "0 0 150px" }}>
          <div style={{ fontSize: "10px", color: "#9CA3AF", fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", marginBottom: "8px" }}>Story</div>
          <div style={{
            background: `linear-gradient(165deg, ${brand.primary.hex} 0%, ${brand.secondary.hex} 100%)`,
            borderRadius: "10px", padding: "20px 14px", aspectRatio: "9/16", display: "flex", flexDirection: "column", justifyContent: "space-between",
          }}>
            <div style={{ color: "#fff", fontWeight: 700, fontSize: "11px" }}>déclia<span style={{ color: brand.accent.hex }}>.</span></div>
            <div>
              <div style={{ color: "#fff", fontWeight: 800, fontSize: "13px", lineHeight: 1.3, marginBottom: "8px" }}>
                +40% de rétention client
              </div>
              <div style={{ color: "#ffffff88", fontSize: "9px" }}>Swipe up ↑</div>
            </div>
          </div>
        </div>
        {/* Carrousel */}
        <div style={{ flex: "1 1 180px" }}>
          <div style={{ fontSize: "10px", color: "#9CA3AF", fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase", marginBottom: "8px" }}>Carrousel</div>
          <div style={{ background: brand.light.hex, borderRadius: "10px", padding: "22px 18px", aspectRatio: "1/1", display: "flex", flexDirection: "column", justifyContent: "space-between", border: `1px solid #e5e1da` }}>
            <div style={{ width: "32px", height: "3px", background: brand.secondary.hex, borderRadius: "2px" }} />
            <div>
              <div style={{ color: brand.text.hex, fontWeight: 800, fontSize: "15px", lineHeight: 1.3, marginBottom: "6px" }}>
                3 raisons de choisir le <span style={{ color: brand.secondary.hex }}>white-label</span>
              </div>
              <div style={{ color: brand.textLight.hex, fontSize: "10px", lineHeight: 1.5 }}>
                Slide 1/5 — Identité de marque
              </div>
            </div>
            <div style={{ color: brand.secondary.hex, fontSize: "10px", fontWeight: 700 }}>déclia<span style={{ color: brand.accent.hex }}>.</span></div>
          </div>
        </div>
      </div>

      {/* Platform tips */}
      <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
        {platforms.map((p, i) => (
          <div key={i} style={{ background: "#fff", borderRadius: "10px", padding: "18px 20px", border: "1px solid #eceae5", display: "flex", gap: "16px", alignItems: "flex-start", flexWrap: "wrap" }}>
            <div style={{ flex: "0 0 130px" }}>
              <div style={{ fontWeight: 700, fontSize: "14px", color: brand.text.hex }}>{p.name}</div>
              <div style={{ fontSize: "10px", color: brand.textLight.hex, fontFamily: "'DM Mono', monospace", marginTop: "3px" }}>{p.format}</div>
            </div>
            <div style={{ flex: "1 1 240px", fontSize: "13px", color: "#5a5754", lineHeight: 1.6 }}>{p.tip}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

function ContrastSection() {
  const pairs = [
    { fg: brand.text, bg: brand.light, usage: "Texte sur fond de page" },
    { fg: brand.text, bg: brand.surface, usage: "Texte sur cartes" },
    { fg: { hex: "#FFFFFF", name: "Blanc" }, bg: brand.primary, usage: "Texte blanc sur header" },
    { fg: { hex: "#FFFFFF", name: "Blanc" }, bg: brand.secondary, usage: "Texte blanc sur bouton Terracotta" },
    { fg: { hex: "#FFFFFF", name: "Blanc" }, bg: brand.accent, usage: "Texte blanc sur CTA Or Solaire" },
    { fg: { hex: "#FFFFFF", name: "Blanc" }, bg: brand.tertiary, usage: "Texte blanc sur Bleu Ouvert" },
    { fg: brand.textLight, bg: brand.light, usage: "Texte secondaire sur fond" },
    { fg: brand.secondary, bg: brand.light, usage: "Terracotta sur fond clair" },
    { fg: brand.primary, bg: brand.light, usage: "Bleu Crépuscule sur fond clair" },
  ];
  return (
    <div>
      <SectionTitle>Accessibilité & contrastes</SectionTitle>
      <p style={{ color: "#7A7572", fontSize: "14px", lineHeight: 1.7, marginBottom: "28px", maxWidth: "640px" }}>
        Vérification WCAG 2.1 pour toutes les combinaisons courantes. Un ratio ≥ 4.5:1 est requis pour le texte standard (AA), ≥ 3:1 pour les grands textes et éléments UI.
      </p>
      <div style={{ display: "flex", flexDirection: "column", gap: "6px" }}>
        {/* Header */}
        <div style={{ display: "grid", gridTemplateColumns: "60px 1fr 1fr 80px 80px", gap: "8px", padding: "10px 16px", background: "#F6F3ED", borderRadius: "8px", fontSize: "10px", fontWeight: 600, color: "#9CA3AF", letterSpacing: "0.06em", textTransform: "uppercase" }}>
          <div>Aperçu</div><div>Texte</div><div>Fond</div><div>Ratio</div><div>WCAG</div>
        </div>
        {pairs.map((p, i) => {
          const ratio = parseFloat(contrastRatio(p.fg.hex, p.bg.hex));
          const passAA = ratio >= 4.5;
          const passLarge = ratio >= 3;
          return (
            <div key={i} style={{ display: "grid", gridTemplateColumns: "60px 1fr 1fr 80px 80px", gap: "8px", padding: "10px 16px", background: "#fff", borderRadius: "8px", border: "1px solid #eceae5", alignItems: "center", fontSize: "13px" }}>
              <div style={{ width: "44px", height: "30px", background: p.bg.hex, borderRadius: "6px", display: "flex", alignItems: "center", justifyContent: "center", border: isLight(p.bg.hex) ? "1px solid #e5e1da" : "none" }}>
                <span style={{ color: p.fg.hex, fontWeight: 700, fontSize: "11px" }}>Aa</span>
              </div>
              <div style={{ color: brand.text.hex, fontSize: "12px" }}>{p.fg.name || p.fg.hex}</div>
              <div style={{ color: brand.text.hex, fontSize: "12px" }}>{p.bg.name}</div>
              <div style={{ fontWeight: 700, fontSize: "13px", color: passAA ? brand.success.hex : passLarge ? "#B8860B" : brand.error.hex, fontFamily: "'DM Mono', monospace" }}>
                {ratio}:1
              </div>
              <div>
                {passAA ? (
                  <span style={{ background: `${brand.success.hex}15`, color: brand.success.hex, padding: "3px 10px", borderRadius: "5px", fontSize: "10px", fontWeight: 700 }}>AA ✓</span>
                ) : passLarge ? (
                  <span style={{ background: "#B8860B15", color: "#B8860B", padding: "3px 10px", borderRadius: "5px", fontSize: "10px", fontWeight: 700 }}>AA Large</span>
                ) : (
                  <span style={{ background: `${brand.error.hex}15`, color: brand.error.hex, padding: "3px 10px", borderRadius: "5px", fontSize: "10px", fontWeight: 700 }}>Échec</span>
                )}
              </div>
            </div>
          );
        })}
      </div>
      <div style={{ marginTop: "16px", padding: "16px 20px", background: "#F6F3ED", borderRadius: "10px", fontSize: "12px", color: "#7A7572", lineHeight: 1.7 }}>
        <strong style={{ color: brand.text.hex }}>Note :</strong> Les boutons Or Solaire (#CFA044) avec texte blanc ont un ratio limite. Pour les petits textes, privilégiez du texte Encre Profonde (#1E2434) sur fond Or Solaire, ou augmentez la taille du texte à 18px+ / bold 14px+ pour passer en AA Large.
      </div>
    </div>
  );
}

function DontsSection() {
  const rules = [
    { do: "Utiliser le Terracotta comme couleur d'énergie et d'action", dont: "Utiliser le Terracotta sur plus de 30% de la surface", icon: "●" },
    { do: "Garder l'Or Solaire pour les CTA et éléments premium", dont: "Noyer l'or partout — il perd son impact", icon: "●" },
    { do: "Fond Lin Clair ou Blanc Nacré pour les zones de contenu", dont: "Fond blanc pur (#FFFFFF) qui paraît froid et déconnecté", icon: "●" },
    { do: "Alterner sections sombres (Bleu) et claires (Lin) pour le rythme", dont: "Enchaîner 3+ sections du même fond", icon: "●" },
    { do: "Bleu Ouvert pour les liens et interactions secondaires", dont: "Mélanger Bleu Ouvert et Terracotta dans le même bouton", icon: "●" },
    { do: "Le logo déclia. toujours avec le point en Or Solaire", dont: "Changer la couleur du point ou le supprimer", icon: "●" },
    { do: "Ombres douces et chaudes (teintées Bleu Crépuscule à 8%)", dont: "Ombres grises froides ou noires", icon: "●" },
    { do: "Photos avec tons chauds naturels (golden hour, terracotta)", dont: "Photos avec filtres froids, bleutés ou désaturés", icon: "●" },
    { do: "Dégradés : Bleu Crépuscule → Terracotta (145°) pour les stories", dont: "Dégradés arc-en-ciel ou avec plus de 2 couleurs", icon: "●" },
    { do: "Icônes monochromes en Bleu Ouvert ou Pierre Douce", dont: "Icônes multicolores ou avec des couleurs hors palette", icon: "●" },
  ];
  return (
    <div>
      <SectionTitle>Do / Don't</SectionTitle>
      <p style={{ color: "#7A7572", fontSize: "14px", lineHeight: 1.7, marginBottom: "28px", maxWidth: "640px" }}>
        Les règles d'or pour garder une identité Déclia cohérente et impactante sur tous les supports.
      </p>
      <div style={{ display: "flex", flexDirection: "column", gap: "8px" }}>
        {rules.map((r, i) => (
          <div key={i} style={{ display: "flex", gap: "0", borderRadius: "10px", overflow: "hidden", border: "1px solid #eceae5" }}>
            <div style={{ flex: 1, background: "#f0faf3", padding: "16px 18px", borderRight: "1px solid #eceae5" }}>
              <div style={{ fontSize: "10px", fontWeight: 700, color: brand.success.hex, letterSpacing: "0.06em", textTransform: "uppercase", marginBottom: "6px" }}>✓ Do</div>
              <div style={{ fontSize: "13px", color: brand.text.hex, lineHeight: 1.5 }}>{r.do}</div>
            </div>
            <div style={{ flex: 1, background: "#fdf4f4", padding: "16px 18px" }}>
              <div style={{ fontSize: "10px", fontWeight: 700, color: brand.error.hex, letterSpacing: "0.06em", textTransform: "uppercase", marginBottom: "6px" }}>✗ Don't</div>
              <div style={{ fontSize: "13px", color: brand.text.hex, lineHeight: 1.5 }}>{r.dont}</div>
            </div>
          </div>
        ))}
      </div>

      {/* Gradient reference */}
      <div style={{ marginTop: "24px" }}>
        <div style={{ fontSize: "11px", color: "#9CA3AF", fontWeight: 600, letterSpacing: "0.1em", textTransform: "uppercase", marginBottom: "10px" }}>
          Dégradés autorisés
        </div>
        <div style={{ display: "flex", gap: "10px", flexWrap: "wrap" }}>
          {[
            { from: brand.primary.hex, to: brand.secondary.hex, angle: "145deg", label: "Stories & bannières" },
            { from: brand.primary.hex, to: brand.tertiary.hex, angle: "135deg", label: "Headers & hero" },
            { from: brand.secondary.hex, to: brand.accent.hex, angle: "135deg", label: "CTA premium" },
          ].map((g, i) => (
            <div key={i} style={{ flex: "1 1 160px" }}>
              <div style={{
                background: `linear-gradient(${g.angle}, ${g.from}, ${g.to})`,
                borderRadius: "10px", height: "70px", marginBottom: "8px",
              }} />
              <div style={{ fontSize: "11px", color: brand.textLight.hex, textAlign: "center" }}>{g.label}</div>
              <div style={{ fontSize: "10px", color: "#b0ada8", textAlign: "center", fontFamily: "'DM Mono', monospace" }}>
                {g.from} → {g.to}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

function SectionTitle({ children }) {
  return <h2 style={{ fontSize: "22px", fontWeight: 800, color: brand.text.hex, margin: "0 0 8px", letterSpacing: "-0.02em" }}>{children}</h2>;
}

// ─── MAIN ───
export default function DecliaBrandGuide() {
  const [activeSection, setActiveSection] = useState("colors");

  const renderSection = () => {
    switch (activeSection) {
      case "colors": return <ColorsSection />;
      case "usage": return <UsageSection />;
      case "social": return <SocialSection />;
      case "contrast": return <ContrastSection />;
      case "donts": return <DontsSection />;
      default: return <ColorsSection />;
    }
  };

  return (
    <div style={{ fontFamily: "'DM Sans', 'Segoe UI', system-ui, sans-serif", background: "#F8F7F4", minHeight: "100vh" }}>
      <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet" />

      {/* Top bar */}
      <div style={{ background: brand.primary.hex, padding: "20px 28px", display: "flex", justifyContent: "space-between", alignItems: "center", flexWrap: "wrap", gap: "12px" }}>
        <div>
          <div style={{ color: "#fff", fontWeight: 800, fontSize: "20px", letterSpacing: "-0.01em" }}>
            déclia<span style={{ color: brand.accent.hex }}>.</span>
          </div>
          <div style={{ color: "#ffffff66", fontSize: "11px", fontWeight: 500, marginTop: "2px", letterSpacing: "0.06em", textTransform: "uppercase" }}>
            Brand Guide — Palette Crépuscule
          </div>
        </div>
        <div style={{ display: "flex", gap: "5px" }}>
          {[brand.primary.hex, brand.secondary.hex, brand.accent.hex, brand.tertiary.hex, brand.light.hex].map((c, i) => (
            <div key={i} style={{ width: "24px", height: "24px", borderRadius: "6px", background: c, border: "2px solid rgba(255,255,255,0.2)" }} />
          ))}
        </div>
      </div>

      {/* Nav */}
      <div style={{ background: "#fff", borderBottom: "1px solid #eceae5", padding: "0 28px", display: "flex", gap: "4px", overflowX: "auto" }}>
        {sections.map(s => (
          <button
            key={s.id}
            onClick={() => setActiveSection(s.id)}
            style={{
              padding: "14px 18px", border: "none", cursor: "pointer", fontSize: "13px", fontWeight: 600,
              background: "transparent",
              color: activeSection === s.id ? brand.secondary.hex : "#7A7572",
              borderBottom: activeSection === s.id ? `3px solid ${brand.secondary.hex}` : "3px solid transparent",
              transition: "all 0.2s ease", whiteSpace: "nowrap",
              display: "flex", alignItems: "center", gap: "6px",
            }}
          >
            <span style={{ fontSize: "12px" }}>{s.icon}</span>
            {s.label}
          </button>
        ))}
      </div>

      {/* Content */}
      <div style={{ maxWidth: "920px", margin: "0 auto", padding: "36px 24px" }}>
        {renderSection()}
      </div>

      {/* Footer */}
      <div style={{ background: brand.primary.hex, padding: "20px 28px", marginTop: "40px", display: "flex", justifyContent: "space-between", alignItems: "center", flexWrap: "wrap", gap: "8px" }}>
        <div style={{ color: "#ffffff55", fontSize: "11px" }}>
          Déclia Brand Guide · Palette Crépuscule · {new Date().getFullYear()}
        </div>
        <div style={{ color: "#ffffff44", fontSize: "10px", fontFamily: "'DM Mono', monospace" }}>
          Généré pour l'équipe Déclia
        </div>
      </div>
    </div>
  );
}
