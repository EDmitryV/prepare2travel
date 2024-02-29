import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:prepare2travel/consts.dart';
import 'package:prepare2travel/core/util/utils.dart';
import 'package:prepare2travel/data/models/edit_item_dto.dart';
import 'package:prepare2travel/data/repositories/travel_repository.dart';
import 'package:prepare2travel/data/repositories/weather_repository.dart';
import 'package:prepare2travel/features/authentication/view/sign_in_screen.dart';
import 'package:prepare2travel/features/authentication/view/sign_up_screen.dart';
import 'package:prepare2travel/features/authentication/view/verify_email_screen.dart';
import 'package:prepare2travel/features/create_travel/view/create_travel_screen.dart';
import 'package:prepare2travel/features/edit_item/view/edit_item_screen.dart';
import 'package:prepare2travel/features/travel/view/travel_screen.dart';
import 'package:prepare2travel/features/travels_list/view/travels_list_screen_dart.dart';
import 'package:prepare2travel/firebase_options.dart';
import 'package:prepare2travel/route_names.dart';
import 'package:prepare2travel/theme/theme.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:prepare2travel/data/models/day.dart';
import 'package:prepare2travel/data/models/travel.dart';
import 'package:prepare2travel/data/models/item.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    //Регистрация логирования
    final talker = TalkerFlutter.init();
    GetIt.I.registerSingleton(talker);
    GetIt.I.registerSingleton(Utils());
    Bloc.observer = TalkerBlocObserver(
        talker: talker,
        settings: const TalkerBlocLoggerSettings(
            printStateFullData: false, printEventFullData: false));
    FlutterError.onError =
        (details) => GetIt.I<Talker>().handle(details.exception, details.stack);

    //Регистрация репозиториев
    await Hive.initFlutter();

    Hive.registerAdapter(DayAdapter());
    Hive.registerAdapter(ItemAdapter());
    Hive.registerAdapter(TravelAdapter());

    final travelBox = await Hive.openBox<Travel>(travelsBoxName);
    final userBox = await Hive.openBox<LocalUserData>(userBoxName);
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
    GetIt.I.registerLazySingleton<TravelRepository>(() => TravelRepository(
        travelBox: travelBox,
        dio: dio,
        localTravelRepository: GetIt.I<LocalTravelRepository>(),
        localUserRepository: GetIt.I<LocalUserRepository>()));
    GetIt.I.registerLazySingleton<LocalUserRepository>(
        () => LocalUserRepository(userBox: userBox));

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    runApp(Prepare2Travel());
  }, (error, stack) => GetIt.I<Talker>().handle(error, stack));
}

class Prepare2Travel extends StatelessWidget {
  Prepare2Travel({super.key});
  final _goRouter = GoRouter(
      redirect: (context, state) {
        bool loggedIn = false; //TODO add check for user authentication
        if (loggedIn) {
          return "/";
        } else {
          return "/signin";
        }
      },
      observers: [
        TalkerRouteObserver(GetIt.I<Talker>()),
      ],
      routes: [
        GoRoute(
            path: '/',
            builder: (context, state) => const TravelsListScreen(),
            routes: [
              GoRoute(
                  name: RouteNames.signIn,
                  path: 'signin',
                  builder: (context, state) => const SignInScreen()),
              GoRoute(
                  name: RouteNames.signUp,
                  path: 'signup',
                  builder: (context, state) => const SignUpScreen()),
              GoRoute(
                  name: RouteNames.verifyEmail,
                  path: 'verifyemail',
                  builder: (context, state) => const VerifyEmailScreen()),
              GoRoute(
                  name: RouteNames.createTravel,
                  path: 'createtravel',
                  builder: (context, state) => const CreateTravelScreen()),
              GoRoute(
                name: RouteNames.editItem,
                path: 'edititem',
                builder: (context, state) => EditItemScreen(
                    item: (state.extra as EditItemDto).item,
                    travel: (state.extra as EditItemDto).travel),
              ),
              GoRoute(
                  name: RouteNames.travel,
                  path: 'travel',
                  builder: (context, state) => TravelScreen(
                        travel: state.extra as Travel,
                      )),
            ]),
      ]);
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
      routerConfig: _goRouter,
    );
  }
}
