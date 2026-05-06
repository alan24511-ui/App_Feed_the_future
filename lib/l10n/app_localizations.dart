import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @perfil.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get perfil;

  /// No description provided for @ajustes.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get ajustes;

  /// No description provided for @cerrar_sesion.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get cerrar_sesion;

  /// No description provided for @nombre.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nombre;

  /// No description provided for @apellido.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get apellido;

  /// No description provided for @edad.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get edad;

  /// No description provided for @peso.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get peso;

  /// No description provided for @altura.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get altura;

  /// No description provided for @objetivo.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get objetivo;

  /// No description provided for @calorias.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calorias;

  /// No description provided for @modoOscuro.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get modoOscuro;

  /// No description provided for @notificaciones.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificaciones;

  /// No description provided for @inicio.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get inicio;

  /// No description provided for @mascota.
  ///
  /// In en, this message translates to:
  /// **'Pet'**
  String get mascota;

  /// No description provided for @comida.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get comida;

  /// No description provided for @recetas.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recetas;

  /// No description provided for @historial.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historial;

  /// No description provided for @hola.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hola;

  /// No description provided for @seguimiento.
  ///
  /// In en, this message translates to:
  /// **'Active tracking'**
  String get seguimiento;

  /// No description provided for @caloriasHoy.
  ///
  /// In en, this message translates to:
  /// **'Calories today'**
  String get caloriasHoy;

  /// No description provided for @objetivoDiario.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get objetivoDiario;

  /// No description provided for @macronutrientes.
  ///
  /// In en, this message translates to:
  /// **'Macronutrients'**
  String get macronutrientes;

  /// No description provided for @proteina.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get proteina;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get carbs;

  /// No description provided for @grasas.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get grasas;

  /// No description provided for @graficaDiaria.
  ///
  /// In en, this message translates to:
  /// **'Daily chart'**
  String get graficaDiaria;

  /// No description provided for @graficaSemanal.
  ///
  /// In en, this message translates to:
  /// **'Weekly chart'**
  String get graficaSemanal;

  /// No description provided for @meta_nutricional.
  ///
  /// In en, this message translates to:
  /// **'Nutrition goal'**
  String get meta_nutricional;

  /// No description provided for @cambiar_objetivo.
  ///
  /// In en, this message translates to:
  /// **'Change goal'**
  String get cambiar_objetivo;

  /// No description provided for @guardar.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get guardar;

  /// No description provided for @cancelar.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelar;

  /// No description provided for @eliminar.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get eliminar;

  /// No description provided for @acercaDe.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get acercaDe;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @restablecer.
  ///
  /// In en, this message translates to:
  /// **'Reset app'**
  String get restablecer;

  /// No description provided for @confirmar.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmar;

  /// No description provided for @borrarAjustes.
  ///
  /// In en, this message translates to:
  /// **'Local settings will be deleted'**
  String get borrarAjustes;

  /// No description provided for @ajustesReiniciados.
  ///
  /// In en, this message translates to:
  /// **'Settings reset'**
  String get ajustesReiniciados;

  /// No description provided for @noUsuario.
  ///
  /// In en, this message translates to:
  /// **'No user found'**
  String get noUsuario;

  /// No description provided for @noComidas.
  ///
  /// In en, this message translates to:
  /// **'No meals recorded 😅'**
  String get noComidas;

  /// No description provided for @idioma.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get idioma;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
