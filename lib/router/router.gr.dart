// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    CreateTravelRoute.name: (routeData) {
      final args = routeData.argsAs<CreateTravelRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CreateTravelScreen(
          key: args.key,
          user: args.user,
        ),
      );
    },
    EditItemRoute.name: (routeData) {
      final args = routeData.argsAs<EditItemRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditItemScreen(
          key: args.key,
          item: args.item,
          travel: args.travel,
        ),
      );
    },
    EditUserRoute.name: (routeData) {
      final args = routeData.argsAs<EditUserRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditUserScreen(
          key: args.key,
          user: args.user,
        ),
      );
    },
    TravelRoute.name: (routeData) {
      final args = routeData.argsAs<TravelRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TravelScreen(
          key: args.key,
          travel: args.travel,
        ),
      );
    },
    TravelsListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TravelsListScreen(),
      );
    },
  };
}

/// generated route for
/// [CreateTravelScreen]
class CreateTravelRoute extends PageRouteInfo<CreateTravelRouteArgs> {
  CreateTravelRoute({
    Key? key,
    required User user,
    List<PageRouteInfo>? children,
  }) : super(
          CreateTravelRoute.name,
          args: CreateTravelRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'CreateTravelRoute';

  static const PageInfo<CreateTravelRouteArgs> page =
      PageInfo<CreateTravelRouteArgs>(name);
}

class CreateTravelRouteArgs {
  const CreateTravelRouteArgs({
    this.key,
    required this.user,
  });

  final Key? key;

  final User user;

  @override
  String toString() {
    return 'CreateTravelRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [EditItemScreen]
class EditItemRoute extends PageRouteInfo<EditItemRouteArgs> {
  EditItemRoute({
    Key? key,
    required Item? item,
    required Travel travel,
    List<PageRouteInfo>? children,
  }) : super(
          EditItemRoute.name,
          args: EditItemRouteArgs(
            key: key,
            item: item,
            travel: travel,
          ),
          initialChildren: children,
        );

  static const String name = 'EditItemRoute';

  static const PageInfo<EditItemRouteArgs> page =
      PageInfo<EditItemRouteArgs>(name);
}

class EditItemRouteArgs {
  const EditItemRouteArgs({
    this.key,
    required this.item,
    required this.travel,
  });

  final Key? key;

  final Item? item;

  final Travel travel;

  @override
  String toString() {
    return 'EditItemRouteArgs{key: $key, item: $item, travel: $travel}';
  }
}

/// generated route for
/// [EditUserScreen]
class EditUserRoute extends PageRouteInfo<EditUserRouteArgs> {
  EditUserRoute({
    Key? key,
    required User? user,
    List<PageRouteInfo>? children,
  }) : super(
          EditUserRoute.name,
          args: EditUserRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'EditUserRoute';

  static const PageInfo<EditUserRouteArgs> page =
      PageInfo<EditUserRouteArgs>(name);
}

class EditUserRouteArgs {
  const EditUserRouteArgs({
    this.key,
    required this.user,
  });

  final Key? key;

  final User? user;

  @override
  String toString() {
    return 'EditUserRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [TravelScreen]
class TravelRoute extends PageRouteInfo<TravelRouteArgs> {
  TravelRoute({
    Key? key,
    required Travel travel,
    List<PageRouteInfo>? children,
  }) : super(
          TravelRoute.name,
          args: TravelRouteArgs(
            key: key,
            travel: travel,
          ),
          initialChildren: children,
        );

  static const String name = 'TravelRoute';

  static const PageInfo<TravelRouteArgs> page = PageInfo<TravelRouteArgs>(name);
}

class TravelRouteArgs {
  const TravelRouteArgs({
    this.key,
    required this.travel,
  });

  final Key? key;

  final Travel travel;

  @override
  String toString() {
    return 'TravelRouteArgs{key: $key, travel: $travel}';
  }
}

/// generated route for
/// [TravelsListScreen]
class TravelsListRoute extends PageRouteInfo<void> {
  const TravelsListRoute({List<PageRouteInfo>? children})
      : super(
          TravelsListRoute.name,
          initialChildren: children,
        );

  static const String name = 'TravelsListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
