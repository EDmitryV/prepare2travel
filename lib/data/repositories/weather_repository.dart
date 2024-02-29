import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:prepare2travel/core/error/failures.dart';
import 'package:prepare2travel/core/util/utils.dart';
import 'package:prepare2travel/keys.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ApiWeatherRepository {
  final Dio dio;

  ApiWeatherRepository({required this.dio});

  Future<Either<Failure, List<dynamic>>> getWeatherForecast(
      String city,
      String state,
      String country,
      DateTime startDate,
      DateTime endDate) async {
    if (await GetIt.I<Utils>().networkConnected()) {
      try {
        var response = await dio.get(
          'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$city%2C%20$state%2C%20$country/${DateFormat("yyyy-MM-dd").format(startDate)}/${DateFormat("yyyy-MM-dd").format(endDate)}?unitGroup=metric&elements=tempmax%2Ctempmin%2Chumidity%2Cpreciptype&include=days%2Cstatsfcst%2Cfcst&key=$visualcrossingApiKey&contentType=json', //TODO internationalize C
        );
        if (response.statusCode == 200) {
          return Right(response.data['days']);
        } else {
          return Left(ServerFailure());
        }
      } catch (e, st) {
        GetIt.I<Talker>().handle(e, st);
        return Left(UnexpectedFailure());
      }
    } else {
      GetIt.I<Talker>().error("Cant get weather data cause device is offline");
      return Left(OfflineFailure());
    }
  }
}
