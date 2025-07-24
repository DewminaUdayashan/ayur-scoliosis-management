import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final String id;
  final String name;
  const Patient({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
