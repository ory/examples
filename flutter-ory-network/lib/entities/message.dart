// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class NodeMessage with _$NodeMessage {
  const factory NodeMessage(
      {int? id,
      required String text,
      required MessageType type,
      // allows to differentiate between contexts
      @Default('general') String attr}) = _NodeMessage;

  factory NodeMessage.fromJson(Map<String, dynamic> json) =>
      _$NodeMessageFromJson(json);
}

// specifies message type
enum MessageType { info, error, success }

// extension to convert string to enum value
extension MessageTypeExtension on String {
  MessageType get messageType {
    switch (this) {
      case 'info':
        return MessageType.info;
      case 'error':
        return MessageType.error;
      case 'success':
        return MessageType.success;
      default:
        return MessageType.info;
    }
  }
}
