// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Plantera';

  @override
  String get appSubtitle => 'Il tuo compagno di giardino digitale';

  @override
  String get tabHome => 'Home';

  @override
  String get tabCalendar => 'Calendario';

  @override
  String get tabPlants => 'Piante';

  @override
  String get tabMyGarden => 'Le mie piante';

  @override
  String get tabSettings => 'Impostazioni';

  @override
  String get tabOverview => 'Panoramica';

  @override
  String get tabMyPlant => 'La mia pianta';

  @override
  String get tabCare => 'Cure';

  @override
  String get homeWelcomeTitle => 'Iniziamo dalla tua prima pianta';

  @override
  String get homeWelcomeBody =>
      'Sfoglia il database e tocca + su ciò che coltivi — la seguiamo dalla semina al raccolto.';

  @override
  String get homeWelcomeCta => 'Sfoglia le piante';

  @override
  String get gardenOverviewTitle => 'Prossimo raccolto';

  @override
  String get gardenSeeAll => 'Vedi tutto';

  @override
  String get gardenStatTotal => 'In giardino';

  @override
  String get gardenStatHarvestSoon => 'Raccolto presto';

  @override
  String get gardenStatReadyNow => 'Pronto ora';

  @override
  String gardenMore(Object count) {
    return '+$count altre';
  }

  @override
  String get dailyInsightsTitle => 'Oggi in giardino';

  @override
  String get dailyInsightsAllGood =>
      'Tutto sotto controllo. Niente di urgente — goditi il giardino.';

  @override
  String get upcomingCareTitle => 'Cure in arrivo';

  @override
  String get upcomingCareSubtitle => 'Cose da fare questo mese e il prossimo.';

  @override
  String seasonPlannerTitle(Object year) {
    return 'La mia stagione $year';
  }

  @override
  String get seasonPlannerSubtitle =>
      'Cosa vuoi coltivare quest\'anno. Ti avvisiamo quando è il momento di seminare.';

  @override
  String seasonPlannerEmptyTitle(Object year) {
    return 'Pianifica la stagione $year';
  }

  @override
  String get seasonPlannerEmptyBody =>
      'Cosa vuoi coltivare quest\'anno? Ti ricordiamo quando seminare.';

  @override
  String get seasonPlannerEmptyCta => 'Scegli';

  @override
  String get seasonPlannerAddCta => 'Aggiungi pianta';

  @override
  String seasonPlannerCount(Object count) {
    return '$count';
  }

  @override
  String get seasonRowSowNow => 'Semina ora';

  @override
  String seasonRowDaysAway(Object days) {
    return 'Tra $days giorni';
  }

  @override
  String get seasonRowInSeason => 'In stagione';

  @override
  String get weatherUnavailable => 'Meteo non disponibile';

  @override
  String get weatherSetLocation =>
      'Imposta la tua posizione nelle impostazioni';

  @override
  String get dryPeriodTitle => 'Periodo siccitoso in corso';

  @override
  String get frostCardTitle => '❄️ Proteggi dal gelo';

  @override
  String get premiumTeaserTitle => 'Plantera Premium';

  @override
  String get premiumTeaserBody => 'Giardino illimitato e senza pubblicità';

  @override
  String get calendarTitle => 'Calendario di semina';

  @override
  String get calendarMonthGuide => 'Guida del mese';

  @override
  String calendarTaskCount(Object count) {
    return '$count attività';
  }

  @override
  String get calendarPhasePresow => 'SEMINA INTERNA';

  @override
  String get calendarPhaseDirectsow => 'SEMINA DIRETTA';

  @override
  String get calendarPhasePlantout => 'TRAPIANTA';

  @override
  String get calendarPhaseHarvest => 'RACCOLTO';

  @override
  String calendarPhaseCount(Object count) {
    return '$count piante';
  }

  @override
  String calendarEmptyTitle(Object month) {
    return 'Niente da seminare o raccogliere a $month';
  }

  @override
  String get calendarEmptyBody =>
      'Usa il mese per pianificare — ordina semi, organizza aiuole o leggi la guida del mese.';

  @override
  String get myGardenTitle => 'Le mie piante';

  @override
  String get myGardenSearchHint => 'Cerca pianta o posizione';

  @override
  String get myGardenFilterAll => 'Tutte';

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
  String get myGardenEmptyTitle => 'Il tuo giardino è vuoto';

  @override
  String get myGardenEmptyBody =>
      'Aggiungi piante dal database per iniziare il tuo giardino.';

  @override
  String get myGardenEmptyCta => 'Sfoglia il database';

  @override
  String get myGardenAddPlant => 'Aggiungi pianta';

  @override
  String get myGardenNoResults => 'Inga växter matchar';

  @override
  String get myGardenNoResultsBody =>
      'Pröva en annan sökning eller rensa filtren.';

  @override
  String get myGardenWateredNow => 'Annaffiata ora';

  @override
  String get myGardenWateredToday => 'Annaffiata oggi';

  @override
  String get myGardenWateredYesterday => 'Annaffiata ieri';

  @override
  String get plantDatabaseTitle => 'Växtdatabas';

  @override
  String get plantDatabaseSearchHint => 'Sök växt';

  @override
  String get plantCategoryAll => 'Alla';

  @override
  String get addPlantNow => 'Aggiungi al giardino ora';

  @override
  String get addPlantNowBody => 'Hai seminato o piantato — la seguiamo da oggi';

  @override
  String get addPlantSeason => 'Aggiungi alla lista di semina';

  @override
  String get addPlantSeasonBody =>
      'Pensi di coltivarla — ti avvisiamo quando seminare';

  @override
  String get addPlantRemoveSeason => 'Ta bort från såningslistan';

  @override
  String get addPlantRemoveSeasonBody =>
      'Vi slutar påminna om sånings-fönstret';

  @override
  String addedToGardenTitle(Object plant) {
    return '$plant è nel tuo giardino';
  }

  @override
  String get addedToGardenBodyPlain =>
      'La seguiamo da oggi e ti ricordiamo acqua e raccolto.';

  @override
  String addedToGardenBodyScheduled(Object list) {
    return 'Vi följer den från idag. Notiser inkommande för: $list.';
  }

  @override
  String get addedToGardenCta => 'Vai al mio giardino';

  @override
  String get phasePickerTitleNew => 'Var är du i processen?';

  @override
  String get phasePickerTitleEdit => 'Ändra status';

  @override
  String get phaseShowSimple => 'Visa enklare alternativ';

  @override
  String get phaseShowMore => 'Fler alternativ (för den vana odlaren)';

  @override
  String get phaseSimplePlanned => 'Sto pianificando';

  @override
  String get phaseSimplePlannedBody =>
      'Bara på listan — vi påminner när säsongen startar.';

  @override
  String get phaseSimpleGrowing => 'Sta crescendo ora';

  @override
  String get phaseSimpleGrowingBody =>
      'Plantorna är på gång. Vi följer dem fram till skörd.';

  @override
  String get phaseSimpleHarvested => 'Già raccolta';

  @override
  String get phaseSimpleHarvestedBody =>
      'Säsongen är klar för den här plantan.';

  @override
  String get perennialEstablishedTitle => 'Da quando ce l\'hai?';

  @override
  String get perennialEstablishedBody =>
      'Non deve essere preciso – usiamo solo l\'anno.';

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
  String get statusPlanning => 'Pianificazione';

  @override
  String get statusGrowingIndoors => 'Semina interna';

  @override
  String get statusDirectSown => 'Semina diretta';

  @override
  String get statusHardening => 'Indurimento';

  @override
  String get statusOutdoors => 'All\'aperto';

  @override
  String get statusReadyToHarvest => 'Pronta da raccogliere';

  @override
  String get statusHarvested => 'Raccolta';

  @override
  String get statusDormant => 'Dormiente';

  @override
  String get sowingIndoors => 'Inomhus';

  @override
  String get sowingDirect => 'Direkt';

  @override
  String get sowingPlanta => 'Planta';

  @override
  String get sunFull => 'Pieno sole';

  @override
  String get sunPartial => 'Mezz\'ombra';

  @override
  String get sunShade => 'Ombra';

  @override
  String get waterSparse => 'Scarso';

  @override
  String get waterRegular => 'Regolare';

  @override
  String get waterAbundant => 'Abbondante';

  @override
  String get fertilizerLow => 'Basso';

  @override
  String get fertilizerMedium => 'Medio';

  @override
  String get fertilizerHigh => 'Alto';

  @override
  String get lifecycleAnnual => 'Annuale';

  @override
  String get lifecycleBiennial => 'Biennale';

  @override
  String get lifecyclePerennial => 'Perenne';

  @override
  String get lifecycleTree => 'Albero';

  @override
  String get lifecycleShrub => 'Arbusto';

  @override
  String get categoryVegetables => 'Ortaggi';

  @override
  String get categoryHerbs => 'Erbe & spezie';

  @override
  String get categoryFlowers => 'Fiori';

  @override
  String get categoryBerries => 'Bacche';

  @override
  String get categoryFruitTrees => 'Alberi da frutto';

  @override
  String get categoryOther => 'Altro';

  @override
  String get wateredNow => 'Annaffiata';

  @override
  String get wateredConfirmation => 'Annaffiata ✓';

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
  String get harvestTitle => 'Raccolto';

  @override
  String get harvestLog => 'Registra raccolto';

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
  String get buttonCancel => 'Annulla';

  @override
  String get buttonRemove => 'Rimuovi';

  @override
  String get buttonSave => 'Salva';

  @override
  String get buttonNext => 'Avanti';

  @override
  String get buttonStart => 'Inizia';

  @override
  String get buttonSkip => 'Salta';

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
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsPremiumActive => 'Premium attivo';

  @override
  String get settingsPremiumUpgrade => 'Passa a Premium';

  @override
  String get settingsPremiumUnlock => 'Lås upp alla funktioner';

  @override
  String get settingsMyGardens => 'I miei giardini';

  @override
  String settingsMyGardensSubtitle(Object emoji, Object name) {
    return 'Aktiv: $emoji $name';
  }

  @override
  String get settingsMyGardensEmpty => 'Lägg till din första trädgård';

  @override
  String get settingsNotifications => 'Promemoria';

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
  String get settingsSupport => 'Supporto';

  @override
  String get settingsFeedback => 'Invia feedback';

  @override
  String get settingsFeedbackBody =>
      'Buggar, funktionsönskemål eller bara ett vänligt hej';

  @override
  String get gardensTitle => 'Mina trädgårdar';

  @override
  String get gardensActive => 'ATTIVO';

  @override
  String get gardensAddNew => 'Aggiungi un giardino';

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
  String get introPage1Title => 'Aggiungi le piante che coltivi';

  @override
  String get introPage1Body =>
      'Tryck + på en växt för att lägga till den i din trädgård. Vi följer den från sådd till skörd och påminner när det är dags att vattna, beskära eller plantera om.';

  @override
  String get introPage1Hint =>
      'Hittar du växten? Använd \"Växter\"-fliken i botten.';

  @override
  String get introPage2Title => 'Pianifica la stagione';

  @override
  String get introPage2Body =>
      'Tryck på bokmärket för att lägga växten på din säsongs-lista. Du får en notis i februari/mars när det är dags att börja förodla, och i april när det är dags att direktså.';

  @override
  String get introPage2Hint => 'Säsongs-listan ser du på startsidan.';

  @override
  String get introPage3Title => 'Tieni il giardino sotto controllo';

  @override
  String get introPage3Body =>
      'Hem-sidan visar väder, torrperioder och vad du ska göra denna månad. På \"Min trädgård\"-fliken kan du se årets statistik, växtföljd och uppskattat värde av din skörd.';

  @override
  String get introPage3Hint =>
      'Skadedjur & sjukdomar finns i Inställningar när du behöver dem.';

  @override
  String get pestLibraryTitle => 'Parassiti e malattie';

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
  String get tabTodo => 'Da fare';

  @override
  String get todoSectionToday => 'OGGI';

  @override
  String get todoSectionWeek => 'QUESTA SETTIMANA';

  @override
  String get todoSectionMonth => 'QUESTO MESE';

  @override
  String get todoSectionDoneToday => 'FATTO OGGI ✓';

  @override
  String get todoStatToday => 'oggi';

  @override
  String get todoStatWeek => 'questa settimana';

  @override
  String get todoStatDone => 'fatto';

  @override
  String get todoEmptyTitle => 'Tutto sotto controllo';

  @override
  String get todoEmptyBody =>
      'Niente di urgente. Aggiungi piante per ricevere attività quotidiane.';

  @override
  String get todoSwipeDone => 'Fatto';

  @override
  String get todoSwipeSnooze => 'Rimanda';

  @override
  String get progressReadyToHarvest => 'Pronta da raccogliere';

  @override
  String get progressHarvestNow => 'Raccogli ora';

  @override
  String progressDaysLeft(Object days) {
    return '$days giorni rimasti';
  }

  @override
  String progressApproxDaysLeft(Object days) {
    return '~$days giorni rimasti';
  }

  @override
  String get climateCardTitle => 'Clima ultimi 14 giorni';

  @override
  String get climateStatAvg => 'Media gior.';

  @override
  String get climateStatMinMax => 'Min/max';

  @override
  String get climateStatGdd => 'GDD';

  @override
  String get climateInterpretWaking => 'Il giardino si risveglia.';

  @override
  String get climateInterpretEarly =>
      'Stagione molto precoce – solo rustiche (cipolla, piselli, lattuga).';

  @override
  String get climateInterpretSpring =>
      'Stagione primaverile – le semine dirette si stabilizzano, le calde aspettano.';

  @override
  String get climateInterpretMidSpring =>
      'Metà primavera – pomodoro e peperone sotto velo o in serra.';

  @override
  String get climateInterpretFullGrowth =>
      'Piena crescita – tutto matura velocemente, irriga e fertilizza.';

  @override
  String get climateInterpretHot =>
      'Periodo caldo – attenzione all\'irrigazione delle piantine.';

  @override
  String get climateTeaserTitle => 'Carta clima (Premium)';

  @override
  String get climateTeaserBody =>
      'Temperatura media + Growing Degree Days per migliore tempistica di semina e raccolta.';

  @override
  String get weatherSetLocationHint =>
      'Imposta la posizione nelle impostazioni';

  @override
  String weatherFrostWarning(String date, String temp) {
    return 'Avviso gelo $date – $temp°C';
  }

  @override
  String dryPeriodBodyWithThirsty(
    String past,
    String next,
    String names,
    String more,
  ) {
    return 'Solo $past mm di pioggia negli ultimi 14 giorni e $next mm previsti la prossima settimana. Innaffia $names$more — le piante tolleranti alla siccità reggono più a lungo.';
  }

  @override
  String dryPeriodBodyGeneral(String past, String next) {
    return 'Solo $past mm di pioggia negli ultimi 14 giorni e $next mm previsti la prossima settimana. Innaffia con cura, soprattutto le neopiantate e in vaso.';
  }

  @override
  String get dryPeriodMoreSuffix => ' ecc.';

  @override
  String get myGardenWaterAllTooltip => 'Innaffia tutte le piante da esterno';

  @override
  String myGardenSeasonStatsTooltip(String year) {
    return 'La mia stagione $year';
  }

  @override
  String get myGardenGroupTooltip => 'Raggruppa per';

  @override
  String get myGardenNoOutdoorPlants =>
      'Nessuna pianta da esterno da innaffiare ora.';

  @override
  String get myGardenWaterAllTitle => 'Innaffiare tutte?';

  @override
  String myGardenWaterAllConfirm(String count) {
    return 'Segna $count piante da esterno come appena innaffiate.';
  }

  @override
  String get myGardenWaterAllCancel => 'Annulla';

  @override
  String get myGardenWaterAllAction => 'Innaffia tutte';

  @override
  String myGardenWaterAllDone(String count) {
    return '$count piante innaffiate ✓';
  }

  @override
  String get myGardenLocationNone => 'Senza posizione';

  @override
  String get myGardenCategoryOther => 'Altro';

  @override
  String myGardenStatusSince(String status, String year) {
    return '$status • da $year';
  }

  @override
  String myGardenStatusOnDate(String status, String date) {
    return '$status • $date';
  }

  @override
  String settingsMyGardensWithCount(String count) {
    return 'I miei orti ($count)';
  }

  @override
  String get settingsPlanMonthly => 'Abbonamento mensile';

  @override
  String get settingsPlanYearly => 'Abbonamento annuale';

  @override
  String get settingsPlanLifetime => 'A vita';

  @override
  String get settingsPlanFree => 'Gratis';

  @override
  String get settingsStarterKit => '🛒 Kit iniziale';

  @override
  String get settingsMorningHourPickerTitle =>
      'Quando vuoi il ping del mattino?';

  @override
  String get settingsMorningHourPickerBody =>
      'Il riepilogo mattutino e tutti i promemoria di semina partono in quest\'ora. Nulla ti sveglia prima.';

  @override
  String settingsHourFormat(String hour) {
    return 'Ore $hour:00';
  }

  @override
  String settingsBackupFailed(String error) {
    return 'Impossibile creare il backup: $error';
  }

  @override
  String get settingsFeedbackSubject => 'Feedback Plantera';

  @override
  String settingsFeedbackBodyTemplate(String version) {
    return 'Ciao!\n\nFeedback / domanda / segnalazione bug:\n\n\n— Inviato da Plantera $version';
  }

  @override
  String get gardensDelete => 'Elimina';

  @override
  String get gardensCancel => 'Annulla';

  @override
  String get gardensNameLabel => 'Nome';

  @override
  String gardensZoneDescription(String zone, String description) {
    return 'Zona $zone – $description';
  }

  @override
  String gardensCityFormat(String city, String zone) {
    return '$city · $zone';
  }

  @override
  String get introSkip => 'Salta';

  @override
  String get introNext => 'Avanti';

  @override
  String get introStart => 'Iniziamo';

  @override
  String get onboardingWelcome => 'Benvenuto in Plantera';

  @override
  String get onboardingBody =>
      'Scegli la posizione per consigli personalizzati, avvisi gelo e tempi di semina giusti per la tua zona.';

  @override
  String get onboardingUseGps => 'Usa la mia posizione';

  @override
  String get onboardingLocating => 'Recupero posizione…';

  @override
  String get onboardingOrPickCity => 'o scegli una città';

  @override
  String onboardingZoneSubtitle(String zone) {
    return 'Zona $zone';
  }

  @override
  String get onboardingErrorLocationServicesOff =>
      'Servizi di localizzazione disattivati';

  @override
  String get onboardingErrorLocationDenied =>
      'Permesso di localizzazione negato';

  @override
  String get phasePerennialHaveIt => 'Ce l\'ho in giardino';

  @override
  String get phasePerennialHaveItBody =>
      'Mostreremo il raccolto atteso e ricorderemo potatura, concimazione e cura stagionale.';

  @override
  String get phasePerennialPlanning => 'Sto per piantarla';

  @override
  String get phasePerennialPlanningBody =>
      'Sulla lista finché non pianti — promemoria in tempo.';

  @override
  String get phaseDetailedPlanned => 'Sto per coltivare';

  @override
  String get phaseDetailedPlannedBody =>
      'Solo sulla lista — promemoria all\'inizio stagione.';

  @override
  String get phaseDetailedPresow => 'Semina al chiuso';

  @override
  String get phaseDetailedPresowBody =>
      'Piantine al chiuso. Promemoria indurimento tra 5 settimane.';

  @override
  String get phaseDetailedDirectsow => 'Ho seminato in piena terra';

  @override
  String get phaseDetailedDirectsowBody =>
      'Seminato in posto. Promemoria raccolta a venire.';

  @override
  String get phaseDetailedPlantout => 'Piantine messe a dimora';

  @override
  String get phaseDetailedPlantoutBody =>
      'Al posto finale. Promemoria raccolta a venire.';

  @override
  String get phaseFinishedReady => 'Pronta per il raccolto';

  @override
  String get phaseFinishedReadyBody => 'Segnata pronta per il raccolto ora.';

  @override
  String get phaseFinishedHarvested => 'Raccolta';

  @override
  String get phaseFinishedHarvestedBody =>
      'Stagione finita — promemoria in pausa.';

  @override
  String get phaseFinishedDormant => 'In riposo';

  @override
  String get phaseFinishedDormantBody => 'La pianta non è attiva ora.';

  @override
  String get phaseDateHelpPresow => 'In che data hai avviato questa pianta?';

  @override
  String get phaseDateHelpDirectsow =>
      'In che data hai seminato in piena terra?';

  @override
  String get phaseDateHelpPlantout => 'In che data sono uscite le piantine?';

  @override
  String get phaseDateHelpDefault => 'Data';

  @override
  String get phasePerennialYearTitle => 'Da quando ce l\'hai?';

  @override
  String get phasePerennialYearBody =>
      'Non serve precisione — usiamo solo l\'anno.';

  @override
  String phasePerennialYearThis(String year) {
    return 'Quest\'anno ($year)';
  }

  @override
  String phasePerennialYearLast(String year) {
    return 'L\'anno scorso ($year)';
  }

  @override
  String phasePerennialYearTwo(String year) {
    return 'Due anni fa ($year)';
  }

  @override
  String get phasePerennialYearOlder => 'In precedenza (qualche anno fa)';

  @override
  String get plantDetailTabOverview => 'Panoramica';

  @override
  String get plantDetailTabMyPlant => 'La mia pianta';

  @override
  String get plantDetailTabCare => 'Cura';

  @override
  String get plantDetailAddCta => 'Aggiungi al mio orto';

  @override
  String get plantDetailRemoveCta => 'Rimuovi dall\'orto';

  @override
  String get plantDetailRemoveTitle => 'Rimuovere dall\'orto?';

  @override
  String get plantDetailRemoveBody => 'Operazione non annullabile.';

  @override
  String get plantDetailCancel => 'Annulla';

  @override
  String get plantDetailDelete => 'Elimina';

  @override
  String get plantDetailSave => 'Salva';

  @override
  String get plantDetailReset => 'Ripristina';

  @override
  String get plantDetailReuse => 'Riutilizza';

  @override
  String get plantDetailWaterNowSuffix => 'Innaffiata ora';

  @override
  String get plantDetailWaterTapHint =>
      'Tocca quando innaffi per tenere traccia';

  @override
  String get plantDetailWaterDoneSnack => 'Innaffiata ✓';

  @override
  String get plantDetailWaterNotYet => 'Non ancora innaffiata';

  @override
  String get plantDetailWaterJust => 'Appena innaffiata';

  @override
  String get plantDetailWaterToday => 'Innaffiata oggi';

  @override
  String get plantDetailWaterYesterday => 'Innaffiata ieri';

  @override
  String get plantDetailUpcomingCareTitle => '📅  PROSSIMA CURA';

  @override
  String get plantDetailDueNow => 'Ora';

  @override
  String get plantDetailEditPostsTooltip => 'Gestisci post';

  @override
  String get plantDetailNoteHint => 'Scrivi una nota breve…';

  @override
  String get plantDetailNoteTitle => 'Nota';

  @override
  String get plantDetailNoteSubtitle =>
      'Cos\'è successo oggi? Afidi, primo fiore, potatura…';

  @override
  String get plantDetailTakePhoto => 'Scatta foto';

  @override
  String get plantDetailPickLibrary => 'Scegli dalla libreria';

  @override
  String get plantDetailWriteNote => 'Scrivi nota';

  @override
  String get plantDetailUseEmojiAgain => 'Riusa emoji';

  @override
  String plantDetailSaveImageError(String error) {
    return 'Impossibile salvare l\'immagine: $error';
  }

  @override
  String plantDetailSavePhotoError(String error) {
    return 'Impossibile salvare la foto: $error';
  }

  @override
  String get plantDetailDeletePhotoTitle => 'Eliminare la foto?';

  @override
  String get plantDetailDeleteNoteTitle => 'Eliminare la nota?';

  @override
  String get plantDetailDeletePhotoBody =>
      'La foto viene rimossa dal dispositivo.';

  @override
  String get plantDetailDeleteNoteBody => 'La nota scompare.';

  @override
  String get plantDetailAdd => 'Aggiungi';

  @override
  String get plantDetailNoPostsBody =>
      'Nessun post — inizia a documentare la crescita con foto e brevi note.';

  @override
  String get plantDetailChangeStatus => 'Cambia stato';

  @override
  String get plantDetailLocationLabel => 'Posizione';

  @override
  String plantDetailSowingMethodChip(String method) {
    return 'Semina: $method';
  }

  @override
  String plantDetailSowingMethodSnack(String method) {
    return 'Metodo di semina: $method';
  }

  @override
  String get plantDetailDateHelp => 'Quale data?';

  @override
  String get plantDetailHowSowTitle => 'Come semini?';

  @override
  String get plantDetailHowSowBody => 'Determina quali promemoria ricevi.';

  @override
  String get plantDetailLocationTitle => 'Dove sta?';

  @override
  String get plantDetailLocationBody =>
      'Es. \"aiuola nord\", \"la serra\", \"il balcone\".';

  @override
  String get plantDetailHarvestOffsetTitle => 'Regola tempo di raccolta';

  @override
  String get plantDetailHarvestOffsetBody =>
      'Contatore sbagliato? Aggiungi o sottrai giorni — salvato solo per questa pianta.';

  @override
  String get plantDetailReadyToHarvest => 'Pronta per il raccolto';

  @override
  String get plantDetailNextStepPresow => 'Ho seminato al chiuso';

  @override
  String get plantDetailNextStepDirectsow => 'Ho seminato in piena terra';

  @override
  String get plantDetailNextStepPlantout => 'Ho messo a dimora';

  @override
  String get plantDetailNextStepPlantedOut => 'Piantine a dimora';

  @override
  String get plantDetailNextStepHarvestReady => 'Pronta per il raccolto';

  @override
  String get plantDetailNextStepHarvested => 'Raccolta';

  @override
  String get plantDetailHowToTitle => 'Come fare';

  @override
  String get plantDetailTipsTitle => 'Consigli';

  @override
  String get plantDetailPestsTitle => 'Parassiti da osservare';

  @override
  String get plantDetailNoCareTips => 'Nessun consiglio di cura disponibile.';

  @override
  String get plantDetailInfoSun => 'Sole';

  @override
  String get plantDetailInfoWater => 'Acqua';

  @override
  String get plantDetailInfoFertilizer => 'Concime';

  @override
  String get plantDetailInfoFrost => 'Resiste a';

  @override
  String get plantDetailInfoSpacing => 'Distanza';

  @override
  String get plantDetailInfoHarvest => 'Raccolto';

  @override
  String get plantDetailHarvestSection => '🥕  Raccolto';

  @override
  String get plantDetailToolsSection => '🛒 Attrezzi e accessori';

  @override
  String get plantDetailSeasonSection => 'Stagione';

  @override
  String get plantDetailPhasePresow => 'Semina al chiuso';

  @override
  String get plantDetailPhaseDirectsow => 'Semina in piena terra';

  @override
  String get plantDetailPhasePlantout => 'Mettere a dimora';

  @override
  String get plantDetailPhaseHarvest => 'Raccogliere';

  @override
  String get plantDetailZoneWarningBody =>
      'Può funzionare — ma serviranno probabilmente protezione invernale o un posto più caldo.';

  @override
  String plantDetailDateAdded(String date) {
    return 'Aggiunto $date';
  }

  @override
  String plantDetailDateInGardenSince(String year) {
    return 'In orto da $year';
  }

  @override
  String plantDetailDatePlanted(String date) {
    return 'Piantato $date';
  }

  @override
  String get plantDetailHarvestOffsetSubtitle => 'Regola tempo di raccolta';

  @override
  String plantDetailZoneWarning(String zone) {
    return 'Questa pianta non è testata per la zona $zone. Può funzionare — ma serviranno probabilmente protezione invernale o un posto più caldo.';
  }

  @override
  String get harvestSectionTitle => '🥕 Raccolto';

  @override
  String get harvestRemoveTitle => 'Eliminare la voce?';

  @override
  String harvestRemoveBody(String amount, String unit, String date) {
    return '$amount $unit del $date verranno eliminati.';
  }

  @override
  String harvestMoreEntries(String count) {
    return '+ $count voci più vecchie';
  }

  @override
  String harvestAddTitle(String plant) {
    return 'Registra raccolto — $plant';
  }

  @override
  String get harvestAmountLabel => 'Quantità';

  @override
  String get harvestUnitLabel => 'Unità';

  @override
  String get harvestNotesLabel => 'Nota (facoltativo)';

  @override
  String get harvestErrorAmountTooLow => 'Inserisci una quantità superiore a 0';

  @override
  String get harvestErrorFutureDate => 'Non puoi registrare un raccolto futuro';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonDelete => 'Elimina';

  @override
  String get commonSave => 'Salva';

  @override
  String get pestTypeLabelDisease => 'MALATTIA';

  @override
  String get pestTypeLabelDamage => 'DANNO';

  @override
  String get pestTypeLabelPest => 'PARASSITA';

  @override
  String get statsShareButton => 'Condividi';

  @override
  String statsShareText(String year) {
    return 'Il mio orto $year con Plantera 🌱';
  }

  @override
  String get statsShareFailed =>
      'Impossibile creare l\'immagine di condivisione';

  @override
  String get paywallTitleBranded => 'Plantera Premium';

  @override
  String get paywallHeaderFrost =>
      'Ricevi avvisi gelo prima che le piante congelino';

  @override
  String get paywallHeaderGardenLimit => 'Aggiungi tutto il giardino';

  @override
  String get paywallHeaderWaterAll => 'Annaffia tutto con un tocco';

  @override
  String get paywallHeaderPhotoLog => 'Un diario fotografico per le tue piante';

  @override
  String get paywallSubFrost =>
      'Temperatura notturna SMHI — ti avvisiamo la sera prima della notte di gelo';

  @override
  String get paywallSubGardenLimit =>
      'Nessun limite al numero di piante che segui';

  @override
  String get paywallSubWaterAll =>
      'Un pulsante segna tutte le piante da esterno come annaffiate';

  @override
  String get paywallSubPhotoLog => 'Vedile crescere dal seme al raccolto';

  @override
  String get paywallSubHome =>
      'Avvisi gelo, diario fotografico e tutto illimitato';

  @override
  String get paywallSubDefault => 'Porta il tuo giardino al livello successivo';

  @override
  String get paywallBenefitUnlimited => 'Piante illimitate nel tuo giardino';

  @override
  String get paywallBenefitReminders => 'Tutti i promemoria e gli avvisi gelo';

  @override
  String get paywallBenefitPhotos => 'Diario fotografico per ogni pianta';

  @override
  String get paywallBenefitNoAds => 'Senza pubblicità';

  @override
  String get paywallBenefitPdf => 'Esportazione PDF del diario raccolto';

  @override
  String get paywallBenefitArticles =>
      'Accesso completo agli articoli di conoscenza';

  @override
  String get paywallPlanYearly => 'Abbonamento annuale';

  @override
  String paywallPlanYearlySavings(String percent) {
    return 'Risparmia il $percent% rispetto al mensile';
  }

  @override
  String get paywallPlanMonthly => 'Abbonamento mensile';

  @override
  String get paywallPlanLifetime => 'Acquisto a vita (pagamento unico)';

  @override
  String paywallTrialCta(String period) {
    return 'Inizia la prova gratuita ($period)';
  }

  @override
  String paywallTrialThen(String price) {
    return 'Poi $price';
  }

  @override
  String paywallPlanPriceFormat(String title, String price) {
    return '$title • $price';
  }

  @override
  String get paywallRestore => 'Ripristina acquisti precedenti';

  @override
  String get paywallDisclaimer =>
      'Gli abbonamenti si rinnovano automaticamente finché non vengono annullati nelle impostazioni dell\'App Store. L\'addebito avviene 24 h prima del rinnovo.';

  @override
  String get paywallTerms => 'Termini (EULA)';

  @override
  String get paywallPrivacy => 'Informativa sulla privacy';

  @override
  String get paywallErrorStore =>
      'L\'App Store non è disponibile in questo momento — riprova tra poco.';

  @override
  String get paywallErrorProduct =>
      'Impossibile caricare l\'acquisto dall\'App Store. Chiudi la paywall e riaprila.';

  @override
  String get paywallErrorFailed => 'Acquisto fallito. Riprova.';

  @override
  String paywallErrorOpenUrl(String url) {
    return 'Impossibile aprire $url';
  }

  @override
  String get paywallPurchaseSuccess =>
      'Premium attivato — grazie! Tutto è sbloccato.';

  @override
  String get paywallRestoreInProgress => 'Ricerca dei tuoi acquisti…';

  @override
  String get paywallRestoreFailed =>
      'Impossibile contattare l\'App Store. Riprova.';

  @override
  String get paywallRestoreSuccess => 'Premium ripristinato — grazie!';

  @override
  String get paywallRestoreAlreadyActive => 'Premium è già attivo.';

  @override
  String get paywallRestoreNothingFound =>
      'Nessun acquisto trovato per questo ID Apple.';

  @override
  String get paywallAlreadyPremiumTitle => 'Hai Premium';

  @override
  String get paywallAlreadyPremiumBody =>
      'Tutte le funzioni sono sbloccate. Grazie per il supporto — ci aiuta a continuare.';

  @override
  String get paywallAlreadyPremiumCta => 'Torna al giardino';

  @override
  String get paywallProductsUnavailable =>
      'Impossibile caricare i prezzi dall\'App Store. Controlla la connessione e riprova.';

  @override
  String get paywallProductsRetry => 'Riprova';

  @override
  String get onboardingSlide1Title => 'Smetti di indovinare quando seminare';

  @override
  String get onboardingSlide1Body =>
      'Plantera conosce la tua zona climatica e ti dice esattamente quando seminare al chiuso, in pieno campo o trapiantare — pianta per pianta.';

  @override
  String get onboardingSlide2Title => 'Avvisi gelo su cui puoi agire';

  @override
  String get onboardingSlide2Body =>
      'Quando arriva una notte fredda ricevi un avviso in tempo per coprire le piantine. Niente panico alle tre di notte.';

  @override
  String get onboardingSlide3Title => 'Un promemoria al mattino — non 50';

  @override
  String get onboardingSlide3Body =>
      'Annaffiatura, potatura, raccolto e lavori stagionali in un riepilogo giornaliero, così ottieni davvero un raccolto.';

  @override
  String get onboardingFooterSkip => 'Salta';

  @override
  String get onboardingFooterNext => 'Avanti';

  @override
  String get onboardingFooterStart => 'Inizia';

  @override
  String get affiliateDisclosure =>
      'Annonslänkar – vi kan få provision om du handlar via Amazon.';

  @override
  String get monthlyProductsTitle => 'Månadens produkter';
}
