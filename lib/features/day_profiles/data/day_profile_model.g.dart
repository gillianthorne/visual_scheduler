// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayProfileAdapter extends TypeAdapter<DayProfile> {
  @override
  final int typeId = 4;

  @override
  DayProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayProfile(
      id: fields[0] as String,
      name: fields[1] as String,
      tasks: (fields[2] as List).cast<ProfileTask>(),
      repeatOnWeekdays: (fields[3] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, DayProfile obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.tasks)
      ..writeByte(3)
      ..write(obj.repeatOnWeekdays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
