// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_request.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyRequestAdapter extends TypeAdapter<MyRequest> {
  @override
  final int typeId = 4;

  @override
  MyRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyRequest(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MyRequest obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.paymenten)
      ..writeByte(2)
      ..write(obj.decen)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.paymentar)
      ..writeByte(5)
      ..write(obj.decar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
