// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Plantera';

  @override
  String get appSubtitle => 'Your digital garden companion';

  @override
  String get tabHome => 'Home';

  @override
  String get tabCalendar => 'Calendar';

  @override
  String get tabPlants => 'Plants';

  @override
  String get tabMyGarden => 'My plants';

  @override
  String get tabSettings => 'Settings';

  @override
  String get tabOverview => 'Overview';

  @override
  String get tabMyPlant => 'My plant';

  @override
  String get tabCare => 'Care';

  @override
  String get homeWelcomeTitle => 'Let\'s start with your first plant';

  @override
  String get homeWelcomeBody =>
      'Browse the plant database and tap + on what you grow — we\'ll follow it from sowing to harvest.';

  @override
  String get homeWelcomeCta => 'Browse plants';

  @override
  String get gardenOverviewTitle => 'My garden right now';

  @override
  String get gardenSeeAll => 'See all';

  @override
  String get gardenStatTotal => 'In garden';

  @override
  String get gardenStatHarvestSoon => 'Harvest soon';

  @override
  String get gardenStatReadyNow => 'Ready now';

  @override
  String gardenMore(Object count) {
    return '+$count more';
  }

  @override
  String get dailyInsightsTitle => 'Today in the garden';

  @override
  String get dailyInsightsAllGood =>
      'Everything\'s under control. Nothing urgent — enjoy the garden.';

  @override
  String get upcomingCareTitle => 'Upcoming care';

  @override
  String get upcomingCareSubtitle => 'Things to do this and next month.';

  @override
  String seasonPlannerTitle(Object year) {
    return 'My season $year';
  }

  @override
  String get seasonPlannerSubtitle =>
      'What you want to grow this year. We\'ll notify you when it\'s time to sow.';

  @override
  String seasonPlannerEmptyTitle(Object year) {
    return 'Plan season $year';
  }

  @override
  String get seasonPlannerEmptyBody =>
      'What do you want to grow this year? We\'ll remind you when it\'s time to sow.';

  @override
  String get seasonPlannerEmptyCta => 'Choose';

  @override
  String get seasonPlannerAddCta => 'Add plant';

  @override
  String seasonPlannerCount(Object count) {
    return '$count plants';
  }

  @override
  String get seasonRowSowNow => 'Sow now';

  @override
  String seasonRowDaysAway(Object days) {
    return 'In $days days';
  }

  @override
  String get seasonRowInSeason => 'In season';

  @override
  String get weatherUnavailable => 'Weather unavailable';

  @override
  String get weatherSetLocation => 'Set your location in settings';

  @override
  String get dryPeriodTitle => 'Dry spell ongoing';

  @override
  String get frostCardTitle => '❄️ Protect against frost';

  @override
  String get premiumTeaserTitle => 'Plantera Premium';

  @override
  String get premiumTeaserBody => 'Unlimited garden and no ads';

  @override
  String get calendarTitle => 'Planting calendar';

  @override
  String get calendarMonthGuide => 'Monthly guide';

  @override
  String calendarTaskCount(Object count) {
    return '$count tasks';
  }

  @override
  String get calendarPhasePresow => 'START INDOORS';

  @override
  String get calendarPhaseDirectsow => 'DIRECT SOW';

  @override
  String get calendarPhasePlantout => 'PLANT OUT';

  @override
  String get calendarPhaseHarvest => 'HARVEST';

  @override
  String calendarPhaseCount(Object count) {
    return '$count plants';
  }

  @override
  String calendarEmptyTitle(Object month) {
    return 'Nothing to sow or harvest in $month';
  }

  @override
  String get calendarEmptyBody =>
      'Use the month for planning — order seeds, plan beds, or read the monthly guide.';

  @override
  String get myGardenTitle => 'My plants';

  @override
  String get myGardenSearchHint => 'Search plant or location';

  @override
  String get myGardenFilterAll => 'All';

  @override
  String get myGardenGroupByStatus => 'Group by status';

  @override
  String get myGardenGroupByLocation => 'Group by location';

  @override
  String get myGardenGroupByCategory => 'Group by category';

  @override
  String myGardenShowingCount(Object shown, Object total) {
    return 'Showing $shown of $total';
  }

  @override
  String get myGardenEmptyTitle => 'Your garden is empty';

  @override
  String get myGardenEmptyBody =>
      'Add plants from the database to start building your garden.';

  @override
  String get myGardenEmptyCta => 'Browse the plant database';

  @override
  String get myGardenAddPlant => 'Add plant';

  @override
  String get myGardenNoResults => 'No matching plants';

  @override
  String get myGardenNoResultsBody =>
      'Try a different search or clear your filters.';

  @override
  String get myGardenWateredNow => 'Watered just now';

  @override
  String get myGardenWateredToday => 'Watered today';

  @override
  String get myGardenWateredYesterday => 'Watered yesterday';

  @override
  String get plantDatabaseTitle => 'Plant database';

  @override
  String get plantDatabaseSearchHint => 'Search plant';

  @override
  String get plantCategoryAll => 'All';

  @override
  String get addPlantNow => 'Add to garden now';

  @override
  String get addPlantNowBody =>
      'You\'ve sown or planted — we\'ll follow it from today';

  @override
  String get addPlantSeason => 'Add to sowing list';

  @override
  String get addPlantSeasonBody =>
      'Planning to grow it — we\'ll ping when it\'s time to sow';

  @override
  String get addPlantRemoveSeason => 'Remove from sowing list';

  @override
  String get addPlantRemoveSeasonBody =>
      'We\'ll stop reminding about the sowing window';

  @override
  String addedToGardenTitle(Object plant) {
    return '$plant is in your garden';
  }

  @override
  String get addedToGardenBodyPlain =>
      'We\'ll follow it from today and remind you about water and harvest.';

  @override
  String addedToGardenBodyScheduled(Object list) {
    return 'We\'ll follow it from today. Notifications scheduled for: $list.';
  }

  @override
  String get addedToGardenCta => 'Take me to my garden';

  @override
  String get phasePickerTitleNew => 'Where are you in the process?';

  @override
  String get phasePickerTitleEdit => 'Change status';

  @override
  String get phaseShowSimple => 'Show simpler options';

  @override
  String get phaseShowMore => 'More options (for experienced gardeners)';

  @override
  String get phaseSimplePlanned => 'Planning to grow';

  @override
  String get phaseSimplePlannedBody =>
      'Just on the list — we\'ll remind you when the season starts.';

  @override
  String get phaseSimpleGrowing => 'Growing right now';

  @override
  String get phaseSimpleGrowingBody =>
      'Plants are on their way. We\'ll follow them to harvest.';

  @override
  String get phaseSimpleHarvested => 'Already harvested';

  @override
  String get phaseSimpleHarvestedBody => 'Season\'s done for this plant.';

  @override
  String get perennialEstablishedTitle => 'Since when have you had it?';

  @override
  String get perennialEstablishedBody =>
      'Doesn\'t have to be exact – we only use the year.';

  @override
  String perennialThisYear(Object year) {
    return 'This year ($year)';
  }

  @override
  String perennialLastYear(Object year) {
    return 'Last year ($year)';
  }

  @override
  String perennialTwoYearsAgo(Object year) {
    return 'Two years ago ($year)';
  }

  @override
  String get perennialEarlier => 'Earlier (a few years back)';

  @override
  String get statusPlanning => 'Planning';

  @override
  String get statusGrowingIndoors => 'Growing indoors';

  @override
  String get statusDirectSown => 'Direct sown outside';

  @override
  String get statusHardening => 'Hardening off';

  @override
  String get statusOutdoors => 'Outdoors';

  @override
  String get statusReadyToHarvest => 'Ready to harvest';

  @override
  String get statusHarvested => 'Harvested';

  @override
  String get statusDormant => 'Dormant';

  @override
  String get sowingIndoors => 'Indoors';

  @override
  String get sowingDirect => 'Direct';

  @override
  String get sowingPlanta => 'Transplant';

  @override
  String get sunFull => 'Full sun';

  @override
  String get sunPartial => 'Partial shade';

  @override
  String get sunShade => 'Shade';

  @override
  String get waterSparse => 'Sparse';

  @override
  String get waterRegular => 'Regular';

  @override
  String get waterAbundant => 'Abundant';

  @override
  String get fertilizerLow => 'Low';

  @override
  String get fertilizerMedium => 'Medium';

  @override
  String get fertilizerHigh => 'High';

  @override
  String get lifecycleAnnual => 'Annual';

  @override
  String get lifecycleBiennial => 'Biennial';

  @override
  String get lifecyclePerennial => 'Perennial';

  @override
  String get lifecycleTree => 'Tree';

  @override
  String get lifecycleShrub => 'Shrub';

  @override
  String get categoryVegetables => 'Vegetables';

  @override
  String get categoryHerbs => 'Herbs & spices';

  @override
  String get categoryFlowers => 'Flowers';

  @override
  String get categoryBerries => 'Berries';

  @override
  String get categoryFruitTrees => 'Fruit trees';

  @override
  String get categoryOther => 'Other';

  @override
  String get wateredNow => 'Watered';

  @override
  String get wateredConfirmation => 'Watered ✓';

  @override
  String get notWateredYet => 'Not watered yet';

  @override
  String get wateredJustNow => 'Watered just now';

  @override
  String wateredDaysAgo(Object days) {
    return 'Watered $days days ago';
  }

  @override
  String wateredWeeksAgo(Object weeks) {
    return 'Watered $weeks weeks ago';
  }

  @override
  String get journalTitle => 'Journal';

  @override
  String journalCount(Object count) {
    return '$count';
  }

  @override
  String get journalAdd => 'Add';

  @override
  String get journalEmpty =>
      'No entries yet — start documenting growth with photos and short notes.';

  @override
  String get journalNoteTitle => 'Note';

  @override
  String get journalNoteBody =>
      'What happened today? Aphids, first flower, pruning…';

  @override
  String get journalNoteHint => 'Write a short note…';

  @override
  String get journalSave => 'Save';

  @override
  String get journalDeletePhoto => 'Delete photo?';

  @override
  String get journalDeletePhotoBody =>
      'The image will be removed from the device.';

  @override
  String get journalDeleteNote => 'Delete note?';

  @override
  String get journalDeleteNoteBody => 'The note will be removed.';

  @override
  String get journalManage => 'Manage entry';

  @override
  String get actionTakePhoto => 'Take photo';

  @override
  String get actionPickFromLibrary => 'Choose from library';

  @override
  String get actionWriteNote => 'Write a note';

  @override
  String get harvestTitle => 'Harvest';

  @override
  String get harvestLog => 'Log harvest';

  @override
  String get harvestEmpty =>
      'Log what you harvest and the app builds statistics year over year.';

  @override
  String harvestTotalLabel(Object amount, Object unit) {
    return 'Total: $amount $unit';
  }

  @override
  String harvestEstimatedSek(Object amount) {
    return '~$amount kr';
  }

  @override
  String get nextStepBecomeIndoor => 'I\'ve started indoors';

  @override
  String get nextStepBecomeDirect => 'I\'ve direct-sown';

  @override
  String get nextStepBecomePlanted => 'I\'ve planted out';

  @override
  String get nextStepHardenedToPlanted => 'Plants are outside';

  @override
  String get nextStepReadyForHarvest => 'Ready to harvest';

  @override
  String get nextStepHarvested => 'Harvested';

  @override
  String get secondaryChangeStatus => 'Change status';

  @override
  String get secondaryRemove => 'Remove';

  @override
  String get secondaryRemoveConfirmTitle => 'Remove from garden?';

  @override
  String secondaryRemoveConfirmBody(Object plant) {
    return '$plant and all reminders will be removed. This can\'t be undone.';
  }

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonRemove => 'Remove';

  @override
  String get buttonSave => 'Save';

  @override
  String get buttonNext => 'Next';

  @override
  String get buttonStart => 'Get started';

  @override
  String get buttonSkip => 'Skip';

  @override
  String get locationLabel => 'Location';

  @override
  String get locationAdd => 'Add location';

  @override
  String get locationPickerTitle => 'Where is it?';

  @override
  String get locationPickerBody =>
      'E.g. \"north bed\", \"greenhouse\", \"balcony\".';

  @override
  String get locationReuse => 'Use again';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPremiumActive => 'Premium active';

  @override
  String get settingsPremiumUpgrade => 'Upgrade to Premium';

  @override
  String get settingsPremiumUnlock => 'Unlock all features';

  @override
  String get settingsMyGardens => 'My gardens';

  @override
  String settingsMyGardensSubtitle(Object emoji, Object name) {
    return 'Active: $emoji $name';
  }

  @override
  String get settingsMyGardensEmpty => 'Add your first garden';

  @override
  String get settingsNotifications => 'Reminders';

  @override
  String get settingsNotificationsBody => 'Frost alerts and planting times';

  @override
  String get settingsMorningHour => 'Morning time for reminders';

  @override
  String settingsMorningHourBody(Object hour) {
    return 'Garden-morning pings fire at $hour:00';
  }

  @override
  String get settingsLargeText => 'Large text';

  @override
  String get settingsLargeTextBody => 'Slightly larger text throughout the app';

  @override
  String get settingsSimpleStatus => 'Simple status';

  @override
  String get settingsSimpleStatusBody =>
      'Show only 3 main states (planning / growing / harvested). Turn off for full lifecycle.';

  @override
  String get settingsPestLibrary => 'Pests & diseases';

  @override
  String get settingsPestLibraryBody => 'Library of common problems';

  @override
  String get settingsIntro => 'Show introduction';

  @override
  String get settingsIntroBody =>
      'Quick walkthrough of the plus button, season planner and how the app works';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get settingsBackupBody =>
      'Export garden and harvest – save to iCloud Drive or email it to yourself';

  @override
  String get settingsRestorePurchases => 'Restore purchases';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTerms => 'Terms of Use (EULA)';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsFeedback => 'Send feedback';

  @override
  String get settingsFeedbackBody =>
      'Bugs, feature requests, or just a friendly hello';

  @override
  String get gardensTitle => 'My gardens';

  @override
  String get gardensActive => 'ACTIVE';

  @override
  String get gardensAddNew => 'Add new garden';

  @override
  String get gardensEdit => 'Edit';

  @override
  String get gardensNoLocation => 'No location';

  @override
  String gardensPlantCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plants',
      one: '1 plant',
    );
    return '$_temp0';
  }

  @override
  String get gardensSwitcherTitle => 'Switch garden';

  @override
  String get gardensManage => 'Manage gardens';

  @override
  String gardensZoneLine(Object zone) {
    return 'Zone $zone';
  }

  @override
  String get gardensNewTitle => 'New garden';

  @override
  String gardensEditTitle(Object name) {
    return 'Edit $name';
  }

  @override
  String get gardensNamePlaceholder => 'Allotment, Balcony, Cottage…';

  @override
  String get gardensCityLabel => 'City / nearest town';

  @override
  String get gardensCreateButton => 'Create garden';

  @override
  String get gardensSaveButton => 'Save';

  @override
  String get gardensFooterHint =>
      'Each garden has its own zone, plant list and weather. Switch the active garden by tapping it – everything updates instantly.';

  @override
  String gardensDeleteTitle(Object name) {
    return 'Remove $name?';
  }

  @override
  String get gardensDeletePlainBody => 'The garden will be removed.';

  @override
  String gardensDeleteWithPlantsBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plants',
      one: '1 plant',
    );
    return '$_temp0 will be moved to your default garden. The garden will be removed.';
  }

  @override
  String get introPage1Title => 'Add plants you grow';

  @override
  String get introPage1Body =>
      'Tap + on a plant to add it to your garden. We\'ll follow it from sowing to harvest and remind you when to water, prune, or transplant.';

  @override
  String get introPage1Hint =>
      'Can\'t find the plant? Use the \"Plants\" tab at the bottom.';

  @override
  String get introPage2Title => 'Plan your season';

  @override
  String get introPage2Body =>
      'Tap the bookmark to add a plant to your sowing list. You\'ll get a notification in February/March when it\'s time to start indoors, and in April when it\'s time to direct-sow.';

  @override
  String get introPage2Hint => 'The sowing list is shown on the home screen.';

  @override
  String get introPage3Title => 'Stay on top of your garden';

  @override
  String get introPage3Body =>
      'Home shows weather, dry periods, and what to do this month. The \"My garden\" tab shows yearly stats, crop rotation, and estimated harvest value.';

  @override
  String get introPage3Hint =>
      'Pests & diseases are in Settings when you need them.';

  @override
  String get pestLibraryTitle => 'Pests & diseases';

  @override
  String get pestLibrarySearchHint => 'Search by symptom or plant';

  @override
  String get pestLibraryFilterPests => 'Pests';

  @override
  String get pestLibraryFilterDiseases => 'Diseases';

  @override
  String get pestLibraryFilterDamage => 'Damage';

  @override
  String get pestLibraryNoMatch =>
      'Nothing matched. Try a symptom like \"spots\" or \"holes\".';

  @override
  String get pestSectionMild => 'Mild action';

  @override
  String get pestSectionStrong => 'Effective action';

  @override
  String get pestSectionPrevent => 'Prevent';

  @override
  String get pestAffects => 'Affects';

  @override
  String statsTitle(Object year) {
    return 'My garden $year';
  }

  @override
  String statsHero1(Object sek) {
    return 'You\'ve grown about $sek kr worth of food';
  }

  @override
  String statsHero2(Object count) {
    return 'You have $count plants going';
  }

  @override
  String get statsHeroEmpty => 'Season is waiting';

  @override
  String get statsTilePlants => 'Plants';

  @override
  String get statsTileSpecies => 'Species';

  @override
  String get statsTileHarvested => 'Harvested';

  @override
  String get statsHarvestPanelTitle => 'Harvest so far this year';

  @override
  String statsValueLine(Object sek) {
    return 'Estimated value: ~$sek kr';
  }

  @override
  String get statsValueDisclaimer =>
      'Based on rough Swedish supermarket prices per category. Doesn\'t include time or seed costs.';

  @override
  String get statsTopPanelTitle => 'This year\'s best yields';

  @override
  String get statsLocationPanelTitle => 'Where in the garden';

  @override
  String get statsRotationPanelTitle => 'Crop rotation';

  @override
  String get statsRotationBody =>
      'What grew where, by year. Repeats are flagged.';

  @override
  String get statsReflectionTitle => 'Reflection';

  @override
  String get statsEmptyTitle => 'Season hasn\'t started yet';

  @override
  String get statsEmptyBody =>
      'Add plants and log harvests – we\'ll fill this page with the year\'s results.';

  @override
  String get tabTodo => 'To-do';

  @override
  String get todoSectionToday => 'TODAY';

  @override
  String get todoSectionWeek => 'THIS WEEK';

  @override
  String get todoSectionMonth => 'THIS MONTH';

  @override
  String get todoSectionDoneToday => 'DONE TODAY ✓';

  @override
  String get todoStatToday => 'today';

  @override
  String get todoStatWeek => 'this week';

  @override
  String get todoStatDone => 'done';

  @override
  String get todoEmptyTitle => 'All under control';

  @override
  String get todoEmptyBody =>
      'Nothing urgent. Add plants to your garden to start getting daily tasks.';

  @override
  String get todoSwipeDone => 'Done';

  @override
  String get todoSwipeSnooze => 'Snooze';

  @override
  String get progressReadyToHarvest => 'Ready to harvest';

  @override
  String get progressHarvestNow => 'Harvest now';

  @override
  String progressDaysLeft(Object days) {
    return '$days days left';
  }

  @override
  String progressApproxDaysLeft(Object days) {
    return '~$days days left';
  }

  @override
  String get climateCardTitle => 'Climate last 14 days';

  @override
  String get climateStatAvg => 'Daily avg';

  @override
  String get climateStatMinMax => 'Min/max';

  @override
  String get climateStatGdd => 'GDD';

  @override
  String get climateInterpretWaking => 'The garden is waking up.';

  @override
  String get climateInterpretEarly =>
      'Very early season – only cold-hardy crops (onion, peas, lettuce).';

  @override
  String get climateInterpretSpring =>
      'Spring season – direct-sown greens establish; heat-lovers should wait.';

  @override
  String get climateInterpretMidSpring =>
      'Mid-spring – tomato and pepper can go out under fleece or in a greenhouse.';

  @override
  String get climateInterpretFullGrowth =>
      'Full growth pressure – everything matures fast, water and fertilize.';

  @override
  String get climateInterpretHot =>
      'Hot spell – be careful with water on young plants.';

  @override
  String get climateTeaserTitle => 'Climate card (Premium)';

  @override
  String get climateTeaserBody =>
      'Mean temperature + Growing Degree Days for better timing of sowing and harvest.';

  @override
  String get weatherSetLocationHint => 'Set location in settings';

  @override
  String weatherFrostWarning(String date, String temp) {
    return 'Frost warning $date – $temp°C';
  }

  @override
  String dryPeriodBodyWithThirsty(
    String past,
    String next,
    String names,
    String more,
  ) {
    return 'Only $past mm of rain in the last 14 days and $next mm expected the coming week. Water $names$more — drought-tolerant plants cope longer.';
  }

  @override
  String dryPeriodBodyGeneral(String past, String next) {
    return 'Only $past mm of rain in the last 14 days and $next mm expected the coming week. Water carefully, especially newly planted and pots.';
  }

  @override
  String get dryPeriodMoreSuffix => ' and others';

  @override
  String get myGardenWaterAllTooltip => 'Water all outdoor plants';

  @override
  String myGardenSeasonStatsTooltip(String year) {
    return 'My season $year';
  }

  @override
  String get myGardenGroupTooltip => 'Group by';

  @override
  String get myGardenNoOutdoorPlants => 'No outdoor plants to water right now.';

  @override
  String get myGardenWaterAllTitle => 'Water all?';

  @override
  String myGardenWaterAllConfirm(String count) {
    return 'Marking $count outdoor plants as watered right now.';
  }

  @override
  String get myGardenWaterAllCancel => 'Cancel';

  @override
  String get myGardenWaterAllAction => 'Water all';

  @override
  String myGardenWaterAllDone(String count) {
    return '$count plants watered ✓';
  }

  @override
  String get myGardenLocationNone => 'No location';

  @override
  String get myGardenCategoryOther => 'Other';

  @override
  String myGardenStatusSince(String status, String year) {
    return '$status • since $year';
  }

  @override
  String myGardenStatusOnDate(String status, String date) {
    return '$status • $date';
  }

  @override
  String settingsMyGardensWithCount(String count) {
    return 'My gardens ($count)';
  }

  @override
  String get settingsPlanMonthly => 'Monthly subscription';

  @override
  String get settingsPlanYearly => 'Yearly subscription';

  @override
  String get settingsPlanLifetime => 'Lifetime';

  @override
  String get settingsPlanFree => 'Free';

  @override
  String get settingsStarterKit => '🛒 Starter kit';

  @override
  String get settingsMorningHourPickerTitle =>
      'When do you want the morning ping?';

  @override
  String get settingsMorningHourPickerBody =>
      'The morning summary and all planting reminders fire at this hour. Nothing wakes you before.';

  @override
  String settingsHourFormat(String hour) {
    return '$hour:00';
  }

  @override
  String settingsBackupFailed(String error) {
    return 'Could not create backup: $error';
  }

  @override
  String get settingsFeedbackSubject => 'Plantera feedback';

  @override
  String settingsFeedbackBodyTemplate(String version) {
    return 'Hi!\n\nFeedback / question / bug report:\n\n\n— Sent from Plantera $version';
  }

  @override
  String get gardensDelete => 'Delete';

  @override
  String get gardensCancel => 'Cancel';

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
  String get introSkip => 'Skip';

  @override
  String get introNext => 'Next';

  @override
  String get introStart => 'Get started';

  @override
  String get onboardingWelcome => 'Welcome to Plantera';

  @override
  String get onboardingBody =>
      'Choose your location for tailored advice, frost alerts and the right sowing times for your zone.';

  @override
  String get onboardingUseGps => 'Use my location';

  @override
  String get onboardingLocating => 'Getting location…';

  @override
  String get onboardingOrPickCity => 'or pick a city';

  @override
  String onboardingZoneSubtitle(String zone) {
    return 'Zone $zone';
  }

  @override
  String get onboardingErrorLocationServicesOff => 'Location services are off';

  @override
  String get onboardingErrorLocationDenied => 'Location permission denied';

  @override
  String get phasePerennialHaveIt => 'I have it in the garden';

  @override
  String get phasePerennialHaveItBody =>
      'We\'ll show expected harvest and remind you about pruning, fertilizing and seasonal care.';

  @override
  String get phasePerennialPlanning => 'Planning to plant';

  @override
  String get phasePerennialPlanningBody =>
      'On the list until you actually plant — reminders arrive in time.';

  @override
  String get phaseDetailedPlanned => 'Planning to grow';

  @override
  String get phaseDetailedPlannedBody =>
      'Just on the list — reminders arrive in time when the season starts.';

  @override
  String get phaseDetailedPresow => 'I\'m starting indoors';

  @override
  String get phaseDetailedPresowBody =>
      'Seedlings are indoors. Hardening-off reminder in 5 weeks.';

  @override
  String get phaseDetailedDirectsow => 'I\'ve direct-sown outdoors';

  @override
  String get phaseDetailedDirectsowBody =>
      'Sown in place. Harvest reminder remains.';

  @override
  String get phaseDetailedPlantout => 'Seedlings are planted out';

  @override
  String get phaseDetailedPlantoutBody =>
      'In their final spot. Harvest reminder remains.';

  @override
  String get phaseFinishedReady => 'Ready to harvest';

  @override
  String get phaseFinishedReadyBody => 'Marks as harvest-ready now.';

  @override
  String get phaseFinishedHarvested => 'Harvested';

  @override
  String get phaseFinishedHarvestedBody => 'Season is done — reminders pause.';

  @override
  String get phaseFinishedDormant => 'Dormant';

  @override
  String get phaseFinishedDormantBody => 'The plant isn\'t active right now.';

  @override
  String get phaseDateHelpPresow => 'What date did you start this plant?';

  @override
  String get phaseDateHelpDirectsow => 'What date did you direct-sow?';

  @override
  String get phaseDateHelpPlantout => 'What date did the seedlings go out?';

  @override
  String get phaseDateHelpDefault => 'Date';

  @override
  String get phasePerennialYearTitle => 'How long have you had it?';

  @override
  String get phasePerennialYearBody =>
      'Doesn\'t need to be exact — we only use the year.';

  @override
  String phasePerennialYearThis(String year) {
    return 'This year ($year)';
  }

  @override
  String phasePerennialYearLast(String year) {
    return 'Last year ($year)';
  }

  @override
  String phasePerennialYearTwo(String year) {
    return 'Two years ago ($year)';
  }

  @override
  String get phasePerennialYearOlder => 'Earlier (a few years back)';

  @override
  String get plantDetailTabOverview => 'Overview';

  @override
  String get plantDetailTabMyPlant => 'My plant';

  @override
  String get plantDetailTabCare => 'Care';

  @override
  String get plantDetailAddCta => 'Add to my garden';

  @override
  String get plantDetailRemoveCta => 'Remove from garden';

  @override
  String get plantDetailRemoveTitle => 'Remove from garden?';

  @override
  String get plantDetailRemoveBody => 'This cannot be undone.';

  @override
  String get plantDetailCancel => 'Cancel';

  @override
  String get plantDetailDelete => 'Delete';

  @override
  String get plantDetailSave => 'Save';

  @override
  String get plantDetailReset => 'Reset';

  @override
  String get plantDetailReuse => 'Reuse';

  @override
  String get plantDetailWaterNowSuffix => 'Water now';

  @override
  String get plantDetailWaterTapHint => 'Tap when you water to keep track';

  @override
  String get plantDetailWaterDoneSnack => 'Watered ✓';

  @override
  String get plantDetailWaterNotYet => 'Not watered yet';

  @override
  String get plantDetailWaterJust => 'Just watered';

  @override
  String get plantDetailWaterToday => 'Watered today';

  @override
  String get plantDetailWaterYesterday => 'Watered yesterday';

  @override
  String get plantDetailUpcomingCareTitle => '📅  UPCOMING CARE';

  @override
  String get plantDetailDueNow => 'Due now';

  @override
  String get plantDetailEditPostsTooltip => 'Manage posts';

  @override
  String get plantDetailNoteHint => 'Write a short note…';

  @override
  String get plantDetailNoteTitle => 'Note';

  @override
  String get plantDetailNoteSubtitle =>
      'What happened today? Aphids, first flower, pruning…';

  @override
  String get plantDetailTakePhoto => 'Take photo';

  @override
  String get plantDetailPickLibrary => 'Pick from library';

  @override
  String get plantDetailWriteNote => 'Write note';

  @override
  String get plantDetailUseEmojiAgain => 'Use emoji again';

  @override
  String plantDetailSaveImageError(String error) {
    return 'Could not save image: $error';
  }

  @override
  String plantDetailSavePhotoError(String error) {
    return 'Could not save photo: $error';
  }

  @override
  String get plantDetailDeletePhotoTitle => 'Delete photo?';

  @override
  String get plantDetailDeleteNoteTitle => 'Delete note?';

  @override
  String get plantDetailDeletePhotoBody =>
      'The photo is removed from your device.';

  @override
  String get plantDetailDeleteNoteBody => 'The note will be removed.';

  @override
  String get plantDetailAdd => 'Add';

  @override
  String get plantDetailNoPostsBody =>
      'No posts yet — start documenting the plant\'s growth with photos and short notes.';

  @override
  String get plantDetailChangeStatus => 'Change status';

  @override
  String get plantDetailLocationLabel => 'Location';

  @override
  String plantDetailSowingMethodChip(String method) {
    return 'Sow: $method';
  }

  @override
  String plantDetailSowingMethodSnack(String method) {
    return 'Sowing method: $method';
  }

  @override
  String get plantDetailDateHelp => 'Which date?';

  @override
  String get plantDetailHowSowTitle => 'How do you sow?';

  @override
  String get plantDetailHowSowBody => 'Determines which reminders you get.';

  @override
  String get plantDetailLocationTitle => 'Where is it?';

  @override
  String get plantDetailLocationBody =>
      'E.g. \"north bed\", \"the greenhouse\", \"the balcony\".';

  @override
  String get plantDetailHarvestOffsetTitle => 'Adjust harvest time';

  @override
  String get plantDetailHarvestOffsetBody =>
      'Counter off? Add or subtract days — saved just on this plant.';

  @override
  String get plantDetailReadyToHarvest => 'Ready to harvest';

  @override
  String get plantDetailNextStepPresow => 'I started indoors';

  @override
  String get plantDetailNextStepDirectsow => 'I direct-sowed';

  @override
  String get plantDetailNextStepPlantout => 'I planted out';

  @override
  String get plantDetailNextStepPlantedOut => 'Seedlings are planted out';

  @override
  String get plantDetailNextStepHarvestReady => 'Ready to harvest';

  @override
  String get plantDetailNextStepHarvested => 'Harvested';

  @override
  String get plantDetailHowToTitle => 'How to do it';

  @override
  String get plantDetailTipsTitle => 'Tips';

  @override
  String get plantDetailPestsTitle => 'Pests to watch';

  @override
  String get plantDetailNoCareTips => 'No care tips available yet.';

  @override
  String get plantDetailInfoSun => 'Sun';

  @override
  String get plantDetailInfoWater => 'Water';

  @override
  String get plantDetailInfoFertilizer => 'Fertilizer';

  @override
  String get plantDetailInfoFrost => 'Hardy to';

  @override
  String get plantDetailInfoSpacing => 'Spacing';

  @override
  String get plantDetailInfoHarvest => 'Harvest';

  @override
  String get plantDetailHarvestSection => '🥕  Harvest';

  @override
  String get plantDetailToolsSection => '🛒 Tools and supplies';

  @override
  String get plantDetailSeasonSection => 'Season';

  @override
  String get plantDetailPhasePresow => 'Pre-sow';

  @override
  String get plantDetailPhaseDirectsow => 'Direct sow';

  @override
  String get plantDetailPhasePlantout => 'Plant out';

  @override
  String get plantDetailPhaseHarvest => 'Harvest';

  @override
  String get plantDetailZoneWarningBody =>
      'It may work – but you\'ll likely need winter protection or a warmer spot.';

  @override
  String plantDetailDateAdded(String date) {
    return 'Added $date';
  }

  @override
  String plantDetailDateInGardenSince(String year) {
    return 'In the garden since $year';
  }

  @override
  String plantDetailDatePlanted(String date) {
    return 'Planted $date';
  }

  @override
  String get plantDetailHarvestOffsetSubtitle => 'Adjust harvest time';

  @override
  String plantDetailZoneWarning(String zone) {
    return 'This plant isn\'t tested for zone $zone. It may work — but you\'ll likely need winter protection or a warmer spot.';
  }

  @override
  String get harvestSectionTitle => '🥕 Harvest';

  @override
  String get harvestRemoveTitle => 'Remove entry?';

  @override
  String harvestRemoveBody(String amount, String unit, String date) {
    return '$amount $unit from $date will be removed.';
  }

  @override
  String harvestMoreEntries(String count) {
    return '+ $count older entries';
  }

  @override
  String harvestAddTitle(String plant) {
    return 'Log harvest — $plant';
  }

  @override
  String get harvestAmountLabel => 'Amount';

  @override
  String get harvestUnitLabel => 'Unit';

  @override
  String get harvestNotesLabel => 'Note (optional)';

  @override
  String get harvestErrorAmountTooLow => 'Enter an amount greater than 0';

  @override
  String get harvestErrorFutureDate => 'You can\'t log a harvest in the future';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonSave => 'Save';

  @override
  String get pestTypeLabelDisease => 'DISEASE';

  @override
  String get pestTypeLabelDamage => 'DAMAGE';

  @override
  String get pestTypeLabelPest => 'PEST';

  @override
  String get statsShareButton => 'Share';

  @override
  String statsShareText(String year) {
    return 'My garden $year with Plantera 🌱';
  }

  @override
  String get statsShareFailed => 'Could not create share image';

  @override
  String get paywallTitleBranded => 'Plantera Premium';

  @override
  String get paywallHeaderFrost => 'Get frost warnings before plants freeze';

  @override
  String get paywallHeaderGardenLimit => 'Add your whole garden';

  @override
  String get paywallHeaderWaterAll => 'Water everything in one tap';

  @override
  String get paywallHeaderPhotoLog => 'A photo diary for every plant';

  @override
  String get paywallSubFrost =>
      'SMHI overnight temps — we ping you the evening before';

  @override
  String get paywallSubGardenLimit => 'No limit on how many plants you track';

  @override
  String get paywallSubWaterAll =>
      'One button marks every outdoor plant watered';

  @override
  String get paywallSubPhotoLog => 'See them grow from seed to harvest';

  @override
  String get paywallSubHome =>
      'Frost alerts, photo diary and everything unlimited';

  @override
  String get paywallSubDefault => 'Level up your garden';

  @override
  String get paywallBenefitUnlimited => 'Unlimited plants in your garden';

  @override
  String get paywallBenefitReminders => 'All reminders and frost warnings';

  @override
  String get paywallBenefitPhotos => 'Photo diary for every plant';

  @override
  String get paywallBenefitNoAds => 'No ads';

  @override
  String get paywallBenefitPdf => 'PDF export of your harvest journal';

  @override
  String get paywallBenefitArticles => 'Full access to knowledge articles';

  @override
  String get paywallPlanYearly => 'Yearly subscription';

  @override
  String paywallPlanYearlySavings(String percent) {
    return 'Save $percent% vs monthly';
  }

  @override
  String get paywallPlanMonthly => 'Monthly subscription';

  @override
  String get paywallPlanLifetime => 'Lifetime (one-time purchase)';

  @override
  String paywallTrialCta(String period) {
    return 'Start free trial ($period)';
  }

  @override
  String paywallTrialThen(String price) {
    return 'Then $price';
  }

  @override
  String paywallPlanPriceFormat(String title, String price) {
    return '$title • $price';
  }

  @override
  String get paywallRestore => 'Restore previous purchases';

  @override
  String get paywallDisclaimer =>
      'Subscriptions renew automatically until cancelled in App Store settings. You will be charged 24 h before renewal.';

  @override
  String get paywallTerms => 'Terms (EULA)';

  @override
  String get paywallPrivacy => 'Privacy policy';

  @override
  String get paywallErrorStore =>
      'App Store is unavailable right now — please try again in a moment.';

  @override
  String get paywallErrorProduct =>
      'Couldn\'t load purchase from App Store. Close the paywall and open it again.';

  @override
  String get paywallErrorFailed => 'Purchase failed. Please try again.';

  @override
  String paywallErrorOpenUrl(String url) {
    return 'Couldn\'t open $url';
  }

  @override
  String get paywallPurchaseSuccess =>
      'Premium activated — thank you! Everything is unlocked.';

  @override
  String get paywallRestoreInProgress => 'Looking for your purchases…';

  @override
  String get paywallRestoreFailed =>
      'Couldn\'t reach the App Store. Try again.';

  @override
  String get paywallRestoreSuccess => 'Premium restored — thank you!';

  @override
  String get paywallRestoreAlreadyActive => 'Premium is already active.';

  @override
  String get paywallRestoreNothingFound =>
      'No purchases found on this Apple ID.';

  @override
  String get paywallAlreadyPremiumTitle => 'You\'re Premium';

  @override
  String get paywallAlreadyPremiumBody =>
      'All features are unlocked. Thanks for the support — it helps us keep building.';

  @override
  String get paywallAlreadyPremiumCta => 'Back to the garden';

  @override
  String get paywallProductsUnavailable =>
      'Couldn\'t load prices from the App Store. Check your internet and try again.';

  @override
  String get paywallProductsRetry => 'Try again';

  @override
  String get onboardingSlide1Title => 'Stop guessing when to sow';

  @override
  String get onboardingSlide1Body =>
      'Plantera knows your hardiness zone and tells you exactly when to start indoors, direct-sow or plant out — vegetable by vegetable.';

  @override
  String get onboardingSlide2Title => 'Frost alerts you can act on';

  @override
  String get onboardingSlide2Body =>
      'When a cold night is coming you get notified in time to cover the seedlings. No panic at three in the morning.';

  @override
  String get onboardingSlide3Title => 'One morning reminder — not 50';

  @override
  String get onboardingSlide3Body =>
      'Watering, pruning, harvest and seasonal chores gathered in one daily summary so you actually get a harvest worth bragging about.';

  @override
  String get onboardingFooterSkip => 'Skip';

  @override
  String get onboardingFooterNext => 'Next';

  @override
  String get onboardingFooterStart => 'Get started';
}
