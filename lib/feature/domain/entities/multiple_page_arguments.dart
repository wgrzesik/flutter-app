import 'package:note_app/feature/domain/entities/set_entity.dart';

class MultiplePageArguments {
  final SetEntity setEntity;
  final String uid;

  MultiplePageArguments(this.setEntity, this.uid);
}

class MultiplePageArgumentsSetName {
  final String setName;
  final String uid;
  final int badAnswears;
  final int goodAnswears;

  MultiplePageArgumentsSetName(
      this.setName, this.uid, this.badAnswears, this.goodAnswears);
}
