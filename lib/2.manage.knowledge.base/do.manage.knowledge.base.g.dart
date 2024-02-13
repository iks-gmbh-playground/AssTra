// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'do.manage.knowledge.base.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KnowledgeFieldAdapter extends TypeAdapter<KnowledgeField> {
  @override
  final int typeId = 0;

  @override
  KnowledgeField read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    KnowledgeField toReturn = KnowledgeField(
      fields[0] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[1] as String,
      fields[2] as String,
    );
    fields[6].forEach((key,value) => toReturn.addKeyValuePair(key,value));
    return toReturn;
  }

  @override
  void write(BinaryWriter writer, KnowledgeField obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.knowledgeArea)
      ..writeByte(1)
      ..write(obj.questionTemplateForward)
      ..writeByte(2)
      ..write(obj.questionTemplateBackwards)
      ..writeByte(3)
      ..write(obj.keyName)
      ..writeByte(4)
      ..write(obj.valueName)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.keyValuePairs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KnowledgeFieldAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
