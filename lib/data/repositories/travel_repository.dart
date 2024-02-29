// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:prepare2travel/core/error/failures.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:prepare2travel/data/models/day.dart';
import 'package:prepare2travel/data/models/item.dart';
import 'package:prepare2travel/data/models/travel.dart';

class TravelRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<Either<Failure, Travel>> createTravel(Travel travel) async {
    User? user = _auth.currentUser;
    try {
      DocumentReference<Map<String, dynamic>> travelDocRef = await _db
          .collection("users")
          .doc(user!.uid)
          .collection("travels")
          .add(travel.toMap());
      DocumentSnapshot<Map<String, dynamic>> travelDocSnap =
          await travelDocRef.get();
      Travel actualTravel = Travel.fromSnapshot(travelDocSnap);
      String travelId = actualTravel.id!;
      for (var day in travel.days) {
        DocumentReference<Map<String, dynamic>> dayDocRef = await _db
            .collection("users")
            .doc(user.uid)
            .collection("travels")
            .doc(travelId)
            .collection("days")
            .add(day.toMap());
        DocumentSnapshot<Map<String, dynamic>> dayDocSnap =
            await dayDocRef.get();
        actualTravel.days.add(Day.fromSnapshot(dayDocSnap));
      }
      for (var item in travel.items) {
        DocumentReference<Map<String, dynamic>> itemDocRef = await _db
            .collection("users")
            .doc(user.uid)
            .collection("travels")
            .doc(travelId)
            .collection("items")
            .add(item.toMap());
        DocumentSnapshot<Map<String, dynamic>> itemDocSnap =
            await itemDocRef.get();
        actualTravel.items.add(Item.fromSnapshot(itemDocSnap));
      }
      return Right(actualTravel);
    } catch (e, st) {
      GetIt.I<Talker>().error(e, st);
      return Left(UnexpectedFailure());
    }
  }

  Future<Either<Failure, bool>> deleteTravel(Travel travel) async {
    User? user = _auth.currentUser;
    try {
      await _db
          .collection("users")
          .doc(user!.uid)
          .collection("travels")
          .doc(travel.id!)
          .delete();
      return const Right(true);
    } catch (e, st) {
      GetIt.I<Talker>().error(e, st);
      return Left(UnexpectedFailure());
    }
  }

  Future<Either<Failure, List<Travel>>> getAllTravels() async {
    User? user = _auth.currentUser;
    try {
      var travels = await _db
          .collection("user")
          .doc(user!.uid)
          .collection("travels")
          .get();
      List<Travel> results = [];
      for (var travelDoc in travels.docs) {
        var travel = await getTravel(travelDoc.id);
        if (travel.isLeft) {
          return Left(UnexpectedFailure());
        } else {
          results.add(travel.right!);
        }
      }
      return Right(results);
    } catch (e, st) {
      GetIt.I<Talker>().error(e, st);
      return Left(UnexpectedFailure());
    }
  }

  Future<Either<Failure, Travel?>> getTravel(String id) async {
    User? user = _auth.currentUser;
    try {
      var travelDocRef =
          _db.collection("users").doc(user!.uid).collection("travels").doc(id);
      var travel = Travel.fromSnapshot(await travelDocRef.get());
      var itemsQuerySnap = await travelDocRef.collection("items").get();
      for (var itemDoc in itemsQuerySnap.docs) {
        travel.items.add(Item.fromSnapshot(itemDoc));
      }
      var daysQuerySnap = await travelDocRef.collection("days").get();
      for (var dayDoc in daysQuerySnap.docs) {
        travel.days.add(Day.fromSnapshot(dayDoc));
      }
      return Right(travel);
    } catch (e, st) {
      GetIt.I<Talker>().error(e, st);
      return Left(UnexpectedFailure());
    }
  }

  Future<Either<Failure, Travel>> updateTravel(Travel travel) async {
    User? user = _auth.currentUser;
    var travelDocRef = _db
        .collection("users")
        .doc(user!.uid)
        .collection("travels")
        .doc(travel.id!);
    try {
      for (var day in travel.days) {
        await travelDocRef.collection("days").doc(day.id!).set(day.toMap());
      }
      for (var item in travel.items) {
        await travelDocRef.collection("items").doc(item.id!).set(item.toMap());
      }
      await travelDocRef.set(travel.toMap());
      return Right(travel);
    } catch (e, st) {
      GetIt.I<Talker>().error(e, st);
      return Left(UnexpectedFailure());
    }
  }
}
