// 📁 lib/presentation/pages/injuries/widgets/active_injuries_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlicare/core/constants/colors.dart';
import 'package:athlicare/logic/injury_cubit.dart';
import 'package:athlicare/data/models/injury_model.dart';
import 'package:athlicare/data/models/injuries_info.dart';
import '../../../data/state/injury_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlicare/core/constants/colors.dart';
import 'package:athlicare/logic/injury_cubit.dart';
import 'package:athlicare/data/models/injury_model.dart';
import 'package:athlicare/data/models/injuries_info.dart';

// 📁 lib/presentation/pages/injuries/widgets/active_injuries_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlicare/core/constants/colors.dart';
import 'package:athlicare/logic/injury_cubit.dart';
import 'package:athlicare/data/models/injury_model.dart';
import 'package:athlicare/data/models/injuries_info.dart';

extension FirstWhereOrNullExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class ActiveInjuriesView extends StatelessWidget {
  final List<InjuryModel> injuries;
  final int userId;

  const ActiveInjuriesView({
    Key? key,
    required this.injuries,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (injuries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 80, color: Colors.grey[700]),
            const SizedBox(height: 16),
            const Text(
              'No active injuries',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You\'re injury-free! Stay safe during workouts',
              style: TextStyle(color: Colors.white54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: injuries.length,
      itemBuilder: (context, index) {
        return ActiveInjuryCard(
          injury: injuries[index],
          userId: userId,
          onTap: () => _showInjuryDetails(context, injuries[index]),
        );
      },
    );
  }

  void _showInjuryDetails(BuildContext context, InjuryModel injury) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InjuryDetailPage(injury: injury)),
    );
  }
}

// ==================== ACTIVE INJURY CARD ====================

class ActiveInjuryCard extends StatelessWidget {
  final InjuryModel injury;
  final int userId;
  final VoidCallback onTap;

  const ActiveInjuryCard({
    Key? key,
    required this.injury,
    required this.userId,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = injury.recoveryProgress;
    final percentage = (progress * 100).toInt();
    final severityColor = _getSeverityColor(injury.severity);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.secondry.withOpacity(0.15),
              AppColors.secondry.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.secondry.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondry.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.medical_services,
                    color: AppColors.secondry,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        injury.injuryType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${injury.daysElapsed} days since injury',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: severityColor),
                  ),
                  child: Text(
                    injury.severity,
                    style: TextStyle(
                      color: severityColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recovery Progress',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: AppColors.secondry,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress < 0.5
                      ? Colors.red
                      : progress < 0.8
                      ? Colors.orange
                      : Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStat(
                  Icons.schedule,
                  '${injury.daysRemaining} days left',
                  AppColors.secondry,
                ),
                const SizedBox(width: 20),
                _buildStat(
                  Icons.calendar_today,
                  injury.injuryDate.toString().split(' ').first,
                  Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'Tap to view details & do\'s/don\'ts',
                  style: TextStyle(
                    color: AppColors.secondry,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.secondry,
                  size: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }

  Color _getSeverityColor(String severity) {
    if (severity == 'Mild') return Colors.green;
    if (severity == 'Moderate') return Colors.orange;
    return Colors.red;
  }
}

// ==================== INJURY DETAIL PAGE ====================

class InjuryDetailPage extends StatelessWidget {
  final InjuryModel injury;

  const InjuryDetailPage({Key? key, required this.injury}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<InjuryCubit, InjuryState>(
      listener: (context, state) {
        if (state is InjuryActionSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: BlocBuilder<InjuryCubit, InjuryState>(
        builder: (context, state) {
          InjuryModel currentInjury = injury;
          if (state is InjuriesLoaded) {
            final updatedInjury = state.activeInjuries.firstWhereOrNull(
              (i) => i.injuryId == injury.injuryId,
            );
            if (updatedInjury != null) {
              currentInjury = updatedInjury;
            }
          }

          final injuryInfo = context.read<InjuryCubit>().getInjuryInfo(
            currentInjury.injuryType,
          );

          return Scaffold(
            backgroundColor: const Color(0xFF1A1A1A),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSummaryCard(currentInjury),
                          const SizedBox(height: 24),
                          _buildRecoveryProgress(currentInjury),
                          const SizedBox(height: 24),
                          _buildRemainingDaysBox(currentInjury),
                          const SizedBox(height: 24),
                          _buildDaysRestedDisplay(currentInjury),
                          const SizedBox(height: 24),
                          _buildPainLevelDisplay(currentInjury),
                          const SizedBox(height: 24),
                          if (injuryInfo != null) ...[
                            _buildDosDontsSection(
                              'DO\'s for Recovery',
                              injuryInfo.dos,
                              true,
                            ),
                            const SizedBox(height: 24),
                            _buildDosDontsSection(
                              'DON\'Ts',
                              injuryInfo.donts,
                              false,
                            ),
                            const SizedBox(height: 24),
                          ],
                          _buildRecoveredButton(context, currentInjury),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.secondry),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Injury Details',
                  style: TextStyle(
                    color: AppColors.boxColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  injury.injuryType,
                  style: const TextStyle(
                    color: AppColors.secondry,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(InjuryModel currentInjury) {
    final severityColor = currentInjury.severity == 'Mild'
        ? Colors.green
        : currentInjury.severity == 'Moderate'
        ? Colors.orange
        : Colors.red;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondry.withOpacity(0.2),
            AppColors.secondry.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondry.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.medical_services,
                color: AppColors.secondry,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  currentInjury.injuryType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: severityColor),
                ),
                child: Text(
                  currentInjury.severity,
                  style: TextStyle(
                    color: severityColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Since ${currentInjury.injuryDate.day}/${currentInjury.injuryDate.month}/${currentInjury.injuryDate.year}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          if (currentInjury.notes != null &&
              currentInjury.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              currentInjury.notes!,
              style: const TextStyle(color: Colors.white60, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecoveryProgress(InjuryModel currentInjury) {
    final progress = currentInjury.recoveryProgress;
    final percentage = (progress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recovery Progress',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$percentage%',
              style: const TextStyle(
                color: AppColors.secondry,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(
              progress < 0.5
                  ? Colors.red
                  : progress < 0.8
                  ? Colors.orange
                  : Colors.green,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${currentInjury.daysRemaining} days remaining of ${currentInjury.expectedRecoveryDays} total',
          style: const TextStyle(color: Colors.white60, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildRemainingDaysBox(InjuryModel currentInjury) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondry.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Days Remaining',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                '${currentInjury.daysRemaining}',
                style: const TextStyle(
                  color: AppColors.secondry,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Icon(Icons.schedule, color: AppColors.secondry, size: 48),
        ],
      ),
    );
  }

  Widget _buildDaysRestedDisplay(InjuryModel currentInjury) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Days Rested',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Text(
                currentInjury.daysRested.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Icon(Icons.airline_seat_flat, color: Colors.blue, size: 40),
        ],
      ),
    );
  }

  Widget _buildPainLevelDisplay(InjuryModel currentInjury) {
    final painLevel = currentInjury.currentPainLevel;
    Color painColor;
    String painText;

    if (painLevel <= 3) {
      painColor = Colors.green;
      painText = 'Mild';
    } else if (painLevel <= 7) {
      painColor = Colors.orange;
      painText = 'Moderate';
    } else {
      painColor = Colors.red;
      painText = 'Severe';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: painColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pain Level',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    painLevel.toStringAsFixed(1),
                    style: TextStyle(
                      color: painColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text('/10', style: TextStyle(color: painColor, fontSize: 14)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: painColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: painColor),
            ),
            child: Text(
              painText,
              style: TextStyle(
                color: painColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDosDontsSection(String title, List<String> items, bool isDo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isDo ? Icons.check_circle : Icons.cancel,
              color: isDo ? Colors.green : Colors.red,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDo
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDo
                      ? Colors.green.withOpacity(0.3)
                      : Colors.red.withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isDo ? Icons.check : Icons.close,
                    color: isDo ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecoveredButton(
    BuildContext context,
    InjuryModel currentInjury,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _confirmRecovery(context, currentInjury),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Mark as Recovered',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final noteController = TextEditingController(text: injury.notes ?? '');
    String? selectedSeverity = injury.severity;
    double painLevel = injury.currentPainLevel;
    int daysRested = injury.daysRested;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateLocal) => AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: const Text(
            'Edit Injury Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: noteController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Add notes about the injury',
                    hintStyle: const TextStyle(color: Colors.white30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white30),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Severity Level',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['Mild', 'Moderate', 'Severe']
                      .map(
                        (severity) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () => setStateLocal(
                                () => selectedSeverity = severity,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedSeverity == severity
                                      ? AppColors.secondry
                                      : const Color(0xFF1A1A1A),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: selectedSeverity == severity
                                        ? AppColors.secondry
                                        : Colors.white30,
                                  ),
                                ),
                                child: Text(
                                  severity,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: selectedSeverity == severity
                                        ? Colors.white
                                        : Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Days Rested',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (daysRested > 0) {
                          setStateLocal(() => daysRested--);
                        }
                      },
                      icon: const Icon(
                        Icons.remove_circle,
                        color: AppColors.secondry,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondry.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        daysRested.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setStateLocal(() => daysRested++),
                      icon: const Icon(
                        Icons.add_circle,
                        color: AppColors.secondry,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pain Level',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      painLevel.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppColors.secondry,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: painLevel,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        activeColor: AppColors.secondry,
                        onChanged: (value) =>
                            setStateLocal(() => painLevel = value),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedInjury = injury.copyWith(
                  notes: noteController.text,
                  severity: selectedSeverity,
                  daysRested: daysRested,
                  currentPainLevel: painLevel,
                );
                context.read<InjuryCubit>().updateInjury(updatedInjury);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondry,
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Delete Injury?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this injury record?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              context.read<InjuryCubit>().deleteInjury(injury.injuryId!);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmRecovery(BuildContext context, InjuryModel currentInjury) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Mark as Recovered?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to mark this injury as fully recovered?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              context.read<InjuryCubit>().markAsRecovered(
                currentInjury.injuryId!,
              );
              Navigator.pop(context);
            },
            child: const Text(
              'Yes, Recovered!',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
