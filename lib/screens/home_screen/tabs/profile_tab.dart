import 'dart:io';

import 'package:chat_vocab/core/storage/app_perfs.dart';
import 'package:chat_vocab/screens/home_screen/providers/practice_notifier.dart';
import 'package:chat_vocab/screens/home_screen/providers/profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';

final firstOpenDateProvider = FutureProvider<DateTime>((ref) async {
  return await AppPrefs.getFirstOpenDate() ?? DateTime.now();
});

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final firstOpenAsync = ref.watch(firstOpenDateProvider);
    final practicedDaysAsync = ref.watch(practiceProvider);

    return firstOpenAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => const Center(child: Text("Error loading date")),
      data: (firstOpen) {
        final today = DateTime.now();
        final nextMonth = DateTime(today.year, today.month + 2, 0);
        final lastDay = nextMonth.isBefore(firstOpen) ? firstOpen : nextMonth;

        return Container(
          color: const Color(0xFF0F1624),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // PROFILE IMAGE
              GestureDetector(
                onTap: () => _showEditProfileDialog(context, ref),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white24,
                  backgroundImage: profile.imagePath != null
                      ? FileImage(File(profile.imagePath!))
                      : null,
                  child: profile.imagePath == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),

              const SizedBox(height: 12),

              // NAME
              Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // EDIT BUTTON
              GestureDetector(
                onTap: () => _showEditProfileDialog(context, ref),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2A38),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // CALENDAR
              Expanded(
                child: practicedDaysAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, st) =>
                      const Center(child: Text("Error loading practice days")),
                  data: (practicedDays) {
                    return TableCalendar(
                      focusedDay: today,
                      firstDay: firstOpen,
                      lastDay: lastDay,
                      calendarFormat: CalendarFormat.month,
                      daysOfWeekHeight: 35,
                      headerStyle: const HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: false,
                        titleTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colors.white70,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.white70,
                        ),
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: Colors.white38),
                        weekendStyle: TextStyle(color: Colors.white38),
                      ),
                      calendarStyle: const CalendarStyle(
                        outsideDaysVisible: false,
                        defaultTextStyle: TextStyle(color: Colors.white70),
                        todayTextStyle: TextStyle(color: Colors.white),
                      ),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, _) {
                          final key = day.toIso8601String().substring(0, 10);
                          final selected = practicedDays.contains(key);

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 240),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selected
                                  ? const Color(0xFF3D7BFF)
                                  : Colors.transparent,
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF3D7BFF,
                                        ).withValues(alpha: 0.35),
                                        blurRadius: 16,
                                        spreadRadius: 3,
                                      ),
                                    ]
                                  : [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "${day.day}",
                              style: TextStyle(
                                fontSize: 15,
                                color: selected ? Colors.white : Colors.white70,
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // EDIT PROFILE DIALOG
  void _showEditProfileDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(
      text: ref.read(profileProvider).name,
    );
    XFile? pickedImage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final profile = ref.read(profileProvider);

            return AlertDialog(
              backgroundColor: const Color(0xFF1E2A38),
              title: const Text(
                "Edit Profile",
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) {
                        setState(() {
                          pickedImage = image;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white24,
                      backgroundImage: pickedImage != null
                          ? FileImage(File(pickedImage!.path))
                          : (profile.imagePath != null
                                ? FileImage(File(profile.imagePath!))
                                : null),
                      child: (pickedImage == null && profile.imagePath == null)
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Enter your name",
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await ref
                        .read(profileProvider.notifier)
                        .setName(controller.text);
                    if (pickedImage != null) {
                      await ref
                          .read(profileProvider.notifier)
                          .setImage(pickedImage!.path);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
