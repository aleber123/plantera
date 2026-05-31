import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('it'),
    Locale('nb'),
    Locale('sv'),
  ];

  /// No description provided for @appName.
  ///
  /// In sv, this message translates to:
  /// **'Plantera'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In sv, this message translates to:
  /// **'Din digitala trädgårdskompis'**
  String get appSubtitle;

  /// No description provided for @tabHome.
  ///
  /// In sv, this message translates to:
  /// **'Hem'**
  String get tabHome;

  /// No description provided for @tabCalendar.
  ///
  /// In sv, this message translates to:
  /// **'Kalender'**
  String get tabCalendar;

  /// No description provided for @tabPlants.
  ///
  /// In sv, this message translates to:
  /// **'Växter'**
  String get tabPlants;

  /// No description provided for @tabMyGarden.
  ///
  /// In sv, this message translates to:
  /// **'Mina växter'**
  String get tabMyGarden;

  /// No description provided for @tabSettings.
  ///
  /// In sv, this message translates to:
  /// **'Inställningar'**
  String get tabSettings;

  /// No description provided for @tabOverview.
  ///
  /// In sv, this message translates to:
  /// **'Översikt'**
  String get tabOverview;

  /// No description provided for @tabMyPlant.
  ///
  /// In sv, this message translates to:
  /// **'Min planta'**
  String get tabMyPlant;

  /// No description provided for @tabCare.
  ///
  /// In sv, this message translates to:
  /// **'Omsorg'**
  String get tabCare;

  /// No description provided for @homeWelcomeTitle.
  ///
  /// In sv, this message translates to:
  /// **'Vi börjar med första växten'**
  String get homeWelcomeTitle;

  /// No description provided for @homeWelcomeBody.
  ///
  /// In sv, this message translates to:
  /// **'Bläddra växtdatabasen och tryck + på det du odlar — sen följer vi växten från sådd till skörd.'**
  String get homeWelcomeBody;

  /// No description provided for @homeWelcomeCta.
  ///
  /// In sv, this message translates to:
  /// **'Bläddra växtdatabasen'**
  String get homeWelcomeCta;

  /// No description provided for @gardenOverviewTitle.
  ///
  /// In sv, this message translates to:
  /// **'Min trädgård just nu'**
  String get gardenOverviewTitle;

  /// No description provided for @gardenSeeAll.
  ///
  /// In sv, this message translates to:
  /// **'Se alla'**
  String get gardenSeeAll;

  /// No description provided for @gardenStatTotal.
  ///
  /// In sv, this message translates to:
  /// **'I trädgården'**
  String get gardenStatTotal;

  /// No description provided for @gardenStatHarvestSoon.
  ///
  /// In sv, this message translates to:
  /// **'Snart skörd'**
  String get gardenStatHarvestSoon;

  /// No description provided for @gardenStatReadyNow.
  ///
  /// In sv, this message translates to:
  /// **'Redo nu'**
  String get gardenStatReadyNow;

  /// No description provided for @gardenMore.
  ///
  /// In sv, this message translates to:
  /// **'+{count} till'**
  String gardenMore(Object count);

  /// No description provided for @dailyInsightsTitle.
  ///
  /// In sv, this message translates to:
  /// **'Idag i trädgården'**
  String get dailyInsightsTitle;

  /// No description provided for @dailyInsightsAllGood.
  ///
  /// In sv, this message translates to:
  /// **'Allt under kontroll. Inget akut just nu — njut av trädgården.'**
  String get dailyInsightsAllGood;

  /// No description provided for @upcomingCareTitle.
  ///
  /// In sv, this message translates to:
  /// **'Kommande omsorg'**
  String get upcomingCareTitle;

  /// No description provided for @upcomingCareSubtitle.
  ///
  /// In sv, this message translates to:
  /// **'Det här är dags att göra denna och nästa månad.'**
  String get upcomingCareSubtitle;

  /// No description provided for @seasonPlannerTitle.
  ///
  /// In sv, this message translates to:
  /// **'Min säsong {year}'**
  String seasonPlannerTitle(Object year);

  /// No description provided for @seasonPlannerSubtitle.
  ///
  /// In sv, this message translates to:
  /// **'Det här vill du odla i år. Du får en notis när det är dags att så.'**
  String get seasonPlannerSubtitle;

  /// No description provided for @seasonPlannerEmptyTitle.
  ///
  /// In sv, this message translates to:
  /// **'Planera säsongen {year}'**
  String seasonPlannerEmptyTitle(Object year);

  /// No description provided for @seasonPlannerEmptyBody.
  ///
  /// In sv, this message translates to:
  /// **'Vad vill du odla i år? Vi påminner dig när det är dags att så.'**
  String get seasonPlannerEmptyBody;

  /// No description provided for @seasonPlannerEmptyCta.
  ///
  /// In sv, this message translates to:
  /// **'Välj'**
  String get seasonPlannerEmptyCta;

  /// No description provided for @seasonPlannerAddCta.
  ///
  /// In sv, this message translates to:
  /// **'Lägg till växt'**
  String get seasonPlannerAddCta;

  /// No description provided for @seasonPlannerCount.
  ///
  /// In sv, this message translates to:
  /// **'{count} st'**
  String seasonPlannerCount(Object count);

  /// No description provided for @seasonRowSowNow.
  ///
  /// In sv, this message translates to:
  /// **'Så nu'**
  String get seasonRowSowNow;

  /// No description provided for @seasonRowDaysAway.
  ///
  /// In sv, this message translates to:
  /// **'Om {days} dagar'**
  String seasonRowDaysAway(Object days);

  /// No description provided for @seasonRowInSeason.
  ///
  /// In sv, this message translates to:
  /// **'I säsong'**
  String get seasonRowInSeason;

  /// No description provided for @weatherUnavailable.
  ///
  /// In sv, this message translates to:
  /// **'Väder ej tillgängligt'**
  String get weatherUnavailable;

  /// No description provided for @weatherSetLocation.
  ///
  /// In sv, this message translates to:
  /// **'Ange plats i inställningarna'**
  String get weatherSetLocation;

  /// No description provided for @dryPeriodTitle.
  ///
  /// In sv, this message translates to:
  /// **'Torrperiod pågår'**
  String get dryPeriodTitle;

  /// No description provided for @frostCardTitle.
  ///
  /// In sv, this message translates to:
  /// **'❄️ Skydda mot frosten'**
  String get frostCardTitle;

  /// No description provided for @premiumTeaserTitle.
  ///
  /// In sv, this message translates to:
  /// **'Plantera Premium'**
  String get premiumTeaserTitle;

  /// No description provided for @premiumTeaserBody.
  ///
  /// In sv, this message translates to:
  /// **'Obegränsad trädgård och inga annonser'**
  String get premiumTeaserBody;

  /// No description provided for @calendarTitle.
  ///
  /// In sv, this message translates to:
  /// **'Planteringskalender'**
  String get calendarTitle;

  /// No description provided for @calendarMonthGuide.
  ///
  /// In sv, this message translates to:
  /// **'Månadens guide'**
  String get calendarMonthGuide;

  /// No description provided for @calendarTaskCount.
  ///
  /// In sv, this message translates to:
  /// **'{count} uppgifter'**
  String calendarTaskCount(Object count);

  /// No description provided for @calendarPhasePresow.
  ///
  /// In sv, this message translates to:
  /// **'FÖRODLA INOMHUS'**
  String get calendarPhasePresow;

  /// No description provided for @calendarPhaseDirectsow.
  ///
  /// In sv, this message translates to:
  /// **'DIREKTSÅ UTE'**
  String get calendarPhaseDirectsow;

  /// No description provided for @calendarPhasePlantout.
  ///
  /// In sv, this message translates to:
  /// **'PLANTERA UT'**
  String get calendarPhasePlantout;

  /// No description provided for @calendarPhaseHarvest.
  ///
  /// In sv, this message translates to:
  /// **'SKÖRD'**
  String get calendarPhaseHarvest;

  /// No description provided for @calendarPhaseCount.
  ///
  /// In sv, this message translates to:
  /// **'{count} växter'**
  String calendarPhaseCount(Object count);

  /// No description provided for @calendarEmptyTitle.
  ///
  /// In sv, this message translates to:
  /// **'Inget att så eller skörda i {month}'**
  String calendarEmptyTitle(Object month);

  /// No description provided for @calendarEmptyBody.
  ///
  /// In sv, this message translates to:
  /// **'Använd månaden för planering — beställ frön, planera rabatter eller läs månadens guide.'**
  String get calendarEmptyBody;

  /// No description provided for @myGardenTitle.
  ///
  /// In sv, this message translates to:
  /// **'Mina växter'**
  String get myGardenTitle;

  /// No description provided for @myGardenSearchHint.
  ///
  /// In sv, this message translates to:
  /// **'Sök växt eller plats'**
  String get myGardenSearchHint;

  /// No description provided for @myGardenFilterAll.
  ///
  /// In sv, this message translates to:
  /// **'Alla'**
  String get myGardenFilterAll;

  /// No description provided for @myGardenGroupByStatus.
  ///
  /// In sv, this message translates to:
  /// **'Gruppera efter status'**
  String get myGardenGroupByStatus;

  /// No description provided for @myGardenGroupByLocation.
  ///
  /// In sv, this message translates to:
  /// **'Gruppera efter plats'**
  String get myGardenGroupByLocation;

  /// No description provided for @myGardenGroupByCategory.
  ///
  /// In sv, this message translates to:
  /// **'Gruppera efter kategori'**
  String get myGardenGroupByCategory;

  /// No description provided for @myGardenShowingCount.
  ///
  /// In sv, this message translates to:
  /// **'Visar {shown} av {total}'**
  String myGardenShowingCount(Object shown, Object total);

  /// No description provided for @myGardenEmptyTitle.
  ///
  /// In sv, this message translates to:
  /// **'Din trädgård är tom'**
  String get myGardenEmptyTitle;

  /// No description provided for @myGardenEmptyBody.
  ///
  /// In sv, this message translates to:
  /// **'Lägg till växter från databasen så börjar vi bygga din plantering.'**
  String get myGardenEmptyBody;

  /// No description provided for @myGardenEmptyCta.
  ///
  /// In sv, this message translates to:
  /// **'Bläddra i växtdatabasen'**
  String get myGardenEmptyCta;

  /// No description provided for @myGardenAddPlant.
  ///
  /// In sv, this message translates to:
  /// **'Lägg till växt'**
  String get myGardenAddPlant;

  /// No description provided for @myGardenNoResults.
  ///
  /// In sv, this message translates to:
  /// **'Inga växter matchar'**
  String get myGardenNoResults;

  /// No description provided for @myGardenNoResultsBody.
  ///
  /// In sv, this message translates to:
  /// **'Pröva en annan sökning eller rensa filtren.'**
  String get myGardenNoResultsBody;

  /// No description provided for @myGardenWateredNow.
  ///
  /// In sv, this message translates to:
  /// **'Vattnad nyss'**
  String get myGardenWateredNow;

  /// No description provided for @myGardenWateredToday.
  ///
  /// In sv, this message translates to:
  /// **'Vattnad idag'**
  String get myGardenWateredToday;

  /// No description provided for @myGardenWateredYesterday.
  ///
  /// In sv, this message translates to:
  /// **'Vattnad igår'**
  String get myGardenWateredYesterday;

  /// No description provided for @plantDatabaseTitle.
  ///
  /// In sv, this message translates to:
  /// **'Växtdatabas'**
  String get plantDatabaseTitle;

  /// No description provided for @plantDatabaseSearchHint.
  ///
  /// In sv, this message translates to:
  /// **'Sök växt'**
  String get plantDatabaseSearchHint;

  /// No description provided for @plantCategoryAll.
  ///
  /// In sv, this message translates to:
  /// **'Alla'**
  String get plantCategoryAll;

  /// No description provided for @addPlantNow.
  ///
  /// In sv, this message translates to:
  /// **'Lägg till i trädgården nu'**
  String get addPlantNow;

  /// No description provided for @addPlantNowBody.
  ///
  /// In sv, this message translates to:
  /// **'Du har sått eller planterat — vi följer den från idag'**
  String get addPlantNowBody;

  /// No description provided for @addPlantSeason.
  ///
  /// In sv, this message translates to:
  /// **'Lägg till i såningslistan'**
  String get addPlantSeason;

  /// No description provided for @addPlantSeasonBody.
  ///
  /// In sv, this message translates to:
  /// **'Du planerar att odla — vi pingar när det är dags att så'**
  String get addPlantSeasonBody;

  /// No description provided for @addPlantRemoveSeason.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort från såningslistan'**
  String get addPlantRemoveSeason;

  /// No description provided for @addPlantRemoveSeasonBody.
  ///
  /// In sv, this message translates to:
  /// **'Vi slutar påminna om sånings-fönstret'**
  String get addPlantRemoveSeasonBody;

  /// No description provided for @addedToGardenTitle.
  ///
  /// In sv, this message translates to:
  /// **'{plant} är i din trädgård'**
  String addedToGardenTitle(Object plant);

  /// No description provided for @addedToGardenBodyPlain.
  ///
  /// In sv, this message translates to:
  /// **'Vi följer den från idag och påminner om vatten och skörd.'**
  String get addedToGardenBodyPlain;

  /// No description provided for @addedToGardenBodyScheduled.
  ///
  /// In sv, this message translates to:
  /// **'Vi följer den från idag. Notiser inkommande för: {list}.'**
  String addedToGardenBodyScheduled(Object list);

  /// No description provided for @addedToGardenCta.
  ///
  /// In sv, this message translates to:
  /// **'Ta mig till min trädgård'**
  String get addedToGardenCta;

  /// No description provided for @phasePickerTitleNew.
  ///
  /// In sv, this message translates to:
  /// **'Var är du i processen?'**
  String get phasePickerTitleNew;

  /// No description provided for @phasePickerTitleEdit.
  ///
  /// In sv, this message translates to:
  /// **'Ändra status'**
  String get phasePickerTitleEdit;

  /// No description provided for @phaseShowSimple.
  ///
  /// In sv, this message translates to:
  /// **'Visa enklare alternativ'**
  String get phaseShowSimple;

  /// No description provided for @phaseShowMore.
  ///
  /// In sv, this message translates to:
  /// **'Fler alternativ (för den vana odlaren)'**
  String get phaseShowMore;

  /// No description provided for @phaseSimplePlanned.
  ///
  /// In sv, this message translates to:
  /// **'Planerar att odla'**
  String get phaseSimplePlanned;

  /// No description provided for @phaseSimplePlannedBody.
  ///
  /// In sv, this message translates to:
  /// **'Bara på listan — vi påminner när säsongen startar.'**
  String get phaseSimplePlannedBody;

  /// No description provided for @phaseSimpleGrowing.
  ///
  /// In sv, this message translates to:
  /// **'Växer just nu'**
  String get phaseSimpleGrowing;

  /// No description provided for @phaseSimpleGrowingBody.
  ///
  /// In sv, this message translates to:
  /// **'Plantorna är på gång. Vi följer dem fram till skörd.'**
  String get phaseSimpleGrowingBody;

  /// No description provided for @phaseSimpleHarvested.
  ///
  /// In sv, this message translates to:
  /// **'Färdigskördad'**
  String get phaseSimpleHarvested;

  /// No description provided for @phaseSimpleHarvestedBody.
  ///
  /// In sv, this message translates to:
  /// **'Säsongen är klar för den här plantan.'**
  String get phaseSimpleHarvestedBody;

  /// No description provided for @perennialEstablishedTitle.
  ///
  /// In sv, this message translates to:
  /// **'Sedan när har du den?'**
  String get perennialEstablishedTitle;

  /// No description provided for @perennialEstablishedBody.
  ///
  /// In sv, this message translates to:
  /// **'Behöver inte vara exakt – vi använder bara året.'**
  String get perennialEstablishedBody;

  /// No description provided for @perennialThisYear.
  ///
  /// In sv, this message translates to:
  /// **'I år ({year})'**
  String perennialThisYear(Object year);

  /// No description provided for @perennialLastYear.
  ///
  /// In sv, this message translates to:
  /// **'Förra året ({year})'**
  String perennialLastYear(Object year);

  /// No description provided for @perennialTwoYearsAgo.
  ///
  /// In sv, this message translates to:
  /// **'Två år sedan ({year})'**
  String perennialTwoYearsAgo(Object year);

  /// No description provided for @perennialEarlier.
  ///
  /// In sv, this message translates to:
  /// **'Tidigare (några år sedan)'**
  String get perennialEarlier;

  /// No description provided for @statusPlanning.
  ///
  /// In sv, this message translates to:
  /// **'Planerar'**
  String get statusPlanning;

  /// No description provided for @statusGrowingIndoors.
  ///
  /// In sv, this message translates to:
  /// **'Förodlar inomhus'**
  String get statusGrowingIndoors;

  /// No description provided for @statusDirectSown.
  ///
  /// In sv, this message translates to:
  /// **'Direktsådd ute'**
  String get statusDirectSown;

  /// No description provided for @statusHardening.
  ///
  /// In sv, this message translates to:
  /// **'Härdar av'**
  String get statusHardening;

  /// No description provided for @statusOutdoors.
  ///
  /// In sv, this message translates to:
  /// **'Står ute'**
  String get statusOutdoors;

  /// No description provided for @statusReadyToHarvest.
  ///
  /// In sv, this message translates to:
  /// **'Skördeklar'**
  String get statusReadyToHarvest;

  /// No description provided for @statusHarvested.
  ///
  /// In sv, this message translates to:
  /// **'Skördad'**
  String get statusHarvested;

  /// No description provided for @statusDormant.
  ///
  /// In sv, this message translates to:
  /// **'Vilande'**
  String get statusDormant;

  /// No description provided for @sowingIndoors.
  ///
  /// In sv, this message translates to:
  /// **'Inomhus'**
  String get sowingIndoors;

  /// No description provided for @sowingDirect.
  ///
  /// In sv, this message translates to:
  /// **'Direkt'**
  String get sowingDirect;

  /// No description provided for @sowingPlanta.
  ///
  /// In sv, this message translates to:
  /// **'Planta'**
  String get sowingPlanta;

  /// No description provided for @sunFull.
  ///
  /// In sv, this message translates to:
  /// **'Full sol'**
  String get sunFull;

  /// No description provided for @sunPartial.
  ///
  /// In sv, this message translates to:
  /// **'Halvskugga'**
  String get sunPartial;

  /// No description provided for @sunShade.
  ///
  /// In sv, this message translates to:
  /// **'Skugga'**
  String get sunShade;

  /// No description provided for @waterSparse.
  ///
  /// In sv, this message translates to:
  /// **'Sparsam'**
  String get waterSparse;

  /// No description provided for @waterRegular.
  ///
  /// In sv, this message translates to:
  /// **'Regelbunden'**
  String get waterRegular;

  /// No description provided for @waterAbundant.
  ///
  /// In sv, this message translates to:
  /// **'Riklig'**
  String get waterAbundant;

  /// No description provided for @fertilizerLow.
  ///
  /// In sv, this message translates to:
  /// **'Lågt'**
  String get fertilizerLow;

  /// No description provided for @fertilizerMedium.
  ///
  /// In sv, this message translates to:
  /// **'Medel'**
  String get fertilizerMedium;

  /// No description provided for @fertilizerHigh.
  ///
  /// In sv, this message translates to:
  /// **'Högt'**
  String get fertilizerHigh;

  /// No description provided for @lifecycleAnnual.
  ///
  /// In sv, this message translates to:
  /// **'Annuell'**
  String get lifecycleAnnual;

  /// No description provided for @lifecycleBiennial.
  ///
  /// In sv, this message translates to:
  /// **'Tvåårig'**
  String get lifecycleBiennial;

  /// No description provided for @lifecyclePerennial.
  ///
  /// In sv, this message translates to:
  /// **'Perenn'**
  String get lifecyclePerennial;

  /// No description provided for @lifecycleTree.
  ///
  /// In sv, this message translates to:
  /// **'Träd'**
  String get lifecycleTree;

  /// No description provided for @lifecycleShrub.
  ///
  /// In sv, this message translates to:
  /// **'Buske'**
  String get lifecycleShrub;

  /// No description provided for @categoryVegetables.
  ///
  /// In sv, this message translates to:
  /// **'Grönsaker'**
  String get categoryVegetables;

  /// No description provided for @categoryHerbs.
  ///
  /// In sv, this message translates to:
  /// **'Kryddor & örter'**
  String get categoryHerbs;

  /// No description provided for @categoryFlowers.
  ///
  /// In sv, this message translates to:
  /// **'Blommor'**
  String get categoryFlowers;

  /// No description provided for @categoryBerries.
  ///
  /// In sv, this message translates to:
  /// **'Bär'**
  String get categoryBerries;

  /// No description provided for @categoryFruitTrees.
  ///
  /// In sv, this message translates to:
  /// **'Fruktträd'**
  String get categoryFruitTrees;

  /// No description provided for @categoryOther.
  ///
  /// In sv, this message translates to:
  /// **'Övrigt'**
  String get categoryOther;

  /// No description provided for @wateredNow.
  ///
  /// In sv, this message translates to:
  /// **'Vattnad nu'**
  String get wateredNow;

  /// No description provided for @wateredConfirmation.
  ///
  /// In sv, this message translates to:
  /// **'Vattnad ✓'**
  String get wateredConfirmation;

  /// No description provided for @notWateredYet.
  ///
  /// In sv, this message translates to:
  /// **'Inte vattnad än'**
  String get notWateredYet;

  /// No description provided for @wateredJustNow.
  ///
  /// In sv, this message translates to:
  /// **'Nyss vattnad'**
  String get wateredJustNow;

  /// No description provided for @wateredDaysAgo.
  ///
  /// In sv, this message translates to:
  /// **'Vattnad för {days} dagar sedan'**
  String wateredDaysAgo(Object days);

  /// No description provided for @wateredWeeksAgo.
  ///
  /// In sv, this message translates to:
  /// **'Vattnad för {weeks} veckor sedan'**
  String wateredWeeksAgo(Object weeks);

  /// No description provided for @journalTitle.
  ///
  /// In sv, this message translates to:
  /// **'Dagbok'**
  String get journalTitle;

  /// No description provided for @journalCount.
  ///
  /// In sv, this message translates to:
  /// **'{count}'**
  String journalCount(Object count);

  /// No description provided for @journalAdd.
  ///
  /// In sv, this message translates to:
  /// **'Lägg till'**
  String get journalAdd;

  /// No description provided for @journalEmpty.
  ///
  /// In sv, this message translates to:
  /// **'Inga inlägg ännu — börja dokumentera tillväxten med foton och korta anteckningar.'**
  String get journalEmpty;

  /// No description provided for @journalNoteTitle.
  ///
  /// In sv, this message translates to:
  /// **'Anteckning'**
  String get journalNoteTitle;

  /// No description provided for @journalNoteBody.
  ///
  /// In sv, this message translates to:
  /// **'Vad hände idag? Bladlöss, första blomman, beskärning…'**
  String get journalNoteBody;

  /// No description provided for @journalNoteHint.
  ///
  /// In sv, this message translates to:
  /// **'Skriv en kort anteckning…'**
  String get journalNoteHint;

  /// No description provided for @journalSave.
  ///
  /// In sv, this message translates to:
  /// **'Spara'**
  String get journalSave;

  /// No description provided for @journalDeletePhoto.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort foto?'**
  String get journalDeletePhoto;

  /// No description provided for @journalDeletePhotoBody.
  ///
  /// In sv, this message translates to:
  /// **'Bilden raderas från enheten.'**
  String get journalDeletePhotoBody;

  /// No description provided for @journalDeleteNote.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort anteckning?'**
  String get journalDeleteNote;

  /// No description provided for @journalDeleteNoteBody.
  ///
  /// In sv, this message translates to:
  /// **'Anteckningen försvinner.'**
  String get journalDeleteNoteBody;

  /// No description provided for @journalManage.
  ///
  /// In sv, this message translates to:
  /// **'Hantera inlägg'**
  String get journalManage;

  /// No description provided for @actionTakePhoto.
  ///
  /// In sv, this message translates to:
  /// **'Ta foto'**
  String get actionTakePhoto;

  /// No description provided for @actionPickFromLibrary.
  ///
  /// In sv, this message translates to:
  /// **'Välj från bibliotek'**
  String get actionPickFromLibrary;

  /// No description provided for @actionWriteNote.
  ///
  /// In sv, this message translates to:
  /// **'Skriv anteckning'**
  String get actionWriteNote;

  /// No description provided for @harvestTitle.
  ///
  /// In sv, this message translates to:
  /// **'Skörd'**
  String get harvestTitle;

  /// No description provided for @harvestLog.
  ///
  /// In sv, this message translates to:
  /// **'Logga skörd'**
  String get harvestLog;

  /// No description provided for @harvestEmpty.
  ///
  /// In sv, this message translates to:
  /// **'Logga vad du skördar så bygger appen statistik år för år.'**
  String get harvestEmpty;

  /// No description provided for @harvestTotalLabel.
  ///
  /// In sv, this message translates to:
  /// **'Total: {amount} {unit}'**
  String harvestTotalLabel(Object amount, Object unit);

  /// No description provided for @harvestEstimatedSek.
  ///
  /// In sv, this message translates to:
  /// **'~{amount} kr'**
  String harvestEstimatedSek(Object amount);

  /// No description provided for @nextStepBecomeIndoor.
  ///
  /// In sv, this message translates to:
  /// **'Jag har förodlat inomhus'**
  String get nextStepBecomeIndoor;

  /// No description provided for @nextStepBecomeDirect.
  ///
  /// In sv, this message translates to:
  /// **'Jag har direktsått'**
  String get nextStepBecomeDirect;

  /// No description provided for @nextStepBecomePlanted.
  ///
  /// In sv, this message translates to:
  /// **'Jag har utplanterat'**
  String get nextStepBecomePlanted;

  /// No description provided for @nextStepHardenedToPlanted.
  ///
  /// In sv, this message translates to:
  /// **'Plantorna är utplanterade'**
  String get nextStepHardenedToPlanted;

  /// No description provided for @nextStepReadyForHarvest.
  ///
  /// In sv, this message translates to:
  /// **'Klar för skörd'**
  String get nextStepReadyForHarvest;

  /// No description provided for @nextStepHarvested.
  ///
  /// In sv, this message translates to:
  /// **'Skördad'**
  String get nextStepHarvested;

  /// No description provided for @secondaryChangeStatus.
  ///
  /// In sv, this message translates to:
  /// **'Ändra status'**
  String get secondaryChangeStatus;

  /// No description provided for @secondaryRemove.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort'**
  String get secondaryRemove;

  /// No description provided for @secondaryRemoveConfirmTitle.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort från trädgården?'**
  String get secondaryRemoveConfirmTitle;

  /// No description provided for @secondaryRemoveConfirmBody.
  ///
  /// In sv, this message translates to:
  /// **'{plant} och alla påminnelser tas bort. Detta kan inte ångras.'**
  String secondaryRemoveConfirmBody(Object plant);

  /// No description provided for @buttonCancel.
  ///
  /// In sv, this message translates to:
  /// **'Avbryt'**
  String get buttonCancel;

  /// No description provided for @buttonRemove.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort'**
  String get buttonRemove;

  /// No description provided for @buttonSave.
  ///
  /// In sv, this message translates to:
  /// **'Spara'**
  String get buttonSave;

  /// No description provided for @buttonNext.
  ///
  /// In sv, this message translates to:
  /// **'Nästa'**
  String get buttonNext;

  /// No description provided for @buttonStart.
  ///
  /// In sv, this message translates to:
  /// **'Sätt igång'**
  String get buttonStart;

  /// No description provided for @buttonSkip.
  ///
  /// In sv, this message translates to:
  /// **'Hoppa över'**
  String get buttonSkip;

  /// No description provided for @locationLabel.
  ///
  /// In sv, this message translates to:
  /// **'Plats'**
  String get locationLabel;

  /// No description provided for @locationAdd.
  ///
  /// In sv, this message translates to:
  /// **'Lägg till plats'**
  String get locationAdd;

  /// No description provided for @locationPickerTitle.
  ///
  /// In sv, this message translates to:
  /// **'Var står den?'**
  String get locationPickerTitle;

  /// No description provided for @locationPickerBody.
  ///
  /// In sv, this message translates to:
  /// **'T.ex. \"norra rabatten\", \"växthuset\", \"balkongen\".'**
  String get locationPickerBody;

  /// No description provided for @locationReuse.
  ///
  /// In sv, this message translates to:
  /// **'Använd igen'**
  String get locationReuse;

  /// No description provided for @settingsTitle.
  ///
  /// In sv, this message translates to:
  /// **'Inställningar'**
  String get settingsTitle;

  /// No description provided for @settingsPremiumActive.
  ///
  /// In sv, this message translates to:
  /// **'Premium aktivt'**
  String get settingsPremiumActive;

  /// No description provided for @settingsPremiumUpgrade.
  ///
  /// In sv, this message translates to:
  /// **'Uppgradera till Premium'**
  String get settingsPremiumUpgrade;

  /// No description provided for @settingsPremiumUnlock.
  ///
  /// In sv, this message translates to:
  /// **'Lås upp alla funktioner'**
  String get settingsPremiumUnlock;

  /// No description provided for @settingsMyGardens.
  ///
  /// In sv, this message translates to:
  /// **'Mina trädgårdar'**
  String get settingsMyGardens;

  /// No description provided for @settingsMyGardensSubtitle.
  ///
  /// In sv, this message translates to:
  /// **'Aktiv: {emoji} {name}'**
  String settingsMyGardensSubtitle(Object emoji, Object name);

  /// No description provided for @settingsMyGardensEmpty.
  ///
  /// In sv, this message translates to:
  /// **'Lägg till din första trädgård'**
  String get settingsMyGardensEmpty;

  /// No description provided for @settingsNotifications.
  ///
  /// In sv, this message translates to:
  /// **'Påminnelser'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsBody.
  ///
  /// In sv, this message translates to:
  /// **'Frostvarningar och planteringstider'**
  String get settingsNotificationsBody;

  /// No description provided for @settingsMorningHour.
  ///
  /// In sv, this message translates to:
  /// **'Morgon-tid för påminnelser'**
  String get settingsMorningHour;

  /// No description provided for @settingsMorningHourBody.
  ///
  /// In sv, this message translates to:
  /// **'Trädgårdsmorgon-pingar fyrar kl {hour}:00'**
  String settingsMorningHourBody(Object hour);

  /// No description provided for @settingsLargeText.
  ///
  /// In sv, this message translates to:
  /// **'Stor text'**
  String get settingsLargeText;

  /// No description provided for @settingsLargeTextBody.
  ///
  /// In sv, this message translates to:
  /// **'Lite större text i hela appen'**
  String get settingsLargeTextBody;

  /// No description provided for @settingsSimpleStatus.
  ///
  /// In sv, this message translates to:
  /// **'Enkel status'**
  String get settingsSimpleStatus;

  /// No description provided for @settingsSimpleStatusBody.
  ///
  /// In sv, this message translates to:
  /// **'Visa endast 3 huvudtillstånd (planerar / växer / skördad). Stäng av för fullständig livscykel.'**
  String get settingsSimpleStatusBody;

  /// No description provided for @settingsPestLibrary.
  ///
  /// In sv, this message translates to:
  /// **'Skadedjur & sjukdomar'**
  String get settingsPestLibrary;

  /// No description provided for @settingsPestLibraryBody.
  ///
  /// In sv, this message translates to:
  /// **'Bibliotek över vanliga problem'**
  String get settingsPestLibraryBody;

  /// No description provided for @settingsIntro.
  ///
  /// In sv, this message translates to:
  /// **'Visa introduktion'**
  String get settingsIntro;

  /// No description provided for @settingsIntroBody.
  ///
  /// In sv, this message translates to:
  /// **'Snabbgenomgång av Pluss-knappen, säsongsplaneraren och hur appen jobbar'**
  String get settingsIntroBody;

  /// No description provided for @settingsBackup.
  ///
  /// In sv, this message translates to:
  /// **'Säkerhetskopia'**
  String get settingsBackup;

  /// No description provided for @settingsBackupBody.
  ///
  /// In sv, this message translates to:
  /// **'Exportera trädgården och skörden – spara på iCloud Drive eller mejla till dig själv'**
  String get settingsBackupBody;

  /// No description provided for @settingsRestorePurchases.
  ///
  /// In sv, this message translates to:
  /// **'Återställ köp'**
  String get settingsRestorePurchases;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In sv, this message translates to:
  /// **'Integritetspolicy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTerms.
  ///
  /// In sv, this message translates to:
  /// **'Användarvillkor (EULA)'**
  String get settingsTerms;

  /// No description provided for @settingsSupport.
  ///
  /// In sv, this message translates to:
  /// **'Support'**
  String get settingsSupport;

  /// No description provided for @settingsFeedback.
  ///
  /// In sv, this message translates to:
  /// **'Skicka feedback'**
  String get settingsFeedback;

  /// No description provided for @settingsFeedbackBody.
  ///
  /// In sv, this message translates to:
  /// **'Buggar, funktionsönskemål eller bara ett vänligt hej'**
  String get settingsFeedbackBody;

  /// No description provided for @gardensTitle.
  ///
  /// In sv, this message translates to:
  /// **'Mina trädgårdar'**
  String get gardensTitle;

  /// No description provided for @gardensActive.
  ///
  /// In sv, this message translates to:
  /// **'AKTIV'**
  String get gardensActive;

  /// No description provided for @gardensAddNew.
  ///
  /// In sv, this message translates to:
  /// **'Lägg till ny trädgård'**
  String get gardensAddNew;

  /// No description provided for @gardensEdit.
  ///
  /// In sv, this message translates to:
  /// **'Redigera'**
  String get gardensEdit;

  /// No description provided for @gardensNoLocation.
  ///
  /// In sv, this message translates to:
  /// **'Ingen plats'**
  String get gardensNoLocation;

  /// No description provided for @gardensPlantCount.
  ///
  /// In sv, this message translates to:
  /// **'{count, plural, =1{1 växt} other{{count} växter}}'**
  String gardensPlantCount(num count);

  /// No description provided for @gardensSwitcherTitle.
  ///
  /// In sv, this message translates to:
  /// **'Byt trädgård'**
  String get gardensSwitcherTitle;

  /// No description provided for @gardensManage.
  ///
  /// In sv, this message translates to:
  /// **'Hantera trädgårdar'**
  String get gardensManage;

  /// No description provided for @gardensZoneLine.
  ///
  /// In sv, this message translates to:
  /// **'Zon {zone}'**
  String gardensZoneLine(Object zone);

  /// No description provided for @gardensNewTitle.
  ///
  /// In sv, this message translates to:
  /// **'Ny trädgård'**
  String get gardensNewTitle;

  /// No description provided for @gardensEditTitle.
  ///
  /// In sv, this message translates to:
  /// **'Redigera {name}'**
  String gardensEditTitle(Object name);

  /// No description provided for @gardensNamePlaceholder.
  ///
  /// In sv, this message translates to:
  /// **'Kolonilotten, Balkongen, Sommarstället…'**
  String get gardensNamePlaceholder;

  /// No description provided for @gardensCityLabel.
  ///
  /// In sv, this message translates to:
  /// **'Stad / närmsta ort'**
  String get gardensCityLabel;

  /// No description provided for @gardensCreateButton.
  ///
  /// In sv, this message translates to:
  /// **'Skapa trädgård'**
  String get gardensCreateButton;

  /// No description provided for @gardensSaveButton.
  ///
  /// In sv, this message translates to:
  /// **'Spara'**
  String get gardensSaveButton;

  /// No description provided for @gardensFooterHint.
  ///
  /// In sv, this message translates to:
  /// **'Varje trädgård har egen zon, växtlista och väder. Byt aktiv trädgård genom att trycka på den i listan – allt anpassas direkt.'**
  String get gardensFooterHint;

  /// No description provided for @gardensDeleteTitle.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort {name}?'**
  String gardensDeleteTitle(Object name);

  /// No description provided for @gardensDeletePlainBody.
  ///
  /// In sv, this message translates to:
  /// **'Trädgården tas bort.'**
  String get gardensDeletePlainBody;

  /// No description provided for @gardensDeleteWithPlantsBody.
  ///
  /// In sv, this message translates to:
  /// **'{count, plural, =1{1 växt} other{{count} växter}} flyttas till din standard-trädgård. Trädgården tas bort.'**
  String gardensDeleteWithPlantsBody(num count);

  /// No description provided for @introPage1Title.
  ///
  /// In sv, this message translates to:
  /// **'Lägg till växter du odlar'**
  String get introPage1Title;

  /// No description provided for @introPage1Body.
  ///
  /// In sv, this message translates to:
  /// **'Tryck + på en växt för att lägga till den i din trädgård. Vi följer den från sådd till skörd och påminner när det är dags att vattna, beskära eller plantera om.'**
  String get introPage1Body;

  /// No description provided for @introPage1Hint.
  ///
  /// In sv, this message translates to:
  /// **'Hittar du växten? Använd \"Växter\"-fliken i botten.'**
  String get introPage1Hint;

  /// No description provided for @introPage2Title.
  ///
  /// In sv, this message translates to:
  /// **'Planera årets säsong'**
  String get introPage2Title;

  /// No description provided for @introPage2Body.
  ///
  /// In sv, this message translates to:
  /// **'Tryck på bokmärket för att lägga växten på din säsongs-lista. Du får en notis i februari/mars när det är dags att börja förodla, och i april när det är dags att direktså.'**
  String get introPage2Body;

  /// No description provided for @introPage2Hint.
  ///
  /// In sv, this message translates to:
  /// **'Säsongs-listan ser du på startsidan.'**
  String get introPage2Hint;

  /// No description provided for @introPage3Title.
  ///
  /// In sv, this message translates to:
  /// **'Stenkoll på din trädgård'**
  String get introPage3Title;

  /// No description provided for @introPage3Body.
  ///
  /// In sv, this message translates to:
  /// **'Hem-sidan visar väder, torrperioder och vad du ska göra denna månad. På \"Min trädgård\"-fliken kan du se årets statistik, växtföljd och uppskattat värde av din skörd.'**
  String get introPage3Body;

  /// No description provided for @introPage3Hint.
  ///
  /// In sv, this message translates to:
  /// **'Skadedjur & sjukdomar finns i Inställningar när du behöver dem.'**
  String get introPage3Hint;

  /// No description provided for @pestLibraryTitle.
  ///
  /// In sv, this message translates to:
  /// **'Skadedjur & sjukdomar'**
  String get pestLibraryTitle;

  /// No description provided for @pestLibrarySearchHint.
  ///
  /// In sv, this message translates to:
  /// **'Sök efter symptom eller växt'**
  String get pestLibrarySearchHint;

  /// No description provided for @pestLibraryFilterPests.
  ///
  /// In sv, this message translates to:
  /// **'Skadedjur'**
  String get pestLibraryFilterPests;

  /// No description provided for @pestLibraryFilterDiseases.
  ///
  /// In sv, this message translates to:
  /// **'Sjukdomar'**
  String get pestLibraryFilterDiseases;

  /// No description provided for @pestLibraryFilterDamage.
  ///
  /// In sv, this message translates to:
  /// **'Skada'**
  String get pestLibraryFilterDamage;

  /// No description provided for @pestLibraryNoMatch.
  ///
  /// In sv, this message translates to:
  /// **'Inget matchade. Prova med ett symptom som \"fläckar\" eller \"hål\".'**
  String get pestLibraryNoMatch;

  /// No description provided for @pestSectionMild.
  ///
  /// In sv, this message translates to:
  /// **'Mild åtgärd'**
  String get pestSectionMild;

  /// No description provided for @pestSectionStrong.
  ///
  /// In sv, this message translates to:
  /// **'Effektiv åtgärd'**
  String get pestSectionStrong;

  /// No description provided for @pestSectionPrevent.
  ///
  /// In sv, this message translates to:
  /// **'Förebygg'**
  String get pestSectionPrevent;

  /// No description provided for @pestAffects.
  ///
  /// In sv, this message translates to:
  /// **'Drabbar'**
  String get pestAffects;

  /// No description provided for @statsTitle.
  ///
  /// In sv, this message translates to:
  /// **'Min trädgård {year}'**
  String statsTitle(Object year);

  /// No description provided for @statsHero1.
  ///
  /// In sv, this message translates to:
  /// **'Du har odlat fram ungefär {sek} kr i mat'**
  String statsHero1(Object sek);

  /// No description provided for @statsHero2.
  ///
  /// In sv, this message translates to:
  /// **'Du har {count} växter på gång'**
  String statsHero2(Object count);

  /// No description provided for @statsHeroEmpty.
  ///
  /// In sv, this message translates to:
  /// **'Säsongen väntar'**
  String get statsHeroEmpty;

  /// No description provided for @statsTilePlants.
  ///
  /// In sv, this message translates to:
  /// **'Växter'**
  String get statsTilePlants;

  /// No description provided for @statsTileSpecies.
  ///
  /// In sv, this message translates to:
  /// **'Olika arter'**
  String get statsTileSpecies;

  /// No description provided for @statsTileHarvested.
  ///
  /// In sv, this message translates to:
  /// **'Skördade'**
  String get statsTileHarvested;

  /// No description provided for @statsHarvestPanelTitle.
  ///
  /// In sv, this message translates to:
  /// **'Skörd hittills i år'**
  String get statsHarvestPanelTitle;

  /// No description provided for @statsValueLine.
  ///
  /// In sv, this message translates to:
  /// **'Estimerat värde: ~{sek} kr'**
  String statsValueLine(Object sek);

  /// No description provided for @statsValueDisclaimer.
  ///
  /// In sv, this message translates to:
  /// **'Baserat på ungefärliga svenska butikspriser per kategori. Inkluderar inte arbetstid eller frökostnader.'**
  String get statsValueDisclaimer;

  /// No description provided for @statsTopPanelTitle.
  ///
  /// In sv, this message translates to:
  /// **'Årets bästa avkastning'**
  String get statsTopPanelTitle;

  /// No description provided for @statsLocationPanelTitle.
  ///
  /// In sv, this message translates to:
  /// **'Var i trädgården'**
  String get statsLocationPanelTitle;

  /// No description provided for @statsRotationPanelTitle.
  ///
  /// In sv, this message translates to:
  /// **'Växtföljd'**
  String get statsRotationPanelTitle;

  /// No description provided for @statsRotationBody.
  ///
  /// In sv, this message translates to:
  /// **'Vad som odlats var, per år. Repetitioner markeras.'**
  String get statsRotationBody;

  /// No description provided for @statsReflectionTitle.
  ///
  /// In sv, this message translates to:
  /// **'Reflektion'**
  String get statsReflectionTitle;

  /// No description provided for @statsEmptyTitle.
  ///
  /// In sv, this message translates to:
  /// **'Säsongen har inte startat än'**
  String get statsEmptyTitle;

  /// No description provided for @statsEmptyBody.
  ///
  /// In sv, this message translates to:
  /// **'Lägg till växter och registrera skördar – så fyller vi den här sidan med årets resultat.'**
  String get statsEmptyBody;

  /// No description provided for @tabTodo.
  ///
  /// In sv, this message translates to:
  /// **'Att göra'**
  String get tabTodo;

  /// No description provided for @todoSectionToday.
  ///
  /// In sv, this message translates to:
  /// **'IDAG'**
  String get todoSectionToday;

  /// No description provided for @todoSectionWeek.
  ///
  /// In sv, this message translates to:
  /// **'DENNA VECKA'**
  String get todoSectionWeek;

  /// No description provided for @todoSectionMonth.
  ///
  /// In sv, this message translates to:
  /// **'DENNA MÅNAD'**
  String get todoSectionMonth;

  /// No description provided for @todoSectionDoneToday.
  ///
  /// In sv, this message translates to:
  /// **'KLART IDAG ✓'**
  String get todoSectionDoneToday;

  /// No description provided for @todoStatToday.
  ///
  /// In sv, this message translates to:
  /// **'idag'**
  String get todoStatToday;

  /// No description provided for @todoStatWeek.
  ///
  /// In sv, this message translates to:
  /// **'denna vecka'**
  String get todoStatWeek;

  /// No description provided for @todoStatDone.
  ///
  /// In sv, this message translates to:
  /// **'klart'**
  String get todoStatDone;

  /// No description provided for @todoEmptyTitle.
  ///
  /// In sv, this message translates to:
  /// **'Allt under kontroll'**
  String get todoEmptyTitle;

  /// No description provided for @todoEmptyBody.
  ///
  /// In sv, this message translates to:
  /// **'Inget akut just nu. Lägg till växter i din trädgård för att börja få dagliga uppgifter.'**
  String get todoEmptyBody;

  /// No description provided for @todoSwipeDone.
  ///
  /// In sv, this message translates to:
  /// **'Klar'**
  String get todoSwipeDone;

  /// No description provided for @todoSwipeSnooze.
  ///
  /// In sv, this message translates to:
  /// **'Skjut upp'**
  String get todoSwipeSnooze;

  /// No description provided for @progressReadyToHarvest.
  ///
  /// In sv, this message translates to:
  /// **'Redo att skördas'**
  String get progressReadyToHarvest;

  /// No description provided for @progressHarvestNow.
  ///
  /// In sv, this message translates to:
  /// **'Skörda nu'**
  String get progressHarvestNow;

  /// No description provided for @progressDaysLeft.
  ///
  /// In sv, this message translates to:
  /// **'{days} dagar kvar'**
  String progressDaysLeft(Object days);

  /// No description provided for @progressApproxDaysLeft.
  ///
  /// In sv, this message translates to:
  /// **'~{days} dagar kvar'**
  String progressApproxDaysLeft(Object days);

  /// No description provided for @climateCardTitle.
  ///
  /// In sv, this message translates to:
  /// **'Klimat senaste 14 dagar'**
  String get climateCardTitle;

  /// No description provided for @climateStatAvg.
  ///
  /// In sv, this message translates to:
  /// **'Medeldygn'**
  String get climateStatAvg;

  /// No description provided for @climateStatMinMax.
  ///
  /// In sv, this message translates to:
  /// **'Min/max'**
  String get climateStatMinMax;

  /// No description provided for @climateStatGdd.
  ///
  /// In sv, this message translates to:
  /// **'GDD'**
  String get climateStatGdd;

  /// No description provided for @climateInterpretWaking.
  ///
  /// In sv, this message translates to:
  /// **'Trädgården vaknar.'**
  String get climateInterpretWaking;

  /// No description provided for @climateInterpretEarly.
  ///
  /// In sv, this message translates to:
  /// **'Mycket tidig säsong – bara köldtåligt växer (lök, ärtor, sallad).'**
  String get climateInterpretEarly;

  /// No description provided for @climateInterpretSpring.
  ///
  /// In sv, this message translates to:
  /// **'Vårsäsong – direktsådd grönsaker etablerar sig, värmekänsliga ska vänta.'**
  String get climateInterpretSpring;

  /// No description provided for @climateInterpretMidSpring.
  ///
  /// In sv, this message translates to:
  /// **'Mid-vår – tomat och paprika kan ut med fiberduk eller i växthus.'**
  String get climateInterpretMidSpring;

  /// No description provided for @climateInterpretFullGrowth.
  ///
  /// In sv, this message translates to:
  /// **'Fullt växttryck – allt mognar snabbt, vattna och gödsla.'**
  String get climateInterpretFullGrowth;

  /// No description provided for @climateInterpretHot.
  ///
  /// In sv, this message translates to:
  /// **'Het period – var noga med vatten på unga plantor.'**
  String get climateInterpretHot;

  /// No description provided for @climateTeaserTitle.
  ///
  /// In sv, this message translates to:
  /// **'Klimatkort (Premium)'**
  String get climateTeaserTitle;

  /// No description provided for @climateTeaserBody.
  ///
  /// In sv, this message translates to:
  /// **'Medel-dygnstemp + Growing Degree Days för bättre tajming av sådd och skörd.'**
  String get climateTeaserBody;

  /// No description provided for @weatherSetLocationHint.
  ///
  /// In sv, this message translates to:
  /// **'Ange plats i inställningarna'**
  String get weatherSetLocationHint;

  /// No description provided for @weatherFrostWarning.
  ///
  /// In sv, this message translates to:
  /// **'Frostvarning {date} – {temp}°C'**
  String weatherFrostWarning(String date, String temp);

  /// No description provided for @dryPeriodBodyWithThirsty.
  ///
  /// In sv, this message translates to:
  /// **'Bara {past} mm regn senaste 14 dagarna och {next} mm väntas kommande veckan. Vattna {names}{more} — torrkänsliga växter klarar sig längre.'**
  String dryPeriodBodyWithThirsty(
    String past,
    String next,
    String names,
    String more,
  );

  /// No description provided for @dryPeriodBodyGeneral.
  ///
  /// In sv, this message translates to:
  /// **'Bara {past} mm regn senaste 14 dagarna och {next} mm väntas kommande veckan. Vattna noga, särskilt nyplanterade och i krukor.'**
  String dryPeriodBodyGeneral(String past, String next);

  /// No description provided for @dryPeriodMoreSuffix.
  ///
  /// In sv, this message translates to:
  /// **' m.fl.'**
  String get dryPeriodMoreSuffix;

  /// No description provided for @myGardenWaterAllTooltip.
  ///
  /// In sv, this message translates to:
  /// **'Vattna alla utomhus-växter'**
  String get myGardenWaterAllTooltip;

  /// No description provided for @myGardenSeasonStatsTooltip.
  ///
  /// In sv, this message translates to:
  /// **'Min säsong {year}'**
  String myGardenSeasonStatsTooltip(String year);

  /// No description provided for @myGardenGroupTooltip.
  ///
  /// In sv, this message translates to:
  /// **'Gruppera efter'**
  String get myGardenGroupTooltip;

  /// No description provided for @myGardenNoOutdoorPlants.
  ///
  /// In sv, this message translates to:
  /// **'Inga utomhus-växter att vattna just nu.'**
  String get myGardenNoOutdoorPlants;

  /// No description provided for @myGardenWaterAllTitle.
  ///
  /// In sv, this message translates to:
  /// **'Vattna alla?'**
  String get myGardenWaterAllTitle;

  /// No description provided for @myGardenWaterAllConfirm.
  ///
  /// In sv, this message translates to:
  /// **'Markerar {count} utomhus-växter som vattnade just nu.'**
  String myGardenWaterAllConfirm(String count);

  /// No description provided for @myGardenWaterAllCancel.
  ///
  /// In sv, this message translates to:
  /// **'Avbryt'**
  String get myGardenWaterAllCancel;

  /// No description provided for @myGardenWaterAllAction.
  ///
  /// In sv, this message translates to:
  /// **'Vattna alla'**
  String get myGardenWaterAllAction;

  /// No description provided for @myGardenWaterAllDone.
  ///
  /// In sv, this message translates to:
  /// **'{count} växter vattnade ✓'**
  String myGardenWaterAllDone(String count);

  /// No description provided for @myGardenLocationNone.
  ///
  /// In sv, this message translates to:
  /// **'Utan plats'**
  String get myGardenLocationNone;

  /// No description provided for @myGardenCategoryOther.
  ///
  /// In sv, this message translates to:
  /// **'Övrigt'**
  String get myGardenCategoryOther;

  /// No description provided for @myGardenStatusSince.
  ///
  /// In sv, this message translates to:
  /// **'{status} • sedan {year}'**
  String myGardenStatusSince(String status, String year);

  /// No description provided for @myGardenStatusOnDate.
  ///
  /// In sv, this message translates to:
  /// **'{status} • {date}'**
  String myGardenStatusOnDate(String status, String date);

  /// No description provided for @settingsMyGardensWithCount.
  ///
  /// In sv, this message translates to:
  /// **'Mina trädgårdar ({count})'**
  String settingsMyGardensWithCount(String count);

  /// No description provided for @settingsPlanMonthly.
  ///
  /// In sv, this message translates to:
  /// **'Månadsprenumeration'**
  String get settingsPlanMonthly;

  /// No description provided for @settingsPlanYearly.
  ///
  /// In sv, this message translates to:
  /// **'Årsprenumeration'**
  String get settingsPlanYearly;

  /// No description provided for @settingsPlanLifetime.
  ///
  /// In sv, this message translates to:
  /// **'Livstidsköp'**
  String get settingsPlanLifetime;

  /// No description provided for @settingsPlanFree.
  ///
  /// In sv, this message translates to:
  /// **'Gratis'**
  String get settingsPlanFree;

  /// No description provided for @settingsStarterKit.
  ///
  /// In sv, this message translates to:
  /// **'🛒 Nybörjarkit'**
  String get settingsStarterKit;

  /// No description provided for @settingsMorningHourPickerTitle.
  ///
  /// In sv, this message translates to:
  /// **'När vill du få morgon-pingen?'**
  String get settingsMorningHourPickerTitle;

  /// No description provided for @settingsMorningHourPickerBody.
  ///
  /// In sv, this message translates to:
  /// **'Trädgårdsmorgon-summeringen och alla planteringstider fyrar denna timme. Ingenting väcker dig innan.'**
  String get settingsMorningHourPickerBody;

  /// No description provided for @settingsHourFormat.
  ///
  /// In sv, this message translates to:
  /// **'Kl {hour}:00'**
  String settingsHourFormat(String hour);

  /// No description provided for @settingsBackupFailed.
  ///
  /// In sv, this message translates to:
  /// **'Kunde inte skapa backup: {error}'**
  String settingsBackupFailed(String error);

  /// No description provided for @settingsFeedbackSubject.
  ///
  /// In sv, this message translates to:
  /// **'Plantera feedback'**
  String get settingsFeedbackSubject;

  /// No description provided for @settingsFeedbackBodyTemplate.
  ///
  /// In sv, this message translates to:
  /// **'Hej!\n\nFeedback / fråga / buggrapport:\n\n\n— Skickat från Plantera {version}'**
  String settingsFeedbackBodyTemplate(String version);

  /// No description provided for @gardensDelete.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort'**
  String get gardensDelete;

  /// No description provided for @gardensCancel.
  ///
  /// In sv, this message translates to:
  /// **'Avbryt'**
  String get gardensCancel;

  /// No description provided for @gardensNameLabel.
  ///
  /// In sv, this message translates to:
  /// **'Namn'**
  String get gardensNameLabel;

  /// No description provided for @gardensZoneDescription.
  ///
  /// In sv, this message translates to:
  /// **'Zon {zone} – {description}'**
  String gardensZoneDescription(String zone, String description);

  /// No description provided for @gardensCityFormat.
  ///
  /// In sv, this message translates to:
  /// **'{city} · {zone}'**
  String gardensCityFormat(String city, String zone);

  /// No description provided for @introSkip.
  ///
  /// In sv, this message translates to:
  /// **'Hoppa över'**
  String get introSkip;

  /// No description provided for @introNext.
  ///
  /// In sv, this message translates to:
  /// **'Nästa'**
  String get introNext;

  /// No description provided for @introStart.
  ///
  /// In sv, this message translates to:
  /// **'Sätt igång'**
  String get introStart;

  /// No description provided for @onboardingWelcome.
  ///
  /// In sv, this message translates to:
  /// **'Välkommen till Plantera'**
  String get onboardingWelcome;

  /// No description provided for @onboardingBody.
  ///
  /// In sv, this message translates to:
  /// **'Välj din plats för personliga råd, frostvarningar och rätt såtider för just din odlingszon.'**
  String get onboardingBody;

  /// No description provided for @onboardingUseGps.
  ///
  /// In sv, this message translates to:
  /// **'Använd min plats'**
  String get onboardingUseGps;

  /// No description provided for @onboardingLocating.
  ///
  /// In sv, this message translates to:
  /// **'Hämtar plats…'**
  String get onboardingLocating;

  /// No description provided for @onboardingOrPickCity.
  ///
  /// In sv, this message translates to:
  /// **'eller välj stad'**
  String get onboardingOrPickCity;

  /// No description provided for @onboardingZoneSubtitle.
  ///
  /// In sv, this message translates to:
  /// **'Zon {zone}'**
  String onboardingZoneSubtitle(String zone);

  /// No description provided for @onboardingErrorLocationServicesOff.
  ///
  /// In sv, this message translates to:
  /// **'Platstjänster är avstängda'**
  String get onboardingErrorLocationServicesOff;

  /// No description provided for @onboardingErrorLocationDenied.
  ///
  /// In sv, this message translates to:
  /// **'Platsbehörighet nekad'**
  String get onboardingErrorLocationDenied;

  /// No description provided for @phasePerennialHaveIt.
  ///
  /// In sv, this message translates to:
  /// **'Jag har den i trädgården'**
  String get phasePerennialHaveIt;

  /// No description provided for @phasePerennialHaveItBody.
  ///
  /// In sv, this message translates to:
  /// **'Vi visar förväntad skörd och påminner om beskärning, gödning och annan säsongs-omsorg.'**
  String get phasePerennialHaveItBody;

  /// No description provided for @phasePerennialPlanning.
  ///
  /// In sv, this message translates to:
  /// **'Planerar att plantera'**
  String get phasePerennialPlanning;

  /// No description provided for @phasePerennialPlanningBody.
  ///
  /// In sv, this message translates to:
  /// **'Bara på listan tills du faktiskt planterar — påminnelser kommer i god tid.'**
  String get phasePerennialPlanningBody;

  /// No description provided for @phaseDetailedPlanned.
  ///
  /// In sv, this message translates to:
  /// **'Planerar att odla'**
  String get phaseDetailedPlanned;

  /// No description provided for @phaseDetailedPlannedBody.
  ///
  /// In sv, this message translates to:
  /// **'Bara för listan — påminnelser kommer i god tid när säsongen startar.'**
  String get phaseDetailedPlannedBody;

  /// No description provided for @phaseDetailedPresow.
  ///
  /// In sv, this message translates to:
  /// **'Jag förodlar inomhus'**
  String get phaseDetailedPresow;

  /// No description provided for @phaseDetailedPresowBody.
  ///
  /// In sv, this message translates to:
  /// **'Plantorna växer inomhus. Få härda av-påminnelse om 5 veckor.'**
  String get phaseDetailedPresowBody;

  /// No description provided for @phaseDetailedDirectsow.
  ///
  /// In sv, this message translates to:
  /// **'Jag har direktsått ute'**
  String get phaseDetailedDirectsow;

  /// No description provided for @phaseDetailedDirectsowBody.
  ///
  /// In sv, this message translates to:
  /// **'Sått direkt på växtplats. Skördepåminnelse återstår.'**
  String get phaseDetailedDirectsowBody;

  /// No description provided for @phaseDetailedPlantout.
  ///
  /// In sv, this message translates to:
  /// **'Plantorna är utplanterade'**
  String get phaseDetailedPlantout;

  /// No description provided for @phaseDetailedPlantoutBody.
  ///
  /// In sv, this message translates to:
  /// **'Står på sin slutliga växtplats. Skördepåminnelse återstår.'**
  String get phaseDetailedPlantoutBody;

  /// No description provided for @phaseFinishedReady.
  ///
  /// In sv, this message translates to:
  /// **'Klar för skörd'**
  String get phaseFinishedReady;

  /// No description provided for @phaseFinishedReadyBody.
  ///
  /// In sv, this message translates to:
  /// **'Markeras som skördeklar nu.'**
  String get phaseFinishedReadyBody;

  /// No description provided for @phaseFinishedHarvested.
  ///
  /// In sv, this message translates to:
  /// **'Skördad'**
  String get phaseFinishedHarvested;

  /// No description provided for @phaseFinishedHarvestedBody.
  ///
  /// In sv, this message translates to:
  /// **'Säsongen är klar — påminnelser pausas.'**
  String get phaseFinishedHarvestedBody;

  /// No description provided for @phaseFinishedDormant.
  ///
  /// In sv, this message translates to:
  /// **'Vilande'**
  String get phaseFinishedDormant;

  /// No description provided for @phaseFinishedDormantBody.
  ///
  /// In sv, this message translates to:
  /// **'Plantan är inte aktiv just nu.'**
  String get phaseFinishedDormantBody;

  /// No description provided for @phaseDateHelpPresow.
  ///
  /// In sv, this message translates to:
  /// **'Vilket datum började du odla denna planta?'**
  String get phaseDateHelpPresow;

  /// No description provided for @phaseDateHelpDirectsow.
  ///
  /// In sv, this message translates to:
  /// **'Vilket datum direktsådde du?'**
  String get phaseDateHelpDirectsow;

  /// No description provided for @phaseDateHelpPlantout.
  ///
  /// In sv, this message translates to:
  /// **'Vilket datum kom plantorna ut?'**
  String get phaseDateHelpPlantout;

  /// No description provided for @phaseDateHelpDefault.
  ///
  /// In sv, this message translates to:
  /// **'Datum'**
  String get phaseDateHelpDefault;

  /// No description provided for @phasePerennialYearTitle.
  ///
  /// In sv, this message translates to:
  /// **'Sedan när har du den?'**
  String get phasePerennialYearTitle;

  /// No description provided for @phasePerennialYearBody.
  ///
  /// In sv, this message translates to:
  /// **'Behöver inte vara exakt – vi använder bara året.'**
  String get phasePerennialYearBody;

  /// No description provided for @phasePerennialYearThis.
  ///
  /// In sv, this message translates to:
  /// **'I år ({year})'**
  String phasePerennialYearThis(String year);

  /// No description provided for @phasePerennialYearLast.
  ///
  /// In sv, this message translates to:
  /// **'Förra året ({year})'**
  String phasePerennialYearLast(String year);

  /// No description provided for @phasePerennialYearTwo.
  ///
  /// In sv, this message translates to:
  /// **'Två år sedan ({year})'**
  String phasePerennialYearTwo(String year);

  /// No description provided for @phasePerennialYearOlder.
  ///
  /// In sv, this message translates to:
  /// **'Tidigare (några år sedan)'**
  String get phasePerennialYearOlder;

  /// No description provided for @plantDetailTabOverview.
  ///
  /// In sv, this message translates to:
  /// **'Översikt'**
  String get plantDetailTabOverview;

  /// No description provided for @plantDetailTabMyPlant.
  ///
  /// In sv, this message translates to:
  /// **'Min planta'**
  String get plantDetailTabMyPlant;

  /// No description provided for @plantDetailTabCare.
  ///
  /// In sv, this message translates to:
  /// **'Omsorg'**
  String get plantDetailTabCare;

  /// No description provided for @plantDetailAddCta.
  ///
  /// In sv, this message translates to:
  /// **'Lägg till i min trädgård'**
  String get plantDetailAddCta;

  /// No description provided for @plantDetailRemoveCta.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort från trädgården'**
  String get plantDetailRemoveCta;

  /// No description provided for @plantDetailRemoveTitle.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort från trädgården?'**
  String get plantDetailRemoveTitle;

  /// No description provided for @plantDetailRemoveBody.
  ///
  /// In sv, this message translates to:
  /// **'Detta kan inte ångras.'**
  String get plantDetailRemoveBody;

  /// No description provided for @plantDetailCancel.
  ///
  /// In sv, this message translates to:
  /// **'Avbryt'**
  String get plantDetailCancel;

  /// No description provided for @plantDetailDelete.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort'**
  String get plantDetailDelete;

  /// No description provided for @plantDetailSave.
  ///
  /// In sv, this message translates to:
  /// **'Spara'**
  String get plantDetailSave;

  /// No description provided for @plantDetailReset.
  ///
  /// In sv, this message translates to:
  /// **'Återställ'**
  String get plantDetailReset;

  /// No description provided for @plantDetailReuse.
  ///
  /// In sv, this message translates to:
  /// **'Använd igen'**
  String get plantDetailReuse;

  /// No description provided for @plantDetailWaterNowSuffix.
  ///
  /// In sv, this message translates to:
  /// **'Vattnad nu'**
  String get plantDetailWaterNowSuffix;

  /// No description provided for @plantDetailWaterTapHint.
  ///
  /// In sv, this message translates to:
  /// **'Tryck när du vattnar för att hålla koll'**
  String get plantDetailWaterTapHint;

  /// No description provided for @plantDetailWaterDoneSnack.
  ///
  /// In sv, this message translates to:
  /// **'Vattnad ✓'**
  String get plantDetailWaterDoneSnack;

  /// No description provided for @plantDetailWaterNotYet.
  ///
  /// In sv, this message translates to:
  /// **'Inte vattnad än'**
  String get plantDetailWaterNotYet;

  /// No description provided for @plantDetailWaterJust.
  ///
  /// In sv, this message translates to:
  /// **'Nyss vattnad'**
  String get plantDetailWaterJust;

  /// No description provided for @plantDetailWaterToday.
  ///
  /// In sv, this message translates to:
  /// **'Vattnad idag'**
  String get plantDetailWaterToday;

  /// No description provided for @plantDetailWaterYesterday.
  ///
  /// In sv, this message translates to:
  /// **'Vattnad igår'**
  String get plantDetailWaterYesterday;

  /// No description provided for @plantDetailUpcomingCareTitle.
  ///
  /// In sv, this message translates to:
  /// **'📅  KOMMANDE OMSORG'**
  String get plantDetailUpcomingCareTitle;

  /// No description provided for @plantDetailDueNow.
  ///
  /// In sv, this message translates to:
  /// **'Dags nu'**
  String get plantDetailDueNow;

  /// No description provided for @plantDetailEditPostsTooltip.
  ///
  /// In sv, this message translates to:
  /// **'Hantera inlägg'**
  String get plantDetailEditPostsTooltip;

  /// No description provided for @plantDetailNoteHint.
  ///
  /// In sv, this message translates to:
  /// **'Skriv en kort anteckning…'**
  String get plantDetailNoteHint;

  /// No description provided for @plantDetailNoteTitle.
  ///
  /// In sv, this message translates to:
  /// **'Anteckning'**
  String get plantDetailNoteTitle;

  /// No description provided for @plantDetailNoteSubtitle.
  ///
  /// In sv, this message translates to:
  /// **'Vad hände idag? Bladlöss, första blomman, beskärning…'**
  String get plantDetailNoteSubtitle;

  /// No description provided for @plantDetailTakePhoto.
  ///
  /// In sv, this message translates to:
  /// **'Ta foto'**
  String get plantDetailTakePhoto;

  /// No description provided for @plantDetailPickLibrary.
  ///
  /// In sv, this message translates to:
  /// **'Välj från bibliotek'**
  String get plantDetailPickLibrary;

  /// No description provided for @plantDetailWriteNote.
  ///
  /// In sv, this message translates to:
  /// **'Skriv anteckning'**
  String get plantDetailWriteNote;

  /// No description provided for @plantDetailUseEmojiAgain.
  ///
  /// In sv, this message translates to:
  /// **'Använd emoji igen'**
  String get plantDetailUseEmojiAgain;

  /// No description provided for @plantDetailSaveImageError.
  ///
  /// In sv, this message translates to:
  /// **'Kunde inte spara bild: {error}'**
  String plantDetailSaveImageError(String error);

  /// No description provided for @plantDetailSavePhotoError.
  ///
  /// In sv, this message translates to:
  /// **'Kunde inte spara foto: {error}'**
  String plantDetailSavePhotoError(String error);

  /// No description provided for @plantDetailDeletePhotoTitle.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort foto?'**
  String get plantDetailDeletePhotoTitle;

  /// No description provided for @plantDetailDeleteNoteTitle.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort anteckning?'**
  String get plantDetailDeleteNoteTitle;

  /// No description provided for @plantDetailDeletePhotoBody.
  ///
  /// In sv, this message translates to:
  /// **'Bilden raderas från enheten.'**
  String get plantDetailDeletePhotoBody;

  /// No description provided for @plantDetailDeleteNoteBody.
  ///
  /// In sv, this message translates to:
  /// **'Anteckningen försvinner.'**
  String get plantDetailDeleteNoteBody;

  /// No description provided for @plantDetailAdd.
  ///
  /// In sv, this message translates to:
  /// **'Lägg till'**
  String get plantDetailAdd;

  /// No description provided for @plantDetailNoPostsBody.
  ///
  /// In sv, this message translates to:
  /// **'Inga inlägg ännu — börja dokumentera tillväxten med foton och korta anteckningar.'**
  String get plantDetailNoPostsBody;

  /// No description provided for @plantDetailChangeStatus.
  ///
  /// In sv, this message translates to:
  /// **'Ändra status'**
  String get plantDetailChangeStatus;

  /// No description provided for @plantDetailLocationLabel.
  ///
  /// In sv, this message translates to:
  /// **'Plats'**
  String get plantDetailLocationLabel;

  /// No description provided for @plantDetailSowingMethodChip.
  ///
  /// In sv, this message translates to:
  /// **'Sår: {method}'**
  String plantDetailSowingMethodChip(String method);

  /// No description provided for @plantDetailSowingMethodSnack.
  ///
  /// In sv, this message translates to:
  /// **'Sårmetod: {method}'**
  String plantDetailSowingMethodSnack(String method);

  /// No description provided for @plantDetailDateHelp.
  ///
  /// In sv, this message translates to:
  /// **'Vilket datum?'**
  String get plantDetailDateHelp;

  /// No description provided for @plantDetailHowSowTitle.
  ///
  /// In sv, this message translates to:
  /// **'Hur sår du?'**
  String get plantDetailHowSowTitle;

  /// No description provided for @plantDetailHowSowBody.
  ///
  /// In sv, this message translates to:
  /// **'Avgör vilka påminnelser du får.'**
  String get plantDetailHowSowBody;

  /// No description provided for @plantDetailLocationTitle.
  ///
  /// In sv, this message translates to:
  /// **'Var står den?'**
  String get plantDetailLocationTitle;

  /// No description provided for @plantDetailLocationBody.
  ///
  /// In sv, this message translates to:
  /// **'T.ex. \"norra rabatten\", \"växthuset\", \"balkongen\".'**
  String get plantDetailLocationBody;

  /// No description provided for @plantDetailHarvestOffsetTitle.
  ///
  /// In sv, this message translates to:
  /// **'Justera skördetid'**
  String get plantDetailHarvestOffsetTitle;

  /// No description provided for @plantDetailHarvestOffsetBody.
  ///
  /// In sv, this message translates to:
  /// **'Räknaren ligger fel? Lägg till eller dra av dagar — sparas på just denna planta.'**
  String get plantDetailHarvestOffsetBody;

  /// No description provided for @plantDetailReadyToHarvest.
  ///
  /// In sv, this message translates to:
  /// **'Redo att skördas'**
  String get plantDetailReadyToHarvest;

  /// No description provided for @plantDetailNextStepPresow.
  ///
  /// In sv, this message translates to:
  /// **'Jag har förodlat inomhus'**
  String get plantDetailNextStepPresow;

  /// No description provided for @plantDetailNextStepDirectsow.
  ///
  /// In sv, this message translates to:
  /// **'Jag har direktsått'**
  String get plantDetailNextStepDirectsow;

  /// No description provided for @plantDetailNextStepPlantout.
  ///
  /// In sv, this message translates to:
  /// **'Jag har utplanterat'**
  String get plantDetailNextStepPlantout;

  /// No description provided for @plantDetailNextStepPlantedOut.
  ///
  /// In sv, this message translates to:
  /// **'Plantorna är utplanterade'**
  String get plantDetailNextStepPlantedOut;

  /// No description provided for @plantDetailNextStepHarvestReady.
  ///
  /// In sv, this message translates to:
  /// **'Klar för skörd'**
  String get plantDetailNextStepHarvestReady;

  /// No description provided for @plantDetailNextStepHarvested.
  ///
  /// In sv, this message translates to:
  /// **'Skördad'**
  String get plantDetailNextStepHarvested;

  /// No description provided for @plantDetailHowToTitle.
  ///
  /// In sv, this message translates to:
  /// **'Så här gör du'**
  String get plantDetailHowToTitle;

  /// No description provided for @plantDetailTipsTitle.
  ///
  /// In sv, this message translates to:
  /// **'Tips'**
  String get plantDetailTipsTitle;

  /// No description provided for @plantDetailPestsTitle.
  ///
  /// In sv, this message translates to:
  /// **'Skadedjur att bevaka'**
  String get plantDetailPestsTitle;

  /// No description provided for @plantDetailNoCareTips.
  ///
  /// In sv, this message translates to:
  /// **'Inga skötselråd tillgängliga ännu.'**
  String get plantDetailNoCareTips;

  /// No description provided for @plantDetailInfoSun.
  ///
  /// In sv, this message translates to:
  /// **'Sol'**
  String get plantDetailInfoSun;

  /// No description provided for @plantDetailInfoWater.
  ///
  /// In sv, this message translates to:
  /// **'Vatten'**
  String get plantDetailInfoWater;

  /// No description provided for @plantDetailInfoFertilizer.
  ///
  /// In sv, this message translates to:
  /// **'Gödsel'**
  String get plantDetailInfoFertilizer;

  /// No description provided for @plantDetailInfoFrost.
  ///
  /// In sv, this message translates to:
  /// **'Tål till'**
  String get plantDetailInfoFrost;

  /// No description provided for @plantDetailInfoSpacing.
  ///
  /// In sv, this message translates to:
  /// **'Avstånd'**
  String get plantDetailInfoSpacing;

  /// No description provided for @plantDetailInfoHarvest.
  ///
  /// In sv, this message translates to:
  /// **'Skörd'**
  String get plantDetailInfoHarvest;

  /// No description provided for @plantDetailHarvestSection.
  ///
  /// In sv, this message translates to:
  /// **'🥕  Skörd'**
  String get plantDetailHarvestSection;

  /// No description provided for @plantDetailToolsSection.
  ///
  /// In sv, this message translates to:
  /// **'🛒 Verktyg och tillbehör'**
  String get plantDetailToolsSection;

  /// No description provided for @plantDetailSeasonSection.
  ///
  /// In sv, this message translates to:
  /// **'Säsong'**
  String get plantDetailSeasonSection;

  /// No description provided for @plantDetailPhasePresow.
  ///
  /// In sv, this message translates to:
  /// **'Förodla'**
  String get plantDetailPhasePresow;

  /// No description provided for @plantDetailPhaseDirectsow.
  ///
  /// In sv, this message translates to:
  /// **'Direktså'**
  String get plantDetailPhaseDirectsow;

  /// No description provided for @plantDetailPhasePlantout.
  ///
  /// In sv, this message translates to:
  /// **'Plantera ut'**
  String get plantDetailPhasePlantout;

  /// No description provided for @plantDetailPhaseHarvest.
  ///
  /// In sv, this message translates to:
  /// **'Skörd'**
  String get plantDetailPhaseHarvest;

  /// No description provided for @plantDetailZoneWarningBody.
  ///
  /// In sv, this message translates to:
  /// **'Det kan gå – men du behöver troligen vinterskydd eller en varmare plats.'**
  String get plantDetailZoneWarningBody;

  /// No description provided for @plantDetailDateAdded.
  ///
  /// In sv, this message translates to:
  /// **'Tillagd {date}'**
  String plantDetailDateAdded(String date);

  /// No description provided for @plantDetailDateInGardenSince.
  ///
  /// In sv, this message translates to:
  /// **'I trädgården sedan {year}'**
  String plantDetailDateInGardenSince(String year);

  /// No description provided for @plantDetailDatePlanted.
  ///
  /// In sv, this message translates to:
  /// **'Planterad {date}'**
  String plantDetailDatePlanted(String date);

  /// No description provided for @plantDetailHarvestOffsetSubtitle.
  ///
  /// In sv, this message translates to:
  /// **'Justera skördetid'**
  String get plantDetailHarvestOffsetSubtitle;

  /// No description provided for @plantDetailZoneWarning.
  ///
  /// In sv, this message translates to:
  /// **'Den här växten är inte testad för zon {zone}. Det kan gå – men du behöver troligen vinterskydd eller en varmare plats.'**
  String plantDetailZoneWarning(String zone);

  /// No description provided for @harvestSectionTitle.
  ///
  /// In sv, this message translates to:
  /// **'🥕 Skörd'**
  String get harvestSectionTitle;

  /// No description provided for @harvestRemoveTitle.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort post?'**
  String get harvestRemoveTitle;

  /// No description provided for @harvestRemoveBody.
  ///
  /// In sv, this message translates to:
  /// **'{amount} {unit} från {date} tas bort.'**
  String harvestRemoveBody(String amount, String unit, String date);

  /// No description provided for @harvestMoreEntries.
  ///
  /// In sv, this message translates to:
  /// **'+ {count} äldre poster'**
  String harvestMoreEntries(String count);

  /// No description provided for @harvestAddTitle.
  ///
  /// In sv, this message translates to:
  /// **'Logga skörd — {plant}'**
  String harvestAddTitle(String plant);

  /// No description provided for @harvestAmountLabel.
  ///
  /// In sv, this message translates to:
  /// **'Mängd'**
  String get harvestAmountLabel;

  /// No description provided for @harvestUnitLabel.
  ///
  /// In sv, this message translates to:
  /// **'Enhet'**
  String get harvestUnitLabel;

  /// No description provided for @harvestNotesLabel.
  ///
  /// In sv, this message translates to:
  /// **'Anteckning (valfritt)'**
  String get harvestNotesLabel;

  /// No description provided for @harvestErrorAmountTooLow.
  ///
  /// In sv, this message translates to:
  /// **'Ange en mängd större än 0'**
  String get harvestErrorAmountTooLow;

  /// No description provided for @harvestErrorFutureDate.
  ///
  /// In sv, this message translates to:
  /// **'Du kan inte logga skörd i framtiden'**
  String get harvestErrorFutureDate;

  /// No description provided for @commonCancel.
  ///
  /// In sv, this message translates to:
  /// **'Avbryt'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort'**
  String get commonDelete;

  /// No description provided for @commonSave.
  ///
  /// In sv, this message translates to:
  /// **'Spara'**
  String get commonSave;

  /// No description provided for @pestTypeLabelDisease.
  ///
  /// In sv, this message translates to:
  /// **'SJUKDOM'**
  String get pestTypeLabelDisease;

  /// No description provided for @pestTypeLabelDamage.
  ///
  /// In sv, this message translates to:
  /// **'SKADA'**
  String get pestTypeLabelDamage;

  /// No description provided for @pestTypeLabelPest.
  ///
  /// In sv, this message translates to:
  /// **'SKADEDJUR'**
  String get pestTypeLabelPest;

  /// No description provided for @statsShareButton.
  ///
  /// In sv, this message translates to:
  /// **'Dela'**
  String get statsShareButton;

  /// No description provided for @statsShareText.
  ///
  /// In sv, this message translates to:
  /// **'Min trädgård {year} med Plantera 🌱'**
  String statsShareText(String year);

  /// No description provided for @statsShareFailed.
  ///
  /// In sv, this message translates to:
  /// **'Kunde inte skapa delningsbild'**
  String get statsShareFailed;

  /// No description provided for @paywallTitleBranded.
  ///
  /// In sv, this message translates to:
  /// **'Plantera Premium'**
  String get paywallTitleBranded;

  /// No description provided for @paywallHeaderFrost.
  ///
  /// In sv, this message translates to:
  /// **'Få frostvarning innan plantorna fryser'**
  String get paywallHeaderFrost;

  /// No description provided for @paywallHeaderGardenLimit.
  ///
  /// In sv, this message translates to:
  /// **'Lägg till hela trädgården'**
  String get paywallHeaderGardenLimit;

  /// No description provided for @paywallHeaderWaterAll.
  ///
  /// In sv, this message translates to:
  /// **'Vattna alla med ett tryck'**
  String get paywallHeaderWaterAll;

  /// No description provided for @paywallHeaderPhotoLog.
  ///
  /// In sv, this message translates to:
  /// **'Fotodagbok för dina växter'**
  String get paywallHeaderPhotoLog;

  /// No description provided for @paywallSubFrost.
  ///
  /// In sv, this message translates to:
  /// **'SMHI-baserad nattetemp — vi pingar dig kvällen före frostnatten'**
  String get paywallSubFrost;

  /// No description provided for @paywallSubGardenLimit.
  ///
  /// In sv, this message translates to:
  /// **'Inga gränser på antal växter du följer'**
  String get paywallSubGardenLimit;

  /// No description provided for @paywallSubWaterAll.
  ///
  /// In sv, this message translates to:
  /// **'En knapp markerar alla utomhusväxter vattnade'**
  String get paywallSubWaterAll;

  /// No description provided for @paywallSubPhotoLog.
  ///
  /// In sv, this message translates to:
  /// **'Se hur de växer från frö till skörd'**
  String get paywallSubPhotoLog;

  /// No description provided for @paywallSubHome.
  ///
  /// In sv, this message translates to:
  /// **'Frostvarningar, fotodagbok och allt obegränsat'**
  String get paywallSubHome;

  /// No description provided for @paywallSubDefault.
  ///
  /// In sv, this message translates to:
  /// **'Växla upp din trädgård'**
  String get paywallSubDefault;

  /// No description provided for @paywallBenefitUnlimited.
  ///
  /// In sv, this message translates to:
  /// **'Obegränsade växter i min trädgård'**
  String get paywallBenefitUnlimited;

  /// No description provided for @paywallBenefitReminders.
  ///
  /// In sv, this message translates to:
  /// **'Alla påminnelser och frostvarningar'**
  String get paywallBenefitReminders;

  /// No description provided for @paywallBenefitPhotos.
  ///
  /// In sv, this message translates to:
  /// **'Fotodagbok för varje växt'**
  String get paywallBenefitPhotos;

  /// No description provided for @paywallBenefitNoAds.
  ///
  /// In sv, this message translates to:
  /// **'Inga annonser'**
  String get paywallBenefitNoAds;

  /// No description provided for @paywallBenefitPdf.
  ///
  /// In sv, this message translates to:
  /// **'PDF-export av skördedagbok'**
  String get paywallBenefitPdf;

  /// No description provided for @paywallBenefitArticles.
  ///
  /// In sv, this message translates to:
  /// **'Full tillgång till kunskapsartiklar'**
  String get paywallBenefitArticles;

  /// No description provided for @paywallPlanYearly.
  ///
  /// In sv, this message translates to:
  /// **'Årsprenumeration'**
  String get paywallPlanYearly;

  /// No description provided for @paywallPlanYearlySavings.
  ///
  /// In sv, this message translates to:
  /// **'Spara {percent}% jämfört med månad'**
  String paywallPlanYearlySavings(String percent);

  /// No description provided for @paywallPlanMonthly.
  ///
  /// In sv, this message translates to:
  /// **'Månadsprenumeration'**
  String get paywallPlanMonthly;

  /// No description provided for @paywallPlanLifetime.
  ///
  /// In sv, this message translates to:
  /// **'Livstidsköp (engångsbetalning)'**
  String get paywallPlanLifetime;

  /// No description provided for @paywallTrialCta.
  ///
  /// In sv, this message translates to:
  /// **'Starta gratis provperiod ({period})'**
  String paywallTrialCta(String period);

  /// No description provided for @paywallTrialThen.
  ///
  /// In sv, this message translates to:
  /// **'Sedan {price}'**
  String paywallTrialThen(String price);

  /// No description provided for @paywallPlanPriceFormat.
  ///
  /// In sv, this message translates to:
  /// **'{title} • {price}'**
  String paywallPlanPriceFormat(String title, String price);

  /// No description provided for @paywallRestore.
  ///
  /// In sv, this message translates to:
  /// **'Återställ tidigare köp'**
  String get paywallRestore;

  /// No description provided for @paywallDisclaimer.
  ///
  /// In sv, this message translates to:
  /// **'Prenumerationer förnyas automatiskt tills de avslutas i App Store-inställningarna. Avgiften dras 24 h före förnyelse.'**
  String get paywallDisclaimer;

  /// No description provided for @paywallTerms.
  ///
  /// In sv, this message translates to:
  /// **'Villkor (EULA)'**
  String get paywallTerms;

  /// No description provided for @paywallPrivacy.
  ///
  /// In sv, this message translates to:
  /// **'Integritetspolicy'**
  String get paywallPrivacy;

  /// No description provided for @paywallErrorStore.
  ///
  /// In sv, this message translates to:
  /// **'App Store är inte tillgängligt just nu — försök igen om en stund.'**
  String get paywallErrorStore;

  /// No description provided for @paywallErrorProduct.
  ///
  /// In sv, this message translates to:
  /// **'Köpet kunde inte laddas från App Store. Stäng paywallen och öppna igen.'**
  String get paywallErrorProduct;

  /// No description provided for @paywallErrorFailed.
  ///
  /// In sv, this message translates to:
  /// **'Köpet misslyckades. Försök igen.'**
  String get paywallErrorFailed;

  /// No description provided for @paywallErrorOpenUrl.
  ///
  /// In sv, this message translates to:
  /// **'Kunde inte öppna {url}'**
  String paywallErrorOpenUrl(String url);

  /// Paywall UX feedback strings (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Premium aktiverat — tack! Allt är upplåst.'**
  String get paywallPurchaseSuccess;

  /// Paywall UX feedback strings (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Söker efter dina köp…'**
  String get paywallRestoreInProgress;

  /// Paywall UX feedback strings (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Kunde inte kontakta App Store. Försök igen.'**
  String get paywallRestoreFailed;

  /// Paywall UX feedback strings (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Premium återställd — tack!'**
  String get paywallRestoreSuccess;

  /// Paywall UX feedback strings (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Premium är redan aktivt.'**
  String get paywallRestoreAlreadyActive;

  /// Paywall UX feedback strings (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Inga köp hittades på det här Apple-ID:t.'**
  String get paywallRestoreNothingFound;

  /// Paywall UX feedback strings (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Du har Premium'**
  String get paywallAlreadyPremiumTitle;

  /// Paywall UX feedback strings (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Alla funktioner är upplåsta. Tack för stödet — det hjälper oss bygga vidare.'**
  String get paywallAlreadyPremiumBody;

  /// Paywall UX feedback strings (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Tillbaka till trädgården'**
  String get paywallAlreadyPremiumCta;

  /// Paywall UX feedback strings (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Kunde inte ladda priserna från App Store. Kolla din internet och försök igen.'**
  String get paywallProductsUnavailable;

  /// Paywall UX feedback strings (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Försök igen'**
  String get paywallProductsRetry;

  /// Onboarding value-prop slide (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Sluta gissa när du ska så'**
  String get onboardingSlide1Title;

  /// Onboarding value-prop slide (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Plantera vet din odlingszon och säger åt dig exakt när det är dags att förodla, direktså eller plantera ut — växt för växt.'**
  String get onboardingSlide1Body;

  /// Onboarding value-prop slide (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Frostvarning från SMHI'**
  String get onboardingSlide2Title;

  /// Onboarding value-prop slide (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'När det blir kallt om natten får du en notis i tid att täcka över spirorna. Inte panik klockan tre på natten.'**
  String get onboardingSlide2Body;

  /// Onboarding value-prop slide (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'En morgonpåminnelse — inte 50'**
  String get onboardingSlide3Title;

  /// Onboarding value-prop slide (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Vatten, beskärning, skörd och säsongs-sysslor samlas i en daglig översikt så du faktiskt får en skörd att vara stolt över.'**
  String get onboardingSlide3Body;

  /// Onboarding value-prop slide (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Hoppa över'**
  String get onboardingFooterSkip;

  /// Onboarding value-prop slide (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Nästa'**
  String get onboardingFooterNext;

  /// Onboarding value-prop slide (added 2026-05)
  ///
  /// In sv, this message translates to:
  /// **'Kom igång'**
  String get onboardingFooterStart;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'da',
    'de',
    'el',
    'en',
    'es',
    'fi',
    'fr',
    'it',
    'nb',
    'sv',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'nb':
      return AppLocalizationsNb();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
