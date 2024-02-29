import 'package:prepare2travel/data/models/item.dart';
import 'package:prepare2travel/data/models/travel.dart';

class EditItemDto {
  final Travel travel;
  final Item? item;

  EditItemDto({required this.travel, required this.item});
}
