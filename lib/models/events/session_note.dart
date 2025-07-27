import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_note.g.dart';

@JsonSerializable()
class SessionNote extends Equatable {
  final String id;
  final String patientEventId;
  final String noteContent;

  const SessionNote({
    required this.id,
    required this.patientEventId,
    required this.noteContent,
  });

  factory SessionNote.fromJson(Map<String, dynamic> json) =>
      _$SessionNoteFromJson(json);
  Map<String, dynamic> toJson() => _$SessionNoteToJson(this);

  @override
  List<Object?> get props => [id];
}
