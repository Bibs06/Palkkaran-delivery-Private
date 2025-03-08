import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddImageViewModel extends StateNotifier<String?> {
  AddImageViewModel() : super(null);

  void showPermissionDialog(BuildContext context, String message) {
    Navigator.pop(context);

    if (context.mounted) {
      if (Platform.isIOS) {
        // Cupertino dialog for iOS
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Permissions Required'),
            content: Text(
              '$message'
              'Please enable this permission in your device settings to continue.',
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await openAppSettings(); // Open app settings
                },
                child: const Text('Open Settings'),
              ),
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      } else {
        // Material dialog for Android
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permissions Required'),
            content: Text(
              '$message'
              'Please enable this permission in your app settings to continue.',
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await openAppSettings(); // Open app settings
                },
                child: const Text('Open Settings'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> pickImage(ImageSource source, BuildContext context) async {
    try {
      XFile? image =
          await ImagePicker().pickImage(source: source, imageQuality: 10);
      state = image!.path;
      log(state.toString());
    } catch (e) {
      PermissionStatus cameraStatus = await Permission.camera.status;
      PermissionStatus photoStatus = await Permission.photos.status;
      if (Platform.isIOS && photoStatus.isDenied) {
        showPermissionDialog(context,
            'Gallery access is required to select photos from your device.');
      }
      if (cameraStatus.isDenied) {
        showPermissionDialog(
            context, 'Camera access is required to take photos');
      }
    }
  }
}

final addImageProvider =
    StateNotifierProvider<AddImageViewModel, String?>((ref) {
  return AddImageViewModel();
});
