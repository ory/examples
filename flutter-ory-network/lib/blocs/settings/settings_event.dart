// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class CreateSettingsFlow extends SettingsEvent {}

final class ChangePassword extends SettingsEvent {
  final String value;

  ChangePassword({required this.value});

  @override
  List<Object> get props => [value];
}

final class ChangePasswordVisibility extends SettingsEvent {
  final bool value;

  ChangePasswordVisibility({required this.value});

  @override
  List<Object> get props => [value];
}

final class SubmitNewPassword extends SettingsEvent {
  final String flowId;
  final String value;

  SubmitNewPassword({required this.flowId, required this.value});

  @override
  List<Object> get props => [flowId, value];
}

class ChangeNodeValue<T> extends SettingsEvent {
  final T value;
  final String name;

  ChangeNodeValue({required this.value, required this.name});
}

class SubmitNewSettings extends SettingsEvent {
  final String flowId;
  final UiNodeGroupEnum group;

  SubmitNewSettings({required this.flowId, required this.group});
  @override
  List<Object> get props => [flowId, group];
}
