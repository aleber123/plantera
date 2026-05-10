// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appName => 'Plantera';

  @override
  String get appSubtitle => 'Ο ψηφιακός σύντροφος του κήπου σας';

  @override
  String get tabHome => 'Αρχική';

  @override
  String get tabCalendar => 'Ημερολόγιο';

  @override
  String get tabPlants => 'Φυτά';

  @override
  String get tabMyGarden => 'Τα φυτά μου';

  @override
  String get tabSettings => 'Ρυθμίσεις';

  @override
  String get tabOverview => 'Επισκόπηση';

  @override
  String get tabMyPlant => 'Το φυτό μου';

  @override
  String get tabCare => 'Φροντίδα';

  @override
  String get homeWelcomeTitle => 'Ας ξεκινήσουμε με το πρώτο σας φυτό';

  @override
  String get homeWelcomeBody =>
      'Περιηγηθείτε στη βάση φυτών και πατήστε + σε αυτό που καλλιεργείτε — το παρακολουθούμε από τη σπορά μέχρι τη συγκομιδή.';

  @override
  String get homeWelcomeCta => 'Περιήγηση φυτών';

  @override
  String get gardenOverviewTitle => 'Επόμενη συγκομιδή';

  @override
  String get gardenSeeAll => 'Όλα';

  @override
  String get gardenStatTotal => 'Στον κήπο';

  @override
  String get gardenStatHarvestSoon => 'Σύντομα συγκομιδή';

  @override
  String get gardenStatReadyNow => 'Έτοιμο τώρα';

  @override
  String gardenMore(Object count) {
    return '+$count ακόμα';
  }

  @override
  String get dailyInsightsTitle => 'Σήμερα στον κήπο';

  @override
  String get dailyInsightsAllGood =>
      'Όλα υπό έλεγχο. Τίποτα επείγον — απολαύστε τον κήπο.';

  @override
  String get upcomingCareTitle => 'Επερχόμενη φροντίδα';

  @override
  String get upcomingCareSubtitle =>
      'Πράγματα να κάνετε αυτόν και τον επόμενο μήνα.';

  @override
  String seasonPlannerTitle(Object year) {
    return 'Η σεζόν μου $year';
  }

  @override
  String get seasonPlannerSubtitle =>
      'Τι θέλετε να καλλιεργήσετε φέτος. Θα σας ειδοποιήσουμε όταν είναι ώρα για σπορά.';

  @override
  String seasonPlannerEmptyTitle(Object year) {
    return 'Σχεδιάστε τη σεζόν $year';
  }

  @override
  String get seasonPlannerEmptyBody =>
      'Τι θέλετε να καλλιεργήσετε φέτος; Θα σας υπενθυμίσουμε πότε να σπείρετε.';

  @override
  String get seasonPlannerEmptyCta => 'Επιλογή';

  @override
  String get seasonPlannerAddCta => 'Προσθήκη φυτού';

  @override
  String seasonPlannerCount(Object count) {
    return '$count';
  }

  @override
  String get seasonRowSowNow => 'Σπείρετε τώρα';

  @override
  String seasonRowDaysAway(Object days) {
    return 'Σε $days ημέρες';
  }

  @override
  String get seasonRowInSeason => 'Στη σεζόν';

  @override
  String get weatherUnavailable => 'Καιρός μη διαθέσιμος';

  @override
  String get weatherSetLocation => 'Ορίστε τη θέση σας στις ρυθμίσεις';

  @override
  String get dryPeriodTitle => 'Περίοδος ξηρασίας σε εξέλιξη';

  @override
  String get frostCardTitle => '❄️ Προστασία από παγετό';

  @override
  String get premiumTeaserTitle => 'Plantera Premium';

  @override
  String get premiumTeaserBody => 'Απεριόριστος κήπος χωρίς διαφημίσεις';

  @override
  String get calendarTitle => 'Ημερολόγιο φύτευσης';

  @override
  String get calendarMonthGuide => 'Οδηγός μήνα';

  @override
  String calendarTaskCount(Object count) {
    return '$count εργασίες';
  }

  @override
  String get calendarPhasePresow => 'ΕΣΩΤΕΡΙΚΗ ΣΠΟΡΑ';

  @override
  String get calendarPhaseDirectsow => 'ΑΠΕΥΘΕΙΑΣ ΣΠΟΡΑ';

  @override
  String get calendarPhasePlantout => 'ΦΥΤΕΨΗ';

  @override
  String get calendarPhaseHarvest => 'ΣΥΓΚΟΜΙΔΗ';

  @override
  String calendarPhaseCount(Object count) {
    return '$count φυτά';
  }

  @override
  String calendarEmptyTitle(Object month) {
    return 'Τίποτα προς σπορά ή συγκομιδή τον $month';
  }

  @override
  String get calendarEmptyBody =>
      'Χρησιμοποιήστε τον μήνα για σχεδιασμό — παραγγείλτε σπόρους, οργανώστε παρτέρια ή διαβάστε τον οδηγό του μήνα.';

  @override
  String get myGardenTitle => 'Τα φυτά μου';

  @override
  String get myGardenSearchHint => 'Αναζήτηση φυτού ή τοποθεσίας';

  @override
  String get myGardenFilterAll => 'Όλα';

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
  String get myGardenEmptyTitle => 'Ο κήπος σας είναι άδειος';

  @override
  String get myGardenEmptyBody =>
      'Προσθέστε φυτά από τη βάση δεδομένων για να ξεκινήσετε.';

  @override
  String get myGardenEmptyCta => 'Περιήγηση στη βάση';

  @override
  String get myGardenAddPlant => 'Προσθήκη φυτού';

  @override
  String get myGardenNoResults => 'Inga växter matchar';

  @override
  String get myGardenNoResultsBody =>
      'Pröva en annan sökning eller rensa filtren.';

  @override
  String get myGardenWateredNow => 'Ποτίστηκε τώρα';

  @override
  String get myGardenWateredToday => 'Ποτίστηκε σήμερα';

  @override
  String get myGardenWateredYesterday => 'Ποτίστηκε χθες';

  @override
  String get plantDatabaseTitle => 'Växtdatabas';

  @override
  String get plantDatabaseSearchHint => 'Sök växt';

  @override
  String get plantCategoryAll => 'Alla';

  @override
  String get addPlantNow => 'Προσθήκη στον κήπο τώρα';

  @override
  String get addPlantNowBody =>
      'Έχετε σπείρει ή φυτέψει — το παρακολουθούμε από σήμερα';

  @override
  String get addPlantSeason => 'Προσθήκη στη λίστα σποράς';

  @override
  String get addPlantSeasonBody =>
      'Σχεδιάζετε να καλλιεργήσετε — θα σας ειδοποιήσουμε πότε να σπείρετε';

  @override
  String get addPlantRemoveSeason => 'Ta bort från såningslistan';

  @override
  String get addPlantRemoveSeasonBody =>
      'Vi slutar påminna om sånings-fönstret';

  @override
  String addedToGardenTitle(Object plant) {
    return '$plant είναι στον κήπο σας';
  }

  @override
  String get addedToGardenBodyPlain =>
      'Το παρακολουθούμε από σήμερα και υπενθυμίζουμε πότισμα και συγκομιδή.';

  @override
  String addedToGardenBodyScheduled(Object list) {
    return 'Vi följer den från idag. Notiser inkommande för: $list.';
  }

  @override
  String get addedToGardenCta => 'Μετάβαση στον κήπο μου';

  @override
  String get phasePickerTitleNew => 'Var är du i processen?';

  @override
  String get phasePickerTitleEdit => 'Ändra status';

  @override
  String get phaseShowSimple => 'Visa enklare alternativ';

  @override
  String get phaseShowMore => 'Fler alternativ (för den vana odlaren)';

  @override
  String get phaseSimplePlanned => 'Σχεδιάζω καλλιέργεια';

  @override
  String get phaseSimplePlannedBody =>
      'Bara på listan — vi påminner när säsongen startar.';

  @override
  String get phaseSimpleGrowing => 'Αναπτύσσεται τώρα';

  @override
  String get phaseSimpleGrowingBody =>
      'Plantorna är på gång. Vi följer dem fram till skörd.';

  @override
  String get phaseSimpleHarvested => 'Έχει συγκομιδεί';

  @override
  String get phaseSimpleHarvestedBody =>
      'Säsongen är klar för den här plantan.';

  @override
  String get perennialEstablishedTitle => 'Από πότε το έχετε;';

  @override
  String get perennialEstablishedBody =>
      'Δεν χρειάζεται ακρίβεια – χρησιμοποιούμε μόνο το έτος.';

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
  String get statusPlanning => 'Σχεδιασμός';

  @override
  String get statusGrowingIndoors => 'Σπορά εσωτερικά';

  @override
  String get statusDirectSown => 'Απευθείας σπορά';

  @override
  String get statusHardening => 'Σκληραγώγηση';

  @override
  String get statusOutdoors => 'Στο ύπαιθρο';

  @override
  String get statusReadyToHarvest => 'Έτοιμο για συγκομιδή';

  @override
  String get statusHarvested => 'Συγκομιδέν';

  @override
  String get statusDormant => 'Ληθαργικό';

  @override
  String get sowingIndoors => 'Inomhus';

  @override
  String get sowingDirect => 'Direkt';

  @override
  String get sowingPlanta => 'Planta';

  @override
  String get sunFull => 'Πλήρης ήλιος';

  @override
  String get sunPartial => 'Ημισκιά';

  @override
  String get sunShade => 'Σκιά';

  @override
  String get waterSparse => 'Λίγο';

  @override
  String get waterRegular => 'Τακτικά';

  @override
  String get waterAbundant => 'Άφθονο';

  @override
  String get fertilizerLow => 'Χαμηλό';

  @override
  String get fertilizerMedium => 'Μέτριο';

  @override
  String get fertilizerHigh => 'Υψηλό';

  @override
  String get lifecycleAnnual => 'Ετήσιο';

  @override
  String get lifecycleBiennial => 'Διετές';

  @override
  String get lifecyclePerennial => 'Πολυετές';

  @override
  String get lifecycleTree => 'Δέντρο';

  @override
  String get lifecycleShrub => 'Θάμνος';

  @override
  String get categoryVegetables => 'Λαχανικά';

  @override
  String get categoryHerbs => 'Βότανα & μπαχαρικά';

  @override
  String get categoryFlowers => 'Λουλούδια';

  @override
  String get categoryBerries => 'Μούρα';

  @override
  String get categoryFruitTrees => 'Οπωροφόρα δέντρα';

  @override
  String get categoryOther => 'Άλλα';

  @override
  String get wateredNow => 'Ποτισμένο';

  @override
  String get wateredConfirmation => 'Ποτίστηκε ✓';

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
  String get harvestTitle => 'Συγκομιδή';

  @override
  String get harvestLog => 'Καταγραφή συγκομιδής';

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
  String get buttonCancel => 'Ακύρωση';

  @override
  String get buttonRemove => 'Αφαίρεση';

  @override
  String get buttonSave => 'Αποθήκευση';

  @override
  String get buttonNext => 'Επόμενο';

  @override
  String get buttonStart => 'Έναρξη';

  @override
  String get buttonSkip => 'Παράλειψη';

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
  String get settingsTitle => 'Ρυθμίσεις';

  @override
  String get settingsPremiumActive => 'Premium ενεργό';

  @override
  String get settingsPremiumUpgrade => 'Αναβάθμιση σε Premium';

  @override
  String get settingsPremiumUnlock => 'Lås upp alla funktioner';

  @override
  String get settingsMyGardens => 'Οι κήποι μου';

  @override
  String settingsMyGardensSubtitle(Object emoji, Object name) {
    return 'Aktiv: $emoji $name';
  }

  @override
  String get settingsMyGardensEmpty => 'Lägg till din första trädgård';

  @override
  String get settingsNotifications => 'Υπενθυμίσεις';

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
  String get settingsSupport => 'Υποστήριξη';

  @override
  String get settingsFeedback => 'Στείλτε σχόλια';

  @override
  String get settingsFeedbackBody =>
      'Buggar, funktionsönskemål eller bara ett vänligt hej';

  @override
  String get gardensTitle => 'Mina trädgårdar';

  @override
  String get gardensActive => 'ΕΝΕΡΓΟ';

  @override
  String get gardensAddNew => 'Προσθήκη νέου κήπου';

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
  String get introPage1Title => 'Προσθέστε φυτά που καλλιεργείτε';

  @override
  String get introPage1Body =>
      'Tryck + på en växt för att lägga till den i din trädgård. Vi följer den från sådd till skörd och påminner när det är dags att vattna, beskära eller plantera om.';

  @override
  String get introPage1Hint =>
      'Hittar du växten? Använd \"Växter\"-fliken i botten.';

  @override
  String get introPage2Title => 'Σχεδιάστε τη σεζόν σας';

  @override
  String get introPage2Body =>
      'Tryck på bokmärket för att lägga växten på din säsongs-lista. Du får en notis i februari/mars när det är dags att börja förodla, och i april när det är dags att direktså.';

  @override
  String get introPage2Hint => 'Säsongs-listan ser du på startsidan.';

  @override
  String get introPage3Title => 'Ελέγξτε τον κήπο σας';

  @override
  String get introPage3Body =>
      'Hem-sidan visar väder, torrperioder och vad du ska göra denna månad. På \"Min trädgård\"-fliken kan du se årets statistik, växtföljd och uppskattat värde av din skörd.';

  @override
  String get introPage3Hint =>
      'Skadedjur & sjukdomar finns i Inställningar när du behöver dem.';

  @override
  String get pestLibraryTitle => 'Παράσιτα & ασθένειες';

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
  String get tabTodo => 'Εργασίες';

  @override
  String get todoSectionToday => 'ΣΗΜΕΡΑ';

  @override
  String get todoSectionWeek => 'ΑΥΤΗ ΤΗ ΕΒΔΟΜΑΔΑ';

  @override
  String get todoSectionMonth => 'ΑΥΤΟΝ ΤΟΝ ΜΗΝΑ';

  @override
  String get todoSectionDoneToday => 'ΟΛΟΚΛΗΡΩΘΗΚΕ ΣΗΜΕΡΑ ✓';

  @override
  String get todoStatToday => 'σήμερα';

  @override
  String get todoStatWeek => 'αυτή την εβδομάδα';

  @override
  String get todoStatDone => 'ολοκληρώθηκε';

  @override
  String get todoEmptyTitle => 'Όλα υπό έλεγχο';

  @override
  String get todoEmptyBody =>
      'Τίποτα επείγον. Προσθέστε φυτά για να λαμβάνετε καθημερινές εργασίες.';

  @override
  String get todoSwipeDone => 'Έτοιμο';

  @override
  String get todoSwipeSnooze => 'Αναβολή';

  @override
  String get progressReadyToHarvest => 'Έτοιμο για συγκομιδή';

  @override
  String get progressHarvestNow => 'Συγκομιδή τώρα';

  @override
  String progressDaysLeft(Object days) {
    return '$days ημέρες απομένουν';
  }

  @override
  String progressApproxDaysLeft(Object days) {
    return '~$days ημέρες απομένουν';
  }

  @override
  String get climateCardTitle => 'Κλίμα τελευταίες 14 ημέρες';

  @override
  String get climateStatAvg => 'Μέση ημέρ.';

  @override
  String get climateStatMinMax => 'Ελάχ/Μέγ';

  @override
  String get climateStatGdd => 'GDD';

  @override
  String get climateInterpretWaking => 'Ο κήπος ξυπνά.';

  @override
  String get climateInterpretEarly =>
      'Πολύ πρώιμη εποχή – μόνο ψυχρανθεκτικά (κρεμμύδι, μπιζέλι, μαρούλι).';

  @override
  String get climateInterpretSpring =>
      'Εαρινή εποχή – οι απευθείας σπορές εγκαθίστανται, τα θερμόφιλα περιμένουν.';

  @override
  String get climateInterpretMidSpring =>
      'Μέση άνοιξη – ντομάτα και πιπεριά κάτω από πέπλο ή σε θερμοκήπιο.';

  @override
  String get climateInterpretFullGrowth =>
      'Πλήρης ανάπτυξη – όλα ωριμάζουν γρήγορα, ποτίστε και λιπάνετε.';

  @override
  String get climateInterpretHot =>
      'Καυτή περίοδος – προσοχή στο πότισμα των νεαρών φυτών.';

  @override
  String get climateTeaserTitle => 'Κάρτα κλίματος (Premium)';

  @override
  String get climateTeaserBody =>
      'Μέση θερμοκρασία + Growing Degree Days για καλύτερο χρονισμό σποράς και συγκομιδής.';

  @override
  String get weatherSetLocationHint => 'Ορίστε τοποθεσία στις ρυθμίσεις';

  @override
  String weatherFrostWarning(String date, String temp) {
    return 'Προειδοποίηση παγετού $date – $temp°C';
  }

  @override
  String dryPeriodBodyWithThirsty(
    String past,
    String next,
    String names,
    String more,
  ) {
    return 'Μόνο $past mm βροχής τις τελευταίες 14 ημέρες και $next mm αναμένονται την επόμενη εβδομάδα. Ποτίστε $names$more — τα φυτά ανθεκτικά στην ξηρασία αντέχουν περισσότερο.';
  }

  @override
  String dryPeriodBodyGeneral(String past, String next) {
    return 'Μόνο $past mm βροχής τις τελευταίες 14 ημέρες και $next mm αναμένονται την επόμενη εβδομάδα. Ποτίστε προσεκτικά, ειδικά νεοφυτεμένα και σε γλάστρες.';
  }

  @override
  String get dryPeriodMoreSuffix => ' κ.ά.';

  @override
  String get myGardenWaterAllTooltip => 'Ποτίστε όλα τα εξωτερικά φυτά';

  @override
  String myGardenSeasonStatsTooltip(String year) {
    return 'Η σεζόν μου $year';
  }

  @override
  String get myGardenGroupTooltip => 'Ομαδοποίηση';

  @override
  String get myGardenNoOutdoorPlants =>
      'Δεν υπάρχουν εξωτερικά φυτά για πότισμα τώρα.';

  @override
  String get myGardenWaterAllTitle => 'Πότισμα όλων;';

  @override
  String myGardenWaterAllConfirm(String count) {
    return 'Σημειώνει $count εξωτερικά φυτά ως ποτισμένα τώρα.';
  }

  @override
  String get myGardenWaterAllCancel => 'Ακύρωση';

  @override
  String get myGardenWaterAllAction => 'Πότισμα όλων';

  @override
  String myGardenWaterAllDone(String count) {
    return '$count φυτά ποτισμένα ✓';
  }

  @override
  String get myGardenLocationNone => 'Χωρίς τοποθεσία';

  @override
  String get myGardenCategoryOther => 'Άλλο';

  @override
  String myGardenStatusSince(String status, String year) {
    return '$status • από $year';
  }

  @override
  String myGardenStatusOnDate(String status, String date) {
    return '$status • $date';
  }

  @override
  String settingsMyGardensWithCount(String count) {
    return 'Οι κήποι μου ($count)';
  }

  @override
  String get settingsPlanMonthly => 'Μηνιαία συνδρομή';

  @override
  String get settingsPlanYearly => 'Ετήσια συνδρομή';

  @override
  String get settingsPlanLifetime => 'Δια βίου';

  @override
  String get settingsPlanFree => 'Δωρεάν';

  @override
  String get settingsStarterKit => '🛒 Κιτ έναρξης';

  @override
  String get settingsMorningHourPickerTitle =>
      'Πότε θέλετε την πρωινή ειδοποίηση;';

  @override
  String get settingsMorningHourPickerBody =>
      'Η πρωινή σύνοψη και όλες οι υπενθυμίσεις σποράς χτυπούν αυτήν την ώρα. Τίποτα δεν σας ξυπνά νωρίτερα.';

  @override
  String settingsHourFormat(String hour) {
    return '$hour:00';
  }

  @override
  String settingsBackupFailed(String error) {
    return 'Αποτυχία δημιουργίας αντιγράφου: $error';
  }

  @override
  String get settingsFeedbackSubject => 'Σχόλια Plantera';

  @override
  String settingsFeedbackBodyTemplate(String version) {
    return 'Γεια!\n\nΣχόλια / ερώτηση / αναφορά σφάλματος:\n\n\n— Εστάλη από Plantera $version';
  }

  @override
  String get gardensDelete => 'Διαγραφή';

  @override
  String get gardensCancel => 'Ακύρωση';

  @override
  String get gardensNameLabel => 'Όνομα';

  @override
  String gardensZoneDescription(String zone, String description) {
    return 'Ζώνη $zone – $description';
  }

  @override
  String gardensCityFormat(String city, String zone) {
    return '$city · $zone';
  }

  @override
  String get introSkip => 'Παράλειψη';

  @override
  String get introNext => 'Επόμενο';

  @override
  String get introStart => 'Ξεκινήστε';

  @override
  String get onboardingWelcome => 'Καλώς ήρθατε στο Plantera';

  @override
  String get onboardingBody =>
      'Επιλέξτε την τοποθεσία σας για εξατομικευμένες συμβουλές, ειδοποιήσεις παγετού και σωστές περιόδους σποράς.';

  @override
  String get onboardingUseGps => 'Χρήση τοποθεσίας μου';

  @override
  String get onboardingLocating => 'Λήψη τοποθεσίας…';

  @override
  String get onboardingOrPickCity => 'ή επιλέξτε πόλη';

  @override
  String onboardingZoneSubtitle(String zone) {
    return 'Ζώνη $zone';
  }

  @override
  String get onboardingErrorLocationServicesOff =>
      'Υπηρεσίες τοποθεσίας απενεργοποιημένες';

  @override
  String get onboardingErrorLocationDenied => 'Άρνηση πρόσβασης τοποθεσίας';

  @override
  String get phasePerennialHaveIt => 'Το έχω στον κήπο';

  @override
  String get phasePerennialHaveItBody =>
      'Θα δείξουμε αναμενόμενη συγκομιδή και θα υπενθυμίσουμε για κλάδεμα, λίπανση και εποχιακή φροντίδα.';

  @override
  String get phasePerennialPlanning => 'Σχεδιάζω να φυτέψω';

  @override
  String get phasePerennialPlanningBody =>
      'Στη λίστα μέχρι να φυτέψετε — οι υπενθυμίσεις φτάνουν εγκαίρως.';

  @override
  String get phaseDetailedPlanned => 'Σχεδιάζω να καλλιεργήσω';

  @override
  String get phaseDetailedPlannedBody =>
      'Μόνο στη λίστα — υπενθυμίσεις εγκαίρως στην έναρξη της σεζόν.';

  @override
  String get phaseDetailedPresow => 'Προφυτεύω εντός';

  @override
  String get phaseDetailedPresowBody =>
      'Τα φυτά μεγαλώνουν εντός. Υπενθύμιση σκλήρυνσης σε 5 εβδομάδες.';

  @override
  String get phaseDetailedDirectsow => 'Έσπειρα απευθείας έξω';

  @override
  String get phaseDetailedDirectsowBody =>
      'Σπαρμένο επιτόπου. Απομένει υπενθύμιση συγκομιδής.';

  @override
  String get phaseDetailedPlantout => 'Τα φυτά μεταφυτεύτηκαν';

  @override
  String get phaseDetailedPlantoutBody =>
      'Στην τελική θέση. Απομένει υπενθύμιση συγκομιδής.';

  @override
  String get phaseFinishedReady => 'Έτοιμο για συγκομιδή';

  @override
  String get phaseFinishedReadyBody => 'Σημειώνεται έτοιμο για συγκομιδή τώρα.';

  @override
  String get phaseFinishedHarvested => 'Συγκομίστηκε';

  @override
  String get phaseFinishedHarvestedBody =>
      'Η σεζόν τελείωσε — υπενθυμίσεις σε παύση.';

  @override
  String get phaseFinishedDormant => 'Σε λήθαργο';

  @override
  String get phaseFinishedDormantBody => 'Το φυτό δεν είναι ενεργό τώρα.';

  @override
  String get phaseDateHelpPresow => 'Ποια ημερομηνία ξεκινήσατε αυτό το φυτό;';

  @override
  String get phaseDateHelpDirectsow => 'Ποια ημερομηνία σπείρατε απευθείας;';

  @override
  String get phaseDateHelpPlantout => 'Ποια ημερομηνία βγήκαν τα φυτά;';

  @override
  String get phaseDateHelpDefault => 'Ημερομηνία';

  @override
  String get phasePerennialYearTitle => 'Από πότε το έχετε;';

  @override
  String get phasePerennialYearBody =>
      'Δεν χρειάζεται ακρίβεια — χρησιμοποιούμε μόνο το έτος.';

  @override
  String phasePerennialYearThis(String year) {
    return 'Φέτος ($year)';
  }

  @override
  String phasePerennialYearLast(String year) {
    return 'Πέρυσι ($year)';
  }

  @override
  String phasePerennialYearTwo(String year) {
    return 'Πριν δύο χρόνια ($year)';
  }

  @override
  String get phasePerennialYearOlder => 'Παλαιότερα (πριν μερικά χρόνια)';

  @override
  String get plantDetailTabOverview => 'Επισκόπηση';

  @override
  String get plantDetailTabMyPlant => 'Το φυτό μου';

  @override
  String get plantDetailTabCare => 'Φροντίδα';

  @override
  String get plantDetailAddCta => 'Προσθήκη στον κήπο μου';

  @override
  String get plantDetailRemoveCta => 'Αφαίρεση από τον κήπο';

  @override
  String get plantDetailRemoveTitle => 'Αφαίρεση από τον κήπο;';

  @override
  String get plantDetailRemoveBody => 'Δεν αναιρείται.';

  @override
  String get plantDetailCancel => 'Ακύρωση';

  @override
  String get plantDetailDelete => 'Διαγραφή';

  @override
  String get plantDetailSave => 'Αποθήκευση';

  @override
  String get plantDetailReset => 'Επαναφορά';

  @override
  String get plantDetailReuse => 'Επαναχρήση';

  @override
  String get plantDetailWaterNowSuffix => 'Ποτίστηκε τώρα';

  @override
  String get plantDetailWaterTapHint => 'Πατήστε όταν ποτίζετε';

  @override
  String get plantDetailWaterDoneSnack => 'Ποτίστηκε ✓';

  @override
  String get plantDetailWaterNotYet => 'Δεν έχει ποτιστεί ακόμα';

  @override
  String get plantDetailWaterJust => 'Μόλις ποτίστηκε';

  @override
  String get plantDetailWaterToday => 'Ποτίστηκε σήμερα';

  @override
  String get plantDetailWaterYesterday => 'Ποτίστηκε χθες';

  @override
  String get plantDetailUpcomingCareTitle => '📅  ΕΠΕΡΧΟΜΕΝΗ ΦΡΟΝΤΙΔΑ';

  @override
  String get plantDetailDueNow => 'Τώρα';

  @override
  String get plantDetailEditPostsTooltip => 'Διαχείριση αναρτήσεων';

  @override
  String get plantDetailNoteHint => 'Γράψτε μια σύντομη σημείωση…';

  @override
  String get plantDetailNoteTitle => 'Σημείωση';

  @override
  String get plantDetailNoteSubtitle =>
      'Τι συνέβη σήμερα; Αφίδες, πρώτο άνθος, κλάδεμα…';

  @override
  String get plantDetailTakePhoto => 'Λήψη φωτογραφίας';

  @override
  String get plantDetailPickLibrary => 'Επιλογή από βιβλιοθήκη';

  @override
  String get plantDetailWriteNote => 'Γράψτε σημείωση';

  @override
  String get plantDetailUseEmojiAgain => 'Επαναχρήση emoji';

  @override
  String plantDetailSaveImageError(String error) {
    return 'Αδυναμία αποθήκευσης εικόνας: $error';
  }

  @override
  String plantDetailSavePhotoError(String error) {
    return 'Αδυναμία αποθήκευσης φωτογραφίας: $error';
  }

  @override
  String get plantDetailDeletePhotoTitle => 'Διαγραφή φωτογραφίας;';

  @override
  String get plantDetailDeleteNoteTitle => 'Διαγραφή σημείωσης;';

  @override
  String get plantDetailDeletePhotoBody =>
      'Η φωτογραφία διαγράφεται από τη συσκευή.';

  @override
  String get plantDetailDeleteNoteBody => 'Η σημείωση εξαφανίζεται.';

  @override
  String get plantDetailAdd => 'Προσθήκη';

  @override
  String get plantDetailNoPostsBody =>
      'Καμία ανάρτηση — ξεκινήστε να καταγράφετε την ανάπτυξη.';

  @override
  String get plantDetailChangeStatus => 'Αλλαγή κατάστασης';

  @override
  String get plantDetailLocationLabel => 'Τοποθεσία';

  @override
  String plantDetailSowingMethodChip(String method) {
    return 'Σπορά: $method';
  }

  @override
  String plantDetailSowingMethodSnack(String method) {
    return 'Μέθοδος σποράς: $method';
  }

  @override
  String get plantDetailDateHelp => 'Ποια ημερομηνία;';

  @override
  String get plantDetailHowSowTitle => 'Πώς σπέρνετε;';

  @override
  String get plantDetailHowSowBody => 'Καθορίζει ποιες υπενθυμίσεις λαμβάνετε.';

  @override
  String get plantDetailLocationTitle => 'Πού βρίσκεται;';

  @override
  String get plantDetailLocationBody =>
      'Π.χ. \"βόρειο παρτέρι\", \"θερμοκήπιο\", \"μπαλκόνι\".';

  @override
  String get plantDetailHarvestOffsetTitle => 'Ρύθμιση χρόνου συγκομιδής';

  @override
  String get plantDetailHarvestOffsetBody =>
      'Λάθος μετρητής; Προσθέστε ή αφαιρέστε ημέρες — αποθηκεύεται μόνο για αυτό το φυτό.';

  @override
  String get plantDetailReadyToHarvest => 'Έτοιμο για συγκομιδή';

  @override
  String get plantDetailNextStepPresow => 'Έσπειρα εντός';

  @override
  String get plantDetailNextStepDirectsow => 'Έσπειρα απευθείας';

  @override
  String get plantDetailNextStepPlantout => 'Μεταφύτευσα';

  @override
  String get plantDetailNextStepPlantedOut => 'Τα φυτά μεταφυτεύτηκαν';

  @override
  String get plantDetailNextStepHarvestReady => 'Έτοιμο για συγκομιδή';

  @override
  String get plantDetailNextStepHarvested => 'Συγκομίστηκε';

  @override
  String get plantDetailHowToTitle => 'Πώς να το κάνετε';

  @override
  String get plantDetailTipsTitle => 'Συμβουλές';

  @override
  String get plantDetailPestsTitle => 'Παράσιτα προς παρακολούθηση';

  @override
  String get plantDetailNoCareTips => 'Δεν υπάρχουν συμβουλές φροντίδας.';

  @override
  String get plantDetailInfoSun => 'Ήλιος';

  @override
  String get plantDetailInfoWater => 'Νερό';

  @override
  String get plantDetailInfoFertilizer => 'Λίπασμα';

  @override
  String get plantDetailInfoFrost => 'Αντέχει έως';

  @override
  String get plantDetailInfoSpacing => 'Απόσταση';

  @override
  String get plantDetailInfoHarvest => 'Συγκομιδή';

  @override
  String get plantDetailHarvestSection => '🥕  Συγκομιδή';

  @override
  String get plantDetailToolsSection => '🛒 Εργαλεία και αξεσουάρ';

  @override
  String get plantDetailSeasonSection => 'Σεζόν';

  @override
  String get plantDetailPhasePresow => 'Σπορά εντός';

  @override
  String get plantDetailPhaseDirectsow => 'Απευθείας σπορά';

  @override
  String get plantDetailPhasePlantout => 'Μεταφύτευση';

  @override
  String get plantDetailPhaseHarvest => 'Συγκομιδή';

  @override
  String get plantDetailZoneWarningBody =>
      'Μπορεί να γίνει — αλλά πιθανόν θα χρειαστεί προστασία ή θερμότερη θέση.';

  @override
  String plantDetailDateAdded(String date) {
    return 'Προστέθηκε $date';
  }

  @override
  String plantDetailDateInGardenSince(String year) {
    return 'Στον κήπο από $year';
  }

  @override
  String plantDetailDatePlanted(String date) {
    return 'Φυτεύτηκε $date';
  }

  @override
  String get plantDetailHarvestOffsetSubtitle => 'Ρύθμιση χρόνου συγκομιδής';

  @override
  String plantDetailZoneWarning(String zone) {
    return 'Αυτό το φυτό δεν έχει δοκιμαστεί για ζώνη $zone. Μπορεί να γίνει — αλλά πιθανόν θα χρειαστεί προστασία ή θερμότερη θέση.';
  }

  @override
  String get harvestSectionTitle => '🥕 Συγκομιδή';

  @override
  String get harvestRemoveTitle => 'Αφαίρεση καταχώρησης;';

  @override
  String harvestRemoveBody(String amount, String unit, String date) {
    return 'Αφαιρούνται $amount $unit από $date.';
  }

  @override
  String harvestMoreEntries(String count) {
    return '+ $count παλαιότερες καταχωρήσεις';
  }

  @override
  String harvestAddTitle(String plant) {
    return 'Καταγραφή συγκομιδής — $plant';
  }

  @override
  String get harvestAmountLabel => 'Ποσότητα';

  @override
  String get harvestUnitLabel => 'Μονάδα';

  @override
  String get harvestNotesLabel => 'Σημείωση (προαιρετικό)';

  @override
  String get harvestErrorAmountTooLow => 'Δώστε ποσότητα μεγαλύτερη του 0';

  @override
  String get harvestErrorFutureDate =>
      'Δεν μπορείτε να καταγράψετε μελλοντική συγκομιδή';

  @override
  String get commonCancel => 'Ακύρωση';

  @override
  String get commonDelete => 'Διαγραφή';

  @override
  String get commonSave => 'Αποθήκευση';

  @override
  String get pestTypeLabelDisease => 'ΑΣΘΕΝΕΙΑ';

  @override
  String get pestTypeLabelDamage => 'ΖΗΜΙΑ';

  @override
  String get pestTypeLabelPest => 'ΠΑΡΑΣΙΤΟ';
}
