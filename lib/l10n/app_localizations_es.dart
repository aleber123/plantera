// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Plantera';

  @override
  String get appSubtitle => 'Tu compañero de jardín digital';

  @override
  String get tabHome => 'Inicio';

  @override
  String get tabCalendar => 'Calendario';

  @override
  String get tabPlants => 'Plantas';

  @override
  String get tabMyGarden => 'Mis plantas';

  @override
  String get tabSettings => 'Ajustes';

  @override
  String get tabOverview => 'Resumen';

  @override
  String get tabMyPlant => 'Mi planta';

  @override
  String get tabCare => 'Cuidados';

  @override
  String get homeWelcomeTitle => 'Empecemos con tu primera planta';

  @override
  String get homeWelcomeBody =>
      'Explora la base de datos y pulsa + en lo que cultivas — la seguimos desde la siembra hasta la cosecha.';

  @override
  String get homeWelcomeCta => 'Explorar plantas';

  @override
  String get gardenOverviewTitle => 'Próxima cosecha';

  @override
  String get gardenSeeAll => 'Ver todas';

  @override
  String get gardenStatTotal => 'En el jardín';

  @override
  String get gardenStatHarvestSoon => 'Cosecha pronto';

  @override
  String get gardenStatReadyNow => 'Listo ahora';

  @override
  String gardenMore(Object count) {
    return '+$count más';
  }

  @override
  String get dailyInsightsTitle => 'Hoy en el jardín';

  @override
  String get dailyInsightsAllGood =>
      'Todo bajo control. Nada urgente — disfruta del jardín.';

  @override
  String get upcomingCareTitle => 'Próximos cuidados';

  @override
  String get upcomingCareSubtitle => 'Tareas para este mes y el próximo.';

  @override
  String seasonPlannerTitle(Object year) {
    return 'Mi temporada $year';
  }

  @override
  String get seasonPlannerSubtitle =>
      'Lo que quieres cultivar este año. Te avisaremos cuando sea hora de sembrar.';

  @override
  String seasonPlannerEmptyTitle(Object year) {
    return 'Planificar temporada $year';
  }

  @override
  String get seasonPlannerEmptyBody =>
      '¿Qué quieres cultivar este año? Te recordaremos cuándo sembrar.';

  @override
  String get seasonPlannerEmptyCta => 'Elegir';

  @override
  String get seasonPlannerAddCta => 'Añadir planta';

  @override
  String seasonPlannerCount(Object count) {
    return '$count';
  }

  @override
  String get seasonRowSowNow => 'Sembrar ahora';

  @override
  String seasonRowDaysAway(Object days) {
    return 'En $days días';
  }

  @override
  String get seasonRowInSeason => 'En temporada';

  @override
  String get weatherUnavailable => 'Tiempo no disponible';

  @override
  String get weatherSetLocation => 'Configura tu ubicación en los ajustes';

  @override
  String get dryPeriodTitle => 'Período seco en curso';

  @override
  String get frostCardTitle => '❄️ Proteger de la helada';

  @override
  String get premiumTeaserTitle => 'Plantera Premium';

  @override
  String get premiumTeaserBody => 'Jardín ilimitado y sin anuncios';

  @override
  String get calendarTitle => 'Calendario de siembra';

  @override
  String get calendarMonthGuide => 'Guía del mes';

  @override
  String calendarTaskCount(Object count) {
    return '$count tareas';
  }

  @override
  String get calendarPhasePresow => 'SEMBRAR INTERIOR';

  @override
  String get calendarPhaseDirectsow => 'SIEMBRA DIRECTA';

  @override
  String get calendarPhasePlantout => 'TRASPLANTAR';

  @override
  String get calendarPhaseHarvest => 'COSECHA';

  @override
  String calendarPhaseCount(Object count) {
    return '$count plantas';
  }

  @override
  String calendarEmptyTitle(Object month) {
    return 'Nada que sembrar o cosechar en $month';
  }

  @override
  String get calendarEmptyBody =>
      'Aprovecha el mes para planificar — pide semillas, organiza bancales o lee la guía del mes.';

  @override
  String get myGardenTitle => 'Mis plantas';

  @override
  String get myGardenSearchHint => 'Buscar planta o ubicación';

  @override
  String get myGardenFilterAll => 'Todas';

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
  String get myGardenEmptyTitle => 'Tu jardín está vacío';

  @override
  String get myGardenEmptyBody =>
      'Añade plantas desde la base de datos para empezar tu jardín.';

  @override
  String get myGardenEmptyCta => 'Explorar la base de datos';

  @override
  String get myGardenAddPlant => 'Añadir planta';

  @override
  String get myGardenNoResults => 'Inga växter matchar';

  @override
  String get myGardenNoResultsBody =>
      'Pröva en annan sökning eller rensa filtren.';

  @override
  String get myGardenWateredNow => 'Regado ahora';

  @override
  String get myGardenWateredToday => 'Regado hoy';

  @override
  String get myGardenWateredYesterday => 'Regado ayer';

  @override
  String get plantDatabaseTitle => 'Växtdatabas';

  @override
  String get plantDatabaseSearchHint => 'Sök växt';

  @override
  String get plantCategoryAll => 'Alla';

  @override
  String get addPlantNow => 'Añadir al jardín ahora';

  @override
  String get addPlantNowBody =>
      'Has sembrado o plantado — la seguimos desde hoy';

  @override
  String get addPlantSeason => 'Añadir a la lista de siembra';

  @override
  String get addPlantSeasonBody =>
      'Planeas cultivar — te avisaremos cuándo sembrar';

  @override
  String get addPlantRemoveSeason => 'Ta bort från såningslistan';

  @override
  String get addPlantRemoveSeasonBody =>
      'Vi slutar påminna om sånings-fönstret';

  @override
  String addedToGardenTitle(Object plant) {
    return '$plant está en tu jardín';
  }

  @override
  String get addedToGardenBodyPlain =>
      'La seguimos desde hoy y te recordamos riego y cosecha.';

  @override
  String addedToGardenBodyScheduled(Object list) {
    return 'Vi följer den från idag. Notiser inkommande för: $list.';
  }

  @override
  String get addedToGardenCta => 'Llévame a mi jardín';

  @override
  String get phasePickerTitleNew => 'Var är du i processen?';

  @override
  String get phasePickerTitleEdit => 'Ändra status';

  @override
  String get phaseShowSimple => 'Visa enklare alternativ';

  @override
  String get phaseShowMore => 'Fler alternativ (för den vana odlaren)';

  @override
  String get phaseSimplePlanned => 'Planeo cultivar';

  @override
  String get phaseSimplePlannedBody =>
      'Bara på listan — vi påminner när säsongen startar.';

  @override
  String get phaseSimpleGrowing => 'Creciendo ahora';

  @override
  String get phaseSimpleGrowingBody =>
      'Plantorna är på gång. Vi följer dem fram till skörd.';

  @override
  String get phaseSimpleHarvested => 'Ya cosechado';

  @override
  String get phaseSimpleHarvestedBody =>
      'Säsongen är klar för den här plantan.';

  @override
  String get perennialEstablishedTitle => '¿Desde cuándo la tienes?';

  @override
  String get perennialEstablishedBody =>
      'No tiene que ser exacto – solo usamos el año.';

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
  String get statusPlanning => 'Planificación';

  @override
  String get statusGrowingIndoors => 'Semillero interior';

  @override
  String get statusDirectSown => 'Sembrado directo';

  @override
  String get statusHardening => 'Endurecimiento';

  @override
  String get statusOutdoors => 'En el exterior';

  @override
  String get statusReadyToHarvest => 'Listo para cosechar';

  @override
  String get statusHarvested => 'Cosechado';

  @override
  String get statusDormant => 'Latente';

  @override
  String get sowingIndoors => 'Inomhus';

  @override
  String get sowingDirect => 'Direkt';

  @override
  String get sowingPlanta => 'Planta';

  @override
  String get sunFull => 'Pleno sol';

  @override
  String get sunPartial => 'Media sombra';

  @override
  String get sunShade => 'Sombra';

  @override
  String get waterSparse => 'Escaso';

  @override
  String get waterRegular => 'Regular';

  @override
  String get waterAbundant => 'Abundante';

  @override
  String get fertilizerLow => 'Bajo';

  @override
  String get fertilizerMedium => 'Medio';

  @override
  String get fertilizerHigh => 'Alto';

  @override
  String get lifecycleAnnual => 'Anual';

  @override
  String get lifecycleBiennial => 'Bienal';

  @override
  String get lifecyclePerennial => 'Perenne';

  @override
  String get lifecycleTree => 'Árbol';

  @override
  String get lifecycleShrub => 'Arbusto';

  @override
  String get categoryVegetables => 'Verduras';

  @override
  String get categoryHerbs => 'Hierbas y especias';

  @override
  String get categoryFlowers => 'Flores';

  @override
  String get categoryBerries => 'Bayas';

  @override
  String get categoryFruitTrees => 'Árboles frutales';

  @override
  String get categoryOther => 'Otros';

  @override
  String get wateredNow => 'Regado';

  @override
  String get wateredConfirmation => 'Regado ✓';

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
  String get harvestTitle => 'Cosecha';

  @override
  String get harvestLog => 'Registrar cosecha';

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
  String get buttonCancel => 'Cancelar';

  @override
  String get buttonRemove => 'Eliminar';

  @override
  String get buttonSave => 'Guardar';

  @override
  String get buttonNext => 'Siguiente';

  @override
  String get buttonStart => 'Empezar';

  @override
  String get buttonSkip => 'Saltar';

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
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsPremiumActive => 'Premium activo';

  @override
  String get settingsPremiumUpgrade => 'Pasar a Premium';

  @override
  String get settingsPremiumUnlock => 'Lås upp alla funktioner';

  @override
  String get settingsMyGardens => 'Mis jardines';

  @override
  String settingsMyGardensSubtitle(Object emoji, Object name) {
    return 'Aktiv: $emoji $name';
  }

  @override
  String get settingsMyGardensEmpty => 'Lägg till din första trädgård';

  @override
  String get settingsNotifications => 'Recordatorios';

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
  String get settingsSupport => 'Soporte';

  @override
  String get settingsFeedback => 'Enviar comentarios';

  @override
  String get settingsFeedbackBody =>
      'Buggar, funktionsönskemål eller bara ett vänligt hej';

  @override
  String get gardensTitle => 'Mina trädgårdar';

  @override
  String get gardensActive => 'ACTIVO';

  @override
  String get gardensAddNew => 'Añadir un jardín';

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
  String get introPage1Title => 'Añade plantas que cultivas';

  @override
  String get introPage1Body =>
      'Tryck + på en växt för att lägga till den i din trädgård. Vi följer den från sådd till skörd och påminner när det är dags att vattna, beskära eller plantera om.';

  @override
  String get introPage1Hint =>
      'Hittar du växten? Använd \"Växter\"-fliken i botten.';

  @override
  String get introPage2Title => 'Planifica tu temporada';

  @override
  String get introPage2Body =>
      'Tryck på bokmärket för att lägga växten på din säsongs-lista. Du får en notis i februari/mars när det är dags att börja förodla, och i april när det är dags att direktså.';

  @override
  String get introPage2Hint => 'Säsongs-listan ser du på startsidan.';

  @override
  String get introPage3Title => 'Controla tu jardín';

  @override
  String get introPage3Body =>
      'Hem-sidan visar väder, torrperioder och vad du ska göra denna månad. På \"Min trädgård\"-fliken kan du se årets statistik, växtföljd och uppskattat värde av din skörd.';

  @override
  String get introPage3Hint =>
      'Skadedjur & sjukdomar finns i Inställningar när du behöver dem.';

  @override
  String get pestLibraryTitle => 'Plagas y enfermedades';

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
  String get tabTodo => 'Tareas';

  @override
  String get todoSectionToday => 'HOY';

  @override
  String get todoSectionWeek => 'ESTA SEMANA';

  @override
  String get todoSectionMonth => 'ESTE MES';

  @override
  String get todoSectionDoneToday => 'HECHO HOY ✓';

  @override
  String get todoStatToday => 'hoy';

  @override
  String get todoStatWeek => 'esta semana';

  @override
  String get todoStatDone => 'hecho';

  @override
  String get todoEmptyTitle => 'Todo bajo control';

  @override
  String get todoEmptyBody =>
      'Nada urgente. Añade plantas para recibir tareas diarias.';

  @override
  String get todoSwipeDone => 'Hecho';

  @override
  String get todoSwipeSnooze => 'Posponer';

  @override
  String get progressReadyToHarvest => 'Listo para cosechar';

  @override
  String get progressHarvestNow => 'Cosechar ahora';

  @override
  String progressDaysLeft(Object days) {
    return '$days días restantes';
  }

  @override
  String progressApproxDaysLeft(Object days) {
    return '~$days días restantes';
  }

  @override
  String get climateCardTitle => 'Clima últimos 14 días';

  @override
  String get climateStatAvg => 'Media diaria';

  @override
  String get climateStatMinMax => 'Mín/máx';

  @override
  String get climateStatGdd => 'GDD';

  @override
  String get climateInterpretWaking => 'El jardín se despierta.';

  @override
  String get climateInterpretEarly =>
      'Temporada muy temprana – solo rústicas (cebolla, guisantes, lechuga).';

  @override
  String get climateInterpretSpring =>
      'Temporada primaveral – las siembras directas se establecen, las cálidas esperan.';

  @override
  String get climateInterpretMidSpring =>
      'Media primavera – tomate y pimiento bajo velo o en invernadero.';

  @override
  String get climateInterpretFullGrowth =>
      'Pleno crecimiento – todo madura rápido, riega y abona.';

  @override
  String get climateInterpretHot =>
      'Período caluroso – cuidado con el riego en plantas jóvenes.';

  @override
  String get climateTeaserTitle => 'Tarjeta de clima (Premium)';

  @override
  String get climateTeaserBody =>
      'Temperatura media + Growing Degree Days para mejor temporización de siembra y cosecha.';

  @override
  String get weatherSetLocationHint => 'Establece la ubicación en ajustes';

  @override
  String weatherFrostWarning(String date, String temp) {
    return 'Aviso de heladas $date – $temp°C';
  }

  @override
  String dryPeriodBodyWithThirsty(
    String past,
    String next,
    String names,
    String more,
  ) {
    return 'Solo $past mm de lluvia en los últimos 14 días y se esperan $next mm la próxima semana. Riega $names$more — las plantas tolerantes a la sequía aguantan más.';
  }

  @override
  String dryPeriodBodyGeneral(String past, String next) {
    return 'Solo $past mm de lluvia en los últimos 14 días y se esperan $next mm la próxima semana. Riega con cuidado, especialmente recién plantadas y en macetas.';
  }

  @override
  String get dryPeriodMoreSuffix => ' etc.';

  @override
  String get myGardenWaterAllTooltip => 'Regar todas las plantas de exterior';

  @override
  String myGardenSeasonStatsTooltip(String year) {
    return 'Mi temporada $year';
  }

  @override
  String get myGardenGroupTooltip => 'Agrupar por';

  @override
  String get myGardenNoOutdoorPlants =>
      'No hay plantas de exterior para regar ahora.';

  @override
  String get myGardenWaterAllTitle => '¿Regar todas?';

  @override
  String myGardenWaterAllConfirm(String count) {
    return 'Marca $count plantas de exterior como regadas ahora.';
  }

  @override
  String get myGardenWaterAllCancel => 'Cancelar';

  @override
  String get myGardenWaterAllAction => 'Regar todas';

  @override
  String myGardenWaterAllDone(String count) {
    return '$count plantas regadas ✓';
  }

  @override
  String get myGardenLocationNone => 'Sin ubicación';

  @override
  String get myGardenCategoryOther => 'Otro';

  @override
  String myGardenStatusSince(String status, String year) {
    return '$status • desde $year';
  }

  @override
  String myGardenStatusOnDate(String status, String date) {
    return '$status • $date';
  }

  @override
  String settingsMyGardensWithCount(String count) {
    return 'Mis huertos ($count)';
  }

  @override
  String get settingsPlanMonthly => 'Suscripción mensual';

  @override
  String get settingsPlanYearly => 'Suscripción anual';

  @override
  String get settingsPlanLifetime => 'De por vida';

  @override
  String get settingsPlanFree => 'Gratis';

  @override
  String get settingsStarterKit => '🛒 Kit de inicio';

  @override
  String get settingsMorningHourPickerTitle =>
      '¿Cuándo quieres el aviso de la mañana?';

  @override
  String get settingsMorningHourPickerBody =>
      'El resumen matinal y todos los recordatorios de siembra se activan a esta hora. Nada te despierta antes.';

  @override
  String settingsHourFormat(String hour) {
    return '$hour:00';
  }

  @override
  String settingsBackupFailed(String error) {
    return 'No se pudo crear la copia: $error';
  }

  @override
  String get settingsFeedbackSubject => 'Comentarios de Plantera';

  @override
  String settingsFeedbackBodyTemplate(String version) {
    return '¡Hola!\n\nComentarios / pregunta / informe de error:\n\n\n— Enviado desde Plantera $version';
  }

  @override
  String get gardensDelete => 'Eliminar';

  @override
  String get gardensCancel => 'Cancelar';

  @override
  String get gardensNameLabel => 'Nombre';

  @override
  String gardensZoneDescription(String zone, String description) {
    return 'Zona $zone – $description';
  }

  @override
  String gardensCityFormat(String city, String zone) {
    return '$city · $zone';
  }

  @override
  String get introSkip => 'Omitir';

  @override
  String get introNext => 'Siguiente';

  @override
  String get introStart => 'Empezar';

  @override
  String get onboardingWelcome => 'Bienvenido a Plantera';

  @override
  String get onboardingBody =>
      'Elige tu ubicación para consejos personalizados, alertas de heladas y los tiempos correctos de siembra para tu zona.';

  @override
  String get onboardingUseGps => 'Usar mi ubicación';

  @override
  String get onboardingLocating => 'Obteniendo ubicación…';

  @override
  String get onboardingOrPickCity => 'o elige una ciudad';

  @override
  String onboardingZoneSubtitle(String zone) {
    return 'Zona $zone';
  }

  @override
  String get onboardingErrorLocationServicesOff =>
      'Servicios de ubicación desactivados';

  @override
  String get onboardingErrorLocationDenied => 'Permiso de ubicación denegado';

  @override
  String get phasePerennialHaveIt => 'La tengo en el huerto';

  @override
  String get phasePerennialHaveItBody =>
      'Mostraremos la cosecha esperada y recordaremos la poda, abonado y cuidados de temporada.';

  @override
  String get phasePerennialPlanning => 'Planeo plantar';

  @override
  String get phasePerennialPlanningBody =>
      'En la lista hasta que plantes — los avisos llegan a tiempo.';

  @override
  String get phaseDetailedPlanned => 'Planeo cultivar';

  @override
  String get phaseDetailedPlannedBody =>
      'Solo en la lista — los avisos llegan a tiempo al iniciar la temporada.';

  @override
  String get phaseDetailedPresow => 'Siembro en interior';

  @override
  String get phaseDetailedPresowBody =>
      'Plántulas en interior. Aviso de endurecimiento en 5 semanas.';

  @override
  String get phaseDetailedDirectsow => 'Sembré directamente fuera';

  @override
  String get phaseDetailedDirectsowBody =>
      'Sembrado en su sitio. Queda el aviso de cosecha.';

  @override
  String get phaseDetailedPlantout => 'Plantas trasplantadas';

  @override
  String get phaseDetailedPlantoutBody =>
      'En su sitio final. Queda el aviso de cosecha.';

  @override
  String get phaseFinishedReady => 'Lista para cosechar';

  @override
  String get phaseFinishedReadyBody =>
      'Se marca como lista para cosechar ahora.';

  @override
  String get phaseFinishedHarvested => 'Cosechada';

  @override
  String get phaseFinishedHarvestedBody =>
      'Temporada terminada — avisos pausados.';

  @override
  String get phaseFinishedDormant => 'En reposo';

  @override
  String get phaseFinishedDormantBody => 'La planta no está activa ahora.';

  @override
  String get phaseDateHelpPresow => '¿Qué día empezaste esta planta?';

  @override
  String get phaseDateHelpDirectsow => '¿Qué día sembraste directo?';

  @override
  String get phaseDateHelpPlantout => '¿Qué día salieron las plántulas?';

  @override
  String get phaseDateHelpDefault => 'Fecha';

  @override
  String get phasePerennialYearTitle => '¿Desde cuándo la tienes?';

  @override
  String get phasePerennialYearBody =>
      'No tiene que ser exacto — solo usamos el año.';

  @override
  String phasePerennialYearThis(String year) {
    return 'Este año ($year)';
  }

  @override
  String phasePerennialYearLast(String year) {
    return 'El año pasado ($year)';
  }

  @override
  String phasePerennialYearTwo(String year) {
    return 'Hace dos años ($year)';
  }

  @override
  String get phasePerennialYearOlder => 'Antes (hace algunos años)';

  @override
  String get plantDetailTabOverview => 'Resumen';

  @override
  String get plantDetailTabMyPlant => 'Mi planta';

  @override
  String get plantDetailTabCare => 'Cuidado';

  @override
  String get plantDetailAddCta => 'Añadir a mi huerto';

  @override
  String get plantDetailRemoveCta => 'Quitar del huerto';

  @override
  String get plantDetailRemoveTitle => '¿Quitar del huerto?';

  @override
  String get plantDetailRemoveBody => 'No se puede deshacer.';

  @override
  String get plantDetailCancel => 'Cancelar';

  @override
  String get plantDetailDelete => 'Eliminar';

  @override
  String get plantDetailSave => 'Guardar';

  @override
  String get plantDetailReset => 'Restablecer';

  @override
  String get plantDetailReuse => 'Reutilizar';

  @override
  String get plantDetailWaterNowSuffix => 'Regada ahora';

  @override
  String get plantDetailWaterTapHint => 'Toca al regar para llevar el control';

  @override
  String get plantDetailWaterDoneSnack => 'Regada ✓';

  @override
  String get plantDetailWaterNotYet => 'Aún no regada';

  @override
  String get plantDetailWaterJust => 'Acabada de regar';

  @override
  String get plantDetailWaterToday => 'Regada hoy';

  @override
  String get plantDetailWaterYesterday => 'Regada ayer';

  @override
  String get plantDetailUpcomingCareTitle => '📅  PRÓXIMO CUIDADO';

  @override
  String get plantDetailDueNow => 'Ahora';

  @override
  String get plantDetailEditPostsTooltip => 'Gestionar publicaciones';

  @override
  String get plantDetailNoteHint => 'Escribe una nota corta…';

  @override
  String get plantDetailNoteTitle => 'Nota';

  @override
  String get plantDetailNoteSubtitle =>
      '¿Qué pasó hoy? Pulgones, primera flor, poda…';

  @override
  String get plantDetailTakePhoto => 'Tomar foto';

  @override
  String get plantDetailPickLibrary => 'Elegir de la biblioteca';

  @override
  String get plantDetailWriteNote => 'Escribir nota';

  @override
  String get plantDetailUseEmojiAgain => 'Usar emoji de nuevo';

  @override
  String plantDetailSaveImageError(String error) {
    return 'No se pudo guardar la imagen: $error';
  }

  @override
  String plantDetailSavePhotoError(String error) {
    return 'No se pudo guardar la foto: $error';
  }

  @override
  String get plantDetailDeletePhotoTitle => '¿Eliminar foto?';

  @override
  String get plantDetailDeleteNoteTitle => '¿Eliminar nota?';

  @override
  String get plantDetailDeletePhotoBody =>
      'La foto se elimina del dispositivo.';

  @override
  String get plantDetailDeleteNoteBody => 'La nota desaparece.';

  @override
  String get plantDetailAdd => 'Añadir';

  @override
  String get plantDetailNoPostsBody =>
      'Aún no hay publicaciones — empieza a documentar el crecimiento con fotos y notas.';

  @override
  String get plantDetailChangeStatus => 'Cambiar estado';

  @override
  String get plantDetailLocationLabel => 'Ubicación';

  @override
  String plantDetailSowingMethodChip(String method) {
    return 'Siembra: $method';
  }

  @override
  String plantDetailSowingMethodSnack(String method) {
    return 'Método de siembra: $method';
  }

  @override
  String get plantDetailDateHelp => '¿Qué fecha?';

  @override
  String get plantDetailHowSowTitle => '¿Cómo siembras?';

  @override
  String get plantDetailHowSowBody => 'Determina qué recordatorios recibes.';

  @override
  String get plantDetailLocationTitle => '¿Dónde está?';

  @override
  String get plantDetailLocationBody =>
      'P. ej., \"bancal norte\", \"el invernadero\", \"el balcón\".';

  @override
  String get plantDetailHarvestOffsetTitle => 'Ajustar tiempo de cosecha';

  @override
  String get plantDetailHarvestOffsetBody =>
      '¿Contador equivocado? Suma o resta días — se guarda solo en esta planta.';

  @override
  String get plantDetailReadyToHarvest => 'Lista para cosechar';

  @override
  String get plantDetailNextStepPresow => 'He sembrado en interior';

  @override
  String get plantDetailNextStepDirectsow => 'He sembrado directo';

  @override
  String get plantDetailNextStepPlantout => 'He trasplantado';

  @override
  String get plantDetailNextStepPlantedOut => 'Plantas trasplantadas';

  @override
  String get plantDetailNextStepHarvestReady => 'Lista para cosechar';

  @override
  String get plantDetailNextStepHarvested => 'Cosechada';

  @override
  String get plantDetailHowToTitle => 'Cómo hacerlo';

  @override
  String get plantDetailTipsTitle => 'Consejos';

  @override
  String get plantDetailPestsTitle => 'Plagas a vigilar';

  @override
  String get plantDetailNoCareTips => 'No hay consejos de cuidado disponibles.';

  @override
  String get plantDetailInfoSun => 'Sol';

  @override
  String get plantDetailInfoWater => 'Agua';

  @override
  String get plantDetailInfoFertilizer => 'Abono';

  @override
  String get plantDetailInfoFrost => 'Resiste hasta';

  @override
  String get plantDetailInfoSpacing => 'Distancia';

  @override
  String get plantDetailInfoHarvest => 'Cosecha';

  @override
  String get plantDetailHarvestSection => '🥕  Cosecha';

  @override
  String get plantDetailToolsSection => '🛒 Herramientas y accesorios';

  @override
  String get plantDetailSeasonSection => 'Temporada';

  @override
  String get plantDetailPhasePresow => 'Sembrar en interior';

  @override
  String get plantDetailPhaseDirectsow => 'Sembrar directo';

  @override
  String get plantDetailPhasePlantout => 'Trasplantar';

  @override
  String get plantDetailPhaseHarvest => 'Cosechar';

  @override
  String get plantDetailZoneWarningBody =>
      'Puede funcionar – pero probablemente necesitarás protección invernal o un sitio más cálido.';

  @override
  String plantDetailDateAdded(String date) {
    return 'Añadido $date';
  }

  @override
  String plantDetailDateInGardenSince(String year) {
    return 'En el huerto desde $year';
  }

  @override
  String plantDetailDatePlanted(String date) {
    return 'Plantado $date';
  }

  @override
  String get plantDetailHarvestOffsetSubtitle => 'Ajustar tiempo de cosecha';

  @override
  String plantDetailZoneWarning(String zone) {
    return 'Esta planta no está probada para la zona $zone. Puede funcionar – pero probablemente necesitarás protección invernal o un sitio más cálido.';
  }

  @override
  String get harvestSectionTitle => '🥕 Cosecha';

  @override
  String get harvestRemoveTitle => '¿Eliminar entrada?';

  @override
  String harvestRemoveBody(String amount, String unit, String date) {
    return '$amount $unit del $date se eliminarán.';
  }

  @override
  String harvestMoreEntries(String count) {
    return '+ $count entradas más antiguas';
  }

  @override
  String harvestAddTitle(String plant) {
    return 'Registrar cosecha — $plant';
  }

  @override
  String get harvestAmountLabel => 'Cantidad';

  @override
  String get harvestUnitLabel => 'Unidad';

  @override
  String get harvestNotesLabel => 'Nota (opcional)';

  @override
  String get harvestErrorAmountTooLow => 'Introduce una cantidad mayor que 0';

  @override
  String get harvestErrorFutureDate =>
      'No puedes registrar una cosecha en el futuro';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get pestTypeLabelDisease => 'ENFERMEDAD';

  @override
  String get pestTypeLabelDamage => 'DAÑO';

  @override
  String get pestTypeLabelPest => 'PLAGA';
}
