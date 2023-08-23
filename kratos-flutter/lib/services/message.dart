import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class UiNodeMessage with _$UiNodeMessage {
  const factory UiNodeMessage(
      {required int id,
      required String text,
      required MessageType type,
      required Context context}) = _UiNodeMessage;

  factory UiNodeMessage.fromJson(Map<String, dynamic> json) =>
      _$UiNodeMessageFromJson(json);
}

@freezed
class Context with _$Context {
  const factory Context({@Default(Property.general) Property property}) =
      _Context;

  factory Context.fromJson(Map<String, dynamic> json) =>
      _$ContextFromJson(json);
}

// speicifies which group the node belongs to
enum Property { identifier, password, general }

// specifies message type
enum MessageType { info, error, success }
