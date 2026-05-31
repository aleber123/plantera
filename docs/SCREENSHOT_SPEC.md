# Plantera — ASC Screenshot Spec (Spår B)

Spår B = "odlings-app för svensk villatomt". Screenshots ska sälja
**timing-säkerhet och frostvarning** — inte växt-igenkänning (det är
PicturedThis/Plantas spelplan).

## Format-krav

Apple kräver minst en av två iPhone-storlekar för v2.5.0:

- **6.9″ (iPhone 17 Pro Max-klass)** — 1290 × 2796 px, portrait
- **6.5″ (iPhone 11 Pro Max-klass)** — 1242 × 2688 px, portrait

Generera primärt i 6.9″. ASC nedskalar automatiskt för andra
device-storlekar om bara 6.9″ laddas upp.

PNG eller JPG, RGB, sRGB-profil. Max 8 MB/bild. Upp till 10 bilder
per locale — vi laddar upp 5.

## De 5 bilderna — order spelar roll (första 3 syns utan swipe)

### 1. Hero — värdesproppen i klartext

**Layout:**

```
┌────────────────────────────────┐
│                                │
│   Sluta gissa när              │ ← 48pt rubrik, AppTheme.ink
│   du ska så.                   │
│                                │
│   Plantera vet din zon,        │ ← 22pt body, grå.65
│   varnar för frost från SMHI,  │
│   påminner om varje växt.      │
│                                │
│   ┌─────────────────────┐      │
│   │  [skärmbild Att      │      │ ← 60% av höjden, lätt 8° tilt
│   │   göra-listan med    │      │   höger, drop-shadow
│   │   3 färgade tasks]   │      │
│   └─────────────────────┘      │
│                                │
└────────────────────────────────┘
bg: AppTheme.bgCream (#F5F5DC)
```

**Innehåll i den inbäddade skärmbilden:** "Att göra"-listan med 3
synliga rader:
- 💧 Vattna tomater (blå-accent)
- 🌡️ ❄️ Frostvarning: 2 grader inatt (frostBlue-accent, ikon synlig)
- 🌱 Direktså morötter (grön-accent)

**Varför denna ordning:** hooks är "sluta gissa" → konkret promise.
"Vet din zon" + "SMHI" är trust-signaler. Inbäddade skärmbilden visar
*hur* appen levererar löftet.

### 2. Frost-varning — den emotionella vinsten

**Layout:**

```
┌────────────────────────────────┐
│   ❄️                            │
│   Frostvarning från SMHI.      │ ← 44pt
│   I tid att täcka över.        │
│                                │
│   ┌─────────────────────┐      │
│   │ [climate_card.dart   │      │
│   │  med röd/blå frost-   │      │ ← visar TYDLIG frostvarning-banner
│   │  varning + 5-dagars   │      │   + 5-dagars prognos under
│   │  prognos]             │      │
│   └─────────────────────┘      │
│                                │
│   "Ingen panik kl 03 —          │ ← caption nederst, 18pt grå.65
│    appen säger till i tid."     │
└────────────────────────────────┘
bg: gradient frostBlue → bgCream (vertikal, top→bottom)
```

**Innehåll:** Klimatkortet med en aktiv frostvarning i toppen
("Frostvarning natt mot tisdag — minimum -2°C"). Tydlig snöflinge-ikon,
inte bara färg (color-blind-kompatibelt).

### 3. Att-göra-lista — vad användaren får varje dag

**Layout:**

```
┌────────────────────────────────┐
│   En morgon — inte 50 pingar.   │ ← 40pt
│                                │
│   ┌─────────────────────┐      │
│   │ [todo_screen.dart    │      │
│   │  med 5-6 tasks som   │      │
│   │  visar bredden:      │      │
│   │  - vattna            │      │
│   │  - skörda jordgubbar │      │
│   │  - klipp utlöpare    │      │
│   │  - direktså morot    │      │
│   │  - beskär äpple      │      │
│   │  - gödsla tomater    │      │
│   └─────────────────────┘      │
│                                │
│   Sortera bort gissningarna.    │ ← 18pt caption
└────────────────────────────────┘
bg: AppTheme.bgCream
```

**Innehåll:** Verklig todo-skärm med 5–6 olika TaskKind så användaren
ser bredden (vatten, skörd, beskärning, sådd, gödsling, omsorg).
Varje rad har sin emoji + färg-accent vänster — color-blind-säker.

### 4. Min trädgård — det longitudinella värdet

**Layout:**

```
┌────────────────────────────────┐
│   Skörda mer — år efter år.    │ ← 40pt
│                                │
│   ┌─────────────────────┐      │
│   │ [garden_stats_       │      │
│   │  screen.dart med:    │      │
│   │  - "12,4 kg skördat" │      │
│   │  - "≈ 870 kr"        │      │
│   │  - topp 3 arter      │      │
│   │  - års-trend-graf]   │      │
│   └─────────────────────┘      │
│                                │
│   Statistik som faktiskt        │ ← 18pt
│   säger något om din säsong.    │
└────────────────────────────────┘
bg: AppTheme.bgCream
```

**Innehåll:** Stats-skärm med realistiska siffror (12,4 kg, 870 kr).
Detta är Premium-värdet — visa det innan paywall så user vet vad de
köper.

### 5. Multi-trädgård — för power-users

**Layout:**

```
┌────────────────────────────────┐
│   Balkong, lott, landställe —   │ ← 38pt
│   alla i samma app.            │
│                                │
│   ┌─────────────────────┐      │
│   │ [gardens_screen.dart │      │
│   │  med 3 trädgårdar:   │      │
│   │  🏡 Villatomten      │      │
│   │  🌿 Kolonilott 47    │      │
│   │  🏖️ Landstället      │      │
│   │  Var och en med      │      │
│   │  antal växter + zon] │      │
│   └─────────────────────┘      │
│                                │
│   Byt mellan dem med ett tap.   │
└────────────────────────────────┘
bg: AppTheme.bgCream
```

**Innehåll:** Gardens-listan med 3 trädgårdar, var och en med distinkt
emoji + namn + plant-count + zon. Säljer Premium implicit (multi-garden
är gratis nu, men den här typen av user är den som konverterar).

## Lokalisera screenshots?

**Just nu: bara sv-screenshots.** Per Sverige först-strategi laddar vi
upp till sv (Swedish (Sweden)) endast. en-US-screenshots tar vi i v2.6
om/när vi rullar ut globalt.

ASC: Plantera-listan i App Store Connect har redan 10 locales
metadata-mässigt, men för screenshots behöver vi bara fylla i sv-data.
För andra länder visas inga screenshots = de faller tillbaka på
en-US-versionen, men beskrivningen finns ändå på rätt språk.

## Produktion

**Snabbaste vägen** för att skapa bilderna:

1. Kör appen i iOS-simulator (iPhone 17 Pro Max preset) med svensk
   locale.
2. Seeda en realistisk demo-databas (3 trädgårdar, 15-20 plantor,
   senaste säsongens skördedata, en aktiv frostvarning).
3. Skärmdumpa varje skärm — sparas automatiskt i rätt 6.9″-pixlar.
4. Använd Figma eller Sketch för att lägga skärmbilderna in i
   ovanstående layouts med rubrik + caption.
5. Exportera 5 × PNG @ 1290×2796 px.
6. Ladda upp via ASC → App Store-tab → Screenshots → 6.9″ Display.

**Demo-data-checklist innan screenshot 1:** den första bilden måste
visa en frostvarning — sätt en fake nattprognos på 2°C i
weather_service-mockdata för att trigga frost-task. Annars är det inte
trovärdigt att SMHI-frost faktiskt syns.

## Versions-spårning

| version | hjältesyfte                          | uppdaterad |
|---------|---------------------------------------|-----------|
| 2.5.0   | Spår B-pivot — odlings-värdesprop     | 2026-05-31|
| 2.4.0   | (gamla) Globalisering — USDA-zoner    | 2026-04-? |
| ≤ 2.3   | (gamla) Generisk "trädgårdskompis"    | —         |
