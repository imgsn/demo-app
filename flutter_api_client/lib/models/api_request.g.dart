// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_request.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApiRequestAdapter extends TypeAdapter<ApiRequest> {
  @override
  final int typeId = 0;

  @override
  ApiRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiRequest(
      id: fields[0] as String,
      method: fields[1] as String,
      url: fields[2] as String,
      headers: (fields[3] as Map).cast<String, String>(),
      body: fields[4] as String?,
      timestamp: fields[5] as DateTime,
      statusCode: fields[6] as int?,
      response: fields[7] as String?,
      error: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ApiRequest obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.method)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.headers)
      ..writeByte(4)
      ..write(obj.body)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.statusCode)
      ..writeByte(7)
      ..write(obj.response)
      ..writeByte(8)
      ..write(obj.error);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
