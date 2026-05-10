// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appName => 'Plantera';

  @override
  String get appSubtitle => 'Din digitale hagekompis';

  @override
  String get tabHome => 'Hjem';

  @override
  String get tabCalendar => 'Kalender';

  @override
  String get tabPlants => 'Planter';

  @override
  String get tabMyGarden => 'Mine planter';

  @override
  String get tabSettings => 'Innstillinger';

  @override
  String get tabOverview => 'Oversikt';

  @override
  String get tabMyPlant => 'Min plante';

  @override
  String get tabCare => 'Stell';

  @override
  String get homeWelcomeTitle => 'La oss begynne med din første plante';

  @override
  String get homeWelcomeBody =>
      'Bla i plantedatabasen og trykk + på det du dyrker — vi følger den fra såing til høsting.';

  @override
  String get homeWelcomeCta => 'Bla i planter';

  @override
  String get gardenOverviewTitle => 'Nærmeste høst';

  @override
  String get gardenSeeAll => 'Se alle';

  @override
  String get gardenStatTotal => 'I hagen';

  @override
  String get gardenStatHarvestSoon => 'Snart høst';

  @override
  String get gardenStatReadyNow => 'Klar nå';

  @override
  String gardenMore(Object count) {
    return '+$count til';
  }

  @override
  String get dailyInsightsTitle => 'I dag i hagen';

  @override
  String get dailyInsightsAllGood =>
      'Alt under kontroll. Ingenting akutt — nyt hagen.';

  @override
  String get upcomingCareTitle => 'Kommende stell';

  @override
  String get upcomingCareSubtitle => 'Ting å gjøre denne og neste måned.';

  @override
  String seasonPlannerTitle(Object year) {
    return 'Min sesong $year';
  }

  @override
  String get seasonPlannerSubtitle =>
      'Det du vil dyrke i år. Vi varsler deg når det er på tide å så.';

  @override
  String seasonPlannerEmptyTitle(Object year) {
    return 'Planlegg sesongen $year';
  }

  @override
  String get seasonPlannerEmptyBody =>
      'Hva vil du dyrke i år? Vi minner deg på når det er tid for å så.';

  @override
  String get seasonPlannerEmptyCta => 'Velg';

  @override
  String get seasonPlannerAddCta => 'Legg til plante';

  @override
  String seasonPlannerCount(Object count) {
    return '$count stk';
  }

  @override
  String get seasonRowSowNow => 'Så nå';

  @override
  String seasonRowDaysAway(Object days) {
    return 'Om $days dager';
  }

  @override
  String get seasonRowInSeason => 'I sesong';

  @override
  String get weatherUnavailable => 'Vær utilgjengelig';

  @override
  String get weatherSetLocation => 'Sett din plassering i innstillinger';

  @override
  String get dryPeriodTitle => 'Tørkeperiode pågår';

  @override
  String get frostCardTitle => '❄️ Beskytt mot frost';

  @override
  String get premiumTeaserTitle => 'Plantera Premium';

  @override
  String get premiumTeaserBody => 'Ubegrenset hage og ingen annonser';

  @override
  String get calendarTitle => 'Plantingskalender';

  @override
  String get calendarMonthGuide => 'Månedens guide';

  @override
  String calendarTaskCount(Object count) {
    return '$count oppgaver';
  }

  @override
  String get calendarPhasePresow => 'FORSÅ INNE';

  @override
  String get calendarPhaseDirectsow => 'DIREKTESÅING UTE';

  @override
  String get calendarPhasePlantout => 'PLANT UT';

  @override
  String get calendarPhaseHarvest => 'HØST';

  @override
  String calendarPhaseCount(Object count) {
    return '$count planter';
  }

  @override
  String calendarEmptyTitle(Object month) {
    return 'Ingenting å så eller høste i $month';
  }

  @override
  String get calendarEmptyBody =>
      'Bruk måneden til planlegging — bestill frø, planlegg bed eller les månedens guide.';

  @override
  String get myGardenTitle => 'Mine planter';

  @override
  String get myGardenSearchHint => 'Søk plante eller plassering';

  @override
  String get myGardenFilterAll => 'Alle';

  @override
  String get myGardenGroupByStatus => 'Grupper etter status';

  @override
  String get myGardenGroupByLocation => 'Grupper etter plassering';

  @override
  String get myGardenGroupByCategory => 'Grupper etter kategori';

  @override
  String myGardenShowingCount(Object shown, Object total) {
    return 'Viser $shown av $total';
  }

  @override
  String get myGardenEmptyTitle => 'Hagen din er tom';

  @override
  String get myGardenEmptyBody =>
      'Legg til planter fra databasen for å bygge hagen din.';

  @override
  String get myGardenEmptyCta => 'Bla i plantedatabasen';

  @override
  String get myGardenAddPlant => 'Legg til plante';

  @override
  String get myGardenNoResults => 'Ingen planter samsvarer';

  @override
  String get myGardenNoResultsBody => 'Prøv et annet søk eller fjern filtre.';

  @override
  String get myGardenWateredNow => 'Vannet nå';

  @override
  String get myGardenWateredToday => 'Vannet i dag';

  @override
  String get myGardenWateredYesterday => 'Vannet i går';

  @override
  String get plantDatabaseTitle => 'Plantedatabase';

  @override
  String get plantDatabaseSearchHint => 'Søk plante';

  @override
  String get plantCategoryAll => 'Alle';

  @override
  String get addPlantNow => 'Legg til i hagen nå';

  @override
  String get addPlantNowBody =>
      'Du har sådd eller plantet — vi følger den fra i dag';

  @override
  String get addPlantSeason => 'Legg til på såingslisten';

  @override
  String get addPlantSeasonBody =>
      'Du planlegger å dyrke — vi varsler når det er tid for å så';

  @override
  String get addPlantRemoveSeason => 'Fjern fra såingslisten';

  @override
  String get addPlantRemoveSeasonBody => 'Vi slutter å minne om såvinduet';

  @override
  String addedToGardenTitle(Object plant) {
    return '$plant er i hagen din';
  }

  @override
  String get addedToGardenBodyPlain =>
      'Vi følger den fra i dag og minner om vann og høst.';

  @override
  String addedToGardenBodyScheduled(Object list) {
    return 'Vi følger den fra i dag. Varsler kommer for: $list.';
  }

  @override
  String get addedToGardenCta => 'Ta meg til hagen min';

  @override
  String get phasePickerTitleNew => 'Hvor er du i prosessen?';

  @override
  String get phasePickerTitleEdit => 'Endre status';

  @override
  String get phaseShowSimple => 'Vis enklere alternativer';

  @override
  String get phaseShowMore => 'Flere alternativer (for erfarne)';

  @override
  String get phaseSimplePlanned => 'Planlegger å dyrke';

  @override
  String get phaseSimplePlannedBody =>
      'Bare på listen — vi minner når sesongen starter.';

  @override
  String get phaseSimpleGrowing => 'Vokser akkurat nå';

  @override
  String get phaseSimpleGrowingBody =>
      'Plantene er i gang. Vi følger dem til høst.';

  @override
  String get phaseSimpleHarvested => 'Allerede høstet';

  @override
  String get phaseSimpleHarvestedBody =>
      'Sesongen er ferdig for denne planten.';

  @override
  String get perennialEstablishedTitle => 'Siden når har du den?';

  @override
  String get perennialEstablishedBody =>
      'Trenger ikke være eksakt – vi bruker bare året.';

  @override
  String perennialThisYear(Object year) {
    return 'I år ($year)';
  }

  @override
  String perennialLastYear(Object year) {
    return 'I fjor ($year)';
  }

  @override
  String perennialTwoYearsAgo(Object year) {
    return 'To år siden ($year)';
  }

  @override
  String get perennialEarlier => 'Tidligere (noen år tilbake)';

  @override
  String get statusPlanning => 'Planlegger';

  @override
  String get statusGrowingIndoors => 'Forsår inne';

  @override
  String get statusDirectSown => 'Direkte sådd ute';

  @override
  String get statusHardening => 'Herder av';

  @override
  String get statusOutdoors => 'Står ute';

  @override
  String get statusReadyToHarvest => 'Klar for høst';

  @override
  String get statusHarvested => 'Høstet';

  @override
  String get statusDormant => 'Hviler';

  @override
  String get sowingIndoors => 'Inne';

  @override
  String get sowingDirect => 'Direkte';

  @override
  String get sowingPlanta => 'Plante';

  @override
  String get sunFull => 'Full sol';

  @override
  String get sunPartial => 'Halvskygge';

  @override
  String get sunShade => 'Skygge';

  @override
  String get waterSparse => 'Sparsom';

  @override
  String get waterRegular => 'Regelmessig';

  @override
  String get waterAbundant => 'Rikelig';

  @override
  String get fertilizerLow => 'Lav';

  @override
  String get fertilizerMedium => 'Middels';

  @override
  String get fertilizerHigh => 'Høy';

  @override
  String get lifecycleAnnual => 'Ettårig';

  @override
  String get lifecycleBiennial => 'Toårig';

  @override
  String get lifecyclePerennial => 'Flerårig';

  @override
  String get lifecycleTree => 'Tre';

  @override
  String get lifecycleShrub => 'Busk';

  @override
  String get categoryVegetables => 'Grønnsaker';

  @override
  String get categoryHerbs => 'Krydder & urter';

  @override
  String get categoryFlowers => 'Blomster';

  @override
  String get categoryBerries => 'Bær';

  @override
  String get categoryFruitTrees => 'Frukttrær';

  @override
  String get categoryOther => 'Annet';

  @override
  String get wateredNow => 'Vannet';

  @override
  String get wateredConfirmation => 'Vannet ✓';

  @override
  String get notWateredYet => 'Ikke vannet ennå';

  @override
  String get wateredJustNow => 'Vannet nettopp';

  @override
  String wateredDaysAgo(Object days) {
    return 'Vannet for $days dager siden';
  }

  @override
  String wateredWeeksAgo(Object weeks) {
    return 'Vannet for $weeks uker siden';
  }

  @override
  String get journalTitle => 'Dagbok';

  @override
  String journalCount(Object count) {
    return '$count';
  }

  @override
  String get journalAdd => 'Legg til';

  @override
  String get journalEmpty =>
      'Ingen oppføringer ennå — begynn å dokumentere veksten med foto og korte notater.';

  @override
  String get journalNoteTitle => 'Notat';

  @override
  String get journalNoteBody =>
      'Hva skjedde i dag? Bladlus, første blomst, beskjæring…';

  @override
  String get journalNoteHint => 'Skriv et kort notat…';

  @override
  String get journalSave => 'Lagre';

  @override
  String get journalDeletePhoto => 'Slett foto?';

  @override
  String get journalDeletePhotoBody => 'Bildet fjernes fra enheten.';

  @override
  String get journalDeleteNote => 'Slett notat?';

  @override
  String get journalDeleteNoteBody => 'Notatet fjernes.';

  @override
  String get journalManage => 'Administrer oppføring';

  @override
  String get actionTakePhoto => 'Ta foto';

  @override
  String get actionPickFromLibrary => 'Velg fra biblioteket';

  @override
  String get actionWriteNote => 'Skriv et notat';

  @override
  String get harvestTitle => 'Høst';

  @override
  String get harvestLog => 'Loggfør høst';

  @override
  String get harvestEmpty =>
      'Loggfør hva du høster så bygger appen statistikk år for år.';

  @override
  String harvestTotalLabel(Object amount, Object unit) {
    return 'Totalt: $amount $unit';
  }

  @override
  String harvestEstimatedSek(Object amount) {
    return '~$amount kr';
  }

  @override
  String get nextStepBecomeIndoor => 'Jeg har sådd inne';

  @override
  String get nextStepBecomeDirect => 'Jeg har direktesådd';

  @override
  String get nextStepBecomePlanted => 'Jeg har plantet ut';

  @override
  String get nextStepHardenedToPlanted => 'Plantene er ute';

  @override
  String get nextStepReadyForHarvest => 'Klar for høst';

  @override
  String get nextStepHarvested => 'Høstet';

  @override
  String get secondaryChangeStatus => 'Endre status';

  @override
  String get secondaryRemove => 'Fjern';

  @override
  String get secondaryRemoveConfirmTitle => 'Fjerne fra hagen?';

  @override
  String secondaryRemoveConfirmBody(Object plant) {
    return '$plant og alle påminnelser fjernes. Dette kan ikke angres.';
  }

  @override
  String get buttonCancel => 'Avbryt';

  @override
  String get buttonRemove => 'Fjern';

  @override
  String get buttonSave => 'Lagre';

  @override
  String get buttonNext => 'Neste';

  @override
  String get buttonStart => 'Sett i gang';

  @override
  String get buttonSkip => 'Hopp over';

  @override
  String get locationLabel => 'Plassering';

  @override
  String get locationAdd => 'Legg til plassering';

  @override
  String get locationPickerTitle => 'Hvor står den?';

  @override
  String get locationPickerBody =>
      'F.eks. \"nordbedet\", \"drivhus\", \"balkong\".';

  @override
  String get locationReuse => 'Bruk igjen';

  @override
  String get settingsTitle => 'Innstillinger';

  @override
  String get settingsPremiumActive => 'Premium aktivt';

  @override
  String get settingsPremiumUpgrade => 'Oppgrader til Premium';

  @override
  String get settingsPremiumUnlock => 'Lås opp alle funksjoner';

  @override
  String get settingsMyGardens => 'Mine hager';

  @override
  String settingsMyGardensSubtitle(Object emoji, Object name) {
    return 'Aktiv: $emoji $name';
  }

  @override
  String get settingsMyGardensEmpty => 'Legg til din første hage';

  @override
  String get settingsNotifications => 'Påminnelser';

  @override
  String get settingsNotificationsBody => 'Frostvarsler og plantingstider';

  @override
  String get settingsMorningHour => 'Morgentid for påminnelser';

  @override
  String settingsMorningHourBody(Object hour) {
    return 'Hagemorgen-pings fyrer kl $hour:00';
  }

  @override
  String get settingsLargeText => 'Stor tekst';

  @override
  String get settingsLargeTextBody => 'Litt større tekst i hele appen';

  @override
  String get settingsSimpleStatus => 'Enkel status';

  @override
  String get settingsSimpleStatusBody =>
      'Vis kun 3 hovedtilstander (planlegger / vokser / høstet). Slå av for full livssyklus.';

  @override
  String get settingsPestLibrary => 'Skadedyr & sykdommer';

  @override
  String get settingsPestLibraryBody => 'Bibliotek over vanlige problemer';

  @override
  String get settingsIntro => 'Vis introduksjon';

  @override
  String get settingsIntroBody =>
      'Rask gjennomgang av Pluss-knappen, sesongplanleggeren og hvordan appen fungerer';

  @override
  String get settingsBackup => 'Sikkerhetskopi';

  @override
  String get settingsBackupBody =>
      'Eksporter hagen og høsten – lagre på iCloud Drive eller send til deg selv';

  @override
  String get settingsRestorePurchases => 'Gjenopprett kjøp';

  @override
  String get settingsPrivacyPolicy => 'Personvernerklæring';

  @override
  String get settingsTerms => 'Brukervilkår (EULA)';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsFeedback => 'Send tilbakemelding';

  @override
  String get settingsFeedbackBody =>
      'Feil, funksjonsønsker eller bare et hyggelig hei';

  @override
  String get gardensTitle => 'Mine hager';

  @override
  String get gardensActive => 'AKTIV';

  @override
  String get gardensAddNew => 'Legg til ny hage';

  @override
  String get gardensEdit => 'Rediger';

  @override
  String get gardensNoLocation => 'Ingen plassering';

  @override
  String gardensPlantCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count planter',
      one: '1 plante',
    );
    return '$_temp0';
  }

  @override
  String get gardensSwitcherTitle => 'Bytt hage';

  @override
  String get gardensManage => 'Administrer hager';

  @override
  String gardensZoneLine(Object zone) {
    return 'Sone $zone';
  }

  @override
  String get gardensNewTitle => 'Ny hage';

  @override
  String gardensEditTitle(Object name) {
    return 'Rediger $name';
  }

  @override
  String get gardensNamePlaceholder => 'Kolonihage, balkong, hytte…';

  @override
  String get gardensCityLabel => 'By / nærmeste tettsted';

  @override
  String get gardensCreateButton => 'Opprett hage';

  @override
  String get gardensSaveButton => 'Lagre';

  @override
  String get gardensFooterHint =>
      'Hver hage har sin egen sone, planteliste og vær. Bytt aktiv hage ved å trykke på den – alt oppdateres umiddelbart.';

  @override
  String gardensDeleteTitle(Object name) {
    return 'Fjerne $name?';
  }

  @override
  String get gardensDeletePlainBody => 'Hagen fjernes.';

  @override
  String gardensDeleteWithPlantsBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count planter',
      one: '1 plante',
    );
    return '$_temp0 flyttes til standardhagen din. Hagen fjernes.';
  }

  @override
  String get introPage1Title => 'Legg til planter du dyrker';

  @override
  String get introPage1Body =>
      'Trykk + på en plante for å legge den til i hagen din. Vi følger den fra såing til høst og minner om vann, beskjæring og omplanting.';

  @override
  String get introPage1Hint =>
      'Finner du ikke planten? Bruk \"Planter\"-fanen nederst.';

  @override
  String get introPage2Title => 'Planlegg sesongen';

  @override
  String get introPage2Body =>
      'Trykk på bokmerket for å legge planten på såingslisten. Du får varsel i februar/mars når det er tid for å så inne, og i april for direktesåing.';

  @override
  String get introPage2Hint => 'Såingslisten vises på hjemmesiden.';

  @override
  String get introPage3Title => 'Full kontroll på hagen';

  @override
  String get introPage3Body =>
      'Hjem viser vær, tørreperioder og hva du skal gjøre denne måneden. \"Mine planter\"-fanen viser årets statistikk, vekstrotasjon og estimert høstverdi.';

  @override
  String get introPage3Hint =>
      'Skadedyr & sykdommer ligger i Innstillinger når du trenger dem.';

  @override
  String get pestLibraryTitle => 'Skadedyr & sykdommer';

  @override
  String get pestLibrarySearchHint => 'Søk på symptom eller plante';

  @override
  String get pestLibraryFilterPests => 'Skadedyr';

  @override
  String get pestLibraryFilterDiseases => 'Sykdommer';

  @override
  String get pestLibraryFilterDamage => 'Skade';

  @override
  String get pestLibraryNoMatch =>
      'Ingen treff. Prøv et symptom som \"flekker\" eller \"hull\".';

  @override
  String get pestSectionMild => 'Mild handling';

  @override
  String get pestSectionStrong => 'Effektiv handling';

  @override
  String get pestSectionPrevent => 'Forebygg';

  @override
  String get pestAffects => 'Rammer';

  @override
  String statsTitle(Object year) {
    return 'Min hage $year';
  }

  @override
  String statsHero1(Object sek) {
    return 'Du har dyrket frem omtrent $sek kr i mat';
  }

  @override
  String statsHero2(Object count) {
    return 'Du har $count planter på gang';
  }

  @override
  String get statsHeroEmpty => 'Sesongen venter';

  @override
  String get statsTilePlants => 'Planter';

  @override
  String get statsTileSpecies => 'Arter';

  @override
  String get statsTileHarvested => 'Høstet';

  @override
  String get statsHarvestPanelTitle => 'Høst hittil i år';

  @override
  String statsValueLine(Object sek) {
    return 'Estimert verdi: ~$sek kr';
  }

  @override
  String get statsValueDisclaimer =>
      'Basert på omtrentlige svenske butikkpriser per kategori. Inkluderer ikke arbeidstid eller frøkostnader.';

  @override
  String get statsTopPanelTitle => 'Årets beste avkastning';

  @override
  String get statsLocationPanelTitle => 'Hvor i hagen';

  @override
  String get statsRotationPanelTitle => 'Vekstrotasjon';

  @override
  String get statsRotationBody =>
      'Hva som vokste hvor, per år. Gjentakelser markeres.';

  @override
  String get statsReflectionTitle => 'Refleksjon';

  @override
  String get statsEmptyTitle => 'Sesongen har ikke startet ennå';

  @override
  String get statsEmptyBody =>
      'Legg til planter og logg høst – vi fyller siden med årets resultater.';

  @override
  String get tabTodo => 'Gjøremål';

  @override
  String get todoSectionToday => 'I DAG';

  @override
  String get todoSectionWeek => 'DENNE UKEN';

  @override
  String get todoSectionMonth => 'DENNE MÅNEDEN';

  @override
  String get todoSectionDoneToday => 'FERDIG I DAG ✓';

  @override
  String get todoStatToday => 'i dag';

  @override
  String get todoStatWeek => 'denne uken';

  @override
  String get todoStatDone => 'ferdig';

  @override
  String get todoEmptyTitle => 'Alt under kontroll';

  @override
  String get todoEmptyBody =>
      'Ingenting akutt. Legg til planter for å begynne å få daglige oppgaver.';

  @override
  String get todoSwipeDone => 'Ferdig';

  @override
  String get todoSwipeSnooze => 'Utsett';

  @override
  String get progressReadyToHarvest => 'Klar for høst';

  @override
  String get progressHarvestNow => 'Høst nå';

  @override
  String progressDaysLeft(Object days) {
    return '$days dager igjen';
  }

  @override
  String progressApproxDaysLeft(Object days) {
    return '~$days dager igjen';
  }

  @override
  String get climateCardTitle => 'Klima siste 14 dager';

  @override
  String get climateStatAvg => 'Middel/døgn';

  @override
  String get climateStatMinMax => 'Min/maks';

  @override
  String get climateStatGdd => 'GDD';

  @override
  String get climateInterpretWaking => 'Hagen våkner.';

  @override
  String get climateInterpretEarly =>
      'Veldig tidlig sesong – bare kuldetålende vekster (løk, erter, salat).';

  @override
  String get climateInterpretSpring =>
      'Vårsesong – direktesådde grønnsaker etablerer seg, varmekrevende bør vente.';

  @override
  String get climateInterpretMidSpring =>
      'Midt-vår – tomat og paprika kan ut med fiberduk eller i veksthus.';

  @override
  String get climateInterpretFullGrowth =>
      'Full vekst – alt modnes raskt, vann og gjødsle.';

  @override
  String get climateInterpretHot =>
      'Het periode – pass på vanning av unge planter.';

  @override
  String get climateTeaserTitle => 'Klimakort (Premium)';

  @override
  String get climateTeaserBody =>
      'Middel-døgntemp + Growing Degree Days for bedre timing av såing og høsting.';

  @override
  String get weatherSetLocationHint => 'Angi sted i innstillingene';

  @override
  String weatherFrostWarning(String date, String temp) {
    return 'Frostvarsel $date – $temp°C';
  }

  @override
  String dryPeriodBodyWithThirsty(
    String past,
    String next,
    String names,
    String more,
  ) {
    return 'Bare $past mm regn siste 14 dager og $next mm ventes neste uke. Vann $names$more — tørketolerante planter klarer seg lenger.';
  }

  @override
  String dryPeriodBodyGeneral(String past, String next) {
    return 'Bare $past mm regn siste 14 dager og $next mm ventes neste uke. Vann grundig, særlig nyplantede og i potter.';
  }

  @override
  String get dryPeriodMoreSuffix => ' m.fl.';

  @override
  String get myGardenWaterAllTooltip => 'Vann alle utendørsplanter';

  @override
  String myGardenSeasonStatsTooltip(String year) {
    return 'Min sesong $year';
  }

  @override
  String get myGardenGroupTooltip => 'Grupper etter';

  @override
  String get myGardenNoOutdoorPlants =>
      'Ingen utendørsplanter å vanne akkurat nå.';

  @override
  String get myGardenWaterAllTitle => 'Vanne alle?';

  @override
  String myGardenWaterAllConfirm(String count) {
    return 'Markerer $count utendørsplanter som vannet nå.';
  }

  @override
  String get myGardenWaterAllCancel => 'Avbryt';

  @override
  String get myGardenWaterAllAction => 'Vann alle';

  @override
  String myGardenWaterAllDone(String count) {
    return '$count planter vannet ✓';
  }

  @override
  String get myGardenLocationNone => 'Uten sted';

  @override
  String get myGardenCategoryOther => 'Annet';

  @override
  String myGardenStatusSince(String status, String year) {
    return '$status • siden $year';
  }

  @override
  String myGardenStatusOnDate(String status, String date) {
    return '$status • $date';
  }

  @override
  String settingsMyGardensWithCount(String count) {
    return 'Mine hager ($count)';
  }

  @override
  String get settingsPlanMonthly => 'Månedsabonnement';

  @override
  String get settingsPlanYearly => 'Årsabonnement';

  @override
  String get settingsPlanLifetime => 'Livstidskjøp';

  @override
  String get settingsPlanFree => 'Gratis';

  @override
  String get settingsStarterKit => '🛒 Startpakke';

  @override
  String get settingsMorningHourPickerTitle => 'Når vil du ha morgenvarslet?';

  @override
  String get settingsMorningHourPickerBody =>
      'Hagemorgen-oppsummeringen og alle plantepåminnelser går av denne timen. Ingenting vekker deg før.';

  @override
  String settingsHourFormat(String hour) {
    return 'Kl. $hour:00';
  }

  @override
  String settingsBackupFailed(String error) {
    return 'Kunne ikke lage sikkerhetskopi: $error';
  }

  @override
  String get settingsFeedbackSubject => 'Plantera tilbakemelding';

  @override
  String settingsFeedbackBodyTemplate(String version) {
    return 'Hei!\n\nTilbakemelding / spørsmål / feilrapport:\n\n\n— Sendt fra Plantera $version';
  }

  @override
  String get gardensDelete => 'Slett';

  @override
  String get gardensCancel => 'Avbryt';

  @override
  String get gardensNameLabel => 'Navn';

  @override
  String gardensZoneDescription(String zone, String description) {
    return 'Sone $zone – $description';
  }

  @override
  String gardensCityFormat(String city, String zone) {
    return '$city · $zone';
  }

  @override
  String get introSkip => 'Hopp over';

  @override
  String get introNext => 'Neste';

  @override
  String get introStart => 'Sett i gang';

  @override
  String get onboardingWelcome => 'Velkommen til Plantera';

  @override
  String get onboardingBody =>
      'Velg sted for tilpassede råd, frostvarsler og riktige såtider for din sone.';

  @override
  String get onboardingUseGps => 'Bruk min plassering';

  @override
  String get onboardingLocating => 'Henter plassering…';

  @override
  String get onboardingOrPickCity => 'eller velg by';

  @override
  String onboardingZoneSubtitle(String zone) {
    return 'Sone $zone';
  }

  @override
  String get onboardingErrorLocationServicesOff => 'Stedstjenester er av';

  @override
  String get onboardingErrorLocationDenied => 'Stedstilgang nektet';

  @override
  String get phasePerennialHaveIt => 'Jeg har den i hagen';

  @override
  String get phasePerennialHaveItBody =>
      'Vi viser forventet høst og minner om beskjæring, gjødsling og sesongstell.';

  @override
  String get phasePerennialPlanning => 'Planlegger å plante';

  @override
  String get phasePerennialPlanningBody =>
      'På listen til du faktisk planter — påminnelser kommer i tide.';

  @override
  String get phaseDetailedPlanned => 'Planlegger å dyrke';

  @override
  String get phaseDetailedPlannedBody =>
      'Bare på listen — påminnelser kommer i tide når sesongen starter.';

  @override
  String get phaseDetailedPresow => 'Jeg forsår inne';

  @override
  String get phaseDetailedPresowBody =>
      'Plantene vokser inne. Avherding-påminnelse om 5 uker.';

  @override
  String get phaseDetailedDirectsow => 'Jeg har direktesådd ute';

  @override
  String get phaseDetailedDirectsowBody =>
      'Sådd direkte. Høstepåminnelse gjenstår.';

  @override
  String get phaseDetailedPlantout => 'Plantene er plantet ut';

  @override
  String get phaseDetailedPlantoutBody =>
      'På endelig plass. Høstepåminnelse gjenstår.';

  @override
  String get phaseFinishedReady => 'Klar til høsting';

  @override
  String get phaseFinishedReadyBody => 'Markeres som høsteklar nå.';

  @override
  String get phaseFinishedHarvested => 'Høstet';

  @override
  String get phaseFinishedHarvestedBody =>
      'Sesongen er ferdig — påminnelser pauses.';

  @override
  String get phaseFinishedDormant => 'Hvilende';

  @override
  String get phaseFinishedDormantBody => 'Planten er ikke aktiv akkurat nå.';

  @override
  String get phaseDateHelpPresow => 'Hvilken dato startet du denne planten?';

  @override
  String get phaseDateHelpDirectsow => 'Hvilken dato direktesådde du?';

  @override
  String get phaseDateHelpPlantout => 'Hvilken dato kom plantene ut?';

  @override
  String get phaseDateHelpDefault => 'Dato';

  @override
  String get phasePerennialYearTitle => 'Siden når har du den?';

  @override
  String get phasePerennialYearBody =>
      'Trenger ikke være eksakt – vi bruker bare året.';

  @override
  String phasePerennialYearThis(String year) {
    return 'I år ($year)';
  }

  @override
  String phasePerennialYearLast(String year) {
    return 'I fjor ($year)';
  }

  @override
  String phasePerennialYearTwo(String year) {
    return 'For to år siden ($year)';
  }

  @override
  String get phasePerennialYearOlder => 'Tidligere (noen år siden)';

  @override
  String get plantDetailTabOverview => 'Oversikt';

  @override
  String get plantDetailTabMyPlant => 'Min plante';

  @override
  String get plantDetailTabCare => 'Stell';

  @override
  String get plantDetailAddCta => 'Legg til i min hage';

  @override
  String get plantDetailRemoveCta => 'Fjern fra hagen';

  @override
  String get plantDetailRemoveTitle => 'Fjern fra hagen?';

  @override
  String get plantDetailRemoveBody => 'Dette kan ikke angres.';

  @override
  String get plantDetailCancel => 'Avbryt';

  @override
  String get plantDetailDelete => 'Slett';

  @override
  String get plantDetailSave => 'Lagre';

  @override
  String get plantDetailReset => 'Tilbakestill';

  @override
  String get plantDetailReuse => 'Bruk igjen';

  @override
  String get plantDetailWaterNowSuffix => 'Vannet nå';

  @override
  String get plantDetailWaterTapHint => 'Trykk når du vanner for å holde styr';

  @override
  String get plantDetailWaterDoneSnack => 'Vannet ✓';

  @override
  String get plantDetailWaterNotYet => 'Ikke vannet ennå';

  @override
  String get plantDetailWaterJust => 'Nylig vannet';

  @override
  String get plantDetailWaterToday => 'Vannet i dag';

  @override
  String get plantDetailWaterYesterday => 'Vannet i går';

  @override
  String get plantDetailUpcomingCareTitle => '📅  KOMMENDE STELL';

  @override
  String get plantDetailDueNow => 'På tide';

  @override
  String get plantDetailEditPostsTooltip => 'Administrer innlegg';

  @override
  String get plantDetailNoteHint => 'Skriv et kort notat…';

  @override
  String get plantDetailNoteTitle => 'Notat';

  @override
  String get plantDetailNoteSubtitle =>
      'Hva skjedde i dag? Bladlus, første blomst, beskjæring…';

  @override
  String get plantDetailTakePhoto => 'Ta bilde';

  @override
  String get plantDetailPickLibrary => 'Velg fra bibliotek';

  @override
  String get plantDetailWriteNote => 'Skriv notat';

  @override
  String get plantDetailUseEmojiAgain => 'Bruk emoji igjen';

  @override
  String plantDetailSaveImageError(String error) {
    return 'Kunne ikke lagre bilde: $error';
  }

  @override
  String plantDetailSavePhotoError(String error) {
    return 'Kunne ikke lagre foto: $error';
  }

  @override
  String get plantDetailDeletePhotoTitle => 'Slett bilde?';

  @override
  String get plantDetailDeleteNoteTitle => 'Slett notat?';

  @override
  String get plantDetailDeletePhotoBody => 'Bildet slettes fra enheten.';

  @override
  String get plantDetailDeleteNoteBody => 'Notatet forsvinner.';

  @override
  String get plantDetailAdd => 'Legg til';

  @override
  String get plantDetailNoPostsBody =>
      'Ingen innlegg ennå — begynn å dokumentere veksten med bilder og korte notater.';

  @override
  String get plantDetailChangeStatus => 'Endre status';

  @override
  String get plantDetailLocationLabel => 'Sted';

  @override
  String plantDetailSowingMethodChip(String method) {
    return 'Sår: $method';
  }

  @override
  String plantDetailSowingMethodSnack(String method) {
    return 'Såmetode: $method';
  }

  @override
  String get plantDetailDateHelp => 'Hvilken dato?';

  @override
  String get plantDetailHowSowTitle => 'Hvordan sår du?';

  @override
  String get plantDetailHowSowBody => 'Avgjør hvilke påminnelser du får.';

  @override
  String get plantDetailLocationTitle => 'Hvor står den?';

  @override
  String get plantDetailLocationBody =>
      'F.eks. \"nordre bed\", \"veksthuset\", \"balkongen\".';

  @override
  String get plantDetailHarvestOffsetTitle => 'Juster høstetid';

  @override
  String get plantDetailHarvestOffsetBody =>
      'Telleren feil? Legg til eller trekk fra dager — lagres på akkurat denne planten.';

  @override
  String get plantDetailReadyToHarvest => 'Klar til høsting';

  @override
  String get plantDetailNextStepPresow => 'Jeg har forsådd inne';

  @override
  String get plantDetailNextStepDirectsow => 'Jeg har direktesådd';

  @override
  String get plantDetailNextStepPlantout => 'Jeg har plantet ut';

  @override
  String get plantDetailNextStepPlantedOut => 'Plantene er plantet ut';

  @override
  String get plantDetailNextStepHarvestReady => 'Klar for høsting';

  @override
  String get plantDetailNextStepHarvested => 'Høstet';

  @override
  String get plantDetailHowToTitle => 'Slik gjør du';

  @override
  String get plantDetailTipsTitle => 'Tips';

  @override
  String get plantDetailPestsTitle => 'Skadedyr å passe på';

  @override
  String get plantDetailNoCareTips => 'Ingen stelltips tilgjengelig ennå.';

  @override
  String get plantDetailInfoSun => 'Sol';

  @override
  String get plantDetailInfoWater => 'Vann';

  @override
  String get plantDetailInfoFertilizer => 'Gjødsel';

  @override
  String get plantDetailInfoFrost => 'Tåler til';

  @override
  String get plantDetailInfoSpacing => 'Avstand';

  @override
  String get plantDetailInfoHarvest => 'Høst';

  @override
  String get plantDetailHarvestSection => '🥕  Høst';

  @override
  String get plantDetailToolsSection => '🛒 Verktøy og tilbehør';

  @override
  String get plantDetailSeasonSection => 'Sesong';

  @override
  String get plantDetailPhasePresow => 'Forså';

  @override
  String get plantDetailPhaseDirectsow => 'Direktesåing';

  @override
  String get plantDetailPhasePlantout => 'Plante ut';

  @override
  String get plantDetailPhaseHarvest => 'Høste';

  @override
  String get plantDetailZoneWarningBody =>
      'Det kan gå – men du trenger nok vinterbeskyttelse eller en varmere plass.';

  @override
  String plantDetailDateAdded(String date) {
    return 'Lagt til $date';
  }

  @override
  String plantDetailDateInGardenSince(String year) {
    return 'I hagen siden $year';
  }

  @override
  String plantDetailDatePlanted(String date) {
    return 'Plantet $date';
  }

  @override
  String get plantDetailHarvestOffsetSubtitle => 'Juster høstetid';

  @override
  String plantDetailZoneWarning(String zone) {
    return 'Denne planten er ikke testet for sone $zone. Det kan gå – men du trenger nok vinterbeskyttelse eller en varmere plass.';
  }

  @override
  String get harvestSectionTitle => '🥕 Høst';

  @override
  String get harvestRemoveTitle => 'Fjerne post?';

  @override
  String harvestRemoveBody(String amount, String unit, String date) {
    return '$amount $unit fra $date fjernes.';
  }

  @override
  String harvestMoreEntries(String count) {
    return '+ $count eldre poster';
  }

  @override
  String harvestAddTitle(String plant) {
    return 'Logg høst — $plant';
  }

  @override
  String get harvestAmountLabel => 'Mengde';

  @override
  String get harvestUnitLabel => 'Enhet';

  @override
  String get harvestNotesLabel => 'Notat (valgfritt)';

  @override
  String get harvestErrorAmountTooLow => 'Angi en mengde større enn 0';

  @override
  String get harvestErrorFutureDate => 'Du kan ikke logge høst i fremtiden';

  @override
  String get commonCancel => 'Avbryt';

  @override
  String get commonDelete => 'Slett';

  @override
  String get commonSave => 'Lagre';

  @override
  String get pestTypeLabelDisease => 'SYKDOM';

  @override
  String get pestTypeLabelDamage => 'SKADE';

  @override
  String get pestTypeLabelPest => 'SKADEDYR';
}
