import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:templateproject/src/localization/locale.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatefulWidget {
  const SettingsView({Key? key, required this.controller}) : super(key: key);

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    if (box.read('lang') == 'en') {
      dropdownValue = 'English';
    } else if (box.read('lang') == 'hi') {
      dropdownValue = 'Hindi';
    }
  }

  String dropdownValue = 'English';
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Theme'),
                trailing: DropdownButton<ThemeMode>(
                  // Read the selected themeMode from the controller
                  value: widget.controller.themeMode,
                  // Call the updateThemeMode method any time the user selects a theme.
                  onChanged: widget.controller.updateThemeMode,
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System Theme'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light Theme'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark Theme'),
                    )
                  ],
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.translate),
                title: const Text('Language'),
                trailing: DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      if (dropdownValue == 'English') {
                        final box = GetStorage();

                        box.write('lang', 'en');
                        provider.setLocale(const Locale('en'));
                      } else if (dropdownValue == 'Hindi') {
                        final box = GetStorage();

                        box.write('lang', 'hi');
                        provider.setLocale(const Locale('hi'));
                      }
                    });
                  },
                  items: <String>['English', 'Hindi', 'Free', 'Four']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
//  final provider = Provider.of<LocaleProvider>(
//                                       context,
//                                       listen: false);

//                                   provider.setLocale(Locale('en'));

//  final provider = Provider.of<LocaleProvider>(
//                                       context,
//                                       listen: false);

//                                   provider.setLocale(Locale('hi'));