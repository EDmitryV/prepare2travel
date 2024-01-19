import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:prepare2travel/consts.dart';
import 'package:prepare2travel/data/models/user_sex.dart';
import 'package:prepare2travel/data/repositories/api/api_travel_repository.dart';
import 'package:prepare2travel/data/repositories/api/api_user_repository.dart';
import 'package:prepare2travel/data/repositories/api/api_weather_repository.dart';
import 'package:prepare2travel/data/repositories/local/local_travel_repository.dart';
import 'package:prepare2travel/data/repositories/local/local_user_repository.dart';
import 'package:prepare2travel/router/router.dart';
import 'package:prepare2travel/theme/theme.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:prepare2travel/data/models/day.dart';
import 'package:prepare2travel/data/models/user.dart';
import 'package:prepare2travel/data/models/travel.dart';
import 'package:prepare2travel/data/models/item.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    //Регистрация логирования
    final talker = TalkerFlutter.init();
    GetIt.I.registerSingleton(talker);
    Bloc.observer = TalkerBlocObserver(
        talker: talker,
        settings: const TalkerBlocLoggerSettings(
            printStateFullData: false, printEventFullData: false));
    FlutterError.onError =
        (details) => GetIt.I<Talker>().handle(details.exception, details.stack);

    //Регистрация репозиториев
    await Hive.initFlutter();

    // Hive.deleteBoxFromDisk(travelsBoxName);
    // Hive.deleteBoxFromDisk(userBoxName);

    Hive.registerAdapter(DayAdapter());
    Hive.registerAdapter(ItemAdapter());
    Hive.registerAdapter(TravelAdapter());
    Hive.registerAdapter(UserSexAdapter());
    Hive.registerAdapter(UserAdapter());

    final travelBox = await Hive.openBox<Travel>(travelsBoxName);
    final userBox = await Hive.openBox<User>(userBoxName);
    final Dio dio = Dio();
    dio.interceptors.add(TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(printResponseData: false)));

    GetIt.I.registerLazySingleton<ApiUserRepository>(() => ApiUserRepository(
        userBox: userBox,
        dio: dio,
        localUserRepository: GetIt.I<LocalUserRepository>()));
    GetIt.I.registerLazySingleton<ApiWeatherRepository>(
        () => ApiWeatherRepository(dio: dio));
    GetIt.I.registerLazySingleton<LocalTravelRepository>(
        () => LocalTravelRepository(travelBox: travelBox));
    GetIt.I.registerLazySingleton<ApiTravelRepository>(() =>
        ApiTravelRepository(
            travelBox: travelBox,
            dio: dio,
            localTravelRepository: GetIt.I<LocalTravelRepository>(),
            localUserRepository: GetIt.I<LocalUserRepository>()));
    GetIt.I.registerLazySingleton<LocalUserRepository>(
        () => LocalUserRepository(userBox: userBox));

    runApp(Prepare2Travel());
  }, (error, stack) => GetIt.I<Talker>().handle(error, stack));
}

class Prepare2Travel extends StatelessWidget {
  Prepare2Travel({super.key});
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: FToastBuilder(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
      ],
      title: 'Prepare2Travel',
      theme: lightTheme,
      routerConfig: _appRouter.config(
          navigatorObservers: () => [
                TalkerRouteObserver(GetIt.I<Talker>()),
              ]),
    );
  }
}
