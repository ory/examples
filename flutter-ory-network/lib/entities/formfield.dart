// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'formfield.freezed.dart';

@freezed
sealed class FormField<T> with _$FormField {
  const factory FormField({T? value, String? errorMessage}) = _FormField;
}
