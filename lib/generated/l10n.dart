// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home`
  String get homeTitle {
    return Intl.message(
      'Home',
      name: 'homeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add vehicle`
  String get addTitle {
    return Intl.message(
      'Add vehicle',
      name: 'addTitle',
      desc: '',
      args: [],
    );
  }

  /// `Car`
  String get car {
    return Intl.message(
      'Car',
      name: 'car',
      desc: '',
      args: [],
    );
  }

  /// `Bike`
  String get bike {
    return Intl.message(
      'Bike',
      name: 'bike',
      desc: '',
      args: [],
    );
  }

  /// `Other vehicle`
  String get other {
    return Intl.message(
      'Other vehicle',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, an error occurred :(`
  String get homeError {
    return Intl.message(
      'Sorry, an error occurred :(',
      name: 'homeError',
      desc: '',
      args: [],
    );
  }

  /// `yyyy/MM/dd`
  String get dateFormat {
    return Intl.message(
      'yyyy/MM/dd',
      name: 'dateFormat',
      desc: '',
      args: [],
    );
  }

  /// `Enter the model`
  String get helperTextModel {
    return Intl.message(
      'Enter the model',
      name: 'helperTextModel',
      desc: '',
      args: [],
    );
  }

  /// `Model`
  String get hintTextModel {
    return Intl.message(
      'Model',
      name: 'hintTextModel',
      desc: '',
      args: [],
    );
  }

  /// `Model too short`
  String get errorTextModel {
    return Intl.message(
      'Model too short',
      name: 'errorTextModel',
      desc: '',
      args: [],
    );
  }

  /// `Enter version`
  String get helperTextVersion {
    return Intl.message(
      'Enter version',
      name: 'helperTextVersion',
      desc: '',
      args: [],
    );
  }

  /// `version`
  String get hintTextVersion {
    return Intl.message(
      'version',
      name: 'hintTextVersion',
      desc: '',
      args: [],
    );
  }

  /// `Version too short`
  String get errorTextVersion {
    return Intl.message(
      'Version too short',
      name: 'errorTextVersion',
      desc: '',
      args: [],
    );
  }

  /// `Enter the date of the next service`
  String get helperTextNextRevisionDate {
    return Intl.message(
      'Enter the date of the next service',
      name: 'helperTextNextRevisionDate',
      desc: '',
      args: [],
    );
  }

  /// `Date of the next service`
  String get hintTextNextRevisionDate {
    return Intl.message(
      'Date of the next service',
      name: 'hintTextNextRevisionDate',
      desc: '',
      args: [],
    );
  }

  /// `Date of the next service too short`
  String get errorTextNextRevisionDate {
    return Intl.message(
      'Date of the next service too short',
      name: 'errorTextNextRevisionDate',
      desc: '',
      args: [],
    );
  }

  /// `Enter the mileage of the next service`
  String get helperTextNextRevisionDistance {
    return Intl.message(
      'Enter the mileage of the next service',
      name: 'helperTextNextRevisionDistance',
      desc: '',
      args: [],
    );
  }

  /// `Mileage of the next service`
  String get hintTextNextRevisionDistance {
    return Intl.message(
      'Mileage of the next service',
      name: 'hintTextNextRevisionDistance',
      desc: '',
      args: [],
    );
  }

  /// `Mileage of the next service too short`
  String get errorTextNextRevisionDistance {
    return Intl.message(
      'Mileage of the next service too short',
      name: 'errorTextNextRevisionDistance',
      desc: '',
      args: [],
    );
  }

  /// `Enter the front tire pressure`
  String get helperTextFrontTire {
    return Intl.message(
      'Enter the front tire pressure',
      name: 'helperTextFrontTire',
      desc: '',
      args: [],
    );
  }

  /// `Front tire pressure`
  String get hintTextFrontTire {
    return Intl.message(
      'Front tire pressure',
      name: 'hintTextFrontTire',
      desc: '',
      args: [],
    );
  }

  /// `Front tire pressure too short`
  String get errorTextFrontTireShort {
    return Intl.message(
      'Front tire pressure too short',
      name: 'errorTextFrontTireShort',
      desc: '',
      args: [],
    );
  }

  /// `Do not use commas, use this format: 2.2`
  String get errorTextFrontTireNotDouble {
    return Intl.message(
      'Do not use commas, use this format: 2.2',
      name: 'errorTextFrontTireNotDouble',
      desc: '',
      args: [],
    );
  }

  /// `Enter the rear tire pressure`
  String get helperTextRearTire {
    return Intl.message(
      'Enter the rear tire pressure',
      name: 'helperTextRearTire',
      desc: '',
      args: [],
    );
  }

  /// `Rear tire pressure`
  String get hintTextRearTire {
    return Intl.message(
      'Rear tire pressure',
      name: 'hintTextRearTire',
      desc: '',
      args: [],
    );
  }

  /// `Rear tire pressure too short`
  String get errorTextRearTireShort {
    return Intl.message(
      'Rear tire pressure too short',
      name: 'errorTextRearTireShort',
      desc: '',
      args: [],
    );
  }

  /// `Do not use commas, use this format: 2.2`
  String get errorTextRearTireNotDouble {
    return Intl.message(
      'Do not use commas, use this format: 2.2',
      name: 'errorTextRearTireNotDouble',
      desc: '',
      args: [],
    );
  }

  /// `Enter the date of the next technical control`
  String get helperTextNextTechnicalControlDate {
    return Intl.message(
      'Enter the date of the next technical control',
      name: 'helperTextNextTechnicalControlDate',
      desc: '',
      args: [],
    );
  }

  /// `Date of the next technical control`
  String get hintTextNextTechnicalControlDate {
    return Intl.message(
      'Date of the next technical control',
      name: 'hintTextNextTechnicalControlDate',
      desc: '',
      args: [],
    );
  }

  /// `Date of the next technical control too short`
  String get errorTextNextTechnicalControlDate {
    return Intl.message(
      'Date of the next technical control too short',
      name: 'errorTextNextTechnicalControlDate',
      desc: '',
      args: [],
    );
  }

  /// `Saisir the fuel`
  String get helperTextFuel {
    return Intl.message(
      'Saisir the fuel',
      name: 'helperTextFuel',
      desc: '',
      args: [],
    );
  }

  /// `Fuel`
  String get hintTextFuel {
    return Intl.message(
      'Fuel',
      name: 'hintTextFuel',
      desc: '',
      args: [],
    );
  }

  /// `Fuel too short`
  String get errorTextFuel {
    return Intl.message(
      'Fuel too short',
      name: 'errorTextFuel',
      desc: '',
      args: [],
    );
  }

  /// `Enter additional information`
  String get helperTextFreeInformations {
    return Intl.message(
      'Enter additional information',
      name: 'helperTextFreeInformations',
      desc: '',
      args: [],
    );
  }

  /// `Additional information`
  String get hintTextFreeInformations {
    return Intl.message(
      'Additional information',
      name: 'hintTextFreeInformations',
      desc: '',
      args: [],
    );
  }

  /// `Additional information too short`
  String get errorTextFreeInformations {
    return Intl.message(
      'Additional information too short',
      name: 'errorTextFreeInformations',
      desc: '',
      args: [],
    );
  }

  /// `No additional information.`
  String get emptyTextFreeInformations {
    return Intl.message(
      'No additional information.',
      name: 'emptyTextFreeInformations',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get tooltipFormValidate {
    return Intl.message(
      'Register',
      name: 'tooltipFormValidate',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get editVehicle {
    return Intl.message(
      'Edit',
      name: 'editVehicle',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteVehicle {
    return Intl.message(
      'Delete',
      name: 'deleteVehicle',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle save`
  String get vehicleSave {
    return Intl.message(
      'Vehicle save',
      name: 'vehicleSave',
      desc: '',
      args: [],
    );
  }

  /// `Saved changes`
  String get vehicleUpdate {
    return Intl.message(
      'Saved changes',
      name: 'vehicleUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Register a new vehicle`
  String get registerNewVehicle {
    return Intl.message(
      'Register a new vehicle',
      name: 'registerNewVehicle',
      desc: '',
      args: [],
    );
  }

  /// `Back to home`
  String get backToHome {
    return Intl.message(
      'Back to home',
      name: 'backToHome',
      desc: '',
      args: [],
    );
  }

  /// `Your upcoming deadlines`
  String get alertTitlePage {
    return Intl.message(
      'Your upcoming deadlines',
      name: 'alertTitlePage',
      desc: '',
      args: [],
    );
  }

  /// `Technical control`
  String get technicalControl {
    return Intl.message(
      'Technical control',
      name: 'technicalControl',
      desc: '',
      args: [],
    );
  }

  /// `All your technical checks are up to date`
  String get ctIsEmpty {
    return Intl.message(
      'All your technical checks are up to date',
      name: 'ctIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Revisions`
  String get revision {
    return Intl.message(
      'Revisions',
      name: 'revision',
      desc: '',
      args: [],
    );
  }

  /// `All your revisions are up to date`
  String get revisionIsEmpty {
    return Intl.message(
      'All your revisions are up to date',
      name: 'revisionIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Technical control to be done : `
  String get subtitleCtTile {
    return Intl.message(
      'Technical control to be done : ',
      name: 'subtitleCtTile',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming review deadline : `
  String get subtitleRevisionTile {
    return Intl.message(
      'Upcoming review deadline : ',
      name: 'subtitleRevisionTile',
      desc: '',
      args: [],
    );
  }

  /// `No vehicle`
  String get titleListVehicleHomeIsEmpty {
    return Intl.message(
      'No vehicle',
      name: 'titleListVehicleHomeIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `To start, press +`
  String get subTitleListVehicleHomeIsEmpty {
    return Intl.message(
      'To start, press +',
      name: 'subTitleListVehicleHomeIsEmpty',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
