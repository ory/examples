import 'package:freezed_annotation/freezed_annotation.dart';

import 'message.dart';
import 'node_attribute.dart';

part 'form_node.freezed.dart';
part 'form_node.g.dart';

@freezed
sealed class FormNode with _$FormNode {
  const factory FormNode(
      {required NodeAttribute attributes,
      required List<NodeMessage> messages}) = _FormNode;

  factory FormNode.fromJson(Map<String, dynamic> json) =>
      _$FormNodeFromJson(json);
}
