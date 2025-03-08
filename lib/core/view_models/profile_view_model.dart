import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palkkaran/core/enums/view_state.dart';
import 'package:palkkaran/core/models/message_model.dart';
import 'package:palkkaran/core/models/profile_model.dart';
import 'package:palkkaran/core/services/profile_service.dart';

class ProfileViewModel extends StateNotifier<ProfileState> {
  ProfileViewModel() : super(ProfileState());

  Future<void> getProfile() async {
    state = state.copyWith(profileState: ViewState.loading);
    ProfileModel? profileModel = await ProfileService.getProfile();
    state = state.copyWith(
        profileState: ViewState.idle, profileModel: profileModel);
  }

    Future<MessageModel?> updatePassword(Map<String, dynamic> payload) async {
    MessageModel? messageModel = await ProfileService.updatePassword(payload);

    

    return messageModel;
  }

  Future<MessageModel?> updateProfile(Map<String, dynamic> payload) async {
    log(payload.toString());
    state = state.copyWith(profileState: ViewState.loading);
    MessageModel? messageModel = await ProfileService.updateProfile(payload);
    state = state.copyWith(
      profileState: ViewState.idle,
    );
    return messageModel;
  }
}

class ProfileState {
  final ViewState profileState;
  final ViewState profileUpdateState;
  final ProfileModel? profileModel;

  ProfileState(
      {this.profileState = ViewState.idle,
      this.profileUpdateState = ViewState.idle,
      this.profileModel});

  ProfileState copyWith({
    ViewState? profileState,
    ViewState? profileUpdateState,
    ProfileModel? profileModel,
  }) {
    return ProfileState(
        profileState: profileState ?? this.profileState,
        profileUpdateState: profileState ?? this.profileUpdateState,
        profileModel: profileModel ?? this.profileModel);
  }
}

final profileProvider = StateNotifierProvider<ProfileViewModel, ProfileState>(
    (ref) => ProfileViewModel());
