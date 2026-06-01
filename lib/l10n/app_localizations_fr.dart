// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Plantera';

  @override
  String get appSubtitle => 'Votre compagnon de jardinage numérique';

  @override
  String get tabHome => 'Accueil';

  @override
  String get tabCalendar => 'Calendrier';

  @override
  String get tabPlants => 'Plantes';

  @override
  String get tabMyGarden => 'Mes plantes';

  @override
  String get tabSettings => 'Réglages';

  @override
  String get tabOverview => 'Aperçu';

  @override
  String get tabMyPlant => 'Ma plante';

  @override
  String get tabCare => 'Soins';

  @override
  String get homeWelcomeTitle => 'Commençons par votre première plante';

  @override
  String get homeWelcomeBody =>
      'Parcourez la base de données et appuyez sur + pour ce que vous cultivez — nous suivons la plante du semis à la récolte.';

  @override
  String get homeWelcomeCta => 'Parcourir les plantes';

  @override
  String get gardenOverviewTitle => 'Prochaine récolte';

  @override
  String get gardenSeeAll => 'Voir tout';

  @override
  String get gardenStatTotal => 'Au jardin';

  @override
  String get gardenStatHarvestSoon => 'Bientôt récolte';

  @override
  String get gardenStatReadyNow => 'Prêt maintenant';

  @override
  String gardenMore(Object count) {
    return '+$count de plus';
  }

  @override
  String get dailyInsightsTitle => 'Aujourd\'hui au jardin';

  @override
  String get dailyInsightsAllGood =>
      'Tout va bien. Rien d\'urgent — profitez du jardin.';

  @override
  String get upcomingCareTitle => 'Soins à venir';

  @override
  String get upcomingCareSubtitle => 'À faire ce mois-ci et le mois prochain.';

  @override
  String seasonPlannerTitle(Object year) {
    return 'Ma saison $year';
  }

  @override
  String get seasonPlannerSubtitle =>
      'Ce que vous voulez cultiver cette année. Nous vous prévenons quand il est temps de semer.';

  @override
  String seasonPlannerEmptyTitle(Object year) {
    return 'Planifier la saison $year';
  }

  @override
  String get seasonPlannerEmptyBody =>
      'Que voulez-vous cultiver cette année ? Nous vous rappelons quand il est temps de semer.';

  @override
  String get seasonPlannerEmptyCta => 'Choisir';

  @override
  String get seasonPlannerAddCta => 'Ajouter une plante';

  @override
  String seasonPlannerCount(Object count) {
    return '$count';
  }

  @override
  String get seasonRowSowNow => 'Semer maintenant';

  @override
  String seasonRowDaysAway(Object days) {
    return 'Dans $days jours';
  }

  @override
  String get seasonRowInSeason => 'En saison';

  @override
  String get weatherUnavailable => 'Météo indisponible';

  @override
  String get weatherSetLocation => 'Définir votre lieu dans les réglages';

  @override
  String get dryPeriodTitle => 'Période sèche en cours';

  @override
  String get frostCardTitle => '❄️ Protéger du gel';

  @override
  String get premiumTeaserTitle => 'Plantera Premium';

  @override
  String get premiumTeaserBody => 'Jardin illimité et sans publicité';

  @override
  String get calendarTitle => 'Calendrier de plantation';

  @override
  String get calendarMonthGuide => 'Guide du mois';

  @override
  String calendarTaskCount(Object count) {
    return '$count tâches';
  }

  @override
  String get calendarPhasePresow => 'SEMER À L\'INTÉRIEUR';

  @override
  String get calendarPhaseDirectsow => 'SEMIS DIRECT';

  @override
  String get calendarPhasePlantout => 'PLANTER';

  @override
  String get calendarPhaseHarvest => 'RÉCOLTE';

  @override
  String calendarPhaseCount(Object count) {
    return '$count plantes';
  }

  @override
  String calendarEmptyTitle(Object month) {
    return 'Rien à semer ou récolter en $month';
  }

  @override
  String get calendarEmptyBody =>
      'Profitez du mois pour planifier — commandez des graines, organisez les massifs ou consultez le guide du mois.';

  @override
  String get myGardenTitle => 'Mes plantes';

  @override
  String get myGardenSearchHint => 'Chercher plante ou emplacement';

  @override
  String get myGardenFilterAll => 'Toutes';

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
  String get myGardenEmptyTitle => 'Votre jardin est vide';

  @override
  String get myGardenEmptyBody =>
      'Ajoutez des plantes depuis la base de données pour commencer à construire votre jardin.';

  @override
  String get myGardenEmptyCta => 'Parcourir la base de données';

  @override
  String get myGardenAddPlant => 'Ajouter une plante';

  @override
  String get myGardenNoResults => 'Inga växter matchar';

  @override
  String get myGardenNoResultsBody =>
      'Pröva en annan sökning eller rensa filtren.';

  @override
  String get myGardenWateredNow => 'Arrosé à l\'instant';

  @override
  String get myGardenWateredToday => 'Arrosé aujourd\'hui';

  @override
  String get myGardenWateredYesterday => 'Arrosé hier';

  @override
  String get plantDatabaseTitle => 'Växtdatabas';

  @override
  String get plantDatabaseSearchHint => 'Sök växt';

  @override
  String get plantCategoryAll => 'Alla';

  @override
  String get addPlantNow => 'Ajouter au jardin maintenant';

  @override
  String get addPlantNowBody =>
      'Vous avez semé ou planté — nous suivons à partir d\'aujourd\'hui';

  @override
  String get addPlantSeason => 'Ajouter à la liste de semis';

  @override
  String get addPlantSeasonBody =>
      'Vous prévoyez de cultiver — nous vous prévenons quand semer';

  @override
  String get addPlantRemoveSeason => 'Ta bort från såningslistan';

  @override
  String get addPlantRemoveSeasonBody =>
      'Vi slutar påminna om sånings-fönstret';

  @override
  String addedToGardenTitle(Object plant) {
    return '$plant est dans votre jardin';
  }

  @override
  String get addedToGardenBodyPlain =>
      'Nous suivons à partir d\'aujourd\'hui et rappelons l\'arrosage et la récolte.';

  @override
  String addedToGardenBodyScheduled(Object list) {
    return 'Vi följer den från idag. Notiser inkommande för: $list.';
  }

  @override
  String get addedToGardenCta => 'Aller à mon jardin';

  @override
  String get phasePickerTitleNew => 'Var är du i processen?';

  @override
  String get phasePickerTitleEdit => 'Ändra status';

  @override
  String get phaseShowSimple => 'Visa enklare alternativ';

  @override
  String get phaseShowMore => 'Fler alternativ (för den vana odlaren)';

  @override
  String get phaseSimplePlanned => 'Je prévois de cultiver';

  @override
  String get phaseSimplePlannedBody =>
      'Bara på listan — vi påminner när säsongen startar.';

  @override
  String get phaseSimpleGrowing => 'En croissance maintenant';

  @override
  String get phaseSimpleGrowingBody =>
      'Plantorna är på gång. Vi följer dem fram till skörd.';

  @override
  String get phaseSimpleHarvested => 'Récolté';

  @override
  String get phaseSimpleHarvestedBody =>
      'Säsongen är klar för den här plantan.';

  @override
  String get perennialEstablishedTitle => 'Depuis quand l\'avez-vous ?';

  @override
  String get perennialEstablishedBody =>
      'Pas besoin d\'être exact – nous n\'utilisons que l\'année.';

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
  String get statusPlanning => 'Planification';

  @override
  String get statusGrowingIndoors => 'Semis intérieur';

  @override
  String get statusDirectSown => 'Semis direct';

  @override
  String get statusHardening => 'Endurcissement';

  @override
  String get statusOutdoors => 'Au jardin';

  @override
  String get statusReadyToHarvest => 'Prêt à récolter';

  @override
  String get statusHarvested => 'Récolté';

  @override
  String get statusDormant => 'En dormance';

  @override
  String get sowingIndoors => 'Inomhus';

  @override
  String get sowingDirect => 'Direkt';

  @override
  String get sowingPlanta => 'Planta';

  @override
  String get sunFull => 'Plein soleil';

  @override
  String get sunPartial => 'Mi-ombre';

  @override
  String get sunShade => 'Ombre';

  @override
  String get waterSparse => 'Faible';

  @override
  String get waterRegular => 'Régulier';

  @override
  String get waterAbundant => 'Abondant';

  @override
  String get fertilizerLow => 'Faible';

  @override
  String get fertilizerMedium => 'Moyen';

  @override
  String get fertilizerHigh => 'Élevé';

  @override
  String get lifecycleAnnual => 'Annuelle';

  @override
  String get lifecycleBiennial => 'Bisannuelle';

  @override
  String get lifecyclePerennial => 'Vivace';

  @override
  String get lifecycleTree => 'Arbre';

  @override
  String get lifecycleShrub => 'Arbuste';

  @override
  String get categoryVegetables => 'Légumes';

  @override
  String get categoryHerbs => 'Herbes & épices';

  @override
  String get categoryFlowers => 'Fleurs';

  @override
  String get categoryBerries => 'Baies';

  @override
  String get categoryFruitTrees => 'Arbres fruitiers';

  @override
  String get categoryOther => 'Autre';

  @override
  String get wateredNow => 'Arrosé';

  @override
  String get wateredConfirmation => 'Arrosé ✓';

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
  String get harvestTitle => 'Récolte';

  @override
  String get harvestLog => 'Enregistrer récolte';

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
  String get buttonCancel => 'Annuler';

  @override
  String get buttonRemove => 'Supprimer';

  @override
  String get buttonSave => 'Enregistrer';

  @override
  String get buttonNext => 'Suivant';

  @override
  String get buttonStart => 'Démarrer';

  @override
  String get buttonSkip => 'Passer';

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
  String get settingsTitle => 'Réglages';

  @override
  String get settingsPremiumActive => 'Premium actif';

  @override
  String get settingsPremiumUpgrade => 'Passer à Premium';

  @override
  String get settingsPremiumUnlock => 'Lås upp alla funktioner';

  @override
  String get settingsMyGardens => 'Mes jardins';

  @override
  String settingsMyGardensSubtitle(Object emoji, Object name) {
    return 'Aktiv: $emoji $name';
  }

  @override
  String get settingsMyGardensEmpty => 'Lägg till din första trädgård';

  @override
  String get settingsNotifications => 'Rappels';

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
  String get settingsFeedback => 'Envoyer un retour';

  @override
  String get settingsFeedbackBody =>
      'Buggar, funktionsönskemål eller bara ett vänligt hej';

  @override
  String get gardensTitle => 'Mina trädgårdar';

  @override
  String get gardensActive => 'ACTIF';

  @override
  String get gardensAddNew => 'Ajouter un jardin';

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
  String get introPage1Title => 'Ajoutez les plantes que vous cultivez';

  @override
  String get introPage1Body =>
      'Tryck + på en växt för att lägga till den i din trädgård. Vi följer den från sådd till skörd och påminner när det är dags att vattna, beskära eller plantera om.';

  @override
  String get introPage1Hint =>
      'Hittar du växten? Använd \"Växter\"-fliken i botten.';

  @override
  String get introPage2Title => 'Planifiez votre saison';

  @override
  String get introPage2Body =>
      'Tryck på bokmärket för att lägga växten på din säsongs-lista. Du får en notis i februari/mars när det är dags att börja förodla, och i april när det är dags att direktså.';

  @override
  String get introPage2Hint => 'Säsongs-listan ser du på startsidan.';

  @override
  String get introPage3Title => 'Maîtrisez votre jardin';

  @override
  String get introPage3Body =>
      'Hem-sidan visar väder, torrperioder och vad du ska göra denna månad. På \"Min trädgård\"-fliken kan du se årets statistik, växtföljd och uppskattat värde av din skörd.';

  @override
  String get introPage3Hint =>
      'Skadedjur & sjukdomar finns i Inställningar när du behöver dem.';

  @override
  String get pestLibraryTitle => 'Nuisibles & maladies';

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
  String get tabTodo => 'À faire';

  @override
  String get todoSectionToday => 'AUJOURD\'HUI';

  @override
  String get todoSectionWeek => 'CETTE SEMAINE';

  @override
  String get todoSectionMonth => 'CE MOIS';

  @override
  String get todoSectionDoneToday => 'FAIT AUJOURD\'HUI ✓';

  @override
  String get todoStatToday => 'aujourd\'hui';

  @override
  String get todoStatWeek => 'cette semaine';

  @override
  String get todoStatDone => 'fait';

  @override
  String get todoEmptyTitle => 'Tout sous contrôle';

  @override
  String get todoEmptyBody =>
      'Rien d\'urgent. Ajoutez des plantes pour recevoir des tâches quotidiennes.';

  @override
  String get todoSwipeDone => 'Fait';

  @override
  String get todoSwipeSnooze => 'Reporter';

  @override
  String get progressReadyToHarvest => 'Prêt à récolter';

  @override
  String get progressHarvestNow => 'Récolter maintenant';

  @override
  String progressDaysLeft(Object days) {
    return '$days jours restants';
  }

  @override
  String progressApproxDaysLeft(Object days) {
    return '~$days jours restants';
  }

  @override
  String get climateCardTitle => 'Climat des 14 derniers jours';

  @override
  String get climateStatAvg => 'Moy. jour';

  @override
  String get climateStatMinMax => 'Min/max';

  @override
  String get climateStatGdd => 'GDD';

  @override
  String get climateInterpretWaking => 'Le jardin se réveille.';

  @override
  String get climateInterpretEarly =>
      'Saison très précoce – uniquement les rustiques (oignon, pois, salade).';

  @override
  String get climateInterpretSpring =>
      'Saison de printemps – les semis directs s\'établissent, les frileuses attendent.';

  @override
  String get climateInterpretMidSpring =>
      'Mi-printemps – tomate et poivron sous voile ou en serre.';

  @override
  String get climateInterpretFullGrowth =>
      'Pleine croissance – tout mûrit vite, arrosez et fertilisez.';

  @override
  String get climateInterpretHot =>
      'Période chaude – attention à l\'arrosage des jeunes plants.';

  @override
  String get climateTeaserTitle => 'Carte climat (Premium)';

  @override
  String get climateTeaserBody =>
      'Température moyenne + Growing Degree Days pour mieux planifier semis et récolte.';

  @override
  String get weatherSetLocationHint => 'Définir le lieu dans les paramètres';

  @override
  String weatherFrostWarning(String date, String temp) {
    return 'Alerte gel $date – $temp°C';
  }

  @override
  String dryPeriodBodyWithThirsty(
    String past,
    String next,
    String names,
    String more,
  ) {
    return 'Seulement $past mm de pluie ces 14 derniers jours et $next mm prévus la semaine prochaine. Arrosez $names$more — les plantes tolérantes à la sécheresse tiennent plus longtemps.';
  }

  @override
  String dryPeriodBodyGeneral(String past, String next) {
    return 'Seulement $past mm de pluie ces 14 derniers jours et $next mm prévus la semaine prochaine. Arrosez soigneusement, surtout les jeunes plantations et les pots.';
  }

  @override
  String get dryPeriodMoreSuffix => ' etc.';

  @override
  String get myGardenWaterAllTooltip =>
      'Arroser toutes les plantes d\'extérieur';

  @override
  String myGardenSeasonStatsTooltip(String year) {
    return 'Ma saison $year';
  }

  @override
  String get myGardenGroupTooltip => 'Grouper par';

  @override
  String get myGardenNoOutdoorPlants =>
      'Pas de plantes d\'extérieur à arroser maintenant.';

  @override
  String get myGardenWaterAllTitle => 'Tout arroser ?';

  @override
  String myGardenWaterAllConfirm(String count) {
    return 'Marque $count plantes d\'extérieur comme arrosées.';
  }

  @override
  String get myGardenWaterAllCancel => 'Annuler';

  @override
  String get myGardenWaterAllAction => 'Tout arroser';

  @override
  String myGardenWaterAllDone(String count) {
    return '$count plantes arrosées ✓';
  }

  @override
  String get myGardenLocationNone => 'Sans emplacement';

  @override
  String get myGardenCategoryOther => 'Autre';

  @override
  String myGardenStatusSince(String status, String year) {
    return '$status • depuis $year';
  }

  @override
  String myGardenStatusOnDate(String status, String date) {
    return '$status • $date';
  }

  @override
  String settingsMyGardensWithCount(String count) {
    return 'Mes jardins ($count)';
  }

  @override
  String get settingsPlanMonthly => 'Abonnement mensuel';

  @override
  String get settingsPlanYearly => 'Abonnement annuel';

  @override
  String get settingsPlanLifetime => 'À vie';

  @override
  String get settingsPlanFree => 'Gratuit';

  @override
  String get settingsStarterKit => '🛒 Kit de démarrage';

  @override
  String get settingsMorningHourPickerTitle =>
      'Quand voulez-vous recevoir le ping du matin ?';

  @override
  String get settingsMorningHourPickerBody =>
      'Le résumé matinal et tous les rappels de plantation se déclenchent à cette heure. Rien ne vous réveille avant.';

  @override
  String settingsHourFormat(String hour) {
    return '${hour}h00';
  }

  @override
  String settingsBackupFailed(String error) {
    return 'Impossible de créer la sauvegarde : $error';
  }

  @override
  String get settingsFeedbackSubject => 'Commentaire Plantera';

  @override
  String settingsFeedbackBodyTemplate(String version) {
    return 'Bonjour !\n\nCommentaire / question / rapport de bug :\n\n\n— Envoyé depuis Plantera $version';
  }

  @override
  String get gardensDelete => 'Supprimer';

  @override
  String get gardensCancel => 'Annuler';

  @override
  String get gardensNameLabel => 'Nom';

  @override
  String gardensZoneDescription(String zone, String description) {
    return 'Zone $zone – $description';
  }

  @override
  String gardensCityFormat(String city, String zone) {
    return '$city · $zone';
  }

  @override
  String get introSkip => 'Passer';

  @override
  String get introNext => 'Suivant';

  @override
  String get introStart => 'C\'est parti';

  @override
  String get onboardingWelcome => 'Bienvenue dans Plantera';

  @override
  String get onboardingBody =>
      'Choisissez votre lieu pour des conseils personnalisés, des alertes gel et les bons semis pour votre zone.';

  @override
  String get onboardingUseGps => 'Utiliser ma position';

  @override
  String get onboardingLocating => 'Localisation…';

  @override
  String get onboardingOrPickCity => 'ou choisir une ville';

  @override
  String onboardingZoneSubtitle(String zone) {
    return 'Zone $zone';
  }

  @override
  String get onboardingErrorLocationServicesOff =>
      'Services de localisation désactivés';

  @override
  String get onboardingErrorLocationDenied =>
      'Permission de localisation refusée';

  @override
  String get phasePerennialHaveIt => 'Je l\'ai au jardin';

  @override
  String get phasePerennialHaveItBody =>
      'On affichera la récolte attendue et rappellera taille, fertilisation et soins saisonniers.';

  @override
  String get phasePerennialPlanning => 'Je prévois de planter';

  @override
  String get phasePerennialPlanningBody =>
      'Sur la liste jusqu\'à plantation effective — rappels à temps.';

  @override
  String get phaseDetailedPlanned => 'Je prévois de cultiver';

  @override
  String get phaseDetailedPlannedBody =>
      'Sur la liste — rappels à temps en début de saison.';

  @override
  String get phaseDetailedPresow => 'Semis à l\'intérieur';

  @override
  String get phaseDetailedPresowBody =>
      'Plantules à l\'intérieur. Rappel d\'endurcissement dans 5 semaines.';

  @override
  String get phaseDetailedDirectsow => 'Semis en place';

  @override
  String get phaseDetailedDirectsowBody =>
      'Semé en place. Rappel de récolte à venir.';

  @override
  String get phaseDetailedPlantout => 'Plants en place';

  @override
  String get phaseDetailedPlantoutBody =>
      'À leur emplacement final. Rappel de récolte à venir.';

  @override
  String get phaseFinishedReady => 'Prêt à récolter';

  @override
  String get phaseFinishedReadyBody => 'Marqué prêt à récolter maintenant.';

  @override
  String get phaseFinishedHarvested => 'Récolté';

  @override
  String get phaseFinishedHarvestedBody =>
      'Saison terminée — rappels en pause.';

  @override
  String get phaseFinishedDormant => 'En dormance';

  @override
  String get phaseFinishedDormantBody =>
      'La plante n\'est pas active actuellement.';

  @override
  String get phaseDateHelpPresow =>
      'Quel jour avez-vous démarré cette plante ?';

  @override
  String get phaseDateHelpDirectsow => 'Quel jour avez-vous semé en place ?';

  @override
  String get phaseDateHelpPlantout => 'Quel jour les plants sont-ils sortis ?';

  @override
  String get phaseDateHelpDefault => 'Date';

  @override
  String get phasePerennialYearTitle => 'Depuis quand l\'avez-vous ?';

  @override
  String get phasePerennialYearBody =>
      'Pas besoin d\'être précis — on utilise juste l\'année.';

  @override
  String phasePerennialYearThis(String year) {
    return 'Cette année ($year)';
  }

  @override
  String phasePerennialYearLast(String year) {
    return 'L\'année dernière ($year)';
  }

  @override
  String phasePerennialYearTwo(String year) {
    return 'Il y a deux ans ($year)';
  }

  @override
  String get phasePerennialYearOlder => 'Avant (il y a quelques années)';

  @override
  String get plantDetailTabOverview => 'Vue d\'ensemble';

  @override
  String get plantDetailTabMyPlant => 'Ma plante';

  @override
  String get plantDetailTabCare => 'Soins';

  @override
  String get plantDetailAddCta => 'Ajouter à mon jardin';

  @override
  String get plantDetailRemoveCta => 'Retirer du jardin';

  @override
  String get plantDetailRemoveTitle => 'Retirer du jardin ?';

  @override
  String get plantDetailRemoveBody => 'Cette action est irréversible.';

  @override
  String get plantDetailCancel => 'Annuler';

  @override
  String get plantDetailDelete => 'Supprimer';

  @override
  String get plantDetailSave => 'Enregistrer';

  @override
  String get plantDetailReset => 'Réinitialiser';

  @override
  String get plantDetailReuse => 'Réutiliser';

  @override
  String get plantDetailWaterNowSuffix => 'Arrosée maintenant';

  @override
  String get plantDetailWaterTapHint => 'Touchez quand vous arrosez';

  @override
  String get plantDetailWaterDoneSnack => 'Arrosée ✓';

  @override
  String get plantDetailWaterNotYet => 'Pas encore arrosée';

  @override
  String get plantDetailWaterJust => 'Juste arrosée';

  @override
  String get plantDetailWaterToday => 'Arrosée aujourd\'hui';

  @override
  String get plantDetailWaterYesterday => 'Arrosée hier';

  @override
  String get plantDetailUpcomingCareTitle => '📅  SOINS À VENIR';

  @override
  String get plantDetailDueNow => 'À faire maintenant';

  @override
  String get plantDetailEditPostsTooltip => 'Gérer les publications';

  @override
  String get plantDetailNoteHint => 'Écrire une courte note…';

  @override
  String get plantDetailNoteTitle => 'Note';

  @override
  String get plantDetailNoteSubtitle =>
      'Que s\'est-il passé aujourd\'hui ? Pucerons, première fleur, taille…';

  @override
  String get plantDetailTakePhoto => 'Prendre une photo';

  @override
  String get plantDetailPickLibrary => 'Choisir dans la bibliothèque';

  @override
  String get plantDetailWriteNote => 'Écrire une note';

  @override
  String get plantDetailUseEmojiAgain => 'Réutiliser l\'emoji';

  @override
  String plantDetailSaveImageError(String error) {
    return 'Impossible d\'enregistrer l\'image : $error';
  }

  @override
  String plantDetailSavePhotoError(String error) {
    return 'Impossible d\'enregistrer la photo : $error';
  }

  @override
  String get plantDetailDeletePhotoTitle => 'Supprimer la photo ?';

  @override
  String get plantDetailDeleteNoteTitle => 'Supprimer la note ?';

  @override
  String get plantDetailDeletePhotoBody =>
      'La photo est supprimée de l\'appareil.';

  @override
  String get plantDetailDeleteNoteBody => 'La note disparaît.';

  @override
  String get plantDetailAdd => 'Ajouter';

  @override
  String get plantDetailNoPostsBody =>
      'Aucune publication — commencez à documenter la croissance avec des photos et des notes.';

  @override
  String get plantDetailChangeStatus => 'Changer de statut';

  @override
  String get plantDetailLocationLabel => 'Emplacement';

  @override
  String plantDetailSowingMethodChip(String method) {
    return 'Semis : $method';
  }

  @override
  String plantDetailSowingMethodSnack(String method) {
    return 'Méthode de semis : $method';
  }

  @override
  String get plantDetailDateHelp => 'Quelle date ?';

  @override
  String get plantDetailHowSowTitle => 'Comment semez-vous ?';

  @override
  String get plantDetailHowSowBody => 'Détermine les rappels que vous recevez.';

  @override
  String get plantDetailLocationTitle => 'Où est-elle ?';

  @override
  String get plantDetailLocationBody =>
      'P. ex. « parterre nord », « la serre », « le balcon ».';

  @override
  String get plantDetailHarvestOffsetTitle => 'Ajuster le temps de récolte';

  @override
  String get plantDetailHarvestOffsetBody =>
      'Compteur faux ? Ajoutez ou retirez des jours — sauvegardé pour cette plante.';

  @override
  String get plantDetailReadyToHarvest => 'Prête à récolter';

  @override
  String get plantDetailNextStepPresow => 'J\'ai semé à l\'intérieur';

  @override
  String get plantDetailNextStepDirectsow => 'J\'ai semé en place';

  @override
  String get plantDetailNextStepPlantout => 'J\'ai planté en pleine terre';

  @override
  String get plantDetailNextStepPlantedOut => 'Plants en pleine terre';

  @override
  String get plantDetailNextStepHarvestReady => 'Prête à récolter';

  @override
  String get plantDetailNextStepHarvested => 'Récoltée';

  @override
  String get plantDetailHowToTitle => 'Comment faire';

  @override
  String get plantDetailTipsTitle => 'Conseils';

  @override
  String get plantDetailPestsTitle => 'Ravageurs à surveiller';

  @override
  String get plantDetailNoCareTips =>
      'Aucun conseil de soin disponible pour l\'instant.';

  @override
  String get plantDetailInfoSun => 'Soleil';

  @override
  String get plantDetailInfoWater => 'Eau';

  @override
  String get plantDetailInfoFertilizer => 'Engrais';

  @override
  String get plantDetailInfoFrost => 'Rustique à';

  @override
  String get plantDetailInfoSpacing => 'Espacement';

  @override
  String get plantDetailInfoHarvest => 'Récolte';

  @override
  String get plantDetailHarvestSection => '🥕  Récolte';

  @override
  String get plantDetailToolsSection => '🛒 Outils et accessoires';

  @override
  String get plantDetailSeasonSection => 'Saison';

  @override
  String get plantDetailPhasePresow => 'Semis intérieur';

  @override
  String get plantDetailPhaseDirectsow => 'Semis en place';

  @override
  String get plantDetailPhasePlantout => 'Plantation';

  @override
  String get plantDetailPhaseHarvest => 'Récolter';

  @override
  String get plantDetailZoneWarningBody =>
      'C\'est possible — mais une protection hivernale ou un emplacement plus chaud sera probablement nécessaire.';

  @override
  String plantDetailDateAdded(String date) {
    return 'Ajouté $date';
  }

  @override
  String plantDetailDateInGardenSince(String year) {
    return 'Au jardin depuis $year';
  }

  @override
  String plantDetailDatePlanted(String date) {
    return 'Planté $date';
  }

  @override
  String get plantDetailHarvestOffsetSubtitle => 'Ajuster le temps de récolte';

  @override
  String plantDetailZoneWarning(String zone) {
    return 'Cette plante n\'est pas testée pour la zone $zone. C\'est possible — mais une protection hivernale ou un emplacement plus chaud sera probablement nécessaire.';
  }

  @override
  String get harvestSectionTitle => '🥕 Récolte';

  @override
  String get harvestRemoveTitle => 'Supprimer l\'entrée ?';

  @override
  String harvestRemoveBody(String amount, String unit, String date) {
    return '$amount $unit du $date seront supprimés.';
  }

  @override
  String harvestMoreEntries(String count) {
    return '+ $count entrées plus anciennes';
  }

  @override
  String harvestAddTitle(String plant) {
    return 'Noter la récolte — $plant';
  }

  @override
  String get harvestAmountLabel => 'Quantité';

  @override
  String get harvestUnitLabel => 'Unité';

  @override
  String get harvestNotesLabel => 'Note (facultatif)';

  @override
  String get harvestErrorAmountTooLow => 'Entrez une quantité supérieure à 0';

  @override
  String get harvestErrorFutureDate =>
      'Impossible de noter une récolte dans le futur';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get pestTypeLabelDisease => 'MALADIE';

  @override
  String get pestTypeLabelDamage => 'DOMMAGE';

  @override
  String get pestTypeLabelPest => 'NUISIBLE';

  @override
  String get statsShareButton => 'Partager';

  @override
  String statsShareText(String year) {
    return 'Mon jardin $year avec Plantera 🌱';
  }

  @override
  String get statsShareFailed => 'Impossible de créer l\'image de partage';

  @override
  String get paywallTitleBranded => 'Plantera Premium';

  @override
  String get paywallHeaderFrost =>
      'Recevez une alerte gel avant que vos plantes ne gèlent';

  @override
  String get paywallHeaderGardenLimit => 'Ajoutez tout votre jardin';

  @override
  String get paywallHeaderWaterAll => 'Arrosez tout en un seul tap';

  @override
  String get paywallHeaderPhotoLog => 'Un journal photo pour vos plantes';

  @override
  String get paywallSubFrost =>
      'Températures nocturnes SMHI — on vous prévient la veille de la nuit de gel';

  @override
  String get paywallSubGardenLimit =>
      'Aucune limite sur le nombre de plantes suivies';

  @override
  String get paywallSubWaterAll =>
      'Un bouton marque toutes vos plantes extérieures comme arrosées';

  @override
  String get paywallSubPhotoLog =>
      'Voyez-les grandir de la graine à la récolte';

  @override
  String get paywallSubHome => 'Alertes gel, journal photo et tout en illimité';

  @override
  String get paywallSubDefault => 'Passez votre jardin au niveau supérieur';

  @override
  String get paywallBenefitUnlimited => 'Plantes illimitées dans votre jardin';

  @override
  String get paywallBenefitReminders => 'Tous les rappels et alertes gel';

  @override
  String get paywallBenefitPhotos => 'Journal photo pour chaque plante';

  @override
  String get paywallBenefitNoAds => 'Sans publicité';

  @override
  String get paywallBenefitPdf => 'Export PDF du journal de récolte';

  @override
  String get paywallBenefitArticles =>
      'Accès complet aux articles de connaissance';

  @override
  String get paywallPlanYearly => 'Abonnement annuel';

  @override
  String paywallPlanYearlySavings(String percent) {
    return 'Économisez $percent% par rapport au mensuel';
  }

  @override
  String get paywallPlanMonthly => 'Abonnement mensuel';

  @override
  String get paywallPlanLifetime => 'Achat à vie (paiement unique)';

  @override
  String paywallTrialCta(String period) {
    return 'Commencer l\'essai gratuit ($period)';
  }

  @override
  String paywallTrialThen(String price) {
    return 'Puis $price';
  }

  @override
  String paywallPlanPriceFormat(String title, String price) {
    return '$title • $price';
  }

  @override
  String get paywallRestore => 'Restaurer les achats précédents';

  @override
  String get paywallDisclaimer =>
      'Les abonnements se renouvellent automatiquement jusqu\'à leur annulation dans les réglages App Store. Vous serez débité 24 h avant le renouvellement.';

  @override
  String get paywallTerms => 'Conditions (CLUF)';

  @override
  String get paywallPrivacy => 'Politique de confidentialité';

  @override
  String get paywallErrorStore =>
      'L\'App Store est indisponible pour le moment — réessayez dans quelques instants.';

  @override
  String get paywallErrorProduct =>
      'Impossible de charger l\'achat depuis l\'App Store. Fermez la paywall et rouvrez-la.';

  @override
  String get paywallErrorFailed => 'Échec de l\'achat. Veuillez réessayer.';

  @override
  String paywallErrorOpenUrl(String url) {
    return 'Impossible d\'ouvrir $url';
  }

  @override
  String get paywallPurchaseSuccess =>
      'Premium activé — merci ! Tout est débloqué.';

  @override
  String get paywallRestoreInProgress => 'Recherche de tes achats…';

  @override
  String get paywallRestoreFailed =>
      'Impossible de joindre l\'App Store. Réessayer.';

  @override
  String get paywallRestoreSuccess => 'Premium restauré — merci !';

  @override
  String get paywallRestoreAlreadyActive => 'Premium est déjà actif.';

  @override
  String get paywallRestoreNothingFound =>
      'Aucun achat trouvé sur cet identifiant Apple.';

  @override
  String get paywallAlreadyPremiumTitle => 'Tu as Premium';

  @override
  String get paywallAlreadyPremiumBody =>
      'Toutes les fonctionnalités sont déverrouillées. Merci pour le soutien — ça nous aide à continuer.';

  @override
  String get paywallAlreadyPremiumCta => 'Retour au jardin';

  @override
  String get paywallProductsUnavailable =>
      'Impossible de charger les prix depuis l\'App Store. Vérifie ta connexion et réessaie.';

  @override
  String get paywallProductsRetry => 'Réessayer';

  @override
  String get onboardingSlide1Title => 'Arrêtez de deviner quand semer';

  @override
  String get onboardingSlide1Body =>
      'Plantera connaît votre zone de rusticité et vous dit exactement quand semer en intérieur, en pleine terre ou planter — plante par plante.';

  @override
  String get onboardingSlide2Title => 'Alertes gel utiles';

  @override
  String get onboardingSlide2Body =>
      'Quand une nuit froide arrive, vous êtes prévenu à temps pour protéger les semis. Pas de panique à trois heures du matin.';

  @override
  String get onboardingSlide3Title => 'Un rappel le matin — pas 50';

  @override
  String get onboardingSlide3Body =>
      'Arrosage, taille, récolte et travaux saisonniers réunis dans un résumé quotidien pour vraiment obtenir une récolte.';

  @override
  String get onboardingFooterSkip => 'Passer';

  @override
  String get onboardingFooterNext => 'Suivant';

  @override
  String get onboardingFooterStart => 'Commencer';

  @override
  String get affiliateDisclosure =>
      'Annonslänkar – vi kan få provision om du handlar via Amazon.';

  @override
  String get monthlyProductsTitle => 'Månadens produkter';
}
