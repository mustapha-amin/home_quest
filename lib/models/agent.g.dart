// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgentModelAdapter extends TypeAdapter<AgentModel> {
  @override
  final int typeId = 0;

  @override
  AgentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AgentModel(
      agentID: fields[1] as String,
      name: fields[2] as String,
      phoneNumber: fields[0] as int,
      profilePicture: fields[3] as String,
      listingsIDs: (fields[4] as List).cast<String>(),
      rating: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AgentModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.phoneNumber)
      ..writeByte(1)
      ..write(obj.agentID)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.profilePicture)
      ..writeByte(4)
      ..write(obj.listingsIDs)
      ..writeByte(5)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
