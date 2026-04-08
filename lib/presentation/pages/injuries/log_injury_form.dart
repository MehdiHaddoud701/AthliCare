import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlicare/core/constants/colors.dart';
import 'package:athlicare/logic/injury_cubit.dart';
import 'package:athlicare/data/models/injury_model.dart';
import 'package:athlicare/data/models/injuries_info.dart';
import 'expandable_injury_card.dart';
import 'section_header.dart';

class LogInjuryForm extends StatefulWidget {
  final int userId;

  const LogInjuryForm({Key? key, required this.userId}) : super(key: key);

  @override
  State<LogInjuryForm> createState() => _LogInjuryFormState();
}

class _LogInjuryFormState extends State<LogInjuryForm> {
  String? selectedInjuryType;
  String? selectedSeverity;
  DateTime? injuryDate;
  String? additionalNotes;

  // NEW: User-adjustable fields
  double painLevel = 5.0;
  int daysRested = 0;

  final List<String> severityLevels = ['Mild', 'Moderate', 'Severe'];

  // Update pain level based on severity
  void _updatePainLevelFromSeverity(String severity) {
    setState(() {
      if (severity == 'Mild') {
        painLevel = 3.0;
      } else if (severity == 'Moderate') {
        painLevel = 5.0;
      } else {
        painLevel = 7.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final injuryTypes = context.read<InjuryCubit>().getInjuryTypes();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Injury Information',
            icon: Icons.info_outline,
            onIconTap: () {},
          ),
          const SizedBox(height: 12),
          _buildInjuryInformationCards(),
          const SizedBox(height: 24),

          // Injury Type
          _buildSectionTitle('Injury Type'),
          const SizedBox(height: 8),
          _buildDropdown(
            value: selectedInjuryType,
            hint: 'Select injury type',
            items: injuryTypes,
            onChanged: (value) => setState(() => selectedInjuryType = value),
          ),
          const SizedBox(height: 24),

          // Severity Level
          _buildSectionTitle('Severity Level'),
          const SizedBox(height: 8),
          _buildSeveritySelector(),
          const SizedBox(height: 24),

          // Injury Date
          _buildSectionTitle('When did the injury occur?'),
          const SizedBox(height: 8),
          _buildDatePicker(),
          const SizedBox(height: 24),

          // NEW: Pain Level Selector
          _buildSectionTitle('Current Pain Level (0-10)'),
          const SizedBox(height: 8),
          _buildPainLevelSelector(),
          const SizedBox(height: 24),

          // NEW: Days Rested Selector
          _buildSectionTitle('Days Already Rested'),
          const SizedBox(height: 8),
          _buildDaysRestedSelector(),
          const SizedBox(height: 24),

          // Additional Notes
          _buildSectionTitle('Additional Notes (Optional)'),
          const SizedBox(height: 8),
          _buildNotesField(),
          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveInjuryLog,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondry,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Log Injury',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ==================== WIDGETS ====================

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: Colors.blue, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Log multiple injuries and track each one separately with personalized recovery guidance',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInjuryInformationCards() {
    final injuryTypes = context.read<InjuryCubit>().getInjuryTypes();

    return Column(
      children: injuryTypes.map((type) {
        final info = context.read<InjuryCubit>().getInjuryInfo(type);
        return ExpandableInjuryCard(
          title: type,
          description: info?.description ?? '',
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Colors.grey)),
          isExpanded: true,
          dropdownColor: const Color(0xFF2A2A2A),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSeveritySelector() {
    return Row(
      children: severityLevels.map((severity) {
        final isSelected = selectedSeverity == severity;
        Color color;
        if (severity == 'Mild')
          color = Colors.green;
        else if (severity == 'Moderate')
          color = Colors.orange;
        else
          color = Colors.red;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() => selectedSeverity = severity);
                _updatePainLevelFromSeverity(severity);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? color : const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : Colors.grey[800]!,
                    width: 2,
                  ),
                ),
                child: Text(
                  severity,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: injuryDate ?? DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.secondry,
                  surface: Color(0xFF2A2A2A),
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() => injuryDate = picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              injuryDate != null
                  ? '${injuryDate!.day}/${injuryDate!.month}/${injuryDate!.year}'
                  : 'Select date',
              style: TextStyle(
                color: injuryDate != null ? Colors.white : Colors.grey,
              ),
            ),
            const Icon(Icons.calendar_today, color: AppColors.secondry),
          ],
        ),
      ),
    );
  }

  // NEW: Pain Level Selector
  Widget _buildPainLevelSelector() {
    Color painColor = painLevel <= 3
        ? Colors.green
        : painLevel <= 7
        ? Colors.orange
        : Colors.red;

    String painText = painLevel <= 3
        ? 'Mild'
        : painLevel <= 7
        ? 'Moderate'
        : 'Severe';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pain: ${painLevel.toInt()}/10',
                style: TextStyle(
                  color: painColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.secondry,
              inactiveTrackColor: Colors.grey[800],
              thumbColor: AppColors.secondry,
              overlayColor: AppColors.secondry.withOpacity(0.2),
            ),
            child: Slider(
              value: painLevel,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (value) => setState(() => painLevel = value),
            ),
          ),
        ],
      ),
    );
  }

  // NEW: Days Rested Selector
  Widget _buildDaysRestedSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Days Rested',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (daysRested > 0) {
                    setState(() => daysRested--);
                  }
                },
                icon: const Icon(
                  Icons.remove_circle,
                  color: AppColors.secondry,
                  size: 32,
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => daysRested++),
                icon: const Icon(
                  Icons.add_circle,
                  color: AppColors.secondry,
                  size: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: TextField(
        maxLines: 4,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'e.g., Occurred during workout, felt sudden pain...',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
        onChanged: (value) => additionalNotes = value,
      ),
    );
  }

  // ==================== SAVE LOGIC ====================

  void _saveInjuryLog() {
    // Validate using Cubit
    final validationError = context.read<InjuryCubit>().validateInjury(
      injuryType: selectedInjuryType,
      severity: selectedSeverity,
      injuryDate: injuryDate,
    );

    if (validationError != null) {
      _showError(validationError);
      return;
    }

    // Get injury info for recovery days
    final injuryInfo = context.read<InjuryCubit>().getInjuryInfo(
      selectedInjuryType!,
    );

    if (injuryInfo == null) {
      _showError('Invalid injury type selected');
      return;
    }

    // Create injury model with user-selected values
    final newInjury = InjuryModel(
      userId: widget.userId,
      injuryType: selectedInjuryType!,
      severity: selectedSeverity!,
      injuryDate: injuryDate!,
      expectedRecoveryDays: injuryInfo.typicalRecoveryDays,
      currentPainLevel: painLevel, // Use user-selected pain level
      daysRested: daysRested, // Use user-selected days rested
      notes: additionalNotes?.isNotEmpty == true ? additionalNotes : null,
      isActive: true,
    );

    // Log injury via Cubit
    context.read<InjuryCubit>().logInjury(newInjury);

    // Reset form
    setState(() {
      selectedInjuryType = null;
      selectedSeverity = null;
      injuryDate = null;
      additionalNotes = null;
      painLevel = 5.0;
      daysRested = 0;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
