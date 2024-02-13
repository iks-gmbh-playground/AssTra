// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'do.halloffame.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HallOfFameEntryAdapter extends TypeAdapter<HallOfFameEntry> {
  @override
  final int typeId = 1;

  @override
  HallOfFameEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HallOfFameEntry(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as int,
      fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HallOfFameEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.numberOfOkQuestInSequence)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.millisNeeded)
      ..writeByte(4)
      ..write(obj.direction);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HallOfFameEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
