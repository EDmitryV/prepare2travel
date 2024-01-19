import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:prepare2travel/data/models/item.dart';
import 'package:prepare2travel/data/models/travel.dart';
import 'package:prepare2travel/data/models/user.dart';
import 'package:prepare2travel/features/create_travel/view/create_travel_screen.dart';
import 'package:prepare2travel/features/edit_item/view/edit_item_screen.dart';
import 'package:prepare2travel/features/edit_user/view/edit_user_screen.dart';
import 'package:prepare2travel/features/travel/view/travel_screen.dart';
import 'package:prepare2travel/features/travels_list/view/travels_list_screen_dart.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: TravelsListRoute.page, path: '/'),
    AutoRoute(page: EditUserRoute.page),
    AutoRoute(page: CreateTravelRoute.page),
    AutoRoute(page: TravelRoute.page),
    AutoRoute(page: EditItemRoute.page),
      ];
}