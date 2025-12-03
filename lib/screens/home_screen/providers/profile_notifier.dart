import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_vocab/core/storage/app_perfs.dart';

class ProfileState {
  final String name;
  final String? imagePath;
  ProfileState({required this.name, this.imagePath});

  ProfileState copyWith({String? name, String? imagePath}) {
    return ProfileState(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    state = ProfileState(name: "Your Name", imagePath: null);
    loadProfile();
    return state;
  }

  Future<void> loadProfile() async {
    final name = await AppPrefs.getName() ?? "Your Name";
    final img = await AppPrefs.getImage();
    state = ProfileState(name: name, imagePath: img);
  }

  Future<void> setName(String name) async {
    await AppPrefs.setName(name);
    state = state.copyWith(name: name);
  }

  Future<void> setImage(String path) async {
    await AppPrefs.setImage(path);
    state = state.copyWith(imagePath: path);
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  () => ProfileNotifier(),
);
