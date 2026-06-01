// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appName => 'Plantera';

  @override
  String get appSubtitle => 'Din digitale havekammerat';

  @override
  String get tabHome => 'Hjem';

  @override
  String get tabCalendar => 'Kalender';

  @override
  String get tabPlants => 'Planter';

  @override
  String get tabMyGarden => 'Mine planter';

  @override
  String get tabSettings => 'Indstillinger';

  @override
  String get tabOverview => 'Oversigt';

  @override
  String get tabMyPlant => 'Min plante';

  @override
  String get tabCare => 'Pleje';

  @override
  String get homeWelcomeTitle => 'Lad os starte med din første plante';

  @override
  String get homeWelcomeBody =>
      'Bladr i plantedatabasen og tryk + på det du dyrker — vi følger den fra såning til høst.';

  @override
  String get homeWelcomeCta => 'Bladr i planter';

  @override
  String get gardenOverviewTitle => 'Nærmeste høst';

  @override
  String get gardenSeeAll => 'Se alle';

  @override
  String get gardenStatTotal => 'I haven';

  @override
  String get gardenStatHarvestSoon => 'Snart høst';

  @override
  String get gardenStatReadyNow => 'Klar nu';

  @override
  String gardenMore(Object count) {
    return '+$count mere';
  }

  @override
  String get dailyInsightsTitle => 'I dag i haven';

  @override
  String get dailyInsightsAllGood =>
      'Alt under kontrol. Intet akut — nyd haven.';

  @override
  String get upcomingCareTitle => 'Kommende pleje';

  @override
  String get upcomingCareSubtitle => 'Ting at gøre denne og næste måned.';

  @override
  String seasonPlannerTitle(Object year) {
    return 'Min sæson $year';
  }

  @override
  String get seasonPlannerSubtitle =>
      'Det du vil dyrke i år. Vi giver besked når det er tid til at så.';

  @override
  String seasonPlannerEmptyTitle(Object year) {
    return 'Planlæg sæsonen $year';
  }

  @override
  String get seasonPlannerEmptyBody =>
      'Hvad vil du dyrke i år? Vi minder dig om når det er tid til at så.';

  @override
  String get seasonPlannerEmptyCta => 'Vælg';

  @override
  String get seasonPlannerAddCta => 'Tilføj plante';

  @override
  String seasonPlannerCount(Object count) {
    return '$count stk';
  }

  @override
  String get seasonRowSowNow => 'Så nu';

  @override
  String seasonRowDaysAway(Object days) {
    return 'Om $days dage';
  }

  @override
  String get seasonRowInSeason => 'I sæson';

  @override
  String get weatherUnavailable => 'Vejr utilgængeligt';

  @override
  String get weatherSetLocation => 'Indstil din placering i indstillinger';

  @override
  String get dryPeriodTitle => 'Tørkeperiode er i gang';

  @override
  String get frostCardTitle => '❄️ Beskyt mod frost';

  @override
  String get premiumTeaserTitle => 'Plantera Premium';

  @override
  String get premiumTeaserBody => 'Ubegrænset have og ingen reklamer';

  @override
  String get calendarTitle => 'Plantningskalender';

  @override
  String get calendarMonthGuide => 'Månedens guide';

  @override
  String calendarTaskCount(Object count) {
    return '$count opgaver';
  }

  @override
  String get calendarPhasePresow => 'FORSÅ INDE';

  @override
  String get calendarPhaseDirectsow => 'DIREKTE SÅNING';

  @override
  String get calendarPhasePlantout => 'PLANT UD';

  @override
  String get calendarPhaseHarvest => 'HØST';

  @override
  String calendarPhaseCount(Object count) {
    return '$count planter';
  }

  @override
  String calendarEmptyTitle(Object month) {
    return 'Intet at så eller høste i $month';
  }

  @override
  String get calendarEmptyBody =>
      'Brug måneden til planlægning — bestil frø, planlæg bede eller læs månedens guide.';

  @override
  String get myGardenTitle => 'Mine planter';

  @override
  String get myGardenSearchHint => 'Søg plante eller placering';

  @override
  String get myGardenFilterAll => 'Alle';

  @override
  String get myGardenGroupByStatus => 'Grupper efter status';

  @override
  String get myGardenGroupByLocation => 'Grupper efter placering';

  @override
  String get myGardenGroupByCategory => 'Grupper efter kategori';

  @override
  String myGardenShowingCount(Object shown, Object total) {
    return 'Viser $shown af $total';
  }

  @override
  String get myGardenEmptyTitle => 'Din have er tom';

  @override
  String get myGardenEmptyBody =>
      'Tilføj planter fra databasen for at bygge din have.';

  @override
  String get myGardenEmptyCta => 'Bladr i plantedatabasen';

  @override
  String get myGardenAddPlant => 'Tilføj plante';

  @override
  String get myGardenNoResults => 'Ingen planter matcher';

  @override
  String get myGardenNoResultsBody =>
      'Prøv en anden søgning eller fjern filtre.';

  @override
  String get myGardenWateredNow => 'Vandet nu';

  @override
  String get myGardenWateredToday => 'Vandet i dag';

  @override
  String get myGardenWateredYesterday => 'Vandet i går';

  @override
  String get plantDatabaseTitle => 'Plantedatabase';

  @override
  String get plantDatabaseSearchHint => 'Søg plante';

  @override
  String get plantCategoryAll => 'Alle';

  @override
  String get addPlantNow => 'Tilføj til haven nu';

  @override
  String get addPlantNowBody =>
      'Du har sået eller plantet — vi følger den fra i dag';

  @override
  String get addPlantSeason => 'Tilføj til såningslisten';

  @override
  String get addPlantSeasonBody =>
      'Du planlægger at dyrke — vi giver besked når det er tid til at så';

  @override
  String get addPlantRemoveSeason => 'Fjern fra såningslisten';

  @override
  String get addPlantRemoveSeasonBody => 'Vi stopper med at minde om såvinduet';

  @override
  String addedToGardenTitle(Object plant) {
    return '$plant er i din have';
  }

  @override
  String get addedToGardenBodyPlain =>
      'Vi følger den fra i dag og minder om vand og høst.';

  @override
  String addedToGardenBodyScheduled(Object list) {
    return 'Vi følger den fra i dag. Notifikationer kommer for: $list.';
  }

  @override
  String get addedToGardenCta => 'Tag mig til min have';

  @override
  String get phasePickerTitleNew => 'Hvor er du i processen?';

  @override
  String get phasePickerTitleEdit => 'Skift status';

  @override
  String get phaseShowSimple => 'Vis enklere muligheder';

  @override
  String get phaseShowMore => 'Flere muligheder (for erfarne)';

  @override
  String get phaseSimplePlanned => 'Planlægger at dyrke';

  @override
  String get phaseSimplePlannedBody =>
      'Bare på listen — vi minder dig når sæsonen starter.';

  @override
  String get phaseSimpleGrowing => 'Vokser lige nu';

  @override
  String get phaseSimpleGrowingBody =>
      'Planterne er i gang. Vi følger dem til høst.';

  @override
  String get phaseSimpleHarvested => 'Allerede høstet';

  @override
  String get phaseSimpleHarvestedBody => 'Sæsonen er slut for denne plante.';

  @override
  String get perennialEstablishedTitle => 'Hvor længe har du haft den?';

  @override
  String get perennialEstablishedBody =>
      'Behøver ikke være præcist – vi bruger kun året.';

  @override
  String perennialThisYear(Object year) {
    return 'I år ($year)';
  }

  @override
  String perennialLastYear(Object year) {
    return 'Sidste år ($year)';
  }

  @override
  String perennialTwoYearsAgo(Object year) {
    return 'To år siden ($year)';
  }

  @override
  String get perennialEarlier => 'Tidligere (nogle år tilbage)';

  @override
  String get statusPlanning => 'Planlægger';

  @override
  String get statusGrowingIndoors => 'Forsår inde';

  @override
  String get statusDirectSown => 'Direkte sået ude';

  @override
  String get statusHardening => 'Hærder af';

  @override
  String get statusOutdoors => 'Står ude';

  @override
  String get statusReadyToHarvest => 'Klar til høst';

  @override
  String get statusHarvested => 'Høstet';

  @override
  String get statusDormant => 'I hvile';

  @override
  String get sowingIndoors => 'Inde';

  @override
  String get sowingDirect => 'Direkte';

  @override
  String get sowingPlanta => 'Plante';

  @override
  String get sunFull => 'Fuld sol';

  @override
  String get sunPartial => 'Halvskygge';

  @override
  String get sunShade => 'Skygge';

  @override
  String get waterSparse => 'Sparsom';

  @override
  String get waterRegular => 'Regelmæssig';

  @override
  String get waterAbundant => 'Rigelig';

  @override
  String get fertilizerLow => 'Lav';

  @override
  String get fertilizerMedium => 'Middel';

  @override
  String get fertilizerHigh => 'Høj';

  @override
  String get lifecycleAnnual => 'Etårig';

  @override
  String get lifecycleBiennial => 'Toårig';

  @override
  String get lifecyclePerennial => 'Flerårig';

  @override
  String get lifecycleTree => 'Træ';

  @override
  String get lifecycleShrub => 'Busk';

  @override
  String get categoryVegetables => 'Grøntsager';

  @override
  String get categoryHerbs => 'Krydderier & urter';

  @override
  String get categoryFlowers => 'Blomster';

  @override
  String get categoryBerries => 'Bær';

  @override
  String get categoryFruitTrees => 'Frugttræer';

  @override
  String get categoryOther => 'Andet';

  @override
  String get wateredNow => 'Vandet';

  @override
  String get wateredConfirmation => 'Vandet ✓';

  @override
  String get notWateredYet => 'Ikke vandet endnu';

  @override
  String get wateredJustNow => 'Vandet for nylig';

  @override
  String wateredDaysAgo(Object days) {
    return 'Vandet for $days dage siden';
  }

  @override
  String wateredWeeksAgo(Object weeks) {
    return 'Vandet for $weeks uger siden';
  }

  @override
  String get journalTitle => 'Dagbog';

  @override
  String journalCount(Object count) {
    return '$count';
  }

  @override
  String get journalAdd => 'Tilføj';

  @override
  String get journalEmpty =>
      'Ingen indlæg endnu — begynd at dokumentere væksten med fotos og korte noter.';

  @override
  String get journalNoteTitle => 'Note';

  @override
  String get journalNoteBody =>
      'Hvad skete der i dag? Bladlus, første blomst, beskæring…';

  @override
  String get journalNoteHint => 'Skriv en kort note…';

  @override
  String get journalSave => 'Gem';

  @override
  String get journalDeletePhoto => 'Slet foto?';

  @override
  String get journalDeletePhotoBody => 'Billedet fjernes fra enheden.';

  @override
  String get journalDeleteNote => 'Slet note?';

  @override
  String get journalDeleteNoteBody => 'Noten fjernes.';

  @override
  String get journalManage => 'Administrer indlæg';

  @override
  String get actionTakePhoto => 'Tag foto';

  @override
  String get actionPickFromLibrary => 'Vælg fra bibliotek';

  @override
  String get actionWriteNote => 'Skriv en note';

  @override
  String get harvestTitle => 'Høst';

  @override
  String get harvestLog => 'Log høst';

  @override
  String get harvestEmpty =>
      'Log hvad du høster, og appen bygger statistik år for år.';

  @override
  String harvestTotalLabel(Object amount, Object unit) {
    return 'I alt: $amount $unit';
  }

  @override
  String harvestEstimatedSek(Object amount) {
    return '~$amount kr';
  }

  @override
  String get nextStepBecomeIndoor => 'Jeg har sået inde';

  @override
  String get nextStepBecomeDirect => 'Jeg har direktesået';

  @override
  String get nextStepBecomePlanted => 'Jeg har plantet ud';

  @override
  String get nextStepHardenedToPlanted => 'Planterne er ude';

  @override
  String get nextStepReadyForHarvest => 'Klar til høst';

  @override
  String get nextStepHarvested => 'Høstet';

  @override
  String get secondaryChangeStatus => 'Skift status';

  @override
  String get secondaryRemove => 'Fjern';

  @override
  String get secondaryRemoveConfirmTitle => 'Fjern fra haven?';

  @override
  String secondaryRemoveConfirmBody(Object plant) {
    return '$plant og alle påmindelser fjernes. Dette kan ikke fortrydes.';
  }

  @override
  String get buttonCancel => 'Annuller';

  @override
  String get buttonRemove => 'Fjern';

  @override
  String get buttonSave => 'Gem';

  @override
  String get buttonNext => 'Næste';

  @override
  String get buttonStart => 'Kom i gang';

  @override
  String get buttonSkip => 'Spring over';

  @override
  String get locationLabel => 'Placering';

  @override
  String get locationAdd => 'Tilføj placering';

  @override
  String get locationPickerTitle => 'Hvor står den?';

  @override
  String get locationPickerBody =>
      'F.eks. \"nordbed\", \"drivhus\", \"altan\".';

  @override
  String get locationReuse => 'Brug igen';

  @override
  String get settingsTitle => 'Indstillinger';

  @override
  String get settingsPremiumActive => 'Premium aktivt';

  @override
  String get settingsPremiumUpgrade => 'Opgrader til Premium';

  @override
  String get settingsPremiumUnlock => 'Lås op for alle funktioner';

  @override
  String get settingsMyGardens => 'Mine haver';

  @override
  String settingsMyGardensSubtitle(Object emoji, Object name) {
    return 'Aktiv: $emoji $name';
  }

  @override
  String get settingsMyGardensEmpty => 'Tilføj din første have';

  @override
  String get settingsNotifications => 'Påmindelser';

  @override
  String get settingsNotificationsBody => 'Frostvarsler og plantningstider';

  @override
  String get settingsMorningHour => 'Morgen-tid for påmindelser';

  @override
  String settingsMorningHourBody(Object hour) {
    return 'Havemorgen-pings affyrer kl. $hour:00';
  }

  @override
  String get settingsLargeText => 'Stor tekst';

  @override
  String get settingsLargeTextBody => 'Lidt større tekst i hele appen';

  @override
  String get settingsSimpleStatus => 'Simpel status';

  @override
  String get settingsSimpleStatusBody =>
      'Vis kun 3 hovedtilstande (planlægger / vokser / høstet). Slå fra for fuld livscyklus.';

  @override
  String get settingsPestLibrary => 'Skadedyr & sygdomme';

  @override
  String get settingsPestLibraryBody => 'Bibliotek over almindelige problemer';

  @override
  String get settingsIntro => 'Vis introduktion';

  @override
  String get settingsIntroBody =>
      'Hurtig gennemgang af Plus-knappen, sæsonplanlæggeren og hvordan appen virker';

  @override
  String get settingsBackup => 'Sikkerhedskopi';

  @override
  String get settingsBackupBody =>
      'Eksporter haven og høsten – gem på iCloud Drive eller send til dig selv';

  @override
  String get settingsRestorePurchases => 'Gendan køb';

  @override
  String get settingsPrivacyPolicy => 'Privatlivspolitik';

  @override
  String get settingsTerms => 'Brugsvilkår (EULA)';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsFeedback => 'Send feedback';

  @override
  String get settingsFeedbackBody =>
      'Fejl, funktionsønsker eller bare et venligt hej';

  @override
  String get gardensTitle => 'Mine haver';

  @override
  String get gardensActive => 'AKTIV';

  @override
  String get gardensAddNew => 'Tilføj ny have';

  @override
  String get gardensEdit => 'Rediger';

  @override
  String get gardensNoLocation => 'Ingen placering';

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
  String get gardensSwitcherTitle => 'Skift have';

  @override
  String get gardensManage => 'Administrer haver';

  @override
  String gardensZoneLine(Object zone) {
    return 'Zone $zone';
  }

  @override
  String get gardensNewTitle => 'Ny have';

  @override
  String gardensEditTitle(Object name) {
    return 'Rediger $name';
  }

  @override
  String get gardensNamePlaceholder => 'Kolonihave, altan, sommerhus…';

  @override
  String get gardensCityLabel => 'By / nærmeste by';

  @override
  String get gardensCreateButton => 'Opret have';

  @override
  String get gardensSaveButton => 'Gem';

  @override
  String get gardensFooterHint =>
      'Hver have har sin egen zone, planteliste og vejr. Skift aktiv have ved at trykke på den – alt opdateres med det samme.';

  @override
  String gardensDeleteTitle(Object name) {
    return 'Fjern $name?';
  }

  @override
  String get gardensDeletePlainBody => 'Haven fjernes.';

  @override
  String gardensDeleteWithPlantsBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count planter',
      one: '1 plante',
    );
    return '$_temp0 flyttes til din standardhave. Haven fjernes.';
  }

  @override
  String get introPage1Title => 'Tilføj planter du dyrker';

  @override
  String get introPage1Body =>
      'Tryk + på en plante for at tilføje den til din have. Vi følger den fra såning til høst og minder dig om at vande, beskære eller omplante.';

  @override
  String get introPage1Hint =>
      'Kan du ikke finde planten? Brug \"Planter\"-fanen nederst.';

  @override
  String get introPage2Title => 'Planlæg din sæson';

  @override
  String get introPage2Body =>
      'Tryk på bogmærket for at føje planten til din såningsliste. Du får besked i februar/marts når det er tid til at så inde, og i april for direktesåning.';

  @override
  String get introPage2Hint => 'Såningslisten vises på hjemmesiden.';

  @override
  String get introPage3Title => 'Hold styr på din have';

  @override
  String get introPage3Body =>
      'Hjem viser vejr, tørperioder og hvad du skal gøre denne måned. \"Mine planter\"-fanen viser årets statistik, vækstrotation og estimeret høstværdi.';

  @override
  String get introPage3Hint =>
      'Skadedyr & sygdomme er i Indstillinger når du har brug for dem.';

  @override
  String get pestLibraryTitle => 'Skadedyr & sygdomme';

  @override
  String get pestLibrarySearchHint => 'Søg efter symptom eller plante';

  @override
  String get pestLibraryFilterPests => 'Skadedyr';

  @override
  String get pestLibraryFilterDiseases => 'Sygdomme';

  @override
  String get pestLibraryFilterDamage => 'Skade';

  @override
  String get pestLibraryNoMatch =>
      'Intet match. Prøv et symptom som \"pletter\" eller \"huller\".';

  @override
  String get pestSectionMild => 'Mild handling';

  @override
  String get pestSectionStrong => 'Effektiv handling';

  @override
  String get pestSectionPrevent => 'Forebyg';

  @override
  String get pestAffects => 'Rammer';

  @override
  String statsTitle(Object year) {
    return 'Min have $year';
  }

  @override
  String statsHero1(Object sek) {
    return 'Du har dyrket cirka $sek kr i mad';
  }

  @override
  String statsHero2(Object count) {
    return 'Du har $count planter i gang';
  }

  @override
  String get statsHeroEmpty => 'Sæsonen venter';

  @override
  String get statsTilePlants => 'Planter';

  @override
  String get statsTileSpecies => 'Arter';

  @override
  String get statsTileHarvested => 'Høstet';

  @override
  String get statsHarvestPanelTitle => 'Høst hidtil i år';

  @override
  String statsValueLine(Object sek) {
    return 'Estimeret værdi: ~$sek kr';
  }

  @override
  String get statsValueDisclaimer =>
      'Baseret på omtrentlige danske butikspriser per kategori. Inkluderer ikke arbejdstid eller frøomkostninger.';

  @override
  String get statsTopPanelTitle => 'Årets bedste afkast';

  @override
  String get statsLocationPanelTitle => 'Hvor i haven';

  @override
  String get statsRotationPanelTitle => 'Vækstrotation';

  @override
  String get statsRotationBody =>
      'Hvad der voksede hvor, per år. Gentagelser markeres.';

  @override
  String get statsReflectionTitle => 'Refleksion';

  @override
  String get statsEmptyTitle => 'Sæsonen er ikke startet endnu';

  @override
  String get statsEmptyBody =>
      'Tilføj planter og log høst – vi udfylder siden med årets resultater.';

  @override
  String get tabTodo => 'Opgaver';

  @override
  String get todoSectionToday => 'I DAG';

  @override
  String get todoSectionWeek => 'DENNE UGE';

  @override
  String get todoSectionMonth => 'DENNE MÅNED';

  @override
  String get todoSectionDoneToday => 'FÆRDIG I DAG ✓';

  @override
  String get todoStatToday => 'i dag';

  @override
  String get todoStatWeek => 'denne uge';

  @override
  String get todoStatDone => 'færdig';

  @override
  String get todoEmptyTitle => 'Alt under kontrol';

  @override
  String get todoEmptyBody =>
      'Intet akut. Tilføj planter til din have for at få daglige opgaver.';

  @override
  String get todoSwipeDone => 'Færdig';

  @override
  String get todoSwipeSnooze => 'Udskyd';

  @override
  String get progressReadyToHarvest => 'Klar til høst';

  @override
  String get progressHarvestNow => 'Høst nu';

  @override
  String progressDaysLeft(Object days) {
    return '$days dage tilbage';
  }

  @override
  String progressApproxDaysLeft(Object days) {
    return '~$days dage tilbage';
  }

  @override
  String get climateCardTitle => 'Klima sidste 14 dage';

  @override
  String get climateStatAvg => 'Middel/døgn';

  @override
  String get climateStatMinMax => 'Min/maks';

  @override
  String get climateStatGdd => 'GDD';

  @override
  String get climateInterpretWaking => 'Haven vågner.';

  @override
  String get climateInterpretEarly =>
      'Meget tidlig sæson – kun kuldetålende vækster (løg, ærter, salat).';

  @override
  String get climateInterpretSpring =>
      'Forårssæson – direktesåede grøntsager etableres, varmekrævende skal vente.';

  @override
  String get climateInterpretMidSpring =>
      'Midt-forår – tomat og peber kan ud under fiberdug eller i drivhus.';

  @override
  String get climateInterpretFullGrowth =>
      'Fuld vækst – alt modnes hurtigt, vand og gød.';

  @override
  String get climateInterpretHot =>
      'Varm periode – pas på vanding af unge planter.';

  @override
  String get climateTeaserTitle => 'Klimakort (Premium)';

  @override
  String get climateTeaserBody =>
      'Middel-døgntemp + Growing Degree Days for bedre timing af såning og høst.';

  @override
  String get weatherSetLocationHint => 'Angiv sted i indstillingerne';

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
    return 'Kun $past mm regn de sidste 14 dage og $next mm ventes kommende uge. Vand $names$more — tørke­tolerante planter klarer sig længere.';
  }

  @override
  String dryPeriodBodyGeneral(String past, String next) {
    return 'Kun $past mm regn de sidste 14 dage og $next mm ventes kommende uge. Vand grundigt, især nyplantede og i potter.';
  }

  @override
  String get dryPeriodMoreSuffix => ' m.fl.';

  @override
  String get myGardenWaterAllTooltip => 'Vand alle udendørsplanter';

  @override
  String myGardenSeasonStatsTooltip(String year) {
    return 'Min sæson $year';
  }

  @override
  String get myGardenGroupTooltip => 'Gruppér efter';

  @override
  String get myGardenNoOutdoorPlants =>
      'Ingen udendørsplanter at vande lige nu.';

  @override
  String get myGardenWaterAllTitle => 'Vand alle?';

  @override
  String myGardenWaterAllConfirm(String count) {
    return 'Markerer $count udendørsplanter som vandet nu.';
  }

  @override
  String get myGardenWaterAllCancel => 'Annuller';

  @override
  String get myGardenWaterAllAction => 'Vand alle';

  @override
  String myGardenWaterAllDone(String count) {
    return '$count planter vandet ✓';
  }

  @override
  String get myGardenLocationNone => 'Uden sted';

  @override
  String get myGardenCategoryOther => 'Andet';

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
    return 'Mine haver ($count)';
  }

  @override
  String get settingsPlanMonthly => 'Månedsabonnement';

  @override
  String get settingsPlanYearly => 'Årsabonnement';

  @override
  String get settingsPlanLifetime => 'Livstidskøb';

  @override
  String get settingsPlanFree => 'Gratis';

  @override
  String get settingsStarterKit => '🛒 Startpakke';

  @override
  String get settingsMorningHourPickerTitle =>
      'Hvornår vil du have morgenvarslet?';

  @override
  String get settingsMorningHourPickerBody =>
      'Havemorgen-resuméet og alle plantepåmindelser udløses i denne time. Intet vækker dig inden.';

  @override
  String settingsHourFormat(String hour) {
    return 'Kl. $hour:00';
  }

  @override
  String settingsBackupFailed(String error) {
    return 'Kunne ikke lave sikkerhedskopi: $error';
  }

  @override
  String get settingsFeedbackSubject => 'Plantera feedback';

  @override
  String settingsFeedbackBodyTemplate(String version) {
    return 'Hej!\n\nFeedback / spørgsmål / fejlrapport:\n\n\n— Sendt fra Plantera $version';
  }

  @override
  String get gardensDelete => 'Slet';

  @override
  String get gardensCancel => 'Annuller';

  @override
  String get gardensNameLabel => 'Navn';

  @override
  String gardensZoneDescription(String zone, String description) {
    return 'Zone $zone – $description';
  }

  @override
  String gardensCityFormat(String city, String zone) {
    return '$city · $zone';
  }

  @override
  String get introSkip => 'Spring over';

  @override
  String get introNext => 'Næste';

  @override
  String get introStart => 'Sæt i gang';

  @override
  String get onboardingWelcome => 'Velkommen til Plantera';

  @override
  String get onboardingBody =>
      'Vælg din placering for skræddersyede råd, frostvarsler og rette såtider for din zone.';

  @override
  String get onboardingUseGps => 'Brug min placering';

  @override
  String get onboardingLocating => 'Henter placering…';

  @override
  String get onboardingOrPickCity => 'eller vælg by';

  @override
  String onboardingZoneSubtitle(String zone) {
    return 'Zone $zone';
  }

  @override
  String get onboardingErrorLocationServicesOff =>
      'Lokationstjenester er slået fra';

  @override
  String get onboardingErrorLocationDenied => 'Lokationsadgang nægtet';

  @override
  String get phasePerennialHaveIt => 'Jeg har den i haven';

  @override
  String get phasePerennialHaveItBody =>
      'Vi viser forventet høst og minder om beskæring, gødning og sæsonpleje.';

  @override
  String get phasePerennialPlanning => 'Planlægger at plante';

  @override
  String get phasePerennialPlanningBody =>
      'På listen indtil du faktisk planter — påmindelser kommer i tide.';

  @override
  String get phaseDetailedPlanned => 'Planlægger at dyrke';

  @override
  String get phaseDetailedPlannedBody =>
      'Bare på listen — påmindelser kommer i tide når sæsonen starter.';

  @override
  String get phaseDetailedPresow => 'Jeg forspirer indenfor';

  @override
  String get phaseDetailedPresowBody =>
      'Planterne vokser indenfor. Afhærdnings-påmindelse om 5 uger.';

  @override
  String get phaseDetailedDirectsow => 'Jeg har direkte­sået ude';

  @override
  String get phaseDetailedDirectsowBody =>
      'Sået direkte. Høstpåmindelse mangler.';

  @override
  String get phaseDetailedPlantout => 'Planterne er udplantet';

  @override
  String get phaseDetailedPlantoutBody =>
      'På endelig plads. Høstpåmindelse mangler.';

  @override
  String get phaseFinishedReady => 'Klar til høst';

  @override
  String get phaseFinishedReadyBody => 'Markeres som høstklar nu.';

  @override
  String get phaseFinishedHarvested => 'Høstet';

  @override
  String get phaseFinishedHarvestedBody =>
      'Sæsonen er færdig — påmindelser pauses.';

  @override
  String get phaseFinishedDormant => 'Hvilende';

  @override
  String get phaseFinishedDormantBody => 'Planten er ikke aktiv lige nu.';

  @override
  String get phaseDateHelpPresow => 'Hvilken dato startede du denne plante?';

  @override
  String get phaseDateHelpDirectsow => 'Hvilken dato direkte­såede du?';

  @override
  String get phaseDateHelpPlantout => 'Hvilken dato kom planterne ud?';

  @override
  String get phaseDateHelpDefault => 'Dato';

  @override
  String get phasePerennialYearTitle => 'Hvor længe har du haft den?';

  @override
  String get phasePerennialYearBody =>
      'Behøver ikke være præcist – vi bruger kun året.';

  @override
  String phasePerennialYearThis(String year) {
    return 'I år ($year)';
  }

  @override
  String phasePerennialYearLast(String year) {
    return 'Sidste år ($year)';
  }

  @override
  String phasePerennialYearTwo(String year) {
    return 'For to år siden ($year)';
  }

  @override
  String get phasePerennialYearOlder => 'Tidligere (nogle år siden)';

  @override
  String get plantDetailTabOverview => 'Oversigt';

  @override
  String get plantDetailTabMyPlant => 'Min plante';

  @override
  String get plantDetailTabCare => 'Pleje';

  @override
  String get plantDetailAddCta => 'Tilføj til min have';

  @override
  String get plantDetailRemoveCta => 'Fjern fra haven';

  @override
  String get plantDetailRemoveTitle => 'Fjern fra haven?';

  @override
  String get plantDetailRemoveBody => 'Dette kan ikke fortrydes.';

  @override
  String get plantDetailCancel => 'Annuller';

  @override
  String get plantDetailDelete => 'Slet';

  @override
  String get plantDetailSave => 'Gem';

  @override
  String get plantDetailReset => 'Nulstil';

  @override
  String get plantDetailReuse => 'Brug igen';

  @override
  String get plantDetailWaterNowSuffix => 'Vandet nu';

  @override
  String get plantDetailWaterTapHint => 'Tryk når du vander for at holde styr';

  @override
  String get plantDetailWaterDoneSnack => 'Vandet ✓';

  @override
  String get plantDetailWaterNotYet => 'Ikke vandet endnu';

  @override
  String get plantDetailWaterJust => 'Lige vandet';

  @override
  String get plantDetailWaterToday => 'Vandet i dag';

  @override
  String get plantDetailWaterYesterday => 'Vandet i går';

  @override
  String get plantDetailUpcomingCareTitle => '📅  KOMMENDE PLEJE';

  @override
  String get plantDetailDueNow => 'Skal nu';

  @override
  String get plantDetailEditPostsTooltip => 'Administrer indlæg';

  @override
  String get plantDetailNoteHint => 'Skriv en kort note…';

  @override
  String get plantDetailNoteTitle => 'Note';

  @override
  String get plantDetailNoteSubtitle =>
      'Hvad skete der i dag? Bladlus, første blomst, beskæring…';

  @override
  String get plantDetailTakePhoto => 'Tag billede';

  @override
  String get plantDetailPickLibrary => 'Vælg fra bibliotek';

  @override
  String get plantDetailWriteNote => 'Skriv note';

  @override
  String get plantDetailUseEmojiAgain => 'Brug emoji igen';

  @override
  String plantDetailSaveImageError(String error) {
    return 'Kunne ikke gemme billede: $error';
  }

  @override
  String plantDetailSavePhotoError(String error) {
    return 'Kunne ikke gemme foto: $error';
  }

  @override
  String get plantDetailDeletePhotoTitle => 'Slet billede?';

  @override
  String get plantDetailDeleteNoteTitle => 'Slet note?';

  @override
  String get plantDetailDeletePhotoBody => 'Billedet slettes fra enheden.';

  @override
  String get plantDetailDeleteNoteBody => 'Noten forsvinder.';

  @override
  String get plantDetailAdd => 'Tilføj';

  @override
  String get plantDetailNoPostsBody =>
      'Ingen indlæg endnu — begynd at dokumentere væksten med billeder og korte noter.';

  @override
  String get plantDetailChangeStatus => 'Ændre status';

  @override
  String get plantDetailLocationLabel => 'Sted';

  @override
  String plantDetailSowingMethodChip(String method) {
    return 'Så: $method';
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
  String get plantDetailHowSowBody => 'Bestemmer hvilke påmindelser du får.';

  @override
  String get plantDetailLocationTitle => 'Hvor står den?';

  @override
  String get plantDetailLocationBody =>
      'F.eks. \"nordre bed\", \"drivhuset\", \"altanen\".';

  @override
  String get plantDetailHarvestOffsetTitle => 'Juster høsttid';

  @override
  String get plantDetailHarvestOffsetBody =>
      'Tælleren forkert? Tilføj eller træk dage fra — gemmes på lige denne plante.';

  @override
  String get plantDetailReadyToHarvest => 'Klar til høst';

  @override
  String get plantDetailNextStepPresow => 'Jeg har forspiret';

  @override
  String get plantDetailNextStepDirectsow => 'Jeg har direkte­sået';

  @override
  String get plantDetailNextStepPlantout => 'Jeg har udplantet';

  @override
  String get plantDetailNextStepPlantedOut => 'Planterne er udplantet';

  @override
  String get plantDetailNextStepHarvestReady => 'Klar til høst';

  @override
  String get plantDetailNextStepHarvested => 'Høstet';

  @override
  String get plantDetailHowToTitle => 'Sådan gør du';

  @override
  String get plantDetailTipsTitle => 'Tips';

  @override
  String get plantDetailPestsTitle => 'Skadedyr at holde øje med';

  @override
  String get plantDetailNoCareTips => 'Ingen plejeråd tilgængelige endnu.';

  @override
  String get plantDetailInfoSun => 'Sol';

  @override
  String get plantDetailInfoWater => 'Vand';

  @override
  String get plantDetailInfoFertilizer => 'Gødning';

  @override
  String get plantDetailInfoFrost => 'Tåler til';

  @override
  String get plantDetailInfoSpacing => 'Afstand';

  @override
  String get plantDetailInfoHarvest => 'Høst';

  @override
  String get plantDetailHarvestSection => '🥕  Høst';

  @override
  String get plantDetailToolsSection => '🛒 Værktøjer og tilbehør';

  @override
  String get plantDetailSeasonSection => 'Sæson';

  @override
  String get plantDetailPhasePresow => 'Forspire';

  @override
  String get plantDetailPhaseDirectsow => 'Direkte­så';

  @override
  String get plantDetailPhasePlantout => 'Udplante';

  @override
  String get plantDetailPhaseHarvest => 'Høste';

  @override
  String get plantDetailZoneWarningBody =>
      'Det kan gå – men du har nok brug for vinterbeskyttelse eller et varmere sted.';

  @override
  String plantDetailDateAdded(String date) {
    return 'Tilføjet $date';
  }

  @override
  String plantDetailDateInGardenSince(String year) {
    return 'I haven siden $year';
  }

  @override
  String plantDetailDatePlanted(String date) {
    return 'Plantet $date';
  }

  @override
  String get plantDetailHarvestOffsetSubtitle => 'Juster høsttid';

  @override
  String plantDetailZoneWarning(String zone) {
    return 'Denne plante er ikke testet for zone $zone. Det kan gå – men du har nok brug for vinterbeskyttelse eller et varmere sted.';
  }

  @override
  String get harvestSectionTitle => '🥕 Høst';

  @override
  String get harvestRemoveTitle => 'Fjern post?';

  @override
  String harvestRemoveBody(String amount, String unit, String date) {
    return '$amount $unit fra $date fjernes.';
  }

  @override
  String harvestMoreEntries(String count) {
    return '+ $count ældre poster';
  }

  @override
  String harvestAddTitle(String plant) {
    return 'Log høst — $plant';
  }

  @override
  String get harvestAmountLabel => 'Mængde';

  @override
  String get harvestUnitLabel => 'Enhed';

  @override
  String get harvestNotesLabel => 'Note (valgfri)';

  @override
  String get harvestErrorAmountTooLow => 'Angiv en mængde større end 0';

  @override
  String get harvestErrorFutureDate => 'Du kan ikke logge høst i fremtiden';

  @override
  String get commonCancel => 'Annuller';

  @override
  String get commonDelete => 'Slet';

  @override
  String get commonSave => 'Gem';

  @override
  String get pestTypeLabelDisease => 'SYGDOM';

  @override
  String get pestTypeLabelDamage => 'SKADE';

  @override
  String get pestTypeLabelPest => 'SKADEDYR';

  @override
  String get statsShareButton => 'Del';

  @override
  String statsShareText(String year) {
    return 'Min have $year med Plantera 🌱';
  }

  @override
  String get statsShareFailed => 'Kunne ikke lave delbillede';

  @override
  String get paywallTitleBranded => 'Plantera Premium';

  @override
  String get paywallHeaderFrost => 'Få frostadvarsel før planterne fryser';

  @override
  String get paywallHeaderGardenLimit => 'Tilføj hele haven';

  @override
  String get paywallHeaderWaterAll => 'Vand alt med ét tryk';

  @override
  String get paywallHeaderPhotoLog => 'Fotodagbog for dine planter';

  @override
  String get paywallSubFrost =>
      'SMHI-baseret nattemperatur — vi pinger dig aftenen før frostnatten';

  @override
  String get paywallSubGardenLimit =>
      'Ingen grænser for hvor mange planter du følger';

  @override
  String get paywallSubWaterAll =>
      'Én knap markerer alle udendørsplanter vandet';

  @override
  String get paywallSubPhotoLog => 'Se dem vokse fra frø til høst';

  @override
  String get paywallSubHome => 'Frostvarsler, fotodagbog og alt ubegrænset';

  @override
  String get paywallSubDefault => 'Løft din have';

  @override
  String get paywallBenefitUnlimited => 'Ubegrænset antal planter i haven';

  @override
  String get paywallBenefitReminders => 'Alle påmindelser og frostadvarsler';

  @override
  String get paywallBenefitPhotos => 'Fotodagbog for hver plante';

  @override
  String get paywallBenefitNoAds => 'Ingen annoncer';

  @override
  String get paywallBenefitPdf => 'PDF-eksport af høstdagbogen';

  @override
  String get paywallBenefitArticles => 'Fuld adgang til vidensartikler';

  @override
  String get paywallPlanYearly => 'Årligt abonnement';

  @override
  String paywallPlanYearlySavings(String percent) {
    return 'Spar $percent% sammenlignet med måned';
  }

  @override
  String get paywallPlanMonthly => 'Månedligt abonnement';

  @override
  String get paywallPlanLifetime => 'Livstidskøb (engangsbetaling)';

  @override
  String paywallTrialCta(String period) {
    return 'Start gratis prøveperiode ($period)';
  }

  @override
  String paywallTrialThen(String price) {
    return 'Derefter $price';
  }

  @override
  String paywallPlanPriceFormat(String title, String price) {
    return '$title • $price';
  }

  @override
  String get paywallRestore => 'Gendan tidligere køb';

  @override
  String get paywallDisclaimer =>
      'Abonnementer fornyes automatisk indtil de annulleres i App Store-indstillingerne. Beløbet trækkes 24 t før fornyelse.';

  @override
  String get paywallTerms => 'Vilkår (EULA)';

  @override
  String get paywallPrivacy => 'Privatlivspolitik';

  @override
  String get paywallErrorStore =>
      'App Store er ikke tilgængelig lige nu — prøv igen om et øjeblik.';

  @override
  String get paywallErrorProduct =>
      'Købet kunne ikke indlæses fra App Store. Luk paywallen og åbn igen.';

  @override
  String get paywallErrorFailed => 'Købet mislykkedes. Prøv igen.';

  @override
  String paywallErrorOpenUrl(String url) {
    return 'Kunne ikke åbne $url';
  }

  @override
  String get paywallPurchaseSuccess =>
      'Premium aktiveret — tak! Alt er låst op.';

  @override
  String get paywallRestoreInProgress => 'Søger efter dine køb…';

  @override
  String get paywallRestoreFailed =>
      'Kunne ikke kontakte App Store. Prøv igen.';

  @override
  String get paywallRestoreSuccess => 'Premium gendannet — tak!';

  @override
  String get paywallRestoreAlreadyActive => 'Premium er allerede aktivt.';

  @override
  String get paywallRestoreNothingFound =>
      'Ingen køb fundet på dette Apple-ID.';

  @override
  String get paywallAlreadyPremiumTitle => 'Du har Premium';

  @override
  String get paywallAlreadyPremiumBody =>
      'Alle funktioner er låst op. Tak for støtten — det hjælper os bygge videre.';

  @override
  String get paywallAlreadyPremiumCta => 'Tilbage til haven';

  @override
  String get paywallProductsUnavailable =>
      'Kunne ikke hente priser fra App Store. Tjek internet og prøv igen.';

  @override
  String get paywallProductsRetry => 'Prøv igen';

  @override
  String get onboardingSlide1Title => 'Stop med at gætte hvornår du skal så';

  @override
  String get onboardingSlide1Body =>
      'Plantera kender din hårdførhedszone og fortæller dig præcis hvornår du skal forspire, direkte så eller plante ud — plante for plante.';

  @override
  String get onboardingSlide2Title => 'Frostvarsler du kan handle på';

  @override
  String get onboardingSlide2Body =>
      'Når en kold nat nærmer sig får du besked i tide til at dække spirerne. Ingen panik klokken tre om natten.';

  @override
  String get onboardingSlide3Title => 'Én morgenpåmindelse — ikke 50';

  @override
  String get onboardingSlide3Body =>
      'Vanding, beskæring, høst og sæsonopgaver samlet i én daglig oversigt så du rent faktisk får en høst at være stolt af.';

  @override
  String get onboardingFooterSkip => 'Spring over';

  @override
  String get onboardingFooterNext => 'Næste';

  @override
  String get onboardingFooterStart => 'Kom i gang';

  @override
  String get affiliateDisclosure =>
      'Annonslänkar – vi kan få provision om du handlar via Amazon.';

  @override
  String get monthlyProductsTitle => 'Månadens produkter';
}
