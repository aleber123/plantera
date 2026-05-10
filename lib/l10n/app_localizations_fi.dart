// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appName => 'Plantera';

  @override
  String get appSubtitle => 'Digitaalinen puutarhakaverisi';

  @override
  String get tabHome => 'Koti';

  @override
  String get tabCalendar => 'Kalenteri';

  @override
  String get tabPlants => 'Kasvit';

  @override
  String get tabMyGarden => 'Omat kasvit';

  @override
  String get tabSettings => 'Asetukset';

  @override
  String get tabOverview => 'Yleiskatsaus';

  @override
  String get tabMyPlant => 'Oma kasvi';

  @override
  String get tabCare => 'Hoito';

  @override
  String get homeWelcomeTitle => 'Aloitetaan ensimmäisestä kasvistasi';

  @override
  String get homeWelcomeBody =>
      'Selaa kasvitietokantaa ja paina + sen päällä, mitä viljelet — seuraamme kasvua kylvöstä satoon.';

  @override
  String get homeWelcomeCta => 'Selaa kasveja';

  @override
  String get gardenOverviewTitle => 'Lähin sato';

  @override
  String get gardenSeeAll => 'Näytä kaikki';

  @override
  String get gardenStatTotal => 'Puutarhassa';

  @override
  String get gardenStatHarvestSoon => 'Pian satoa';

  @override
  String get gardenStatReadyNow => 'Valmis nyt';

  @override
  String gardenMore(Object count) {
    return '+$count lisää';
  }

  @override
  String get dailyInsightsTitle => 'Tänään puutarhassa';

  @override
  String get dailyInsightsAllGood =>
      'Kaikki hallinnassa. Ei mitään kiireellistä – nauti puutarhastasi.';

  @override
  String get upcomingCareTitle => 'Tulevat hoitotoimenpiteet';

  @override
  String get upcomingCareSubtitle =>
      'Tehtävät tälle ja seuraavalle kuukaudelle.';

  @override
  String seasonPlannerTitle(Object year) {
    return 'Kauteni $year';
  }

  @override
  String get seasonPlannerSubtitle =>
      'Mitä haluat kasvattaa tänä vuonna. Ilmoitamme, kun on kylvön aika.';

  @override
  String seasonPlannerEmptyTitle(Object year) {
    return 'Suunnittele kausi $year';
  }

  @override
  String get seasonPlannerEmptyBody =>
      'Mitä haluat kasvattaa tänä vuonna? Muistutamme, kun on kylvön aika.';

  @override
  String get seasonPlannerEmptyCta => 'Valitse';

  @override
  String get seasonPlannerAddCta => 'Lisää kasvi';

  @override
  String seasonPlannerCount(Object count) {
    return '$count kpl';
  }

  @override
  String get seasonRowSowNow => 'Kylvä nyt';

  @override
  String seasonRowDaysAway(Object days) {
    return '$days päivän päästä';
  }

  @override
  String get seasonRowInSeason => 'Kauden aikana';

  @override
  String get weatherUnavailable => 'Sää ei saatavilla';

  @override
  String get weatherSetLocation => 'Aseta sijaintisi asetuksissa';

  @override
  String get dryPeriodTitle => 'Kuivuusjakso meneillään';

  @override
  String get frostCardTitle => '❄️ Suojaa pakkaselta';

  @override
  String get premiumTeaserTitle => 'Plantera Premium';

  @override
  String get premiumTeaserBody => 'Rajaton puutarha ja ei mainoksia';

  @override
  String get calendarTitle => 'Istutuskalenteri';

  @override
  String get calendarMonthGuide => 'Kuukauden opas';

  @override
  String calendarTaskCount(Object count) {
    return '$count tehtävää';
  }

  @override
  String get calendarPhasePresow => 'ESIKYLVÖ SISÄLLÄ';

  @override
  String get calendarPhaseDirectsow => 'SUORAKYLVÖ ULOS';

  @override
  String get calendarPhasePlantout => 'ISTUTA ULOS';

  @override
  String get calendarPhaseHarvest => 'SATO';

  @override
  String calendarPhaseCount(Object count) {
    return '$count kasvia';
  }

  @override
  String calendarEmptyTitle(Object month) {
    return 'Ei kylvettävää tai korjattavaa kuussa $month';
  }

  @override
  String get calendarEmptyBody =>
      'Käytä kuukausi suunnitteluun – tilaa siemeniä, suunnittele penkkejä tai lue kuukauden opas.';

  @override
  String get myGardenTitle => 'Omat kasvit';

  @override
  String get myGardenSearchHint => 'Etsi kasvi tai sijainti';

  @override
  String get myGardenFilterAll => 'Kaikki';

  @override
  String get myGardenGroupByStatus => 'Gruppera efter status';

  @override
  String get myGardenGroupByLocation => 'Gruppera efter plats';

  @override
  String get myGardenGroupByCategory => 'Gruppera efter kategori';

  @override
  String myGardenShowingCount(Object shown, Object total) {
    return 'Visar $shown av $total';
  }

  @override
  String get myGardenEmptyTitle => 'Puutarhasi on tyhjä';

  @override
  String get myGardenEmptyBody =>
      'Lisää kasveja tietokannasta rakentaaksesi puutarhasi.';

  @override
  String get myGardenEmptyCta => 'Selaa kasvitietokantaa';

  @override
  String get myGardenAddPlant => 'Lisää kasvi';

  @override
  String get myGardenNoResults => 'Inga växter matchar';

  @override
  String get myGardenNoResultsBody =>
      'Pröva en annan sökning eller rensa filtren.';

  @override
  String get myGardenWateredNow => 'Kasteltu juuri';

  @override
  String get myGardenWateredToday => 'Kasteltu tänään';

  @override
  String get myGardenWateredYesterday => 'Kasteltu eilen';

  @override
  String get plantDatabaseTitle => 'Växtdatabas';

  @override
  String get plantDatabaseSearchHint => 'Sök växt';

  @override
  String get plantCategoryAll => 'Alla';

  @override
  String get addPlantNow => 'Lisää puutarhaan nyt';

  @override
  String get addPlantNowBody =>
      'Olet kylvänyt tai istuttanut — seuraamme tästä päivästä';

  @override
  String get addPlantSeason => 'Lisää kylvölistalle';

  @override
  String get addPlantSeasonBody =>
      'Suunnittelet kasvattamista — ilmoitamme kun on kylvön aika';

  @override
  String get addPlantRemoveSeason => 'Ta bort från såningslistan';

  @override
  String get addPlantRemoveSeasonBody =>
      'Vi slutar påminna om sånings-fönstret';

  @override
  String addedToGardenTitle(Object plant) {
    return '$plant on puutarhassasi';
  }

  @override
  String get addedToGardenBodyPlain =>
      'Seuraamme tästä päivästä ja muistutamme kastelusta ja sadosta.';

  @override
  String addedToGardenBodyScheduled(Object list) {
    return 'Vi följer den från idag. Notiser inkommande för: $list.';
  }

  @override
  String get addedToGardenCta => 'Vie minut puutarhaan';

  @override
  String get phasePickerTitleNew => 'Var är du i processen?';

  @override
  String get phasePickerTitleEdit => 'Ändra status';

  @override
  String get phaseShowSimple => 'Visa enklare alternativ';

  @override
  String get phaseShowMore => 'Fler alternativ (för den vana odlaren)';

  @override
  String get phaseSimplePlanned => 'Suunnittelen kasvattamista';

  @override
  String get phaseSimplePlannedBody =>
      'Bara på listan — vi påminner när säsongen startar.';

  @override
  String get phaseSimpleGrowing => 'Kasvaa parhaillaan';

  @override
  String get phaseSimpleGrowingBody =>
      'Plantorna är på gång. Vi följer dem fram till skörd.';

  @override
  String get phaseSimpleHarvested => 'Sato korjattu';

  @override
  String get phaseSimpleHarvestedBody =>
      'Säsongen är klar för den här plantan.';

  @override
  String get perennialEstablishedTitle => 'Mistä lähtien sinulla on se?';

  @override
  String get perennialEstablishedBody =>
      'Ei tarvitse olla tarkka – käytämme vain vuotta.';

  @override
  String perennialThisYear(Object year) {
    return 'I år ($year)';
  }

  @override
  String perennialLastYear(Object year) {
    return 'Förra året ($year)';
  }

  @override
  String perennialTwoYearsAgo(Object year) {
    return 'Två år sedan ($year)';
  }

  @override
  String get perennialEarlier => 'Tidigare (några år sedan)';

  @override
  String get statusPlanning => 'Suunnittelee';

  @override
  String get statusGrowingIndoors => 'Esikasvattaa sisällä';

  @override
  String get statusDirectSown => 'Suorakylvetty ulos';

  @override
  String get statusHardening => 'Karaisee';

  @override
  String get statusOutdoors => 'Ulkona';

  @override
  String get statusReadyToHarvest => 'Valmis korjattavaksi';

  @override
  String get statusHarvested => 'Korjattu';

  @override
  String get statusDormant => 'Lepotila';

  @override
  String get sowingIndoors => 'Inomhus';

  @override
  String get sowingDirect => 'Direkt';

  @override
  String get sowingPlanta => 'Planta';

  @override
  String get sunFull => 'Täysi aurinko';

  @override
  String get sunPartial => 'Puolivarjo';

  @override
  String get sunShade => 'Varjo';

  @override
  String get waterSparse => 'Säästeliäs';

  @override
  String get waterRegular => 'Säännöllinen';

  @override
  String get waterAbundant => 'Runsas';

  @override
  String get fertilizerLow => 'Matala';

  @override
  String get fertilizerMedium => 'Keskitaso';

  @override
  String get fertilizerHigh => 'Korkea';

  @override
  String get lifecycleAnnual => 'Yksivuotinen';

  @override
  String get lifecycleBiennial => 'Kaksivuotinen';

  @override
  String get lifecyclePerennial => 'Monivuotinen';

  @override
  String get lifecycleTree => 'Puu';

  @override
  String get lifecycleShrub => 'Pensas';

  @override
  String get categoryVegetables => 'Vihannekset';

  @override
  String get categoryHerbs => 'Yrtit & mausteet';

  @override
  String get categoryFlowers => 'Kukat';

  @override
  String get categoryBerries => 'Marjat';

  @override
  String get categoryFruitTrees => 'Hedelmäpuut';

  @override
  String get categoryOther => 'Muut';

  @override
  String get wateredNow => 'Kasteltu';

  @override
  String get wateredConfirmation => 'Kasteltu ✓';

  @override
  String get notWateredYet => 'Inte vattnad än';

  @override
  String get wateredJustNow => 'Nyss vattnad';

  @override
  String wateredDaysAgo(Object days) {
    return 'Vattnad för $days dagar sedan';
  }

  @override
  String wateredWeeksAgo(Object weeks) {
    return 'Vattnad för $weeks veckor sedan';
  }

  @override
  String get journalTitle => 'Dagbok';

  @override
  String journalCount(Object count) {
    return '$count';
  }

  @override
  String get journalAdd => 'Lägg till';

  @override
  String get journalEmpty =>
      'Inga inlägg ännu — börja dokumentera tillväxten med foton och korta anteckningar.';

  @override
  String get journalNoteTitle => 'Anteckning';

  @override
  String get journalNoteBody =>
      'Vad hände idag? Bladlöss, första blomman, beskärning…';

  @override
  String get journalNoteHint => 'Skriv en kort anteckning…';

  @override
  String get journalSave => 'Spara';

  @override
  String get journalDeletePhoto => 'Ta bort foto?';

  @override
  String get journalDeletePhotoBody => 'Bilden raderas från enheten.';

  @override
  String get journalDeleteNote => 'Ta bort anteckning?';

  @override
  String get journalDeleteNoteBody => 'Anteckningen försvinner.';

  @override
  String get journalManage => 'Hantera inlägg';

  @override
  String get actionTakePhoto => 'Ta foto';

  @override
  String get actionPickFromLibrary => 'Välj från bibliotek';

  @override
  String get actionWriteNote => 'Skriv anteckning';

  @override
  String get harvestTitle => 'Sato';

  @override
  String get harvestLog => 'Kirjaa sato';

  @override
  String get harvestEmpty =>
      'Logga vad du skördar så bygger appen statistik år för år.';

  @override
  String harvestTotalLabel(Object amount, Object unit) {
    return 'Total: $amount $unit';
  }

  @override
  String harvestEstimatedSek(Object amount) {
    return '~$amount kr';
  }

  @override
  String get nextStepBecomeIndoor => 'Jag har förodlat inomhus';

  @override
  String get nextStepBecomeDirect => 'Jag har direktsått';

  @override
  String get nextStepBecomePlanted => 'Jag har utplanterat';

  @override
  String get nextStepHardenedToPlanted => 'Plantorna är utplanterade';

  @override
  String get nextStepReadyForHarvest => 'Klar för skörd';

  @override
  String get nextStepHarvested => 'Skördad';

  @override
  String get secondaryChangeStatus => 'Ändra status';

  @override
  String get secondaryRemove => 'Ta bort';

  @override
  String get secondaryRemoveConfirmTitle => 'Ta bort från trädgården?';

  @override
  String secondaryRemoveConfirmBody(Object plant) {
    return '$plant och alla påminnelser tas bort. Detta kan inte ångras.';
  }

  @override
  String get buttonCancel => 'Peruuta';

  @override
  String get buttonRemove => 'Poista';

  @override
  String get buttonSave => 'Tallenna';

  @override
  String get buttonNext => 'Seuraava';

  @override
  String get buttonStart => 'Aloita';

  @override
  String get buttonSkip => 'Ohita';

  @override
  String get locationLabel => 'Plats';

  @override
  String get locationAdd => 'Lägg till plats';

  @override
  String get locationPickerTitle => 'Var står den?';

  @override
  String get locationPickerBody =>
      'T.ex. \"norra rabatten\", \"växthuset\", \"balkongen\".';

  @override
  String get locationReuse => 'Använd igen';

  @override
  String get settingsTitle => 'Asetukset';

  @override
  String get settingsPremiumActive => 'Premium aktiivinen';

  @override
  String get settingsPremiumUpgrade => 'Päivitä Premiumiin';

  @override
  String get settingsPremiumUnlock => 'Lås upp alla funktioner';

  @override
  String get settingsMyGardens => 'Omat puutarhat';

  @override
  String settingsMyGardensSubtitle(Object emoji, Object name) {
    return 'Aktiv: $emoji $name';
  }

  @override
  String get settingsMyGardensEmpty => 'Lägg till din första trädgård';

  @override
  String get settingsNotifications => 'Muistutukset';

  @override
  String get settingsNotificationsBody => 'Frostvarningar och planteringstider';

  @override
  String get settingsMorningHour => 'Morgon-tid för påminnelser';

  @override
  String settingsMorningHourBody(Object hour) {
    return 'Trädgårdsmorgon-pingar fyrar kl $hour:00';
  }

  @override
  String get settingsLargeText => 'Stor text';

  @override
  String get settingsLargeTextBody => 'Lite större text i hela appen';

  @override
  String get settingsSimpleStatus => 'Enkel status';

  @override
  String get settingsSimpleStatusBody =>
      'Visa endast 3 huvudtillstånd (planerar / växer / skördad). Stäng av för fullständig livscykel.';

  @override
  String get settingsPestLibrary => 'Skadedjur & sjukdomar';

  @override
  String get settingsPestLibraryBody => 'Bibliotek över vanliga problem';

  @override
  String get settingsIntro => 'Visa introduktion';

  @override
  String get settingsIntroBody =>
      'Snabbgenomgång av Pluss-knappen, säsongsplaneraren och hur appen jobbar';

  @override
  String get settingsBackup => 'Säkerhetskopia';

  @override
  String get settingsBackupBody =>
      'Exportera trädgården och skörden – spara på iCloud Drive eller mejla till dig själv';

  @override
  String get settingsRestorePurchases => 'Återställ köp';

  @override
  String get settingsPrivacyPolicy => 'Integritetspolicy';

  @override
  String get settingsTerms => 'Användarvillkor (EULA)';

  @override
  String get settingsSupport => 'Tuki';

  @override
  String get settingsFeedback => 'Lähetä palautetta';

  @override
  String get settingsFeedbackBody =>
      'Buggar, funktionsönskemål eller bara ett vänligt hej';

  @override
  String get gardensTitle => 'Mina trädgårdar';

  @override
  String get gardensActive => 'AKTIIVINEN';

  @override
  String get gardensAddNew => 'Lisää uusi puutarha';

  @override
  String get gardensEdit => 'Redigera';

  @override
  String get gardensNoLocation => 'Ingen plats';

  @override
  String gardensPlantCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count växter',
      one: '1 växt',
    );
    return '$_temp0';
  }

  @override
  String get gardensSwitcherTitle => 'Byt trädgård';

  @override
  String get gardensManage => 'Hantera trädgårdar';

  @override
  String gardensZoneLine(Object zone) {
    return 'Zon $zone';
  }

  @override
  String get gardensNewTitle => 'Ny trädgård';

  @override
  String gardensEditTitle(Object name) {
    return 'Redigera $name';
  }

  @override
  String get gardensNamePlaceholder =>
      'Kolonilotten, Balkongen, Sommarstället…';

  @override
  String get gardensCityLabel => 'Stad / närmsta ort';

  @override
  String get gardensCreateButton => 'Skapa trädgård';

  @override
  String get gardensSaveButton => 'Spara';

  @override
  String get gardensFooterHint =>
      'Varje trädgård har egen zon, växtlista och väder. Byt aktiv trädgård genom att trycka på den i listan – allt anpassas direkt.';

  @override
  String gardensDeleteTitle(Object name) {
    return 'Ta bort $name?';
  }

  @override
  String get gardensDeletePlainBody => 'Trädgården tas bort.';

  @override
  String gardensDeleteWithPlantsBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count växter',
      one: '1 växt',
    );
    return '$_temp0 flyttas till din standard-trädgård. Trädgården tas bort.';
  }

  @override
  String get introPage1Title => 'Lisää kasveja, joita kasvatat';

  @override
  String get introPage1Body =>
      'Tryck + på en växt för att lägga till den i din trädgård. Vi följer den från sådd till skörd och påminner när det är dags att vattna, beskära eller plantera om.';

  @override
  String get introPage1Hint =>
      'Hittar du växten? Använd \"Växter\"-fliken i botten.';

  @override
  String get introPage2Title => 'Suunnittele kausi';

  @override
  String get introPage2Body =>
      'Tryck på bokmärket för att lägga växten på din säsongs-lista. Du får en notis i februari/mars när det är dags att börja förodla, och i april när det är dags att direktså.';

  @override
  String get introPage2Hint => 'Säsongs-listan ser du på startsidan.';

  @override
  String get introPage3Title => 'Pidä puutarha hallussa';

  @override
  String get introPage3Body =>
      'Hem-sidan visar väder, torrperioder och vad du ska göra denna månad. På \"Min trädgård\"-fliken kan du se årets statistik, växtföljd och uppskattat värde av din skörd.';

  @override
  String get introPage3Hint =>
      'Skadedjur & sjukdomar finns i Inställningar när du behöver dem.';

  @override
  String get pestLibraryTitle => 'Tuholaiset & sairaudet';

  @override
  String get pestLibrarySearchHint => 'Sök efter symptom eller växt';

  @override
  String get pestLibraryFilterPests => 'Skadedjur';

  @override
  String get pestLibraryFilterDiseases => 'Sjukdomar';

  @override
  String get pestLibraryFilterDamage => 'Skada';

  @override
  String get pestLibraryNoMatch =>
      'Inget matchade. Prova med ett symptom som \"fläckar\" eller \"hål\".';

  @override
  String get pestSectionMild => 'Mild åtgärd';

  @override
  String get pestSectionStrong => 'Effektiv åtgärd';

  @override
  String get pestSectionPrevent => 'Förebygg';

  @override
  String get pestAffects => 'Drabbar';

  @override
  String statsTitle(Object year) {
    return 'Min trädgård $year';
  }

  @override
  String statsHero1(Object sek) {
    return 'Du har odlat fram ungefär $sek kr i mat';
  }

  @override
  String statsHero2(Object count) {
    return 'Du har $count växter på gång';
  }

  @override
  String get statsHeroEmpty => 'Säsongen väntar';

  @override
  String get statsTilePlants => 'Växter';

  @override
  String get statsTileSpecies => 'Olika arter';

  @override
  String get statsTileHarvested => 'Skördade';

  @override
  String get statsHarvestPanelTitle => 'Skörd hittills i år';

  @override
  String statsValueLine(Object sek) {
    return 'Estimerat värde: ~$sek kr';
  }

  @override
  String get statsValueDisclaimer =>
      'Baserat på ungefärliga svenska butikspriser per kategori. Inkluderar inte arbetstid eller frökostnader.';

  @override
  String get statsTopPanelTitle => 'Årets bästa avkastning';

  @override
  String get statsLocationPanelTitle => 'Var i trädgården';

  @override
  String get statsRotationPanelTitle => 'Växtföljd';

  @override
  String get statsRotationBody =>
      'Vad som odlats var, per år. Repetitioner markeras.';

  @override
  String get statsReflectionTitle => 'Reflektion';

  @override
  String get statsEmptyTitle => 'Säsongen har inte startat än';

  @override
  String get statsEmptyBody =>
      'Lägg till växter och registrera skördar – så fyller vi den här sidan med årets resultat.';

  @override
  String get tabTodo => 'Tehtävät';

  @override
  String get todoSectionToday => 'TÄNÄÄN';

  @override
  String get todoSectionWeek => 'TÄLLÄ VIIKOLLA';

  @override
  String get todoSectionMonth => 'TÄSSÄ KUUSSA';

  @override
  String get todoSectionDoneToday => 'VALMIS TÄNÄÄN ✓';

  @override
  String get todoStatToday => 'tänään';

  @override
  String get todoStatWeek => 'viikossa';

  @override
  String get todoStatDone => 'valmis';

  @override
  String get todoEmptyTitle => 'Kaikki hallinnassa';

  @override
  String get todoEmptyBody =>
      'Ei mitään kiireellistä. Lisää kasveja saadaksesi päivittäisiä tehtäviä.';

  @override
  String get todoSwipeDone => 'Valmis';

  @override
  String get todoSwipeSnooze => 'Lykkää';

  @override
  String get progressReadyToHarvest => 'Valmis korjattavaksi';

  @override
  String get progressHarvestNow => 'Korjaa nyt';

  @override
  String progressDaysLeft(Object days) {
    return '$days päivää jäljellä';
  }

  @override
  String progressApproxDaysLeft(Object days) {
    return '~$days päivää jäljellä';
  }

  @override
  String get climateCardTitle => 'Ilmasto viimeiset 14 päivää';

  @override
  String get climateStatAvg => 'Keskim. vrk';

  @override
  String get climateStatMinMax => 'Min/max';

  @override
  String get climateStatGdd => 'GDD';

  @override
  String get climateInterpretWaking => 'Puutarha herää.';

  @override
  String get climateInterpretEarly =>
      'Hyvin varhainen kausi – vain kylmänkestävät (sipuli, herne, salaatti).';

  @override
  String get climateInterpretSpring =>
      'Kevätkausi – suorakylvökset juurtuvat, lämpöä vaativien on odotettava.';

  @override
  String get climateInterpretMidSpring =>
      'Keskikevät – tomaatti ja paprika ulos harsoon tai kasvihuoneeseen.';

  @override
  String get climateInterpretFullGrowth =>
      'Täysi kasvu – kaikki kypsyy nopeasti, kastele ja lannoita.';

  @override
  String get climateInterpretHot =>
      'Kuuma jakso – varo nuorten taimien kastelua.';

  @override
  String get climateTeaserTitle => 'Ilmastokortti (Premium)';

  @override
  String get climateTeaserBody =>
      'Keski-vuorokausilämpötila + Growing Degree Days kylvön ja sadon ajoitukseen.';

  @override
  String get weatherSetLocationHint => 'Aseta sijainti asetuksissa';

  @override
  String weatherFrostWarning(String date, String temp) {
    return 'Hallavaroitus $date – $temp°C';
  }

  @override
  String dryPeriodBodyWithThirsty(
    String past,
    String next,
    String names,
    String more,
  ) {
    return 'Vain $past mm sadetta viimeisten 14 päivän aikana ja $next mm odotettavissa ensi viikolla. Kastele $names$more — kuivuutta sietävät pärjäävät pidempään.';
  }

  @override
  String dryPeriodBodyGeneral(String past, String next) {
    return 'Vain $past mm sadetta viimeisten 14 päivän aikana ja $next mm odotettavissa ensi viikolla. Kastele huolella, etenkin uudet istutukset ja ruukut.';
  }

  @override
  String get dryPeriodMoreSuffix => ' ym.';

  @override
  String get myGardenWaterAllTooltip => 'Kastele kaikki ulkokasvit';

  @override
  String myGardenSeasonStatsTooltip(String year) {
    return 'Kausi $year';
  }

  @override
  String get myGardenGroupTooltip => 'Ryhmittele';

  @override
  String get myGardenNoOutdoorPlants =>
      'Ei ulkokasveja kasteltavaksi juuri nyt.';

  @override
  String get myGardenWaterAllTitle => 'Kastele kaikki?';

  @override
  String myGardenWaterAllConfirm(String count) {
    return 'Merkitsee $count ulkokasvia kastelluiksi juuri nyt.';
  }

  @override
  String get myGardenWaterAllCancel => 'Peruuta';

  @override
  String get myGardenWaterAllAction => 'Kastele kaikki';

  @override
  String myGardenWaterAllDone(String count) {
    return '$count kasvia kasteltu ✓';
  }

  @override
  String get myGardenLocationNone => 'Ei sijaintia';

  @override
  String get myGardenCategoryOther => 'Muu';

  @override
  String myGardenStatusSince(String status, String year) {
    return '$status • vuodesta $year';
  }

  @override
  String myGardenStatusOnDate(String status, String date) {
    return '$status • $date';
  }

  @override
  String settingsMyGardensWithCount(String count) {
    return 'Omat puutarhat ($count)';
  }

  @override
  String get settingsPlanMonthly => 'Kuukausitilaus';

  @override
  String get settingsPlanYearly => 'Vuositilaus';

  @override
  String get settingsPlanLifetime => 'Elinikäinen';

  @override
  String get settingsPlanFree => 'Ilmainen';

  @override
  String get settingsStarterKit => '🛒 Aloituspaketti';

  @override
  String get settingsMorningHourPickerTitle =>
      'Milloin haluat aamuilmoituksen?';

  @override
  String get settingsMorningHourPickerBody =>
      'Aamukooste ja kaikki istutusmuistutukset laukeavat tähän aikaan. Mikään ei herätä aiemmin.';

  @override
  String settingsHourFormat(String hour) {
    return 'Klo $hour:00';
  }

  @override
  String settingsBackupFailed(String error) {
    return 'Varmuuskopiota ei voitu luoda: $error';
  }

  @override
  String get settingsFeedbackSubject => 'Plantera-palaute';

  @override
  String settingsFeedbackBodyTemplate(String version) {
    return 'Hei!\n\nPalaute / kysymys / virheraportti:\n\n\n— Lähetetty Planterasta $version';
  }

  @override
  String get gardensDelete => 'Poista';

  @override
  String get gardensCancel => 'Peruuta';

  @override
  String get gardensNameLabel => 'Nimi';

  @override
  String gardensZoneDescription(String zone, String description) {
    return 'Vyöhyke $zone – $description';
  }

  @override
  String gardensCityFormat(String city, String zone) {
    return '$city · $zone';
  }

  @override
  String get introSkip => 'Ohita';

  @override
  String get introNext => 'Seuraava';

  @override
  String get introStart => 'Aloita';

  @override
  String get onboardingWelcome => 'Tervetuloa Planteraan';

  @override
  String get onboardingBody =>
      'Valitse sijaintisi saadaksesi räätälöidyt neuvot, hallavaroitukset ja oikeat kylvöajat omalle vyöhykkeellesi.';

  @override
  String get onboardingUseGps => 'Käytä sijaintiani';

  @override
  String get onboardingLocating => 'Haetaan sijaintia…';

  @override
  String get onboardingOrPickCity => 'tai valitse kaupunki';

  @override
  String onboardingZoneSubtitle(String zone) {
    return 'Vyöhyke $zone';
  }

  @override
  String get onboardingErrorLocationServicesOff =>
      'Sijaintipalvelut pois käytöstä';

  @override
  String get onboardingErrorLocationDenied => 'Sijaintilupa evätty';

  @override
  String get phasePerennialHaveIt => 'Minulla on se puutarhassa';

  @override
  String get phasePerennialHaveItBody =>
      'Näytämme odotetun sadon ja muistutamme leikkauksesta, lannoituksesta ja kausihoidosta.';

  @override
  String get phasePerennialPlanning => 'Suunnittelen istuttavani';

  @override
  String get phasePerennialPlanningBody =>
      'Vain listalla kunnes oikeasti istutat — muistutukset tulevat ajoissa.';

  @override
  String get phaseDetailedPlanned => 'Suunnittelen kasvattavani';

  @override
  String get phaseDetailedPlannedBody =>
      'Vain listalla — muistutukset tulevat ajoissa kauden alkaessa.';

  @override
  String get phaseDetailedPresow => 'Esikasvatan sisällä';

  @override
  String get phaseDetailedPresowBody =>
      'Taimet kasvavat sisällä. Karaisumuistutus 5 viikon kuluttua.';

  @override
  String get phaseDetailedDirectsow => 'Olen suorakylvänyt ulos';

  @override
  String get phaseDetailedDirectsowBody =>
      'Kylvetty paikalleen. Sadonkorjuumuistutus on jäljellä.';

  @override
  String get phaseDetailedPlantout => 'Taimet on istutettu';

  @override
  String get phaseDetailedPlantoutBody =>
      'Lopullisella paikallaan. Sadonkorjuumuistutus on jäljellä.';

  @override
  String get phaseFinishedReady => 'Valmis korjattavaksi';

  @override
  String get phaseFinishedReadyBody => 'Merkitään korjuuvalmiiksi nyt.';

  @override
  String get phaseFinishedHarvested => 'Korjattu';

  @override
  String get phaseFinishedHarvestedBody =>
      'Kausi on ohi — muistutukset tauolla.';

  @override
  String get phaseFinishedDormant => 'Lepotilassa';

  @override
  String get phaseFinishedDormantBody => 'Kasvi ei ole aktiivinen juuri nyt.';

  @override
  String get phaseDateHelpPresow => 'Minä päivänä aloitit tämän kasvin?';

  @override
  String get phaseDateHelpDirectsow => 'Minä päivänä suorakylvit?';

  @override
  String get phaseDateHelpPlantout => 'Minä päivänä taimet pääsivät ulos?';

  @override
  String get phaseDateHelpDefault => 'Päivämäärä';

  @override
  String get phasePerennialYearTitle => 'Kuinka kauan se on ollut sinulla?';

  @override
  String get phasePerennialYearBody =>
      'Ei tarvitse olla tarkka — käytämme vain vuotta.';

  @override
  String phasePerennialYearThis(String year) {
    return 'Tänä vuonna ($year)';
  }

  @override
  String phasePerennialYearLast(String year) {
    return 'Viime vuonna ($year)';
  }

  @override
  String phasePerennialYearTwo(String year) {
    return 'Kaksi vuotta sitten ($year)';
  }

  @override
  String get phasePerennialYearOlder => 'Aiemmin (muutama vuosi sitten)';

  @override
  String get plantDetailTabOverview => 'Yleiskatsaus';

  @override
  String get plantDetailTabMyPlant => 'Oma kasvi';

  @override
  String get plantDetailTabCare => 'Hoito';

  @override
  String get plantDetailAddCta => 'Lisää puutarhaani';

  @override
  String get plantDetailRemoveCta => 'Poista puutarhasta';

  @override
  String get plantDetailRemoveTitle => 'Poista puutarhasta?';

  @override
  String get plantDetailRemoveBody => 'Tätä ei voi peruuttaa.';

  @override
  String get plantDetailCancel => 'Peruuta';

  @override
  String get plantDetailDelete => 'Poista';

  @override
  String get plantDetailSave => 'Tallenna';

  @override
  String get plantDetailReset => 'Palauta';

  @override
  String get plantDetailReuse => 'Käytä uudelleen';

  @override
  String get plantDetailWaterNowSuffix => 'Kasteltu nyt';

  @override
  String get plantDetailWaterTapHint =>
      'Napauta kun kastelet pitääksesi kirjaa';

  @override
  String get plantDetailWaterDoneSnack => 'Kasteltu ✓';

  @override
  String get plantDetailWaterNotYet => 'Ei kasteltu vielä';

  @override
  String get plantDetailWaterJust => 'Juuri kasteltu';

  @override
  String get plantDetailWaterToday => 'Kasteltu tänään';

  @override
  String get plantDetailWaterYesterday => 'Kasteltu eilen';

  @override
  String get plantDetailUpcomingCareTitle => '📅  TULEVA HOITO';

  @override
  String get plantDetailDueNow => 'Heti nyt';

  @override
  String get plantDetailEditPostsTooltip => 'Hallitse julkaisuja';

  @override
  String get plantDetailNoteHint => 'Kirjoita lyhyt muistiinpano…';

  @override
  String get plantDetailNoteTitle => 'Muistiinpano';

  @override
  String get plantDetailNoteSubtitle =>
      'Mitä tapahtui tänään? Kirvoja, ensimmäinen kukka, leikkaus…';

  @override
  String get plantDetailTakePhoto => 'Ota kuva';

  @override
  String get plantDetailPickLibrary => 'Valitse kirjastosta';

  @override
  String get plantDetailWriteNote => 'Kirjoita muistiinpano';

  @override
  String get plantDetailUseEmojiAgain => 'Käytä emojia uudelleen';

  @override
  String plantDetailSaveImageError(String error) {
    return 'Kuvaa ei voitu tallentaa: $error';
  }

  @override
  String plantDetailSavePhotoError(String error) {
    return 'Valokuvaa ei voitu tallentaa: $error';
  }

  @override
  String get plantDetailDeletePhotoTitle => 'Poista valokuva?';

  @override
  String get plantDetailDeleteNoteTitle => 'Poista muistiinpano?';

  @override
  String get plantDetailDeletePhotoBody => 'Kuva poistetaan laitteelta.';

  @override
  String get plantDetailDeleteNoteBody => 'Muistiinpano katoaa.';

  @override
  String get plantDetailAdd => 'Lisää';

  @override
  String get plantDetailNoPostsBody =>
      'Ei julkaisuja vielä — aloita kasvun dokumentointi kuvilla ja muistiinpanoilla.';

  @override
  String get plantDetailChangeStatus => 'Muuta tila';

  @override
  String get plantDetailLocationLabel => 'Sijainti';

  @override
  String plantDetailSowingMethodChip(String method) {
    return 'Kylvö: $method';
  }

  @override
  String plantDetailSowingMethodSnack(String method) {
    return 'Kylvötapa: $method';
  }

  @override
  String get plantDetailDateHelp => 'Mikä päivä?';

  @override
  String get plantDetailHowSowTitle => 'Miten kylvät?';

  @override
  String get plantDetailHowSowBody => 'Määrittää, mitä muistutuksia saat.';

  @override
  String get plantDetailLocationTitle => 'Missä se on?';

  @override
  String get plantDetailLocationBody =>
      'Esim. \"pohjoispenkki\", \"kasvihuone\", \"parveke\".';

  @override
  String get plantDetailHarvestOffsetTitle => 'Säädä sadonkorjuuaikaa';

  @override
  String get plantDetailHarvestOffsetBody =>
      'Laskuri väärä? Lisää tai vähennä päiviä — tallennetaan vain tälle kasville.';

  @override
  String get plantDetailReadyToHarvest => 'Valmis korjattavaksi';

  @override
  String get plantDetailNextStepPresow => 'Olen esikasvattanut sisällä';

  @override
  String get plantDetailNextStepDirectsow => 'Olen suorakylvänyt';

  @override
  String get plantDetailNextStepPlantout => 'Olen istuttanut';

  @override
  String get plantDetailNextStepPlantedOut => 'Taimet on istutettu';

  @override
  String get plantDetailNextStepHarvestReady => 'Valmis korjattavaksi';

  @override
  String get plantDetailNextStepHarvested => 'Korjattu';

  @override
  String get plantDetailHowToTitle => 'Näin teet';

  @override
  String get plantDetailTipsTitle => 'Vinkit';

  @override
  String get plantDetailPestsTitle => 'Tarkkailtavat tuholaiset';

  @override
  String get plantDetailNoCareTips => 'Ei hoitovinkkejä vielä saatavilla.';

  @override
  String get plantDetailInfoSun => 'Aurinko';

  @override
  String get plantDetailInfoWater => 'Vesi';

  @override
  String get plantDetailInfoFertilizer => 'Lannoite';

  @override
  String get plantDetailInfoFrost => 'Kestää';

  @override
  String get plantDetailInfoSpacing => 'Etäisyys';

  @override
  String get plantDetailInfoHarvest => 'Sato';

  @override
  String get plantDetailHarvestSection => '🥕  Sato';

  @override
  String get plantDetailToolsSection => '🛒 Työkalut ja tarvikkeet';

  @override
  String get plantDetailSeasonSection => 'Kausi';

  @override
  String get plantDetailPhasePresow => 'Esikasvatus';

  @override
  String get plantDetailPhaseDirectsow => 'Suorakylvö';

  @override
  String get plantDetailPhasePlantout => 'Istutus';

  @override
  String get plantDetailPhaseHarvest => 'Sadonkorjuu';

  @override
  String get plantDetailZoneWarningBody =>
      'Voi onnistua – mutta tarvitset luultavasti talvisuojaa tai lämpimämmän paikan.';

  @override
  String plantDetailDateAdded(String date) {
    return 'Lisätty $date';
  }

  @override
  String plantDetailDateInGardenSince(String year) {
    return 'Puutarhassa vuodesta $year';
  }

  @override
  String plantDetailDatePlanted(String date) {
    return 'Istutettu $date';
  }

  @override
  String get plantDetailHarvestOffsetSubtitle => 'Säädä sadonkorjuuaikaa';

  @override
  String plantDetailZoneWarning(String zone) {
    return 'Tätä kasvia ei ole testattu vyöhykkeelle $zone. Voi onnistua – mutta tarvitset luultavasti talvisuojaa tai lämpimämmän paikan.';
  }

  @override
  String get harvestSectionTitle => '🥕 Sato';

  @override
  String get harvestRemoveTitle => 'Poista merkintä?';

  @override
  String harvestRemoveBody(String amount, String unit, String date) {
    return '$amount $unit päivältä $date poistetaan.';
  }

  @override
  String harvestMoreEntries(String count) {
    return '+ $count vanhempaa merkintää';
  }

  @override
  String harvestAddTitle(String plant) {
    return 'Kirjaa sato — $plant';
  }

  @override
  String get harvestAmountLabel => 'Määrä';

  @override
  String get harvestUnitLabel => 'Yksikkö';

  @override
  String get harvestNotesLabel => 'Muistiinpano (valinnainen)';

  @override
  String get harvestErrorAmountTooLow => 'Anna määrä, joka on yli 0';

  @override
  String get harvestErrorFutureDate => 'Et voi kirjata satoa tulevaisuuteen';

  @override
  String get commonCancel => 'Peruuta';

  @override
  String get commonDelete => 'Poista';

  @override
  String get commonSave => 'Tallenna';

  @override
  String get pestTypeLabelDisease => 'SAIRAUS';

  @override
  String get pestTypeLabelDamage => 'VAURIO';

  @override
  String get pestTypeLabelPest => 'TUHOLAINEN';
}
