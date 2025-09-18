import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _key = 'theme_mode';
  final SharedPreferences prefs;
  ThemeCubit(this.prefs) : super(ThemeMode.system) {
    final saved = prefs.getString(_key);
    switch (saved) {
      case 'light':
        emit(ThemeMode.light);
        break;
      case 'dark':
        emit(ThemeMode.dark);
        break;
      default:
        emit(ThemeMode.system);
    }
  }

  void toggle(bool dark) {
    emit(dark ? ThemeMode.dark : ThemeMode.light);
    prefs.setString(_key, dark ? 'dark' : 'light');
  }
}

