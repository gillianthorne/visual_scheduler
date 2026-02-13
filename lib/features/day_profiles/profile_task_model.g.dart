// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileTaskAdapter extends TypeAdapter<ProfileTask> {
  @override
  final int typeId = 5;

  @override
  ProfileTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileTask(
      id: fields[0] as String,
      title: fields[1] as String,
      startOffset: fields[2] as Duration,
      duration: fields[8] as Duration,
      categoryId: fields[3] as String?,
      templateId: fields[4] as String?,
      allowOverlap: fields[5] as bool,
      isReminder: fields[6] as bool,
      notes: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileTask obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.startOffset)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.templateId)
      ..writeByte(5)
      ..write(obj.allowOverlap)
      ..writeByte(6)
      ..write(obj.isReminder)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
