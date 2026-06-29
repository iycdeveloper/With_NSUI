// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'twitter_feed_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TwitterFeedModelAdapter extends TypeAdapter<TwitterFeedModel> {
  @override
  final int typeId = 1;

  @override
  TwitterFeedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TwitterFeedModel(
      text: fields[0] as String?,
      url: fields[1] as String?,
      name: fields[3] as String?,
      profileImageUrl: fields[2] as String?,
      date: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TwitterFeedModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.profileImageUrl)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TwitterFeedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
