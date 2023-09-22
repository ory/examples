// Copyright © 2023 Ory Corp
// SPDX-License-Identifier: Apache-2.0

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ory_client/ory_client.dart';
import 'package:ory_network_flutter/entities/message.dart';
import 'package:ory_network_flutter/repositories/auth.dart';

import '../../repositories/settings.dart';
import '../../services/exceptions.dart';
import '../auth/auth_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

part 'settings_bloc.freezed.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AuthBloc authBloc;
  final SettingsRepository repository;
  late SettingsEvent? _previousEvent;
  SettingsBloc({required this.authBloc, required this.repository})
      : super(SettingsState()) {
    on<CreateSettingsFlow>(_onCreateSettingsFlow);
    on<GetSettingsFlow>(_onGetSettingsFlow);
    on<ChangePasswordVisibility>(_onChangePasswordVisibility);
    on<ChangeNodeValue>(_onChangeNodeValue, transformer: sequential());
    on<ResetButtonValues>(_onResetButtonValues);
    on<UpdateSettingsFlow>(_onUpdateSettingsFlow);
  }

  @override
  void onEvent(SettingsEvent event) {
    _previousEvent = event;
    super.onEvent(event);
  }

  void retry() {
    if (_previousEvent != null) {
      add(_previousEvent!);
    }
  }

  _onChangePasswordVisibility(
      ChangePasswordVisibility event, Emitter<SettingsState> emit) {
    emit(state.copyWith(
        isPasswordHidden: event.value, isSessionRefreshRequired: false));
  }

  _onChangeNodeValue(ChangeNodeValue event, Emitter<SettingsState> emit) {
    if (state.settingsFlow != null) {
      final newSettingsState = repository.changeNodeValue(
          settings: state.settingsFlow!, name: event.name, value: event.value);
      emit(state.copyWith(settingsFlow: newSettingsState, message: null));
    }
  }

  _onResetButtonValues(ResetButtonValues event, Emitter<SettingsState> emit) {
    if (state.settingsFlow != null) {
      final updatedSettings =
          repository.resetButtonValues(settingsFlow: state.settingsFlow!);
      emit(state.copyWith(settingsFlow: updatedSettings));
    }
  }

  Future<void> _onUpdateSettingsFlow(
      UpdateSettingsFlow event, Emitter<SettingsState> emit) async {
    try {
      if (state.settingsFlow != null) {
        emit(state.copyWith(
            isLoading: true, isSessionRefreshRequired: false, message: null));
        final settings = await repository.updateSettingsFlow(
            flowId: state.settingsFlow!.id,
            group: event.group,
            nodes: state.settingsFlow!.ui.nodes.toList());
        emit(state.copyWith(isLoading: false, settingsFlow: settings));
      }
    } on CustomException catch (e) {
      if (e case UnauthorizedException _) {
        // change auth status as the user is not authenticated
        authBloc.add(ChangeAuthStatus(status: AuthStatus.unauthenticated));
      } else if (e case FlowExpiredException _) {
        // create new settings flow
        add(GetSettingsFlow(flowId: e.flowId));
      } else if (e case SessionRefreshRequiredException _) {
        // set session required flag to navigate to login page
        emit(state.copyWith(isSessionRefreshRequired: true, isLoading: false));
      } else if (e case UnknownException _) {
        emit(state.copyWith(
            isLoading: false,
            message: NodeMessage(text: e.message, type: MessageType.error)));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  Future<void> _onCreateSettingsFlow(
      SettingsEvent event, Emitter<SettingsState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, message: null));

      final settingsFlow = await repository.createSettingsFlow();

      emit(state.copyWith(isLoading: false, settingsFlow: settingsFlow));
    } on CustomException catch (e) {
      if (e case UnauthorizedException _) {
        // change auth status as the user is not authenticated
        authBloc.add(ChangeAuthStatus(status: AuthStatus.unauthenticated));
      } else if (e case UnknownException _) {
        emit(state.copyWith(
            isLoading: false,
            message: NodeMessage(text: e.message, type: MessageType.error)));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  Future<void> _onGetSettingsFlow(
      GetSettingsFlow event, Emitter<SettingsState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final settingsFlow =
          await repository.getSettingsFlow(flowId: event.flowId);
      emit(state.copyWith(isLoading: false, settingsFlow: settingsFlow));
    } on CustomException catch (e) {
      if (e case UnauthorizedException _) {
        // change auth status as the user is not authenticated
        authBloc.add(ChangeAuthStatus(status: AuthStatus.unauthenticated));
      } else if (e case UnknownException _) {
        emit(state.copyWith(
            isLoading: false,
            message: NodeMessage(text: e.message, type: MessageType.error)));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    }
  }
}
