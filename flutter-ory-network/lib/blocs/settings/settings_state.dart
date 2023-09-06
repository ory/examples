// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

part of 'settings_bloc.dart';

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState(
      {String? flowId,
      @Default(FormField<String>(value: '')) FormField<String> password,
      @Default(true) bool isPasswordHidden,
      @Default(false) bool isLoading,
      NodeMessage? message}) = _SettingsState;
}
