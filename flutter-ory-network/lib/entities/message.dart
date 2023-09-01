// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class NodeMessage with _$NodeMessage {
  const factory NodeMessage(
      {required int id,
      required String text,
      required MessageType type,
      @Default('general') String attr}) = _NodeMessage;

  factory NodeMessage.fromJson(Map<String, dynamic> json) =>
      _$NodeMessageFromJson(json);
}

// specifies message type
enum MessageType { info, error, success }
