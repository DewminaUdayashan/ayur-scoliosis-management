// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionNote _$SessionNoteFromJson(Map<String, dynamic> json) => SessionNote(
  id: json['id'] as String,
  patientEventId: json['patientEventId'] as String,
  noteContent: json['noteContent'] as String,
);

Map<String, dynamic> _$SessionNoteToJson(SessionNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientEventId': instance.patientEventId,
      'noteContent': instance.noteContent,
    };
