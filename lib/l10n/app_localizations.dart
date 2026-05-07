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

  /// No description provided for @resumenNutricional.
  ///
  /// In en, this message translates to:
  /// **'Nutrition summary'**
  String get resumenNutricional;

  /// No description provided for @registrarComida.
  ///
  /// In en, this message translates to:
  /// **'Register meal'**
  String get registrarComida;

  /// No description provided for @cantidadGramos.
  ///
  /// In en, this message translates to:
  /// **'Amount in grams'**
  String get cantidadGramos;

  /// No description provided for @acompanantes.
  ///
  /// In en, this message translates to:
  /// **'Side dishes'**
  String get acompanantes;

  /// No description provided for @bebida.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get bebida;

  /// No description provided for @seleccionarBebida.
  ///
  /// In en, this message translates to:
  /// **'Select drink'**
  String get seleccionarBebida;

  /// No description provided for @guardarComida.
  ///
  /// In en, this message translates to:
  /// **'Save meal'**
  String get guardarComida;

  /// No description provided for @comidaGuardada.
  ///
  /// In en, this message translates to:
  /// **'Meal saved'**
  String get comidaGuardada;

  /// No description provided for @porciones.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get porciones;

  /// No description provided for @clasicoMexicano.
  ///
  /// In en, this message translates to:
  /// **'Classic Mexican'**
  String get clasicoMexicano;

  /// No description provided for @grandeCompleto.
  ///
  /// In en, this message translates to:
  /// **'Large and complete'**
  String get grandeCompleto;

  /// No description provided for @tradicionalMexicano.
  ///
  /// In en, this message translates to:
  /// **'Traditional Mexican'**
  String get tradicionalMexicano;

  /// No description provided for @caldoTipico.
  ///
  /// In en, this message translates to:
  /// **'Traditional soup'**
  String get caldoTipico;

  /// No description provided for @saborIntenso.
  ///
  /// In en, this message translates to:
  /// **'Strong flavor'**
  String get saborIntenso;

  /// No description provided for @conQueso.
  ///
  /// In en, this message translates to:
  /// **'With cheese'**
  String get conQueso;

  /// No description provided for @rellena.
  ///
  /// In en, this message translates to:
  /// **'Stuffed'**
  String get rellena;

  /// No description provided for @desayunoMexicano.
  ///
  /// In en, this message translates to:
  /// **'Mexican breakfast'**
  String get desayunoMexicano;

  /// No description provided for @caldoTradicional.
  ///
  /// In en, this message translates to:
  /// **'Traditional broth'**
  String get caldoTradicional;

  /// No description provided for @conSalsa.
  ///
  /// In en, this message translates to:
  /// **'With sauce'**
  String get conSalsa;

  /// No description provided for @altaProteina.
  ///
  /// In en, this message translates to:
  /// **'High protein'**
  String get altaProteina;

  /// No description provided for @ricaProteina.
  ///
  /// In en, this message translates to:
  /// **'Rich in protein'**
  String get ricaProteina;

  /// No description provided for @jugosas.
  ///
  /// In en, this message translates to:
  /// **'Juicy'**
  String get jugosas;

  /// No description provided for @comidaRapida.
  ///
  /// In en, this message translates to:
  /// **'Fast food'**
  String get comidaRapida;

  /// No description provided for @clasica.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get clasica;

  /// No description provided for @fuenteEnergia.
  ///
  /// In en, this message translates to:
  /// **'Energy source'**
  String get fuenteEnergia;

  /// No description provided for @energia.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energia;

  /// No description provided for @crujientes.
  ///
  /// In en, this message translates to:
  /// **'Crunchy'**
  String get crujientes;

  /// No description provided for @ligera.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get ligera;

  /// No description provided for @grasasSaludables.
  ///
  /// In en, this message translates to:
  /// **'Healthy fats'**
  String get grasasSaludables;

  /// No description provided for @fibra.
  ///
  /// In en, this message translates to:
  /// **'Fiber'**
  String get fibra;

  /// No description provided for @rapido.
  ///
  /// In en, this message translates to:
  /// **'Quick'**
  String get rapido;

  /// No description provided for @clasico.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get clasico;

  /// No description provided for @polloEmpanizado.
  ///
  /// In en, this message translates to:
  /// **'Breaded chicken'**
  String get polloEmpanizado;

  /// No description provided for @comidaJaponesa.
  ///
  /// In en, this message translates to:
  /// **'Japanese food'**
  String get comidaJaponesa;

  /// No description provided for @rellenos.
  ///
  /// In en, this message translates to:
  /// **'Stuffed'**
  String get rellenos;

  /// No description provided for @sopaAsiatica.
  ///
  /// In en, this message translates to:
  /// **'Asian soup'**
  String get sopaAsiatica;

  /// No description provided for @dulce.
  ///
  /// In en, this message translates to:
  /// **'Sweet'**
  String get dulce;

  /// No description provided for @postre.
  ///
  /// In en, this message translates to:
  /// **'Dessert'**
  String get postre;

  /// No description provided for @tacosPastor.
  ///
  /// In en, this message translates to:
  /// **'🌮 Tacos al pastor'**
  String get tacosPastor;

  /// No description provided for @burrito.
  ///
  /// In en, this message translates to:
  /// **'🌯 Burrito'**
  String get burrito;

  /// No description provided for @tamal.
  ///
  /// In en, this message translates to:
  /// **'🫔 Tamale'**
  String get tamal;

  /// No description provided for @pozole.
  ///
  /// In en, this message translates to:
  /// **'🍲 Pozole'**
  String get pozole;

  /// No description provided for @molePollo.
  ///
  /// In en, this message translates to:
  /// **'🍛 Chicken mole'**
  String get molePollo;

  /// No description provided for @quesadilla.
  ///
  /// In en, this message translates to:
  /// **'🫓 Quesadilla'**
  String get quesadilla;

  /// No description provided for @gordita.
  ///
  /// In en, this message translates to:
  /// **'🥙 Gordita'**
  String get gordita;

  /// No description provided for @huevosRancheros.
  ///
  /// In en, this message translates to:
  /// **'🍳 Huevos rancheros'**
  String get huevosRancheros;

  /// No description provided for @menudo.
  ///
  /// In en, this message translates to:
  /// **'🍲 Menudo'**
  String get menudo;

  /// No description provided for @chilaquiles.
  ///
  /// In en, this message translates to:
  /// **'🥘 Chilaquiles'**
  String get chilaquiles;

  /// No description provided for @pechugaPollo.
  ///
  /// In en, this message translates to:
  /// **'🍗 Chicken breast'**
  String get pechugaPollo;

  /// No description provided for @carneAsada.
  ///
  /// In en, this message translates to:
  /// **'🥩 Grilled meat'**
  String get carneAsada;

  /// No description provided for @costillasBBQ.
  ///
  /// In en, this message translates to:
  /// **'🍖 BBQ ribs'**
  String get costillasBBQ;

  /// No description provided for @hamburguesa.
  ///
  /// In en, this message translates to:
  /// **'🍔 Hamburger'**
  String get hamburguesa;

  /// No description provided for @pizza.
  ///
  /// In en, this message translates to:
  /// **'🍕 Pizza'**
  String get pizza;

  /// No description provided for @arroz.
  ///
  /// In en, this message translates to:
  /// **'🍚 Rice'**
  String get arroz;

  /// No description provided for @pasta.
  ///
  /// In en, this message translates to:
  /// **'🍝 Pasta'**
  String get pasta;

  /// No description provided for @papasFritas.
  ///
  /// In en, this message translates to:
  /// **'🥔 French fries'**
  String get papasFritas;

  /// No description provided for @ensalada.
  ///
  /// In en, this message translates to:
  /// **'🥗 Salad'**
  String get ensalada;

  /// No description provided for @aguacate.
  ///
  /// In en, this message translates to:
  /// **'🥑 Avocado'**
  String get aguacate;

  /// No description provided for @manzana.
  ///
  /// In en, this message translates to:
  /// **'🍎 Apple'**
  String get manzana;

  /// No description provided for @sandwich.
  ///
  /// In en, this message translates to:
  /// **'🥪 Sandwich'**
  String get sandwich;

  /// No description provided for @hotdog.
  ///
  /// In en, this message translates to:
  /// **'🌭 Hot Dog'**
  String get hotdog;

  /// No description provided for @nuggets.
  ///
  /// In en, this message translates to:
  /// **'🍗 Nuggets'**
  String get nuggets;

  /// No description provided for @sushi.
  ///
  /// In en, this message translates to:
  /// **'🍣 Sushi'**
  String get sushi;

  /// No description provided for @dumplings.
  ///
  /// In en, this message translates to:
  /// **'🥟 Dumplings'**
  String get dumplings;

  /// No description provided for @ramen.
  ///
  /// In en, this message translates to:
  /// **'🍜 Ramen'**
  String get ramen;

  /// No description provided for @dona.
  ///
  /// In en, this message translates to:
  /// **'🍩 Donut'**
  String get dona;

  /// No description provided for @chocolate.
  ///
  /// In en, this message translates to:
  /// **'🍫 Chocolate'**
  String get chocolate;

  /// No description provided for @pastel.
  ///
  /// In en, this message translates to:
  /// **'🍰 Cake'**
  String get pastel;

  /// No description provided for @ensaladaExtra.
  ///
  /// In en, this message translates to:
  /// **'🥗 Extra salad'**
  String get ensaladaExtra;

  /// No description provided for @pan.
  ///
  /// In en, this message translates to:
  /// **'🍞 Bread'**
  String get pan;

  /// No description provided for @queso.
  ///
  /// In en, this message translates to:
  /// **'🧀 Cheese'**
  String get queso;

  /// No description provided for @papas.
  ///
  /// In en, this message translates to:
  /// **'🍟 Fries'**
  String get papas;

  /// No description provided for @agua.
  ///
  /// In en, this message translates to:
  /// **'💧 Water'**
  String get agua;

  /// No description provided for @refresco.
  ///
  /// In en, this message translates to:
  /// **'🥤 Soda'**
  String get refresco;

  /// No description provided for @cafe.
  ///
  /// In en, this message translates to:
  /// **'☕ Coffee'**
  String get cafe;

  /// No description provided for @leche.
  ///
  /// In en, this message translates to:
  /// **'🥛 Milk'**
  String get leche;

  /// No description provided for @jugo.
  ///
  /// In en, this message translates to:
  /// **'🧃 Juice'**
  String get jugo;

  /// No description provided for @costillasBbq.
  ///
  /// In en, this message translates to:
  /// **'🍖 BBQ Ribs'**
  String get costillasBbq;

  /// No description provided for @desayuno.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get desayuno;

  /// No description provided for @cena.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get cena;

  /// No description provided for @tipoComida.
  ///
  /// In en, this message translates to:
  /// **'Meal type'**
  String get tipoComida;
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
