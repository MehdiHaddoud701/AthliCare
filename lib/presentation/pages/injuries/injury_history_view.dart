import 'package:flutter/material.dart';
import 'package:athlicare/core/constants/colors.dart';
import 'package:athlicare/data/models/injury_model.dart';

class InjuryHistoryView extends StatelessWidget {
  final List<InjuryModel> injuries;

  const InjuryHistoryView({Key? key, required this.injuries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (injuries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey[700]),
            const SizedBox(height: 16),
            const Text(
              'No injury history yet',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your recovered injuries will appear here',
              style: TextStyle(color: Colors.white54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Summary Card
        _buildSummaryCard(injuries),

        // List of injuries
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: injuries.length,
            itemBuilder: (context, index) {
              return InjuryHistoryCard(injury: injuries[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(List<InjuryModel> injuries) {
    final totalRecoveryDays = injuries.fold<int>(
      0,
      (sum, injury) => sum + injury.expectedRecoveryDays,
    );

    final totalDaysRested = injuries.fold<int>(
      0,
      (sum, injury) => sum + injury.daysRested,
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withOpacity(0.2),
            Colors.green.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text(
                'Recovery Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryStat(
                  'Total Injuries',
                  injuries.length.toString(),
                  Icons.medical_services,
                ),
              ),
              Container(width: 1, height: 40, color: Colors.grey[800]),
              Expanded(
                child: _buildSummaryStat(
                  'Total Rest Days',
                  totalDaysRested.toString(),
                  Icons.airline_seat_flat,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }
}

// ==================== INJURY HISTORY CARD ====================

class InjuryHistoryCard extends StatelessWidget {
  final InjuryModel injury;

  const InjuryHistoryCard({Key? key, required this.injury}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor(injury.severity);
    final daysSinceRecovered = injury.recoveredDate != null
        ? DateTime.now().difference(injury.recoveredDate!).inDays
        : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
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
                      daysSinceRecovered == 0
                          ? 'Recovered today'
                          : 'Recovered $daysSinceRecovered days ago',
                      style: const TextStyle(color: Colors.green, fontSize: 13),
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

          const SizedBox(height: 12),
          Divider(color: Colors.grey[800], height: 1),
          const SizedBox(height: 12),

          // Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStat(
                  Icons.calendar_today,
                  'Injury Date',
                  '${injury.injuryDate.day}/${injury.injuryDate.month}/${injury.injuryDate.year}',
                ),
              ),
              Expanded(
                child: _buildStat(
                  Icons.event_available,
                  'Recovered',
                  injury.recoveredDate != null
                      ? '${injury.recoveredDate!.day}/${injury.recoveredDate!.month}/${injury.recoveredDate!.year}'
                      : 'N/A',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStat(
                  Icons.timer,
                  'Days Rested',
                  '${injury.daysRested} days',
                ),
              ),
              Expanded(
                child: _buildStat(
                  Icons.speed,
                  'Expected',
                  '${injury.expectedRecoveryDays} days',
                ),
              ),
            ],
          ),

          // Recovery Status Badge
          if (injury.daysRested < injury.expectedRecoveryDays) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.trending_up, color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Recovered faster than expected! 🎉',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Notes if available
          if (injury.notes != null && injury.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.note, color: Colors.white60, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      injury.notes!,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.secondry, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getSeverityColor(String severity) {
    if (severity == 'Mild') return Colors.green;
    if (severity == 'Moderate') return Colors.orange;
    return Colors.red;
  }
}
