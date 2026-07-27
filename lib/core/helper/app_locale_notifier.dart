import 'package:flutter/material.dart';

/// Drives MaterialApp.locale directly so any locale change is immediately
/// visible on every screen without relying on EasyLocalization's internal
/// InheritedWidget dependency chain.
final appLocaleNotifier = ValueNotifier<Locale>(const Locale('en'));
