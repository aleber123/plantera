// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appName => 'Plantera';

  @override
  String get appSubtitle => 'Din digitala trädgårdskompis';

  @override
  String get tabHome => 'Hem';

  @override
  String get tabCalendar => 'Kalender';

  @override
  String get tabPlants => 'Växter';

  @override
  String get tabMyGarden => 'Mina växter';

  @override
  String get tabSettings => 'Inställningar';

  @override
  String get tabOverview => 'Översikt';

  @override
  String get tabMyPlant => 'Min planta';

  @override
  String get tabCare => 'Omsorg';

  @override
  String get homeWelcomeTitle => 'Vi börjar med första växten';

  @override
  String get homeWelcomeBody =>
      'Bläddra växtdatabasen och tryck + på det du odlar — sen följer vi växten från sådd till skörd.';

  @override
  String get homeWelcomeCta => 'Bläddra växtdatabasen';

  @override
  String get gardenOverviewTitle => 'Min trädgård just nu';

  @override
  String get gardenSeeAll => 'Se alla';

  @override
  String get gardenStatTotal => 'I trädgården';

  @override
  String get gardenStatHarvestSoon => 'Snart skörd';

  @override
  String get gardenStatReadyNow => 'Redo nu';

  @override
  String gardenMore(Object count) {
    return '+$count till';
  }

  @override
  String get dailyInsightsTitle => 'Idag i trädgården';

  @override
  String get dailyInsightsAllGood =>
      'Allt under kontroll. Inget akut just nu — njut av trädgården.';

  @override
  String get upcomingCareTitle => 'Kommande omsorg';

  @override
  String get upcomingCareSubtitle =>
      'Det här är dags att göra denna och nästa månad.';

  @override
  String seasonPlannerTitle(Object year) {
    return 'Min säsong $year';
  }

  @override
  String get seasonPlannerSubtitle =>
      'Det här vill du odla i år. Du får en notis när det är dags att så.';

  @override
  String seasonPlannerEmptyTitle(Object year) {
    return 'Planera säsongen $year';
  }

  @override
  String get seasonPlannerEmptyBody =>
      'Vad vill du odla i år? Vi påminner dig när det är dags att så.';

  @override
  String get seasonPlannerEmptyCta => 'Välj';

  @override
  String get seasonPlannerAddCta => 'Lägg till växt';

  @override
  String seasonPlannerCount(Object count) {
    return '$count st';
  }

  @override
  String get seasonRowSowNow => 'Så nu';

  @override
  String seasonRowDaysAway(Object days) {
    return 'Om $days dagar';
  }

  @override
  String get seasonRowInSeason => 'I säsong';

  @override
  String get weatherUnavailable => 'Väder ej tillgängligt';

  @override
  String get weatherSetLocation => 'Ange plats i inställningarna';

  @override
  String get dryPeriodTitle => 'Torrperiod pågår';

  @override
  String get frostCardTitle => '❄️ Skydda mot frosten';

  @override
  String get premiumTeaserTitle => 'Plantera Premium';

  @override
  String get premiumTeaserBody => 'Obegränsad trädgård och inga annonser';

  @override
  String get calendarTitle => 'Planteringskalender';

  @override
  String get calendarMonthGuide => 'Månadens guide';

  @override
  String calendarTaskCount(Object count) {
    return '$count uppgifter';
  }

  @override
  String get calendarPhasePresow => 'FÖRODLA INOMHUS';

  @override
  String get calendarPhaseDirectsow => 'DIREKTSÅ UTE';

  @override
  String get calendarPhasePlantout => 'PLANTERA UT';

  @override
  String get calendarPhaseHarvest => 'SKÖRD';

  @override
  String calendarPhaseCount(Object count) {
    return '$count växter';
  }

  @override
  String calendarEmptyTitle(Object month) {
    return 'Inget att så eller skörda i $month';
  }

  @override
  String get calendarEmptyBody =>
      'Använd månaden för planering — beställ frön, planera rabatter eller läs månadens guide.';

  @override
  String get myGardenTitle => 'Mina växter';

  @override
  String get myGardenSearchHint => 'Sök växt eller plats';

  @override
  String get myGardenFilterAll => 'Alla';

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
  String get myGardenEmptyTitle => 'Din trädgård är tom';

  @override
  String get myGardenEmptyBody =>
      'Lägg till växter från databasen så börjar vi bygga din plantering.';

  @override
  String get myGardenEmptyCta => 'Bläddra i växtdatabasen';

  @override
  String get myGardenAddPlant => 'Lägg till växt';

  @override
  String get myGardenNoResults => 'Inga växter matchar';

  @override
  String get myGardenNoResultsBody =>
      'Pröva en annan sökning eller rensa filtren.';

  @override
  String get myGardenWateredNow => 'Vattnad nyss';

  @override
  String get myGardenWateredToday => 'Vattnad idag';

  @override
  String get myGardenWateredYesterday => 'Vattnad igår';

  @override
  String get plantDatabaseTitle => 'Växtdatabas';

  @override
  String get plantDatabaseSearchHint => 'Sök växt';

  @override
  String get plantCategoryAll => 'Alla';

  @override
  String get addPlantNow => 'Lägg till i trädgården nu';

  @override
  String get addPlantNowBody =>
      'Du har sått eller planterat — vi följer den från idag';

  @override
  String get addPlantSeason => 'Lägg till i såningslistan';

  @override
  String get addPlantSeasonBody =>
      'Du planerar att odla — vi pingar när det är dags att så';

  @override
  String get addPlantRemoveSeason => 'Ta bort från såningslistan';

  @override
  String get addPlantRemoveSeasonBody =>
      'Vi slutar påminna om sånings-fönstret';

  @override
  String addedToGardenTitle(Object plant) {
    return '$plant är i din trädgård';
  }

  @override
  String get addedToGardenBodyPlain =>
      'Vi följer den från idag och påminner om vatten och skörd.';

  @override
  String addedToGardenBodyScheduled(Object list) {
    return 'Vi följer den från idag. Notiser inkommande för: $list.';
  }

  @override
  String get addedToGardenCta => 'Ta mig till min trädgård';

  @override
  String get phasePickerTitleNew => 'Var är du i processen?';

  @override
  String get phasePickerTitleEdit => 'Ändra status';

  @override
  String get phaseShowSimple => 'Visa enklare alternativ';

  @override
  String get phaseShowMore => 'Fler alternativ (för den vana odlaren)';

  @override
  String get phaseSimplePlanned => 'Planerar att odla';

  @override
  String get phaseSimplePlannedBody =>
      'Bara på listan — vi påminner när säsongen startar.';

  @override
  String get phaseSimpleGrowing => 'Växer just nu';

  @override
  String get phaseSimpleGrowingBody =>
      'Plantorna är på gång. Vi följer dem fram till skörd.';

  @override
  String get phaseSimpleHarvested => 'Färdigskördad';

  @override
  String get phaseSimpleHarvestedBody =>
      'Säsongen är klar för den här plantan.';

  @override
  String get perennialEstablishedTitle => 'Sedan när har du den?';

  @override
  String get perennialEstablishedBody =>
      'Behöver inte vara exakt – vi använder bara året.';

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
  String get statusPlanning => 'Planerar';

  @override
  String get statusGrowingIndoors => 'Förodlar inomhus';

  @override
  String get statusDirectSown => 'Direktsådd ute';

  @override
  String get statusHardening => 'Härdar av';

  @override
  String get statusOutdoors => 'Står ute';

  @override
  String get statusReadyToHarvest => 'Skördeklar';

  @override
  String get statusHarvested => 'Skördad';

  @override
  String get statusDormant => 'Vilande';

  @override
  String get sowingIndoors => 'Inomhus';

  @override
  String get sowingDirect => 'Direkt';

  @override
  String get sowingPlanta => 'Planta';

  @override
  String get sunFull => 'Full sol';

  @override
  String get sunPartial => 'Halvskugga';

  @override
  String get sunShade => 'Skugga';

  @override
  String get waterSparse => 'Sparsam';

  @override
  String get waterRegular => 'Regelbunden';

  @override
  String get waterAbundant => 'Riklig';

  @override
  String get fertilizerLow => 'Lågt';

  @override
  String get fertilizerMedium => 'Medel';

  @override
  String get fertilizerHigh => 'Högt';

  @override
  String get lifecycleAnnual => 'Annuell';

  @override
  String get lifecycleBiennial => 'Tvåårig';

  @override
  String get lifecyclePerennial => 'Perenn';

  @override
  String get lifecycleTree => 'Träd';

  @override
  String get lifecycleShrub => 'Buske';

  @override
  String get categoryVegetables => 'Grönsaker';

  @override
  String get categoryHerbs => 'Kryddor & örter';

  @override
  String get categoryFlowers => 'Blommor';

  @override
  String get categoryBerries => 'Bär';

  @override
  String get categoryFruitTrees => 'Fruktträd';

  @override
  String get categoryOther => 'Övrigt';

  @override
  String get wateredNow => 'Vattnad nu';

  @override
  String get wateredConfirmation => 'Vattnad ✓';

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
  String get harvestTitle => 'Skörd';

  @override
  String get harvestLog => 'Logga skörd';

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
  String get buttonCancel => 'Avbryt';

  @override
  String get buttonRemove => 'Ta bort';

  @override
  String get buttonSave => 'Spara';

  @override
  String get buttonNext => 'Nästa';

  @override
  String get buttonStart => 'Sätt igång';

  @override
  String get buttonSkip => 'Hoppa över';

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
  String get settingsTitle => 'Inställningar';

  @override
  String get settingsPremiumActive => 'Premium aktivt';

  @override
  String get settingsPremiumUpgrade => 'Uppgradera till Premium';

  @override
  String get settingsPremiumUnlock => 'Lås upp alla funktioner';

  @override
  String get settingsMyGardens => 'Mina trädgårdar';

  @override
  String settingsMyGardensSubtitle(Object emoji, Object name) {
    return 'Aktiv: $emoji $name';
  }

  @override
  String get settingsMyGardensEmpty => 'Lägg till din första trädgård';

  @override
  String get settingsNotifications => 'Påminnelser';

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
  String get settingsSupport => 'Support';

  @override
  String get settingsFeedback => 'Skicka feedback';

  @override
  String get settingsFeedbackBody =>
      'Buggar, funktionsönskemål eller bara ett vänligt hej';

  @override
  String get gardensTitle => 'Mina trädgårdar';

  @override
  String get gardensActive => 'AKTIV';

  @override
  String get gardensAddNew => 'Lägg till ny trädgård';

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
  String get introPage1Title => 'Lägg till växter du odlar';

  @override
  String get introPage1Body =>
      'Tryck + på en växt för att lägga till den i din trädgård. Vi följer den från sådd till skörd och påminner när det är dags att vattna, beskära eller plantera om.';

  @override
  String get introPage1Hint =>
      'Hittar du växten? Använd \"Växter\"-fliken i botten.';

  @override
  String get introPage2Title => 'Planera årets säsong';

  @override
  String get introPage2Body =>
      'Tryck på bokmärket för att lägga växten på din säsongs-lista. Du får en notis i februari/mars när det är dags att börja förodla, och i april när det är dags att direktså.';

  @override
  String get introPage2Hint => 'Säsongs-listan ser du på startsidan.';

  @override
  String get introPage3Title => 'Stenkoll på din trädgård';

  @override
  String get introPage3Body =>
      'Hem-sidan visar väder, torrperioder och vad du ska göra denna månad. På \"Min trädgård\"-fliken kan du se årets statistik, växtföljd och uppskattat värde av din skörd.';

  @override
  String get introPage3Hint =>
      'Skadedjur & sjukdomar finns i Inställningar när du behöver dem.';

  @override
  String get pestLibraryTitle => 'Skadedjur & sjukdomar';

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
  String get tabTodo => 'Att göra';

  @override
  String get todoSectionToday => 'IDAG';

  @override
  String get todoSectionWeek => 'DENNA VECKA';

  @override
  String get todoSectionMonth => 'DENNA MÅNAD';

  @override
  String get todoSectionDoneToday => 'KLART IDAG ✓';

  @override
  String get todoStatToday => 'idag';

  @override
  String get todoStatWeek => 'denna vecka';

  @override
  String get todoStatDone => 'klart';

  @override
  String get todoEmptyTitle => 'Allt under kontroll';

  @override
  String get todoEmptyBody =>
      'Inget akut just nu. Lägg till växter i din trädgård för att börja få dagliga uppgifter.';

  @override
  String get todoSwipeDone => 'Klar';

  @override
  String get todoSwipeSnooze => 'Skjut upp';

  @override
  String get progressReadyToHarvest => 'Redo att skördas';

  @override
  String get progressHarvestNow => 'Skörda nu';

  @override
  String progressDaysLeft(Object days) {
    return '$days dagar kvar';
  }

  @override
  String progressApproxDaysLeft(Object days) {
    return '~$days dagar kvar';
  }

  @override
  String get climateCardTitle => 'Klimat senaste 14 dagar';

  @override
  String get climateStatAvg => 'Medeldygn';

  @override
  String get climateStatMinMax => 'Min/max';

  @override
  String get climateStatGdd => 'GDD';

  @override
  String get climateInterpretWaking => 'Trädgården vaknar.';

  @override
  String get climateInterpretEarly =>
      'Mycket tidig säsong – bara köldtåligt växer (lök, ärtor, sallad).';

  @override
  String get climateInterpretSpring =>
      'Vårsäsong – direktsådd grönsaker etablerar sig, värmekänsliga ska vänta.';

  @override
  String get climateInterpretMidSpring =>
      'Mid-vår – tomat och paprika kan ut med fiberduk eller i växthus.';

  @override
  String get climateInterpretFullGrowth =>
      'Fullt växttryck – allt mognar snabbt, vattna och gödsla.';

  @override
  String get climateInterpretHot =>
      'Het period – var noga med vatten på unga plantor.';

  @override
  String get climateTeaserTitle => 'Klimatkort (Premium)';

  @override
  String get climateTeaserBody =>
      'Medel-dygnstemp + Growing Degree Days för bättre tajming av sådd och skörd.';

  @override
  String get weatherSetLocationHint => 'Ange plats i inställningarna';

  @override
  String weatherFrostWarning(String date, String temp) {
    return 'Frostvarning $date – $temp°C';
  }

  @override
  String dryPeriodBodyWithThirsty(
    String past,
    String next,
    String names,
    String more,
  ) {
    return 'Bara $past mm regn senaste 14 dagarna och $next mm väntas kommande veckan. Vattna $names$more — torrkänsliga växter klarar sig längre.';
  }

  @override
  String dryPeriodBodyGeneral(String past, String next) {
    return 'Bara $past mm regn senaste 14 dagarna och $next mm väntas kommande veckan. Vattna noga, särskilt nyplanterade och i krukor.';
  }

  @override
  String get dryPeriodMoreSuffix => ' m.fl.';

  @override
  String get myGardenWaterAllTooltip => 'Vattna alla utomhus-växter';

  @override
  String myGardenSeasonStatsTooltip(String year) {
    return 'Min säsong $year';
  }

  @override
  String get myGardenGroupTooltip => 'Gruppera efter';

  @override
  String get myGardenNoOutdoorPlants =>
      'Inga utomhus-växter att vattna just nu.';

  @override
  String get myGardenWaterAllTitle => 'Vattna alla?';

  @override
  String myGardenWaterAllConfirm(String count) {
    return 'Markerar $count utomhus-växter som vattnade just nu.';
  }

  @override
  String get myGardenWaterAllCancel => 'Avbryt';

  @override
  String get myGardenWaterAllAction => 'Vattna alla';

  @override
  String myGardenWaterAllDone(String count) {
    return '$count växter vattnade ✓';
  }

  @override
  String get myGardenLocationNone => 'Utan plats';

  @override
  String get myGardenCategoryOther => 'Övrigt';

  @override
  String myGardenStatusSince(String status, String year) {
    return '$status • sedan $year';
  }

  @override
  String myGardenStatusOnDate(String status, String date) {
    return '$status • $date';
  }

  @override
  String settingsMyGardensWithCount(String count) {
    return 'Mina trädgårdar ($count)';
  }

  @override
  String get settingsPlanMonthly => 'Månadsprenumeration';

  @override
  String get settingsPlanYearly => 'Årsprenumeration';

  @override
  String get settingsPlanLifetime => 'Livstidsköp';

  @override
  String get settingsPlanFree => 'Gratis';

  @override
  String get settingsStarterKit => '🛒 Nybörjarkit';

  @override
  String get settingsMorningHourPickerTitle => 'När vill du få morgon-pingen?';

  @override
  String get settingsMorningHourPickerBody =>
      'Trädgårdsmorgon-summeringen och alla planteringstider fyrar denna timme. Ingenting väcker dig innan.';

  @override
  String settingsHourFormat(String hour) {
    return 'Kl $hour:00';
  }

  @override
  String settingsBackupFailed(String error) {
    return 'Kunde inte skapa backup: $error';
  }

  @override
  String get settingsFeedbackSubject => 'Plantera feedback';

  @override
  String settingsFeedbackBodyTemplate(String version) {
    return 'Hej!\n\nFeedback / fråga / buggrapport:\n\n\n— Skickat från Plantera $version';
  }

  @override
  String get gardensDelete => 'Ta bort';

  @override
  String get gardensCancel => 'Avbryt';

  @override
  String get gardensNameLabel => 'Namn';

  @override
  String gardensZoneDescription(String zone, String description) {
    return 'Zon $zone – $description';
  }

  @override
  String gardensCityFormat(String city, String zone) {
    return '$city · $zone';
  }

  @override
  String get introSkip => 'Hoppa över';

  @override
  String get introNext => 'Nästa';

  @override
  String get introStart => 'Sätt igång';

  @override
  String get onboardingWelcome => 'Välkommen till Plantera';

  @override
  String get onboardingBody =>
      'Välj din plats för personliga råd, frostvarningar och rätt såtider för just din odlingszon.';

  @override
  String get onboardingUseGps => 'Använd min plats';

  @override
  String get onboardingLocating => 'Hämtar plats…';

  @override
  String get onboardingOrPickCity => 'eller välj stad';

  @override
  String onboardingZoneSubtitle(String zone) {
    return 'Zon $zone';
  }

  @override
  String get onboardingErrorLocationServicesOff => 'Platstjänster är avstängda';

  @override
  String get onboardingErrorLocationDenied => 'Platsbehörighet nekad';

  @override
  String get phasePerennialHaveIt => 'Jag har den i trädgården';

  @override
  String get phasePerennialHaveItBody =>
      'Vi visar förväntad skörd och påminner om beskärning, gödning och annan säsongs-omsorg.';

  @override
  String get phasePerennialPlanning => 'Planerar att plantera';

  @override
  String get phasePerennialPlanningBody =>
      'Bara på listan tills du faktiskt planterar — påminnelser kommer i god tid.';

  @override
  String get phaseDetailedPlanned => 'Planerar att odla';

  @override
  String get phaseDetailedPlannedBody =>
      'Bara för listan — påminnelser kommer i god tid när säsongen startar.';

  @override
  String get phaseDetailedPresow => 'Jag förodlar inomhus';

  @override
  String get phaseDetailedPresowBody =>
      'Plantorna växer inomhus. Få härda av-påminnelse om 5 veckor.';

  @override
  String get phaseDetailedDirectsow => 'Jag har direktsått ute';

  @override
  String get phaseDetailedDirectsowBody =>
      'Sått direkt på växtplats. Skördepåminnelse återstår.';

  @override
  String get phaseDetailedPlantout => 'Plantorna är utplanterade';

  @override
  String get phaseDetailedPlantoutBody =>
      'Står på sin slutliga växtplats. Skördepåminnelse återstår.';

  @override
  String get phaseFinishedReady => 'Klar för skörd';

  @override
  String get phaseFinishedReadyBody => 'Markeras som skördeklar nu.';

  @override
  String get phaseFinishedHarvested => 'Skördad';

  @override
  String get phaseFinishedHarvestedBody =>
      'Säsongen är klar — påminnelser pausas.';

  @override
  String get phaseFinishedDormant => 'Vilande';

  @override
  String get phaseFinishedDormantBody => 'Plantan är inte aktiv just nu.';

  @override
  String get phaseDateHelpPresow =>
      'Vilket datum började du odla denna planta?';

  @override
  String get phaseDateHelpDirectsow => 'Vilket datum direktsådde du?';

  @override
  String get phaseDateHelpPlantout => 'Vilket datum kom plantorna ut?';

  @override
  String get phaseDateHelpDefault => 'Datum';

  @override
  String get phasePerennialYearTitle => 'Sedan när har du den?';

  @override
  String get phasePerennialYearBody =>
      'Behöver inte vara exakt – vi använder bara året.';

  @override
  String phasePerennialYearThis(String year) {
    return 'I år ($year)';
  }

  @override
  String phasePerennialYearLast(String year) {
    return 'Förra året ($year)';
  }

  @override
  String phasePerennialYearTwo(String year) {
    return 'Två år sedan ($year)';
  }

  @override
  String get phasePerennialYearOlder => 'Tidigare (några år sedan)';

  @override
  String get plantDetailTabOverview => 'Översikt';

  @override
  String get plantDetailTabMyPlant => 'Min planta';

  @override
  String get plantDetailTabCare => 'Omsorg';

  @override
  String get plantDetailAddCta => 'Lägg till i min trädgård';

  @override
  String get plantDetailRemoveCta => 'Ta bort från trädgården';

  @override
  String get plantDetailRemoveTitle => 'Ta bort från trädgården?';

  @override
  String get plantDetailRemoveBody => 'Detta kan inte ångras.';

  @override
  String get plantDetailCancel => 'Avbryt';

  @override
  String get plantDetailDelete => 'Ta bort';

  @override
  String get plantDetailSave => 'Spara';

  @override
  String get plantDetailReset => 'Återställ';

  @override
  String get plantDetailReuse => 'Använd igen';

  @override
  String get plantDetailWaterNowSuffix => 'Vattnad nu';

  @override
  String get plantDetailWaterTapHint =>
      'Tryck när du vattnar för att hålla koll';

  @override
  String get plantDetailWaterDoneSnack => 'Vattnad ✓';

  @override
  String get plantDetailWaterNotYet => 'Inte vattnad än';

  @override
  String get plantDetailWaterJust => 'Nyss vattnad';

  @override
  String get plantDetailWaterToday => 'Vattnad idag';

  @override
  String get plantDetailWaterYesterday => 'Vattnad igår';

  @override
  String get plantDetailUpcomingCareTitle => '📅  KOMMANDE OMSORG';

  @override
  String get plantDetailDueNow => 'Dags nu';

  @override
  String get plantDetailEditPostsTooltip => 'Hantera inlägg';

  @override
  String get plantDetailNoteHint => 'Skriv en kort anteckning…';

  @override
  String get plantDetailNoteTitle => 'Anteckning';

  @override
  String get plantDetailNoteSubtitle =>
      'Vad hände idag? Bladlöss, första blomman, beskärning…';

  @override
  String get plantDetailTakePhoto => 'Ta foto';

  @override
  String get plantDetailPickLibrary => 'Välj från bibliotek';

  @override
  String get plantDetailWriteNote => 'Skriv anteckning';

  @override
  String get plantDetailUseEmojiAgain => 'Använd emoji igen';

  @override
  String plantDetailSaveImageError(String error) {
    return 'Kunde inte spara bild: $error';
  }

  @override
  String plantDetailSavePhotoError(String error) {
    return 'Kunde inte spara foto: $error';
  }

  @override
  String get plantDetailDeletePhotoTitle => 'Ta bort foto?';

  @override
  String get plantDetailDeleteNoteTitle => 'Ta bort anteckning?';

  @override
  String get plantDetailDeletePhotoBody => 'Bilden raderas från enheten.';

  @override
  String get plantDetailDeleteNoteBody => 'Anteckningen försvinner.';

  @override
  String get plantDetailAdd => 'Lägg till';

  @override
  String get plantDetailNoPostsBody =>
      'Inga inlägg ännu — börja dokumentera tillväxten med foton och korta anteckningar.';

  @override
  String get plantDetailChangeStatus => 'Ändra status';

  @override
  String get plantDetailLocationLabel => 'Plats';

  @override
  String plantDetailSowingMethodChip(String method) {
    return 'Sår: $method';
  }

  @override
  String plantDetailSowingMethodSnack(String method) {
    return 'Sårmetod: $method';
  }

  @override
  String get plantDetailDateHelp => 'Vilket datum?';

  @override
  String get plantDetailHowSowTitle => 'Hur sår du?';

  @override
  String get plantDetailHowSowBody => 'Avgör vilka påminnelser du får.';

  @override
  String get plantDetailLocationTitle => 'Var står den?';

  @override
  String get plantDetailLocationBody =>
      'T.ex. \"norra rabatten\", \"växthuset\", \"balkongen\".';

  @override
  String get plantDetailHarvestOffsetTitle => 'Justera skördetid';

  @override
  String get plantDetailHarvestOffsetBody =>
      'Räknaren ligger fel? Lägg till eller dra av dagar — sparas på just denna planta.';

  @override
  String get plantDetailReadyToHarvest => 'Redo att skördas';

  @override
  String get plantDetailNextStepPresow => 'Jag har förodlat inomhus';

  @override
  String get plantDetailNextStepDirectsow => 'Jag har direktsått';

  @override
  String get plantDetailNextStepPlantout => 'Jag har utplanterat';

  @override
  String get plantDetailNextStepPlantedOut => 'Plantorna är utplanterade';

  @override
  String get plantDetailNextStepHarvestReady => 'Klar för skörd';

  @override
  String get plantDetailNextStepHarvested => 'Skördad';

  @override
  String get plantDetailHowToTitle => 'Så här gör du';

  @override
  String get plantDetailTipsTitle => 'Tips';

  @override
  String get plantDetailPestsTitle => 'Skadedjur att bevaka';

  @override
  String get plantDetailNoCareTips => 'Inga skötselråd tillgängliga ännu.';

  @override
  String get plantDetailInfoSun => 'Sol';

  @override
  String get plantDetailInfoWater => 'Vatten';

  @override
  String get plantDetailInfoFertilizer => 'Gödsel';

  @override
  String get plantDetailInfoFrost => 'Tål till';

  @override
  String get plantDetailInfoSpacing => 'Avstånd';

  @override
  String get plantDetailInfoHarvest => 'Skörd';

  @override
  String get plantDetailHarvestSection => '🥕  Skörd';

  @override
  String get plantDetailToolsSection => '🛒 Verktyg och tillbehör';

  @override
  String get plantDetailSeasonSection => 'Säsong';

  @override
  String get plantDetailPhasePresow => 'Förodla';

  @override
  String get plantDetailPhaseDirectsow => 'Direktså';

  @override
  String get plantDetailPhasePlantout => 'Plantera ut';

  @override
  String get plantDetailPhaseHarvest => 'Skörd';

  @override
  String get plantDetailZoneWarningBody =>
      'Det kan gå – men du behöver troligen vinterskydd eller en varmare plats.';

  @override
  String plantDetailDateAdded(String date) {
    return 'Tillagd $date';
  }

  @override
  String plantDetailDateInGardenSince(String year) {
    return 'I trädgården sedan $year';
  }

  @override
  String plantDetailDatePlanted(String date) {
    return 'Planterad $date';
  }

  @override
  String get plantDetailHarvestOffsetSubtitle => 'Justera skördetid';

  @override
  String plantDetailZoneWarning(String zone) {
    return 'Den här växten är inte testad för zon $zone. Det kan gå – men du behöver troligen vinterskydd eller en varmare plats.';
  }

  @override
  String get harvestSectionTitle => '🥕 Skörd';

  @override
  String get harvestRemoveTitle => 'Ta bort post?';

  @override
  String harvestRemoveBody(String amount, String unit, String date) {
    return '$amount $unit från $date tas bort.';
  }

  @override
  String harvestMoreEntries(String count) {
    return '+ $count äldre poster';
  }

  @override
  String harvestAddTitle(String plant) {
    return 'Logga skörd — $plant';
  }

  @override
  String get harvestAmountLabel => 'Mängd';

  @override
  String get harvestUnitLabel => 'Enhet';

  @override
  String get harvestNotesLabel => 'Anteckning (valfritt)';

  @override
  String get harvestErrorAmountTooLow => 'Ange en mängd större än 0';

  @override
  String get harvestErrorFutureDate => 'Du kan inte logga skörd i framtiden';

  @override
  String get commonCancel => 'Avbryt';

  @override
  String get commonDelete => 'Ta bort';

  @override
  String get commonSave => 'Spara';

  @override
  String get pestTypeLabelDisease => 'SJUKDOM';

  @override
  String get pestTypeLabelDamage => 'SKADA';

  @override
  String get pestTypeLabelPest => 'SKADEDJUR';

  @override
  String get statsShareButton => 'Dela';

  @override
  String statsShareText(String year) {
    return 'Min trädgård $year med Plantera 🌱';
  }

  @override
  String get statsShareFailed => 'Kunde inte skapa delningsbild';

  @override
  String get paywallTitleBranded => 'Plantera Premium';

  @override
  String get paywallHeaderFrost => 'Få frostvarning innan plantorna fryser';

  @override
  String get paywallHeaderGardenLimit => 'Lägg till hela trädgården';

  @override
  String get paywallHeaderWaterAll => 'Vattna alla med ett tryck';

  @override
  String get paywallHeaderPhotoLog => 'Fotodagbok för dina växter';

  @override
  String get paywallSubFrost =>
      'SMHI-baserad nattetemp — vi pingar dig kvällen före frostnatten';

  @override
  String get paywallSubGardenLimit => 'Inga gränser på antal växter du följer';

  @override
  String get paywallSubWaterAll =>
      'En knapp markerar alla utomhusväxter vattnade';

  @override
  String get paywallSubPhotoLog => 'Se hur de växer från frö till skörd';

  @override
  String get paywallSubHome => 'Frostvarningar, fotodagbok och allt obegränsat';

  @override
  String get paywallSubDefault => 'Växla upp din trädgård';

  @override
  String get paywallBenefitUnlimited => 'Obegränsade växter i min trädgård';

  @override
  String get paywallBenefitReminders => 'Alla påminnelser och frostvarningar';

  @override
  String get paywallBenefitPhotos => 'Fotodagbok för varje växt';

  @override
  String get paywallBenefitNoAds => 'Inga annonser';

  @override
  String get paywallBenefitPdf => 'PDF-export av skördedagbok';

  @override
  String get paywallBenefitArticles => 'Full tillgång till kunskapsartiklar';

  @override
  String get paywallPlanYearly => 'Årsprenumeration';

  @override
  String paywallPlanYearlySavings(String percent) {
    return 'Spara $percent% jämfört med månad';
  }

  @override
  String get paywallPlanMonthly => 'Månadsprenumeration';

  @override
  String get paywallPlanLifetime => 'Livstidsköp (engångsbetalning)';

  @override
  String paywallTrialCta(String period) {
    return 'Starta gratis provperiod ($period)';
  }

  @override
  String paywallTrialThen(String price) {
    return 'Sedan $price';
  }

  @override
  String paywallPlanPriceFormat(String title, String price) {
    return '$title • $price';
  }

  @override
  String get paywallRestore => 'Återställ tidigare köp';

  @override
  String get paywallDisclaimer =>
      'Prenumerationer förnyas automatiskt tills de avslutas i App Store-inställningarna. Avgiften dras 24 h före förnyelse.';

  @override
  String get paywallTerms => 'Villkor (EULA)';

  @override
  String get paywallPrivacy => 'Integritetspolicy';

  @override
  String get paywallErrorStore =>
      'App Store är inte tillgängligt just nu — försök igen om en stund.';

  @override
  String get paywallErrorProduct =>
      'Köpet kunde inte laddas från App Store. Stäng paywallen och öppna igen.';

  @override
  String get paywallErrorFailed => 'Köpet misslyckades. Försök igen.';

  @override
  String paywallErrorOpenUrl(String url) {
    return 'Kunde inte öppna $url';
  }

  @override
  String get paywallPurchaseSuccess =>
      'Premium aktiverat — tack! Allt är upplåst.';

  @override
  String get paywallRestoreInProgress => 'Söker efter dina köp…';

  @override
  String get paywallRestoreFailed =>
      'Kunde inte kontakta App Store. Försök igen.';

  @override
  String get paywallRestoreSuccess => 'Premium återställd — tack!';

  @override
  String get paywallRestoreAlreadyActive => 'Premium är redan aktivt.';

  @override
  String get paywallRestoreNothingFound =>
      'Inga köp hittades på det här Apple-ID:t.';

  @override
  String get paywallAlreadyPremiumTitle => 'Du har Premium';

  @override
  String get paywallAlreadyPremiumBody =>
      'Alla funktioner är upplåsta. Tack för stödet — det hjälper oss bygga vidare.';

  @override
  String get paywallAlreadyPremiumCta => 'Tillbaka till trädgården';

  @override
  String get paywallProductsUnavailable =>
      'Kunde inte ladda priserna från App Store. Kolla din internet och försök igen.';

  @override
  String get paywallProductsRetry => 'Försök igen';

  @override
  String get onboardingSlide1Title => 'Sluta gissa när du ska så';

  @override
  String get onboardingSlide1Body =>
      'Plantera vet din odlingszon och säger åt dig exakt när det är dags att förodla, direktså eller plantera ut — växt för växt.';

  @override
  String get onboardingSlide2Title => 'Frostvarning från SMHI';

  @override
  String get onboardingSlide2Body =>
      'När det blir kallt om natten får du en notis i tid att täcka över spirorna. Inte panik klockan tre på natten.';

  @override
  String get onboardingSlide3Title => 'En morgonpåminnelse — inte 50';

  @override
  String get onboardingSlide3Body =>
      'Vatten, beskärning, skörd och säsongs-sysslor samlas i en daglig översikt så du faktiskt får en skörd att vara stolt över.';

  @override
  String get onboardingFooterSkip => 'Hoppa över';

  @override
  String get onboardingFooterNext => 'Nästa';

  @override
  String get onboardingFooterStart => 'Kom igång';
}
