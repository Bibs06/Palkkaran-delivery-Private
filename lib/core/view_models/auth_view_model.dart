import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palkkaran/core/enums/view_state.dart';
import 'package:palkkaran/core/models/message_model.dart';
import 'package:palkkaran/core/services/auth_service.dart';

class AuthViewModel extends StateNotifier<ViewState> {
  AuthViewModel() : super(ViewState.idle);

  Future<MessageModel?> login(Map<String, dynamic> payload) async {
    state = ViewState.loading;
    MessageModel? messageModel = await AuthService.login(payload);
    state = ViewState.idle;
    return messageModel;
  }

  Future<MessageModel?> signUp(Map<String, dynamic> payload) async {
    state = ViewState.loading;
    MessageModel? messageModel = await AuthService.signUp(payload);
    state = ViewState.idle;
    return messageModel;
  }
}

final authProvider =
    StateNotifierProvider<AuthViewModel, ViewState>((ref) => AuthViewModel());
