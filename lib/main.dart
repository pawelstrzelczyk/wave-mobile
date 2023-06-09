import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wave/auto_router.gr.dart';
import 'package:wave/providers/device_info.dart';
import 'package:wave/providers/duty_form.dart';
import 'package:wave/providers/duty_scheduled.dart';
import 'package:wave/providers/duty_history.dart';
import 'package:wave/providers/geolocator.dart';
import 'package:wave/providers/language.dart';
import 'package:wave/providers/login.dart';
import 'package:wave/providers/mobilisation_place.dart';
import 'package:wave/providers/patrol_form.dart';
import 'package:wave/providers/patrol_history.dart';
import 'package:wave/providers/status.dart';
import 'package:wave/providers/aad_user.dart';
import 'package:wave/providers/theme.dart';
import 'package:wave/services/api.dart';
import 'package:wave/services/geolocator.dart';
import 'package:wave/themes/dark.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/wave_localizations.dart';
import 'package:wave/themes/light.dart';

import 'firebase_options.dart';

void main() async {
  Intl.systemLocale = await findSystemLocale();
  await dotenv.load(fileName: '.env');

  ApiService apiService = ApiService.getInstance();
  GeolocatorService geolocatorService = GeolocatorService.getInstance();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_URL']!;
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeController>(
            create: (_) => ThemeController(),
          ),
          ChangeNotifierProvider<DeviceInfoController>(
            create: (_) => DeviceInfoController(),
          ),
          ChangeNotifierProvider<LocaleController>(
            create: (_) => LocaleController(),
          ),
          ChangeNotifierProvider<LoginController>(
            create: ((_) => LoginController()),
          ),
          ChangeNotifierProvider<StatusController>(
            create: ((_) => StatusController(apiService)),
          ),
          ChangeNotifierProvider<UserController>(
            create: ((_) => UserController()),
          ),
          ChangeNotifierProvider<GeolocatorController>(
            create: ((_) => GeolocatorController(geolocatorService)),
          ),
          ChangeNotifierProvider<DutyFormController>(
            create: ((_) => DutyFormController(apiService)),
          ),
          ChangeNotifierProvider<PatrolFormController>(
            create: ((_) => PatrolFormController(apiService)),
          ),
          ChangeNotifierProvider<DutyHistoryController>(
            create: ((_) => DutyHistoryController(apiService)),
          ),
          ChangeNotifierProvider<PatrolHistoryController>(
            create: ((_) => PatrolHistoryController(apiService)),
          ),
          ChangeNotifierProvider<MobilisationPlacesController>(
            create: ((_) => MobilisationPlacesController(apiService)),
          ),
          ChangeNotifierProvider<DutyFutureController>(
            create: ((_) => DutyFutureController(apiService)),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
  FlutterNativeSplash.remove();
}

final appRouter = AppRouter();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeController, LocaleController>(
      builder: (context, theme, locale, child) => MaterialApp.router(
        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser(),
        title: 'Wave',
        theme: lightTheme,
        debugShowCheckedModeBanner: false,
        darkTheme: darkTheme,
        themeMode: theme.waveThemeMode,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale(locale.waveLocale, locale.waveLocale.toUpperCase()),
        supportedLocales: const [
          Locale('en', 'EN'),
          Locale('pl', 'PL'),
        ],
      ),
    );
  }
}
