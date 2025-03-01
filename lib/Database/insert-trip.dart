import 'dart:typed_data';

import 'package:floor/floor.dart';

@entity
class Trip {
  @PrimaryKey(autoGenerate: true)
  final int? tripId;

  final String tripBackgroundImage;
  final String tripTitle;
  final String tripDescription;
  final String tripStartDate;
  final String tripEndDate;
  final bool isTripDeleted;
  final Uint8List? tripImage;

  Trip(
      this.tripId,
      this.tripBackgroundImage,
      this.tripTitle,
      this.tripDescription,
      this.tripStartDate,
      this.tripEndDate,
      this.isTripDeleted,
      this.tripImage);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Trip &&
          runtimeType == other.runtimeType &&
          tripId == other.tripId &&
          tripBackgroundImage == other.tripBackgroundImage &&
          tripTitle == other.tripTitle &&
          tripDescription == other.tripTitle &&
          tripStartDate == other.tripStartDate &&
          tripEndDate == other.tripEndDate;

  @override
  int get hashCode => tripId.hashCode ^ tripTitle.hashCode;

  @override
  String toString() {
    return 'Task{id: $tripId, message: $tripTitle}';
  }
}
