import 'package:freezed_annotation/freezed_annotation.dart';

part 'formfield.freezed.dart';

@freezed
sealed class FormField<T> with _$FormField {
  const factory FormField({T? value, String? errorMessage}) = _FormField;
}
