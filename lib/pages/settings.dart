import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wave/components/application_info.dart';
import 'package:wave/components/custom_ui_constants/colors.dart';
import 'package:wave/components/material_components/status_page_appbar.dart';
import 'package:wave/extensions/context.dart';
import 'package:wave/models/settings.dart';
import 'package:wave/providers/language.dart';
import 'package:wave/providers/login.dart';
import 'package:wave/providers/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<WaveTheme> themes = [
      WaveTheme(
        context.translated.themeDarkText,
        ThemeMode.dark,
        context.theme.extension<WaveThemeExtention>()!.darkThemePrimary!,
        Icon(
          Icons.dark_mode_outlined,
          color: context.textTheme.bodySmall!.color,
        ),
      ),
      WaveTheme(
        context.translated.themeLightText,
        ThemeMode.light,
        context.theme.extension<WaveThemeExtention>()!.lighThemePrimary!,
        Icon(
          Icons.light_mode_outlined,
          color: context.textTheme.bodySmall!.color,
        ),
      ),
      WaveTheme(
        context.translated.themeSystemText,
        ThemeMode.system,
        context.theme.extension<WaveThemeExtention>()!.lighThemePrimary!,
        Icon(
          Icons.monitor_rounded,
          color: context.textTheme.bodySmall!.color,
        ),
      ),
    ];

    List<WaveLocale> locales = [
      WaveLocale(
        'polish',
        'pl',
        context.translated.languagePolishText,
        '\u{1F1F5}\u{1F1F1}',
      ),
      WaveLocale(
        'english',
        'en',
        context.translated.languageEnglishText,
        '\u{1F1EC}\u{1F1E7}',
      ),
      WaveLocale(
        'system',
        Intl.shortLocale(Intl.systemLocale),
        context.translated.languageSystemText,
        '\u{1F30D}',
      )
    ];

    return Scaffold(
      appBar: WaveAppBar(
        title: context.translated.settings,
        icon: Icons.settings_outlined,
        topColor: const Color(0xff005F8E),
        bottomColor: const Color(0xfc051f37).withOpacity(0),
        height: context.height * 0.16,
        tabs: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: context.width * .05,
          right: context.width * .05,
          top: context.width * .1,
        ),
        child: SizedBox(
          height: context.height * 0.6,
          width: context.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  context.translated.languageChooseTitle,
                ),
              ),
              Consumer<LocaleController>(
                builder: (context, localeController, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ToggleButtons(
                      isSelected: locales
                          .map(
                            (locale) =>
                                locale.shortName == localeController.waveLocale
                                    ? true
                                    : false,
                          )
                          .toList(),
                      onPressed: (index) => localeController
                          .setWaveLocale(locales[index].shortName),
                      borderRadius: BorderRadius.circular(30.0),
                      children: locales
                          .map(
                            (locale) => Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    locale.unicodeFlag,
                                    style: context.textTheme.bodySmall,
                                  ),
                                  const SizedBox(
                                    width: 12.0,
                                  ),
                                  Text(
                                    locale.longName,
                                    style: context.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  context.translated.themeChooseTitle,
                ),
              ),
              Consumer<ThemeController>(
                builder: (context, themeController, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ToggleButtons(
                      isSelected: themes
                          .map(
                            (theme) =>
                                theme.mode == themeController.waveThemeMode
                                    ? true
                                    : false,
                          )
                          .toList(),
                      onPressed: (index) =>
                          themeController.setWaveThemeMode(themes[index].mode),
                      borderRadius: BorderRadius.circular(30.0),
                      children: themes
                          .map(
                            (theme) => Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  theme.icon,
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    theme.name,
                                    style: context.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(context.translated.privacyPolicyTitle),
                trailing: const Icon(Icons.launch),
                onTap: () => launchUrl(
                  Uri.parse(
                    'https://woprwielkopolska.pl/wave-polityka-prywatnosci/',
                  ),
                ),
                onLongPress: () {},
              ),
              ListTile(
                title: Text(context.translated.userManualTitle),
                trailing: const Icon(Icons.launch),
                onTap: () => launchUrl(
                  Uri.parse(
                    'https://woprwielkopolska.pl/wp-content/uploads/2023/03/instrukcja_aplikacji_mobilnej_PL.pdf',
                  ),
                  mode: LaunchMode.externalApplication,
                ),
                onLongPress: () {},
              ),
              Consumer<LoginController>(
                builder: (context, loginController, _) => ListTile(
                  title: Text(context.translated.logoutTitle),
                  trailing: const Icon(Icons.logout_outlined),
                  onTap: () {
                    loginController.logout(context.translated.logoutMessage);

                    context.router.popUntilRoot();
                  },
                  onLongPress: () {},
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  PackageInfo packageInfo = await PackageInfo.fromPlatform();
                  if (context.mounted) {
                    showAboutDialog(
                      context: context,
                      applicationName: packageInfo.appName,
                      applicationVersion:
                          '${packageInfo.version} (${packageInfo.buildNumber})',
                      applicationIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/wave-playstore.png',
                          scale: 10,
                        ),
                      ),
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    context.theme.cardColor,
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(8.0),
                  ),
                ),
                child: Text(
                  context.translated.about,
                  style: context.textTheme.bodySmall,
                ),
              ),
              const ApplicationInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
