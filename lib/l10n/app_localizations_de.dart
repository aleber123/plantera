// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Plantera';

  @override
  String get appSubtitle => 'Dein digitaler Gartenbegleiter';

  @override
  String get tabHome => 'Start';

  @override
  String get tabCalendar => 'Kalender';

  @override
  String get tabPlants => 'Pflanzen';

  @override
  String get tabMyGarden => 'Meine Pflanzen';

  @override
  String get tabSettings => 'Einstellungen';

  @override
  String get tabOverview => 'Übersicht';

  @override
  String get tabMyPlant => 'Meine Pflanze';

  @override
  String get tabCare => 'Pflege';

  @override
  String get homeWelcomeTitle => 'Beginnen wir mit deiner ersten Pflanze';

  @override
  String get homeWelcomeBody =>
      'Durchsuche die Pflanzendatenbank und tippe + bei dem, was du anbaust — wir begleiten sie von der Aussaat bis zur Ernte.';

  @override
  String get homeWelcomeCta => 'Pflanzen durchsuchen';

  @override
  String get gardenOverviewTitle => 'Nächste Ernte';

  @override
  String get gardenSeeAll => 'Alle ansehen';

  @override
  String get gardenStatTotal => 'Im Garten';

  @override
  String get gardenStatHarvestSoon => 'Bald Ernte';

  @override
  String get gardenStatReadyNow => 'Jetzt bereit';

  @override
  String gardenMore(Object count) {
    return '+$count weitere';
  }

  @override
  String get dailyInsightsTitle => 'Heute im Garten';

  @override
  String get dailyInsightsAllGood =>
      'Alles unter Kontrolle. Nichts Dringendes — genieße den Garten.';

  @override
  String get upcomingCareTitle => 'Anstehende Pflege';

  @override
  String get upcomingCareSubtitle =>
      'Was diesen und nächsten Monat zu tun ist.';

  @override
  String seasonPlannerTitle(Object year) {
    return 'Meine Saison $year';
  }

  @override
  String get seasonPlannerSubtitle =>
      'Was du dieses Jahr anbauen möchtest. Wir benachrichtigen dich, wenn es Zeit zur Aussaat ist.';

  @override
  String seasonPlannerEmptyTitle(Object year) {
    return 'Saison $year planen';
  }

  @override
  String get seasonPlannerEmptyBody =>
      'Was möchtest du dieses Jahr anbauen? Wir erinnern dich, wenn es Zeit zur Aussaat ist.';

  @override
  String get seasonPlannerEmptyCta => 'Auswählen';

  @override
  String get seasonPlannerAddCta => 'Pflanze hinzufügen';

  @override
  String seasonPlannerCount(Object count) {
    return '$count Stück';
  }

  @override
  String get seasonRowSowNow => 'Jetzt säen';

  @override
  String seasonRowDaysAway(Object days) {
    return 'In $days Tagen';
  }

  @override
  String get seasonRowInSeason => 'In Saison';

  @override
  String get weatherUnavailable => 'Wetter nicht verfügbar';

  @override
  String get weatherSetLocation => 'Standort in Einstellungen festlegen';

  @override
  String get dryPeriodTitle => 'Trockenperiode läuft';

  @override
  String get frostCardTitle => '❄️ Vor Frost schützen';

  @override
  String get premiumTeaserTitle => 'Plantera Premium';

  @override
  String get premiumTeaserBody => 'Unbegrenzter Garten und keine Werbung';

  @override
  String get calendarTitle => 'Pflanzkalender';

  @override
  String get calendarMonthGuide => 'Monatsleitfaden';

  @override
  String calendarTaskCount(Object count) {
    return '$count Aufgaben';
  }

  @override
  String get calendarPhasePresow => 'INNEN VORZIEHEN';

  @override
  String get calendarPhaseDirectsow => 'DIREKTSAAT';

  @override
  String get calendarPhasePlantout => 'AUSPFLANZEN';

  @override
  String get calendarPhaseHarvest => 'ERNTE';

  @override
  String calendarPhaseCount(Object count) {
    return '$count Pflanzen';
  }

  @override
  String calendarEmptyTitle(Object month) {
    return 'Nichts zu säen oder ernten im $month';
  }

  @override
  String get calendarEmptyBody =>
      'Nutze den Monat zur Planung — bestelle Samen, plane Beete oder lies den Monatsleitfaden.';

  @override
  String get myGardenTitle => 'Meine Pflanzen';

  @override
  String get myGardenSearchHint => 'Pflanze oder Standort suchen';

  @override
  String get myGardenFilterAll => 'Alle';

  @override
  String get myGardenGroupByStatus => 'Nach Status gruppieren';

  @override
  String get myGardenGroupByLocation => 'Nach Standort gruppieren';

  @override
  String get myGardenGroupByCategory => 'Nach Kategorie gruppieren';

  @override
  String myGardenShowingCount(Object shown, Object total) {
    return 'Zeige $shown von $total';
  }

  @override
  String get myGardenEmptyTitle => 'Dein Garten ist leer';

  @override
  String get myGardenEmptyBody =>
      'Füge Pflanzen aus der Datenbank hinzu, um deinen Garten aufzubauen.';

  @override
  String get myGardenEmptyCta => 'Pflanzendatenbank durchsuchen';

  @override
  String get myGardenAddPlant => 'Pflanze hinzufügen';

  @override
  String get myGardenNoResults => 'Keine passenden Pflanzen';

  @override
  String get myGardenNoResultsBody =>
      'Versuche eine andere Suche oder lösche die Filter.';

  @override
  String get myGardenWateredNow => 'Eben gegossen';

  @override
  String get myGardenWateredToday => 'Heute gegossen';

  @override
  String get myGardenWateredYesterday => 'Gestern gegossen';

  @override
  String get plantDatabaseTitle => 'Pflanzendatenbank';

  @override
  String get plantDatabaseSearchHint => 'Pflanze suchen';

  @override
  String get plantCategoryAll => 'Alle';

  @override
  String get addPlantNow => 'Jetzt zum Garten hinzufügen';

  @override
  String get addPlantNowBody =>
      'Du hast gesät oder gepflanzt — wir begleiten ab heute';

  @override
  String get addPlantSeason => 'Zur Aussaatliste hinzufügen';

  @override
  String get addPlantSeasonBody =>
      'Du planst den Anbau — wir melden uns zur Aussaatzeit';

  @override
  String get addPlantRemoveSeason => 'Von Aussaatliste entfernen';

  @override
  String get addPlantRemoveSeasonBody =>
      'Wir hören auf, an das Aussaatfenster zu erinnern';

  @override
  String addedToGardenTitle(Object plant) {
    return '$plant ist in deinem Garten';
  }

  @override
  String get addedToGardenBodyPlain =>
      'Wir begleiten ab heute und erinnern an Wasser und Ernte.';

  @override
  String addedToGardenBodyScheduled(Object list) {
    return 'Wir begleiten ab heute. Benachrichtigungen geplant für: $list.';
  }

  @override
  String get addedToGardenCta => 'Zu meinem Garten';

  @override
  String get phasePickerTitleNew => 'Wo bist du im Prozess?';

  @override
  String get phasePickerTitleEdit => 'Status ändern';

  @override
  String get phaseShowSimple => 'Einfachere Optionen anzeigen';

  @override
  String get phaseShowMore => 'Mehr Optionen (für Erfahrene)';

  @override
  String get phaseSimplePlanned => 'Geplanter Anbau';

  @override
  String get phaseSimplePlannedBody =>
      'Nur auf der Liste — wir erinnern dich, wenn die Saison beginnt.';

  @override
  String get phaseSimpleGrowing => 'Wächst gerade';

  @override
  String get phaseSimpleGrowingBody =>
      'Pflanzen sind unterwegs. Wir begleiten sie bis zur Ernte.';

  @override
  String get phaseSimpleHarvested => 'Bereits geerntet';

  @override
  String get phaseSimpleHarvestedBody => 'Saison für diese Pflanze beendet.';

  @override
  String get perennialEstablishedTitle => 'Seit wann hast du sie?';

  @override
  String get perennialEstablishedBody =>
      'Muss nicht exakt sein – wir verwenden nur das Jahr.';

  @override
  String perennialThisYear(Object year) {
    return 'Dieses Jahr ($year)';
  }

  @override
  String perennialLastYear(Object year) {
    return 'Letztes Jahr ($year)';
  }

  @override
  String perennialTwoYearsAgo(Object year) {
    return 'Vor zwei Jahren ($year)';
  }

  @override
  String get perennialEarlier => 'Früher (vor einigen Jahren)';

  @override
  String get statusPlanning => 'Geplant';

  @override
  String get statusGrowingIndoors => 'Vorzucht innen';

  @override
  String get statusDirectSown => 'Direkt gesät';

  @override
  String get statusHardening => 'Abhärten';

  @override
  String get statusOutdoors => 'Im Freien';

  @override
  String get statusReadyToHarvest => 'Erntereif';

  @override
  String get statusHarvested => 'Geerntet';

  @override
  String get statusDormant => 'Ruhend';

  @override
  String get sowingIndoors => 'Innen';

  @override
  String get sowingDirect => 'Direkt';

  @override
  String get sowingPlanta => 'Setzling';

  @override
  String get sunFull => 'Volle Sonne';

  @override
  String get sunPartial => 'Halbschatten';

  @override
  String get sunShade => 'Schatten';

  @override
  String get waterSparse => 'Sparsam';

  @override
  String get waterRegular => 'Regelmäßig';

  @override
  String get waterAbundant => 'Reichlich';

  @override
  String get fertilizerLow => 'Niedrig';

  @override
  String get fertilizerMedium => 'Mittel';

  @override
  String get fertilizerHigh => 'Hoch';

  @override
  String get lifecycleAnnual => 'Einjährig';

  @override
  String get lifecycleBiennial => 'Zweijährig';

  @override
  String get lifecyclePerennial => 'Mehrjährig';

  @override
  String get lifecycleTree => 'Baum';

  @override
  String get lifecycleShrub => 'Strauch';

  @override
  String get categoryVegetables => 'Gemüse';

  @override
  String get categoryHerbs => 'Kräuter & Gewürze';

  @override
  String get categoryFlowers => 'Blumen';

  @override
  String get categoryBerries => 'Beeren';

  @override
  String get categoryFruitTrees => 'Obstbäume';

  @override
  String get categoryOther => 'Sonstiges';

  @override
  String get wateredNow => 'Gegossen';

  @override
  String get wateredConfirmation => 'Gegossen ✓';

  @override
  String get notWateredYet => 'Noch nicht gegossen';

  @override
  String get wateredJustNow => 'Eben gegossen';

  @override
  String wateredDaysAgo(Object days) {
    return 'Vor $days Tagen gegossen';
  }

  @override
  String wateredWeeksAgo(Object weeks) {
    return 'Vor $weeks Wochen gegossen';
  }

  @override
  String get journalTitle => 'Tagebuch';

  @override
  String journalCount(Object count) {
    return '$count';
  }

  @override
  String get journalAdd => 'Hinzufügen';

  @override
  String get journalEmpty =>
      'Noch keine Einträge — beginne, das Wachstum mit Fotos und kurzen Notizen zu dokumentieren.';

  @override
  String get journalNoteTitle => 'Notiz';

  @override
  String get journalNoteBody =>
      'Was ist heute passiert? Blattläuse, erste Blüte, Beschneiden…';

  @override
  String get journalNoteHint => 'Kurze Notiz schreiben…';

  @override
  String get journalSave => 'Speichern';

  @override
  String get journalDeletePhoto => 'Foto löschen?';

  @override
  String get journalDeletePhotoBody => 'Das Bild wird vom Gerät entfernt.';

  @override
  String get journalDeleteNote => 'Notiz löschen?';

  @override
  String get journalDeleteNoteBody => 'Die Notiz wird entfernt.';

  @override
  String get journalManage => 'Eintrag verwalten';

  @override
  String get actionTakePhoto => 'Foto aufnehmen';

  @override
  String get actionPickFromLibrary => 'Aus Mediathek wählen';

  @override
  String get actionWriteNote => 'Notiz schreiben';

  @override
  String get harvestTitle => 'Ernte';

  @override
  String get harvestLog => 'Ernte protokollieren';

  @override
  String get harvestEmpty =>
      'Protokolliere, was du erntest, und die App baut Statistik Jahr für Jahr auf.';

  @override
  String harvestTotalLabel(Object amount, Object unit) {
    return 'Gesamt: $amount $unit';
  }

  @override
  String harvestEstimatedSek(Object amount) {
    return '~$amount kr';
  }

  @override
  String get nextStepBecomeIndoor => 'Ich habe innen vorgezogen';

  @override
  String get nextStepBecomeDirect => 'Ich habe direktgesät';

  @override
  String get nextStepBecomePlanted => 'Ich habe ausgepflanzt';

  @override
  String get nextStepHardenedToPlanted => 'Pflanzen sind draußen';

  @override
  String get nextStepReadyForHarvest => 'Erntereif';

  @override
  String get nextStepHarvested => 'Geerntet';

  @override
  String get secondaryChangeStatus => 'Status ändern';

  @override
  String get secondaryRemove => 'Entfernen';

  @override
  String get secondaryRemoveConfirmTitle => 'Aus dem Garten entfernen?';

  @override
  String secondaryRemoveConfirmBody(Object plant) {
    return '$plant und alle Erinnerungen werden entfernt. Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get buttonCancel => 'Abbrechen';

  @override
  String get buttonRemove => 'Entfernen';

  @override
  String get buttonSave => 'Speichern';

  @override
  String get buttonNext => 'Weiter';

  @override
  String get buttonStart => 'Loslegen';

  @override
  String get buttonSkip => 'Überspringen';

  @override
  String get locationLabel => 'Standort';

  @override
  String get locationAdd => 'Standort hinzufügen';

  @override
  String get locationPickerTitle => 'Wo steht sie?';

  @override
  String get locationPickerBody =>
      'Z.B. \"Nordbeet\", \"Gewächshaus\", \"Balkon\".';

  @override
  String get locationReuse => 'Erneut verwenden';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsPremiumActive => 'Premium aktiv';

  @override
  String get settingsPremiumUpgrade => 'Auf Premium upgraden';

  @override
  String get settingsPremiumUnlock => 'Alle Funktionen freischalten';

  @override
  String get settingsMyGardens => 'Meine Gärten';

  @override
  String settingsMyGardensSubtitle(Object emoji, Object name) {
    return 'Aktiv: $emoji $name';
  }

  @override
  String get settingsMyGardensEmpty => 'Erstelle deinen ersten Garten';

  @override
  String get settingsNotifications => 'Erinnerungen';

  @override
  String get settingsNotificationsBody => 'Frostwarnungen und Pflanzzeiten';

  @override
  String get settingsMorningHour => 'Morgenzeit für Erinnerungen';

  @override
  String settingsMorningHourBody(Object hour) {
    return 'Garten-Morgen-Pings um $hour:00';
  }

  @override
  String get settingsLargeText => 'Großer Text';

  @override
  String get settingsLargeTextBody => 'Etwas größerer Text in der gesamten App';

  @override
  String get settingsSimpleStatus => 'Einfacher Status';

  @override
  String get settingsSimpleStatusBody =>
      'Nur 3 Hauptzustände anzeigen (Geplant / Wächst / Geerntet). Für vollen Lebenszyklus deaktivieren.';

  @override
  String get settingsPestLibrary => 'Schädlinge & Krankheiten';

  @override
  String get settingsPestLibraryBody => 'Bibliothek häufiger Probleme';

  @override
  String get settingsIntro => 'Einführung anzeigen';

  @override
  String get settingsIntroBody =>
      'Schnelldurchlauf der Plus-Taste, Saisonplaner und wie die App funktioniert';

  @override
  String get settingsBackup => 'Sicherungskopie';

  @override
  String get settingsBackupBody =>
      'Garten und Ernte exportieren – auf iCloud Drive speichern oder per E-Mail senden';

  @override
  String get settingsRestorePurchases => 'Käufe wiederherstellen';

  @override
  String get settingsPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get settingsTerms => 'Nutzungsbedingungen (EULA)';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsFeedback => 'Feedback senden';

  @override
  String get settingsFeedbackBody =>
      'Bugs, Feature-Wünsche oder einfach ein freundliches Hallo';

  @override
  String get gardensTitle => 'Meine Gärten';

  @override
  String get gardensActive => 'AKTIV';

  @override
  String get gardensAddNew => 'Neuen Garten hinzufügen';

  @override
  String get gardensEdit => 'Bearbeiten';

  @override
  String get gardensNoLocation => 'Kein Standort';

  @override
  String gardensPlantCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Pflanzen',
      one: '1 Pflanze',
    );
    return '$_temp0';
  }

  @override
  String get gardensSwitcherTitle => 'Garten wechseln';

  @override
  String get gardensManage => 'Gärten verwalten';

  @override
  String gardensZoneLine(Object zone) {
    return 'Zone $zone';
  }

  @override
  String get gardensNewTitle => 'Neuer Garten';

  @override
  String gardensEditTitle(Object name) {
    return '$name bearbeiten';
  }

  @override
  String get gardensNamePlaceholder => 'Schrebergarten, Balkon, Wochenendhaus…';

  @override
  String get gardensCityLabel => 'Stadt / nächster Ort';

  @override
  String get gardensCreateButton => 'Garten erstellen';

  @override
  String get gardensSaveButton => 'Speichern';

  @override
  String get gardensFooterHint =>
      'Jeder Garten hat eigene Zone, Pflanzliste und Wetter. Aktiven Garten durch Antippen wechseln – alles aktualisiert sich sofort.';

  @override
  String gardensDeleteTitle(Object name) {
    return '$name entfernen?';
  }

  @override
  String get gardensDeletePlainBody => 'Der Garten wird entfernt.';

  @override
  String gardensDeleteWithPlantsBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Pflanzen',
      one: '1 Pflanze',
    );
    return '$_temp0 werden in deinen Standardgarten verschoben. Der Garten wird entfernt.';
  }

  @override
  String get introPage1Title => 'Pflanzen hinzufügen, die du anbaust';

  @override
  String get introPage1Body =>
      'Tippe + bei einer Pflanze, um sie in deinen Garten aufzunehmen. Wir begleiten sie von der Aussaat bis zur Ernte und erinnern an Gießen, Beschneiden und Umpflanzen.';

  @override
  String get introPage1Hint =>
      'Pflanze nicht gefunden? Nutze den Tab \"Pflanzen\" unten.';

  @override
  String get introPage2Title => 'Saison planen';

  @override
  String get introPage2Body =>
      'Tippe das Lesezeichen, um eine Pflanze auf die Aussaatliste zu setzen. Du erhältst im Februar/März eine Benachrichtigung, wenn es Zeit zur Innen-Aussaat ist, und im April zur Direktsaat.';

  @override
  String get introPage2Hint => 'Die Aussaatliste ist auf dem Startbildschirm.';

  @override
  String get introPage3Title => 'Den Garten im Griff';

  @override
  String get introPage3Body =>
      'Start zeigt Wetter, Trockenphasen und was diesen Monat zu tun ist. Der Tab \"Meine Pflanzen\" zeigt Jahresstatistik, Fruchtfolge und geschätzten Ernte-Wert.';

  @override
  String get introPage3Hint =>
      'Schädlinge & Krankheiten findest du in den Einstellungen.';

  @override
  String get pestLibraryTitle => 'Schädlinge & Krankheiten';

  @override
  String get pestLibrarySearchHint => 'Nach Symptom oder Pflanze suchen';

  @override
  String get pestLibraryFilterPests => 'Schädlinge';

  @override
  String get pestLibraryFilterDiseases => 'Krankheiten';

  @override
  String get pestLibraryFilterDamage => 'Schaden';

  @override
  String get pestLibraryNoMatch =>
      'Nichts gefunden. Versuche ein Symptom wie \"Flecken\" oder \"Löcher\".';

  @override
  String get pestSectionMild => 'Milde Maßnahme';

  @override
  String get pestSectionStrong => 'Wirksame Maßnahme';

  @override
  String get pestSectionPrevent => 'Vorbeugen';

  @override
  String get pestAffects => 'Betrifft';

  @override
  String statsTitle(Object year) {
    return 'Mein Garten $year';
  }

  @override
  String statsHero1(Object sek) {
    return 'Du hast etwa $sek kr an Lebensmitteln angebaut';
  }

  @override
  String statsHero2(Object count) {
    return 'Du hast $count Pflanzen am Wachsen';
  }

  @override
  String get statsHeroEmpty => 'Saison wartet';

  @override
  String get statsTilePlants => 'Pflanzen';

  @override
  String get statsTileSpecies => 'Arten';

  @override
  String get statsTileHarvested => 'Geerntet';

  @override
  String get statsHarvestPanelTitle => 'Bisherige Ernte dieses Jahr';

  @override
  String statsValueLine(Object sek) {
    return 'Geschätzter Wert: ~$sek kr';
  }

  @override
  String get statsValueDisclaimer =>
      'Basiert auf groben Supermarktpreisen pro Kategorie. Arbeitszeit oder Saatkosten nicht enthalten.';

  @override
  String get statsTopPanelTitle => 'Beste Erträge des Jahres';

  @override
  String get statsLocationPanelTitle => 'Wo im Garten';

  @override
  String get statsRotationPanelTitle => 'Fruchtfolge';

  @override
  String get statsRotationBody =>
      'Was wo wuchs, pro Jahr. Wiederholungen werden markiert.';

  @override
  String get statsReflectionTitle => 'Reflexion';

  @override
  String get statsEmptyTitle => 'Saison hat noch nicht begonnen';

  @override
  String get statsEmptyBody =>
      'Pflanzen hinzufügen und Ernten protokollieren – wir füllen die Seite mit den Jahresergebnissen.';

  @override
  String get tabTodo => 'Aufgaben';

  @override
  String get todoSectionToday => 'HEUTE';

  @override
  String get todoSectionWeek => 'DIESE WOCHE';

  @override
  String get todoSectionMonth => 'DIESEN MONAT';

  @override
  String get todoSectionDoneToday => 'HEUTE ERLEDIGT ✓';

  @override
  String get todoStatToday => 'heute';

  @override
  String get todoStatWeek => 'diese Woche';

  @override
  String get todoStatDone => 'erledigt';

  @override
  String get todoEmptyTitle => 'Alles unter Kontrolle';

  @override
  String get todoEmptyBody =>
      'Nichts Dringendes. Füge Pflanzen hinzu, um tägliche Aufgaben zu erhalten.';

  @override
  String get todoSwipeDone => 'Erledigt';

  @override
  String get todoSwipeSnooze => 'Verschieben';

  @override
  String get progressReadyToHarvest => 'Erntereif';

  @override
  String get progressHarvestNow => 'Jetzt ernten';

  @override
  String progressDaysLeft(Object days) {
    return '$days Tage übrig';
  }

  @override
  String progressApproxDaysLeft(Object days) {
    return '~$days Tage übrig';
  }

  @override
  String get climateCardTitle => 'Klima letzte 14 Tage';

  @override
  String get climateStatAvg => 'Tagesmittel';

  @override
  String get climateStatMinMax => 'Min/max';

  @override
  String get climateStatGdd => 'GDD';

  @override
  String get climateInterpretWaking => 'Der Garten erwacht.';

  @override
  String get climateInterpretEarly =>
      'Sehr frühe Saison – nur Kältetolerante (Zwiebel, Erbse, Salat).';

  @override
  String get climateInterpretSpring =>
      'Frühjahrssaison – direkt gesäte Gemüse etablieren sich, Wärmeliebende warten.';

  @override
  String get climateInterpretMidSpring =>
      'Mittlerer Frühling – Tomate und Paprika unter Vlies oder ins Gewächshaus.';

  @override
  String get climateInterpretFullGrowth =>
      'Volles Wachstum – alles reift schnell, gießen und düngen.';

  @override
  String get climateInterpretHot =>
      'Heiße Phase – auf Bewässerung junger Pflanzen achten.';

  @override
  String get climateTeaserTitle => 'Klimakarte (Premium)';

  @override
  String get climateTeaserBody =>
      'Tagesmitteltemperatur + Growing Degree Days für besseres Timing von Aussaat und Ernte.';

  @override
  String get weatherSetLocationHint =>
      'Standort in den Einstellungen festlegen';

  @override
  String weatherFrostWarning(String date, String temp) {
    return 'Frostwarnung $date – $temp°C';
  }

  @override
  String dryPeriodBodyWithThirsty(
    String past,
    String next,
    String names,
    String more,
  ) {
    return 'Nur $past mm Regen in den letzten 14 Tagen und $next mm in der kommenden Woche erwartet. Gießen Sie $names$more — trockenheitsverträgliche Pflanzen halten länger durch.';
  }

  @override
  String dryPeriodBodyGeneral(String past, String next) {
    return 'Nur $past mm Regen in den letzten 14 Tagen und $next mm in der kommenden Woche erwartet. Sorgfältig gießen, besonders Neupflanzungen und Töpfe.';
  }

  @override
  String get dryPeriodMoreSuffix => ' u.a.';

  @override
  String get myGardenWaterAllTooltip => 'Alle Outdoor-Pflanzen gießen';

  @override
  String myGardenSeasonStatsTooltip(String year) {
    return 'Meine Saison $year';
  }

  @override
  String get myGardenGroupTooltip => 'Gruppieren nach';

  @override
  String get myGardenNoOutdoorPlants => 'Keine Outdoor-Pflanzen zu gießen.';

  @override
  String get myGardenWaterAllTitle => 'Alle gießen?';

  @override
  String myGardenWaterAllConfirm(String count) {
    return 'Markiert $count Outdoor-Pflanzen als gerade gegossen.';
  }

  @override
  String get myGardenWaterAllCancel => 'Abbrechen';

  @override
  String get myGardenWaterAllAction => 'Alle gießen';

  @override
  String myGardenWaterAllDone(String count) {
    return '$count Pflanzen gegossen ✓';
  }

  @override
  String get myGardenLocationNone => 'Ohne Standort';

  @override
  String get myGardenCategoryOther => 'Andere';

  @override
  String myGardenStatusSince(String status, String year) {
    return '$status • seit $year';
  }

  @override
  String myGardenStatusOnDate(String status, String date) {
    return '$status • $date';
  }

  @override
  String settingsMyGardensWithCount(String count) {
    return 'Meine Gärten ($count)';
  }

  @override
  String get settingsPlanMonthly => 'Monatsabo';

  @override
  String get settingsPlanYearly => 'Jahresabo';

  @override
  String get settingsPlanLifetime => 'Lebenslang';

  @override
  String get settingsPlanFree => 'Kostenlos';

  @override
  String get settingsStarterKit => '🛒 Starter-Kit';

  @override
  String get settingsMorningHourPickerTitle =>
      'Wann soll der Morgenping kommen?';

  @override
  String get settingsMorningHourPickerBody =>
      'Die Morgenübersicht und alle Pflanzerinnerungen laufen zu dieser Stunde. Nichts weckt Sie vorher.';

  @override
  String settingsHourFormat(String hour) {
    return '$hour:00 Uhr';
  }

  @override
  String settingsBackupFailed(String error) {
    return 'Backup konnte nicht erstellt werden: $error';
  }

  @override
  String get settingsFeedbackSubject => 'Plantera-Feedback';

  @override
  String settingsFeedbackBodyTemplate(String version) {
    return 'Hallo!\n\nFeedback / Frage / Fehlerbericht:\n\n\n— Gesendet von Plantera $version';
  }

  @override
  String get gardensDelete => 'Löschen';

  @override
  String get gardensCancel => 'Abbrechen';

  @override
  String get gardensNameLabel => 'Name';

  @override
  String gardensZoneDescription(String zone, String description) {
    return 'Zone $zone – $description';
  }

  @override
  String gardensCityFormat(String city, String zone) {
    return '$city · $zone';
  }

  @override
  String get introSkip => 'Überspringen';

  @override
  String get introNext => 'Weiter';

  @override
  String get introStart => 'Loslegen';

  @override
  String get onboardingWelcome => 'Willkommen bei Plantera';

  @override
  String get onboardingBody =>
      'Wählen Sie Ihren Standort für maßgeschneiderte Tipps, Frostwarnungen und passende Aussaatzeiten.';

  @override
  String get onboardingUseGps => 'Meinen Standort verwenden';

  @override
  String get onboardingLocating => 'Standort wird ermittelt…';

  @override
  String get onboardingOrPickCity => 'oder Stadt wählen';

  @override
  String onboardingZoneSubtitle(String zone) {
    return 'Zone $zone';
  }

  @override
  String get onboardingErrorLocationServicesOff =>
      'Ortungsdienste sind deaktiviert';

  @override
  String get onboardingErrorLocationDenied => 'Standortberechtigung verweigert';

  @override
  String get phasePerennialHaveIt => 'Ich habe sie im Garten';

  @override
  String get phasePerennialHaveItBody =>
      'Wir zeigen die erwartete Ernte und erinnern an Schnitt, Düngung und Saisonpflege.';

  @override
  String get phasePerennialPlanning => 'Plane zu pflanzen';

  @override
  String get phasePerennialPlanningBody =>
      'Nur auf der Liste, bis Sie tatsächlich pflanzen — Erinnerungen kommen rechtzeitig.';

  @override
  String get phaseDetailedPlanned => 'Plane den Anbau';

  @override
  String get phaseDetailedPlannedBody =>
      'Nur auf der Liste — Erinnerungen kommen rechtzeitig zum Saisonstart.';

  @override
  String get phaseDetailedPresow => 'Vorziehen drinnen';

  @override
  String get phaseDetailedPresowBody =>
      'Sämlinge wachsen drinnen. Abhärtungs-Erinnerung in 5 Wochen.';

  @override
  String get phaseDetailedDirectsow => 'Direktsaat im Freien';

  @override
  String get phaseDetailedDirectsowBody =>
      'Direkt am Standort gesät. Ernte-Erinnerung folgt.';

  @override
  String get phaseDetailedPlantout => 'Pflanzen sind ausgesetzt';

  @override
  String get phaseDetailedPlantoutBody =>
      'Am endgültigen Platz. Ernte-Erinnerung folgt.';

  @override
  String get phaseFinishedReady => 'Erntereif';

  @override
  String get phaseFinishedReadyBody => 'Wird jetzt als erntereif markiert.';

  @override
  String get phaseFinishedHarvested => 'Geerntet';

  @override
  String get phaseFinishedHarvestedBody =>
      'Saison vorbei — Erinnerungen pausiert.';

  @override
  String get phaseFinishedDormant => 'Ruhend';

  @override
  String get phaseFinishedDormantBody => 'Die Pflanze ist gerade nicht aktiv.';

  @override
  String get phaseDateHelpPresow => 'Wann haben Sie diese Pflanze gestartet?';

  @override
  String get phaseDateHelpDirectsow => 'Wann haben Sie direktgesät?';

  @override
  String get phaseDateHelpPlantout => 'Wann kamen die Sämlinge nach draußen?';

  @override
  String get phaseDateHelpDefault => 'Datum';

  @override
  String get phasePerennialYearTitle => 'Seit wann haben Sie sie?';

  @override
  String get phasePerennialYearBody =>
      'Muss nicht exakt sein — wir nutzen nur das Jahr.';

  @override
  String phasePerennialYearThis(String year) {
    return 'Dieses Jahr ($year)';
  }

  @override
  String phasePerennialYearLast(String year) {
    return 'Letztes Jahr ($year)';
  }

  @override
  String phasePerennialYearTwo(String year) {
    return 'Vor zwei Jahren ($year)';
  }

  @override
  String get phasePerennialYearOlder => 'Früher (vor einigen Jahren)';

  @override
  String get plantDetailTabOverview => 'Übersicht';

  @override
  String get plantDetailTabMyPlant => 'Meine Pflanze';

  @override
  String get plantDetailTabCare => 'Pflege';

  @override
  String get plantDetailAddCta => 'Zu meinem Garten hinzufügen';

  @override
  String get plantDetailRemoveCta => 'Aus dem Garten entfernen';

  @override
  String get plantDetailRemoveTitle => 'Aus dem Garten entfernen?';

  @override
  String get plantDetailRemoveBody =>
      'Dies kann nicht rückgängig gemacht werden.';

  @override
  String get plantDetailCancel => 'Abbrechen';

  @override
  String get plantDetailDelete => 'Löschen';

  @override
  String get plantDetailSave => 'Speichern';

  @override
  String get plantDetailReset => 'Zurücksetzen';

  @override
  String get plantDetailReuse => 'Wiederverwenden';

  @override
  String get plantDetailWaterNowSuffix => 'Jetzt gegossen';

  @override
  String get plantDetailWaterTapHint =>
      'Tippen, wenn Sie gießen, um den Überblick zu behalten';

  @override
  String get plantDetailWaterDoneSnack => 'Gegossen ✓';

  @override
  String get plantDetailWaterNotYet => 'Noch nicht gegossen';

  @override
  String get plantDetailWaterJust => 'Gerade gegossen';

  @override
  String get plantDetailWaterToday => 'Heute gegossen';

  @override
  String get plantDetailWaterYesterday => 'Gestern gegossen';

  @override
  String get plantDetailUpcomingCareTitle => '📅  ANSTEHENDE PFLEGE';

  @override
  String get plantDetailDueNow => 'Jetzt fällig';

  @override
  String get plantDetailEditPostsTooltip => 'Beiträge verwalten';

  @override
  String get plantDetailNoteHint => 'Kurze Notiz schreiben…';

  @override
  String get plantDetailNoteTitle => 'Notiz';

  @override
  String get plantDetailNoteSubtitle =>
      'Was ist heute passiert? Blattläuse, erste Blüte, Schnitt…';

  @override
  String get plantDetailTakePhoto => 'Foto aufnehmen';

  @override
  String get plantDetailPickLibrary => 'Aus Bibliothek wählen';

  @override
  String get plantDetailWriteNote => 'Notiz schreiben';

  @override
  String get plantDetailUseEmojiAgain => 'Emoji erneut verwenden';

  @override
  String plantDetailSaveImageError(String error) {
    return 'Bild konnte nicht gespeichert werden: $error';
  }

  @override
  String plantDetailSavePhotoError(String error) {
    return 'Foto konnte nicht gespeichert werden: $error';
  }

  @override
  String get plantDetailDeletePhotoTitle => 'Foto löschen?';

  @override
  String get plantDetailDeleteNoteTitle => 'Notiz löschen?';

  @override
  String get plantDetailDeletePhotoBody => 'Das Foto wird vom Gerät gelöscht.';

  @override
  String get plantDetailDeleteNoteBody => 'Die Notiz wird entfernt.';

  @override
  String get plantDetailAdd => 'Hinzufügen';

  @override
  String get plantDetailNoPostsBody =>
      'Noch keine Beiträge — beginnen Sie mit Fotos und kurzen Notizen.';

  @override
  String get plantDetailChangeStatus => 'Status ändern';

  @override
  String get plantDetailLocationLabel => 'Standort';

  @override
  String plantDetailSowingMethodChip(String method) {
    return 'Saat: $method';
  }

  @override
  String plantDetailSowingMethodSnack(String method) {
    return 'Saatmethode: $method';
  }

  @override
  String get plantDetailDateHelp => 'Welches Datum?';

  @override
  String get plantDetailHowSowTitle => 'Wie säen Sie?';

  @override
  String get plantDetailHowSowBody =>
      'Bestimmt, welche Erinnerungen Sie erhalten.';

  @override
  String get plantDetailLocationTitle => 'Wo steht sie?';

  @override
  String get plantDetailLocationBody =>
      'Z. B. \"Nordbeet\", \"Gewächshaus\", \"Balkon\".';

  @override
  String get plantDetailHarvestOffsetTitle => 'Erntezeit anpassen';

  @override
  String get plantDetailHarvestOffsetBody =>
      'Zähler falsch? Tage hinzufügen oder abziehen — wird nur für diese Pflanze gespeichert.';

  @override
  String get plantDetailReadyToHarvest => 'Erntereif';

  @override
  String get plantDetailNextStepPresow => 'Ich habe drinnen vorgezogen';

  @override
  String get plantDetailNextStepDirectsow => 'Ich habe direkt gesät';

  @override
  String get plantDetailNextStepPlantout => 'Ich habe ausgepflanzt';

  @override
  String get plantDetailNextStepPlantedOut => 'Pflanzen sind ausgepflanzt';

  @override
  String get plantDetailNextStepHarvestReady => 'Erntereif';

  @override
  String get plantDetailNextStepHarvested => 'Geerntet';

  @override
  String get plantDetailHowToTitle => 'So geht\'s';

  @override
  String get plantDetailTipsTitle => 'Tipps';

  @override
  String get plantDetailPestsTitle => 'Schädlinge im Auge behalten';

  @override
  String get plantDetailNoCareTips => 'Noch keine Pflegehinweise verfügbar.';

  @override
  String get plantDetailInfoSun => 'Sonne';

  @override
  String get plantDetailInfoWater => 'Wasser';

  @override
  String get plantDetailInfoFertilizer => 'Dünger';

  @override
  String get plantDetailInfoFrost => 'Hart bis';

  @override
  String get plantDetailInfoSpacing => 'Abstand';

  @override
  String get plantDetailInfoHarvest => 'Ernte';

  @override
  String get plantDetailHarvestSection => '🥕  Ernte';

  @override
  String get plantDetailToolsSection => '🛒 Werkzeuge und Zubehör';

  @override
  String get plantDetailSeasonSection => 'Saison';

  @override
  String get plantDetailPhasePresow => 'Vorziehen';

  @override
  String get plantDetailPhaseDirectsow => 'Direktsaat';

  @override
  String get plantDetailPhasePlantout => 'Auspflanzen';

  @override
  String get plantDetailPhaseHarvest => 'Ernten';

  @override
  String get plantDetailZoneWarningBody =>
      'Es kann klappen – aber Sie brauchen wahrscheinlich Winterschutz oder einen wärmeren Platz.';

  @override
  String plantDetailDateAdded(String date) {
    return 'Hinzugefügt $date';
  }

  @override
  String plantDetailDateInGardenSince(String year) {
    return 'Im Garten seit $year';
  }

  @override
  String plantDetailDatePlanted(String date) {
    return 'Gepflanzt $date';
  }

  @override
  String get plantDetailHarvestOffsetSubtitle => 'Erntezeit anpassen';

  @override
  String plantDetailZoneWarning(String zone) {
    return 'Diese Pflanze ist nicht für Zone $zone getestet. Es kann klappen – aber Sie brauchen wahrscheinlich Winterschutz oder einen wärmeren Platz.';
  }

  @override
  String get harvestSectionTitle => '🥕 Ernte';

  @override
  String get harvestRemoveTitle => 'Eintrag entfernen?';

  @override
  String harvestRemoveBody(String amount, String unit, String date) {
    return '$amount $unit vom $date werden entfernt.';
  }

  @override
  String harvestMoreEntries(String count) {
    return '+ $count ältere Einträge';
  }

  @override
  String harvestAddTitle(String plant) {
    return 'Ernte erfassen — $plant';
  }

  @override
  String get harvestAmountLabel => 'Menge';

  @override
  String get harvestUnitLabel => 'Einheit';

  @override
  String get harvestNotesLabel => 'Notiz (optional)';

  @override
  String get harvestErrorAmountTooLow => 'Geben Sie eine Menge größer 0 ein';

  @override
  String get harvestErrorFutureDate =>
      'Sie können keine zukünftige Ernte erfassen';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get pestTypeLabelDisease => 'KRANKHEIT';

  @override
  String get pestTypeLabelDamage => 'SCHADEN';

  @override
  String get pestTypeLabelPest => 'SCHÄDLING';
}
