import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlicare/core/constants/colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import '../../../logic/workout_cubit.dart';

class ExerciseDetailPage extends StatefulWidget {
  final int taskId;
  final String title;
  final String imageUrl;
  final int duration;
  final String level;
  final int? workoutId; // Add this to refresh workout detail
  final int? dayId; // Add this to refresh day workouts

  const ExerciseDetailPage({
    super.key,
    required this.taskId,
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.level,
    this.workoutId, // Optional: provide if coming from workout detail
    this.dayId, // Optional: provide if coming from day workouts
  });

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _wasCompleted = false; // Track if task was completed

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration;
  }

  void _toggleTimer() {
    if (_isPlaying) {
      _timer?.cancel();
      setState(() => _isPlaying = false);
    } else {
      setState(() => _isPlaying = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds == 0) {
          _timer?.cancel();

          // Mark task completed
          context.read<WorkoutCubit>().markTaskCompleted(widget.taskId);
          _wasCompleted = true; // Track completion

          _showCompleteEffect();
        } else {
          setState(() => _remainingSeconds--);
        }
      });
    }
  }

  Future<void> _showCompleteEffect() async {
    try {
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play(AssetSource('sounds/success.mp3'));
    } catch (_) {}

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.secondry,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),

              const SizedBox(height: 16),

              const Text(
                "Great Job! 🎉",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "You completed ${widget.title}!",
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // ONE BUTTON ONLY
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondry,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    _audioPlayer.stop();
                    Navigator.pop(context); // close dialog ONLY
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (mounted) {
      setState(() {
        _isPlaying = false;
        _remainingSeconds = widget.duration;
      });
    }
  }

  // ✅ Override back button to refresh previous screen
  Future<bool> _onWillPop() async {
    if (_wasCompleted) {
      // Refresh the appropriate screen based on where we came from
      if (widget.workoutId != null) {
        await context.read<WorkoutCubit>().refreshWorkoutDetail(
          widget.workoutId!,
        );
      }
      if (widget.dayId != null) {
        await context.read<WorkoutCubit>().refreshDayWorkouts(widget.dayId!);
      }
    }
    return true; // Allow back navigation
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');

    return WillPopScope(
      onWillPop: _onWillPop, // ✅ Handle back button
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () async {
              // ✅ Refresh before popping
              if (_wasCompleted) {
                if (widget.workoutId != null) {
                  await context.read<WorkoutCubit>().refreshWorkoutDetail(
                    widget.workoutId!,
                  );
                }
                if (widget.dayId != null) {
                  await context.read<WorkoutCubit>().refreshDayWorkouts(
                    widget.dayId!,
                  );
                }
              }
              Navigator.pop(context);
            },
          ),
          title: Text(
            widget.title,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 360,
                    color: AppColors.secondry,
                  ),
                  Positioned.fill(
                    top: 10,
                    bottom: 10,
                    left: 16,
                    right: 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: widget.imageUrl.startsWith('http')
                        ? Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, _) {
                              return Container(
                                color: Colors.grey[800],
                                child: const Icon(
                                  Icons.fitness_center,
                                  color: AppColors.primary,
                                  size: 80,
                                ),
                              );
                            },
                          )
                        : Image.asset(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, _) {
                              return Container(
                                color: Colors.grey[800],
                                child: const Icon(
                                  Icons.fitness_center,
                                  color: AppColors.primary,
                                  size: 80,
                                ),
                              );
                            },
                          ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleTimer,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: AppColors.secondry,
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text(
                "$minutes:$seconds",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.boxColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Focus on your breathing and maintain steady form.",
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _infoChip(Icons.timer, "${widget.duration ~/ 60} Min"),
                        _infoChip(Icons.trending_up, widget.level),
                        _infoChip(Icons.fitness_center, "Advanced"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
