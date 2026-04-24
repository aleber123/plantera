import '../models/monthly_guide.dart';

/// Svenska odlingskalendern månad för månad. Innehållet är skrivet specifikt
/// för Plantera och är baserat på allmän odlingspraxis i Sverige — inte
/// copy-pastat från någon extern källa.
class MonthlyGuides {
  static const Map<int, MonthlyGuide> _byMonth = {
    1: MonthlyGuide(
      month: 1,
      headline: 'Januari – dags att starta inomhus',
      intro:
          'Även om snön ligger kvar finns det mycket att göra. Januari är månaden för förodling av växter med lång utvecklingstid och för experiment med vintersådd utomhus.',
      sections: [
        GuideSection(
          title: 'Förså inomhus',
          emoji: '🌱',
          intro:
              'Värmekrävande växter med lång mognadstid behöver starta tidigt. Ljuset är för svagt i fönstret – använd växtbelysning.',
          bullets: [
            'Chili',
            'Paprika',
            'Kronärtskocka',
            'Purjolök',
            'Jätteverbena',
            'Pelargon',
          ],
          tip:
              'Vissa frön behöver en köldperiod (stratifiering). Ställ ut fröerna ett par veckor innan du tar in dem igen.',
          affiliateBundle: 'grow_lights',
        ),
        GuideSection(
          title: 'Odla grönsaker inomhus',
          emoji: '🏠',
          intro:
              'Med växtbelysning kan du odla bladgrönt och kryddor året runt. Perfekt för färska smaker i vintermat.',
          bullets: [
            'Sallad',
            'Krasse',
            'Rädisor',
            'Busktomater',
            'Självbefruktande gurka',
            'Ärtskott och mungbönor',
          ],
          affiliateBundle: 'indoor_grow',
        ),
        GuideSection(
          title: 'Vinterså ute',
          emoji: '❄️',
          intro:
              'Morötter, dill och spenat kan sås direkt på frusen jord. När snön smälter väcker vårvärmen fröna naturligt.',
          bullets: [
            'Morot',
            'Dill',
            'Spenat',
            'Persilja',
            'Palsternacka',
          ],
          tip:
              'Skrapa bort snön, så fröna, täck med ett tunt lager jord och lägg tillbaka snön.',
          affiliateBundle: 'winter_sowing',
        ),
      ],
      chores: [
        'Gå igenom fröförrådet inför säsongen',
        'Beställ nya frökataloger',
        'Stratifiera frön som kräver köldperiod',
        'Rengör och sterilisera krukor från föregående år',
      ],
    ),
    2: MonthlyGuide(
      month: 2,
      headline: 'Februari – förodlingen tar fart',
      intro:
          'Dagarna blir ljusare och det är dags att förså fler långsvåra växter. Vintersådd fungerar utmärkt nu när kylan är stabil.',
      sections: [
        GuideSection(
          title: 'Förså inomhus',
          emoji: '🌱',
          intro:
              'Växter med lång utvecklingstid behöver starta senast nu. Ge extra ljus.',
          bullets: [
            'Chili och paprika',
            'Aubergine',
            'Physalis',
            'Kronärtskocka',
            'Stjälkselleri',
            'Timjan',
            'Purjolök',
            'Pelargon',
            'Heliotrop',
            'Jätteverbena',
          ],
          affiliateBundle: 'grow_lights',
        ),
        GuideSection(
          title: 'Förodla olika kålsorter',
          emoji: '🥬',
          intro:
              'Kålsorter tjänar på tidig start. Täck med insektsnät vid utplantering.',
          bullets: [
            'Grönkål',
            'Svartkål',
            'Blomkål',
            'Purpurkål',
            'Brysselkål',
          ],
          affiliateBundle: 'forsa_kit',
        ),
        GuideSection(
          title: 'Odla inomhus',
          emoji: '🏠',
          intro: 'Bladgrönt för vintersalladen.',
          bullets: [
            'Sallad',
            'Ärtskott',
            'Krasse',
            'Busktomater',
            'Malabarspenat',
          ],
          affiliateBundle: 'indoor_grow',
        ),
        GuideSection(
          title: 'Vinterså ute',
          emoji: '❄️',
          intro:
              'Sådder i plastlådor eller direkt på friland ger tåliga plantor och tidig skörd.',
          bullets: [
            'Morot',
            'Spenat',
            'Dill',
            'Svartrot',
            'Sallat',
            'Persilja',
            'Palsternacka',
            'Rotpersilja',
            'Haverrot',
          ],
          affiliateBundle: 'winter_sowing',
        ),
      ],
      chores: [
        'Så fler chili- och paprikasorter',
        'Starta vintersådd i plastlådor',
        'Ge befintliga förodlingar mer ljus',
      ],
    ),
    3: MonthlyGuide(
      month: 3,
      headline: 'Mars – våren smygstartar',
      intro:
          'Ljuset vänder och förodlingen kommer igång på riktigt. Tomater, majs och sommarblommor sätts nu i jorden inomhus.',
      sections: [
        GuideSection(
          title: 'Förså inomhus',
          emoji: '🍅',
          intro:
              'Tomater och tomatillo är lätta att få igång. Majs och potatis startar också nu.',
          bullets: [
            'Tomater (inklusive tomatillo)',
            'Sockermajs',
            'Sommarblommor (zinnia, rosenskära, blåklint)',
            'Luktärt',
          ],
          tip:
              'Tomatfröer gror vid 20–25°C. Omplantera i större kruka när plantan fått två äkta blad.',
          affiliateBundle: 'tomato_kit',
        ),
        GuideSection(
          title: 'Förgro potatis',
          emoji: '🥔',
          intro:
              'För tidig skörd – förgro sättpotatis ljust och svalt i 3–4 veckor.',
          bullets: [
            'Förstavärst sättpotatis (t.ex. Maria, Solist)',
            'Tidig potatis (t.ex. Amandine)',
            'Specialsorter (t.ex. Blå Kongo)',
          ],
          affiliateBundle: 'potato_kit',
        ),
        GuideSection(
          title: 'Så utomhus i pallkrage eller varmbänk',
          emoji: '🌾',
          intro:
              'Tåliga växter kan sås i pallkragar eller skyddat i växthus.',
          bullets: [
            'Vinterportlak',
            'Sallat',
            'Vintersallat',
            'Spenat',
            'Rucola',
          ],
          affiliateBundle: 'pallkrage',
        ),
        GuideSection(
          title: 'Väck upp vilande växter',
          emoji: '🌸',
          intro:
              'Dahliaknölar och pelargoner väcks till liv genom omplantering och ljus.',
          bullets: [
            'Dahlia',
            'Pelargon',
            'Begonia',
          ],
        ),
      ],
      chores: [
        'Beskär fruktträd medan de fortfarande är i vila',
        'Tvätta växthusets glas',
        'Ta bort vinterskydd från rosor när frosten släppt',
      ],
    ),
    4: MonthlyGuide(
      month: 4,
      headline: 'April – våren på riktigt',
      intro:
          'Nu börjar den riktiga förodlingssäsongen. De känsligaste växterna stannar inomhus, medan tåliga grönsaker kan sås direkt på friland.',
      sections: [
        GuideSection(
          title: 'Förså inomhus',
          emoji: '🌱',
          intro: 'De mest värmekrävande växterna behöver fortsatt inomhusstart.',
          bullets: [
            'Squash',
            'Pumpa',
            'Gurka (slutet av månaden)',
            'Melon',
            'Tomat',
            'Basilika',
            'Broccoli',
            'Blomkål',
            'Mangold',
            'Fänkål',
            'Majrova',
            'Brytbönor',
          ],
          affiliateBundle: 'forsa_kit',
        ),
        GuideSection(
          title: 'Sommarblommor inomhus',
          emoji: '🌸',
          intro: 'Ge sommarens blomsterprakt ett försprång.',
          bullets: [
            'Lejongap',
            'Murbinka',
            'Buskkrasse',
            'Sommarflox',
            'Zinnia',
            'Rosenskära',
            'Blåklint',
            'Solros',
            'Jungfrun i det gröna',
            'Blomstertobak',
          ],
          affiliateBundle: 'flower_seeds',
        ),
        GuideSection(
          title: 'Så utomhus',
          emoji: '🌾',
          intro:
              'När jorden är minst 5–6°C kan många tåliga växter sås direkt.',
          bullets: [
            'Spenat',
            'Rädisa',
            'Morötter',
            'Dill',
            'Romasallat',
            'Persilja',
            'Plocksallat',
            'Sockerärt',
            'Ettåriga sommarblommor',
          ],
          affiliateBundle: 'spring_outdoor',
        ),
      ],
      chores: [
        'Förbered odlingslandet med gödsel och mull',
        'Sätt upp bambupinnar för klängväxter',
        'Gödsla fruktträd och bärbuskar',
      ],
    ),
    5: MonthlyGuide(
      month: 5,
      headline: 'Maj – äntligen odlingssäsong',
      intro:
          'När tjälen släpper och frostrisken minskar är det dags för storsådd utomhus och utplantering av förodlade plantor.',
      sections: [
        GuideSection(
          title: 'Så direkt på friland',
          emoji: '🌱',
          intro:
              'Det mesta kan nu sås direkt. Ta hänsyn till din zon och frostnätter.',
          bullets: [
            'Morot (sommar- och vinter)',
            'Rödbeta och andra betor',
            'Spenat',
            'Piplök',
            'Ärter',
            'Bönor (efter sista frost)',
            'Sallat',
            'Sommarblommor',
          ],
          affiliateBundle: 'spring_outdoor',
        ),
        GuideSection(
          title: 'Sätt i jord',
          emoji: '🪴',
          intro: 'Sättlök och sättpotatis ger säkra skördar.',
          bullets: [
            'Gul och röd sättlök',
            'Sättpotatis',
            'Dahliaknölar (efter frostrisken)',
            'Purjolöksplantor',
          ],
          affiliateBundle: 'sattlok',
        ),
        GuideSection(
          title: 'Plantera ut förodlade plantor',
          emoji: '🌿',
          intro:
              'Härdiga plantor kan ut nu – avhärda alltid först i en vecka. Vänta med det mest värmekrävande.',
          bullets: [
            'Sallat och bladgrönt',
            'Kål',
            'Broccoli',
            'Tomater (i växthus)',
            'Luktärt',
          ],
          tip:
              'Avhärda plantorna genom att låta dem stå ute dagtid en vecka innan permanent utplantering.',
          affiliateBundle: 'fiberduk',
        ),
      ],
      chores: [
        'Sätt upp klängstöd till ärtor och tomater',
        'Fiberduk till nyplanterade rabatter',
        'Börja gallra tidiga sådder',
      ],
    ),
    6: MonthlyGuide(
      month: 6,
      headline: 'Juni – full fart i trädgården',
      intro:
          'Frostnätterna är över på de flesta håll. Nu kan även det mest värmekrävande planteras ut.',
      sections: [
        GuideSection(
          title: 'Så direkt på friland',
          emoji: '🌾',
          intro: 'Snabbväxande grödor ger sen sommarskörd.',
          bullets: [
            'Sommarmorötter',
            'Rädisor',
            'Rucola',
            'Spenat',
            'Sockerärtor',
            'Koriander',
            'Dill',
          ],
          affiliateBundle: 'spring_outdoor',
        ),
        GuideSection(
          title: 'Plantera ut värmekrävande plantor',
          emoji: '🌞',
          intro:
              'Nu är jorden varm nog för gurka, squash, pumpa, bönor och dahlia.',
          bullets: [
            'Gurka',
            'Squash och zucchini',
            'Pumpa',
            'Bönor',
            'Dahlia',
            'Basilika',
            'Isbergssallad',
          ],
          affiliateBundle: 'forsa_kit',
        ),
        GuideSection(
          title: 'Så blommor för pollinerare',
          emoji: '🐝',
          intro:
              'Blommor ökar skörden genom att locka bin, fjärilar och blomflugor.',
          bullets: [
            'Ringblomma',
            'Blåklint',
            'Honungsört',
            'Rosenskära',
          ],
          affiliateBundle: 'flower_seeds',
        ),
      ],
      chores: [
        'Kupa potatis',
        'Tjuva sidoskott på tomater',
        'Vattna rikligt i torrt väder',
        'Täckodla med gräsklipp',
      ],
    ),
    7: MonthlyGuide(
      month: 7,
      headline: 'Juli – skörd och nysådd',
      intro:
          'Sommaren är här. Tidiga skördar börjar komma in och nya sådder kan göras i tomma luckor.',
      sections: [
        GuideSection(
          title: 'Så på friland',
          emoji: '🌾',
          intro:
              'Snabbväxande grönsaker för sen skörd och luckor i landet.',
          bullets: [
            'Rucola',
            'Rädisor',
            'Snabbväxande rotfrukter',
            'Ärtor och bönor',
            'Asiatiska grönsaker',
            'Senapskål',
          ],
          affiliateBundle: 'spring_outdoor',
        ),
        GuideSection(
          title: 'Skörd börjar',
          emoji: '🥕',
          intro:
              'Bär, tidiga grönsaker och kryddor är klara. Skörda ofta för mer produktion.',
          bullets: [
            'Jordgubbar',
            'Hallon',
            'Vinbär',
            'Tidiga morötter',
            'Sallat',
            'Vitlök (när blasten lägger sig)',
            'Basilika och andra kryddor',
          ],
          affiliateBundle: 'harvest',
        ),
        GuideSection(
          title: 'Förökning',
          emoji: '🌿',
          intro: 'Ta revor av jordgubbar och sticklingar av favoritplantor.',
          bullets: [
            'Jordgubbsrevor',
            'Kryddsticklingar (timjan, rosmarin)',
            'Perenner genom delning',
          ],
        ),
      ],
      chores: [
        'Vattna morgon eller kväll',
        'Gödsla tomater, gurka och chili regelbundet',
        'Plocka blommor till buketter för fortsatt blomning',
        'Täckodla med gräsklipp mot uttorkning',
      ],
    ),
    8: MonthlyGuide(
      month: 8,
      headline: 'Augusti – skördens höjdpunkt',
      intro:
          'Äpplen, tomater, gurkor och kryddor strömmar in. Men det är inte för sent att så snabbväxande bladgrönt.',
      sections: [
        GuideSection(
          title: 'Så nytt',
          emoji: '🥬',
          intro:
              'Svalare väder gynnar bladgrönt. Rucola och sallad gror bättre nu.',
          bullets: [
            'Rucola',
            'Asiatiska grönsaker',
            'Sallad',
            'Vintersallat',
          ],
          affiliateBundle: 'spring_outdoor',
        ),
        GuideSection(
          title: 'Plantera perenner och buskar',
          emoji: '🌳',
          intro:
              'Ökande markfukt gynnar nyplantering. Barrträd och vintergröna växter etablerar sig bra nu.',
          bullets: [
            'Perenner',
            'Buskar',
            'Fruktträd',
            'Barrträd',
          ],
          affiliateBundle: 'perennials',
        ),
        GuideSection(
          title: 'Skörda och lagra',
          emoji: '🧺',
          intro:
              'Bygg upp vinterförrådet. Frys, sylta, safta, torka, fermentera.',
          bullets: [
            'Äpplen',
            'Tomater',
            'Gurkor',
            'Kryddor (toppa basilika, skörda nedifrån rosmarin)',
          ],
          tip:
              'Toppa tomatplantorna nu så plantan lägger energin på de tomater som redan finns.',
          affiliateBundle: 'harvest',
        ),
      ],
      chores: [
        'Samla fröer från överblommade blommor',
        'Ta in chili och paprika om nätterna blir kalla',
        'Börja gröngödsla tomma land',
      ],
    ),
    9: MonthlyGuide(
      month: 9,
      headline: 'September – skördens månad',
      intro:
          'Höstluft och färgsprakande löv. Säsongen knyts ihop – men det går fortfarande att plantera och skörda.',
      sections: [
        GuideSection(
          title: 'Så bladgrönt',
          emoji: '🥬',
          intro: 'Snabbväxande bladgrönt hinner ge skörd.',
          bullets: [
            'Pak choi',
            'Fältsallat',
            'Vintersallat',
            'Spenat',
            'Mikroblad',
            'Ärtskott',
          ],
          affiliateBundle: 'spring_outdoor',
        ),
        GuideSection(
          title: 'Plantera blomsterlökar',
          emoji: '🌷',
          intro:
              'Höstsätt lökväxter nu för vårens blomsterprakt. Gödsla vid planteringen.',
          bullets: [
            'Tulpaner',
            'Narcisser',
            'Allium',
            'Pärlhyacinter',
            'Krokus',
          ],
          affiliateBundle: 'autumn_bulbs',
        ),
        GuideSection(
          title: 'Skörda',
          emoji: '🍎',
          intro:
              'Det mesta ska in nu. Chili, paprika och tomater kan eftermogna inomhus.',
          bullets: [
            'Äpplen och päron',
            'Chili och paprika',
            'Squash och pumpa',
            'Tomatillo',
            'Sent mognande tomater',
          ],
          affiliateBundle: 'harvest',
        ),
      ],
      chores: [
        'Planera omflyttning av perenner',
        'Skörda fröer en torr dag',
        'Börja täckodla tomma odlingsland',
      ],
    ),
    10: MonthlyGuide(
      month: 10,
      headline: 'Oktober – plantering och höstsådd',
      intro:
          'Markfukten hjälper nyetablerade växter. Utmärkt tid för buskar, rosor, perenner och blomsterlökar.',
      sections: [
        GuideSection(
          title: 'Plantera blomsterlökar',
          emoji: '🌷',
          intro:
              'Få ner höstlökarna innan tjälen sätter in. Även krukor på balkongen.',
          bullets: [
            'Tulpaner',
            'Narcisser',
            'Allium',
            'Pärlhyacinter',
            'Krokus',
          ],
          affiliateBundle: 'autumn_bulbs',
        ),
        GuideSection(
          title: 'Höstså',
          emoji: '🌰',
          intro:
              'Vissa frön kräver köldperiod för att gro. Andra ligger i träda till våren.',
          bullets: [
            'Ramslök',
            'Salladslök',
            'Spenat',
            'Vintersallat',
            'Morot (sent)',
            'Palsternacka',
            'Persilja',
            'Dill',
            'Gräslök',
          ],
          affiliateBundle: 'winter_sowing',
        ),
        GuideSection(
          title: 'Tvååriga blommor för höstsådd',
          emoji: '🌸',
          intro: 'Bildar bladrosett nu och blommar år två.',
          bullets: [
            'Borstnejlika',
            'Mariaklocka',
            'Förgätmigej',
            'Blåklocka',
            'Prästkrage',
            'Pensé',
          ],
          affiliateBundle: 'flower_seeds',
        ),
        GuideSection(
          title: 'Plantera perenner, buskar och rosor',
          emoji: '🌹',
          intro: 'Markfukten ger plantorna en skonsam start.',
          bullets: [
            'Rosor',
            'Perenner',
            'Bärbuskar',
            'Fruktträd',
          ],
          affiliateBundle: 'perennials',
        ),
      ],
      chores: [
        'Plocka upp dahliaknölar för vinterförvaring',
        'Städa ur växthuset',
        'Klipp gräsmattan en sista gång',
        'Höstvattna rhododendron och barrträd',
      ],
    ),
    11: MonthlyGuide(
      month: 11,
      headline: 'November – vintersticklingar och höstsådd',
      intro:
          'Vädret varierar, men det finns alltid något att göra. Sticklingar, ympkvistar och vitlök sätts nu.',
      sections: [
        GuideSection(
          title: 'Föröka med vintersticklingar',
          emoji: '🌿',
          intro:
              'Ta kvistar från buskar och förvedade växter i vila. Sätts i jord eller vatten.',
          bullets: [
            'Forsythia',
            'Pil',
            'Kaprifol',
            'Fläder',
            'Ros',
            'Buddleja',
            'Krusbär',
            'Vinbär',
          ],
          tip:
              'Ta kvistar till vårens ympning av äppel- och päronträd. Förvara i plastpåse i kylen.',
          affiliateBundle: 'propagation',
        ),
        GuideSection(
          title: 'Sätt vitlök',
          emoji: '🧄',
          intro:
              'Klyftor ska i backen ett par veckor innan tjälen. Stora, friska utsädesklyftor ger störst skörd.',
          bullets: [
            'Höstvitlök',
            'Ramslök (om du hittar lökar)',
          ],
          affiliateBundle: 'sattlok',
        ),
        GuideSection(
          title: 'Höstså och vinterså',
          emoji: '❄️',
          intro:
              'När kylan är stabil kan du vinterså direkt i snön för tidig vårskörd.',
          bullets: [
            'Sommarmorot',
            'Palsternacka',
            'Havrerot',
            'Svartrot',
            'Spenat',
            'Dill',
            'Persilja',
            'Blåklint',
            'Riddarsporre',
            'Ringblomma',
          ],
          affiliateBundle: 'winter_sowing',
        ),
        GuideSection(
          title: 'Odla inomhus',
          emoji: '🏠',
          intro: 'Växtbelysning ger friska plantor i mörker.',
          bullets: [
            'Ärtskott',
            'Basilika',
            'Sallat',
            'Kruktomat',
            'Partenokarpa gurkor',
            'Groddar av rädisa, fänkål, broccoli',
          ],
          affiliateBundle: 'indoor_grow',
        ),
      ],
      chores: [
        'Skydda känsliga växter med granris eller växtduk',
        'Kupa rosor med sand eller barkmull',
        'Ta in redskap och utemöbler',
        'Driv upp amaryllis, tazetter och hyacinter till jul',
      ],
    ),
    12: MonthlyGuide(
      month: 12,
      headline: 'December – planera och experimentera',
      intro:
          'Lugnare tid i trädgården – men dags att summera året och starta nästa säsongs chili. Vintersådd pågår i stabil kyla.',
      sections: [
        GuideSection(
          title: 'Vinterså',
          emoji: '❄️',
          intro:
              'Så direkt på frusen jord. Tinad jord täcker fröna. Vårskörd redan i mars-april.',
          bullets: [
            'Sommarmorot',
            'Sallat',
            'Palsternacka',
            'Rucola',
            'Vinterportlak',
            'Rädisa',
            'Dill',
            'Svartrot',
            'Haverrot',
            'Persilja',
            'Spenat',
          ],
          affiliateBundle: 'winter_sowing',
        ),
        GuideSection(
          title: 'Sommarblommor för vintersådd',
          emoji: '🌺',
          intro: 'Blommor som behöver kylperiod (stratifiering).',
          bullets: [
            'Jätteverbena',
            'Ringblomma',
            'Sömntuta',
            'Zinnia',
            'Vallmo',
            'Rosenskära',
            'Solros',
            'Tagetes',
            'Blåklint',
          ],
          affiliateBundle: 'flower_seeds',
        ),
        GuideSection(
          title: 'Perenner för vintersådd',
          emoji: '🌿',
          intro: 'Perenner med köldkravsfrön.',
          bullets: [
            'Jättedaggkåpa',
            'Lavendel',
            'Stjärnflocka',
            'Salvia',
            'Anisisop',
            'Toppklocka',
          ],
          affiliateBundle: 'perennials',
        ),
        GuideSection(
          title: 'Förså chili och paprika',
          emoji: '🌶️',
          intro:
              'Lång utvecklingstid kräver tidig start. Behöver växtbelysning.',
          bullets: [
            'Chili (alla sorter)',
            'Paprika',
            'Sallat för senare utplantering i varmbänk',
          ],
          affiliateBundle: 'grow_lights',
        ),
      ],
      chores: [
        'Skaka av blöt snö från grenar',
        'Beskär vindruvor i vila',
        'Gör jularrangemang med amaryllis och tazetter',
        'Planera nästa års odling',
      ],
    ),
  };

  static MonthlyGuide forMonth(int month) => _byMonth[month]!;
  static List<MonthlyGuide> all() => _byMonth.values.toList();
}
