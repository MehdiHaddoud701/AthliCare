import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlicare/presentation/widgets/CustomBottomNavBar.dart';
import 'package:athlicare/core/constants/colors.dart';
import 'package:athlicare/logic/injury_cubit.dart';
import 'package:athlicare/data/state/injury_state.dart';
import 'package:athlicare/data/models/injury_model.dart';

// Import sub-widgets
import 'log_injury_form.dart';
import 'active_injuries_view.dart';
import 'injury_history_view.dart';

class InjuryRecoveryPage extends StatefulWidget {
  final int userId;

  const InjuryRecoveryPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<InjuryRecoveryPage> createState() => _InjuryRecoveryPageState();
}

class _InjuryRecoveryPageState extends State<InjuryRecoveryPage> {
  int _selectedIndex = 2; // Bottom nav index
  int _selectedTab = 0; // 0 = Log Injury, 1 = Active Injuries, 2 = History

  @override
  void initState() {
    super.initState();
    // Load injuries on page open
    context.read<InjuryCubit>().loadInjuries(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: BlocConsumer<InjuryCubit, InjuryState>(
          listener: (context, state) {
            if (state is InjuryActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              // Switch to Active Injuries tab after logging
              if (state.message.contains('logged')) {
                setState(() => _selectedTab = 1);
              }
            }

            if (state is InjuryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _buildHeader(state),
                _buildTabButtons(state),
                const SizedBox(height: 16),
                Expanded(child: _buildContent(state)),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  // ==================== HEADER ====================
  Widget _buildHeader(InjuryState state) {
    int activeCount = 0;
    if (state is InjuriesLoaded) {
      activeCount = state.activeInjuries.length;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Injury & Recovery',
                  style: TextStyle(
                    color: AppColors.boxColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (activeCount > 0)
                  Text(
                    '$activeCount active ${activeCount == 1 ? 'injury' : 'injuries'}',
                    style: const TextStyle(
                      color: AppColors.secondry,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.secondry),
            onPressed: () {
              context.read<InjuryCubit>().loadInjuries(widget.userId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.secondry),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
    );
  }

  // ==================== TAB BUTTONS ====================
  Widget _buildTabButtons(InjuryState state) {
    int activeCount = 0;
    int historyCount = 0;

    if (state is InjuriesLoaded) {
      activeCount = state.activeInjuries.length;
      historyCount = state.historyInjuries.length;
    }

    final tabs = [
      {'title': 'Log Injury', 'badge': null},
      {'title': 'Active', 'badge': activeCount > 0 ? activeCount : null},
      {'title': 'History', 'badge': historyCount > 0 ? historyCount : null},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: List.generate(tabs.length, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index < tabs.length - 1 ? 8 : 0,
                left: index > 0 ? 8 : 0,
              ),
              child: _buildTabButton(
                tabs[index]['title'] as String,
                index,
                tabs[index]['badge'] as int?,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabButton(String text, int index, int? badge) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondry : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : AppColors.secondry,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  badge.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? AppColors.secondry : Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ==================== CONTENT ====================
  Widget _buildContent(InjuryState state) {
    if (state is InjuryLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.secondry),
      );
    }

    if (state is InjuriesLoaded) {
      switch (_selectedTab) {
        case 0:
          return LogInjuryForm(userId: widget.userId);
        case 1:
          return ActiveInjuriesView(
            injuries: state.activeInjuries,
            userId: widget.userId,
          );
        case 2:
          return InjuryHistoryView(injuries: state.historyInjuries);
        default:
          return LogInjuryForm(userId: widget.userId);
      }
    }

    // Initial or error state
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 80,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 16),
          const Text(
            'Track your injuries',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<InjuryCubit>().loadInjuries(widget.userId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondry,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Load Injuries'),
          ),
        ],
      ),
    );
  }

  // ==================== HELP DIALOG ====================
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Help & Information',
          style: TextStyle(color: Colors.white),
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Track Multiple Injuries',
                style: TextStyle(
                  color: AppColors.secondry,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '• Log unlimited injuries\n'
                '• Track recovery progress for each\n'
                '• View recovery timelines\n'
                '• Get do\'s and don\'ts guidance',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 16),
              Text(
                'Recovery Tracking',
                style: TextStyle(
                  color: AppColors.secondry,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '• System calculates recovery days\n'
                '• Track days rested automatically\n'
                '• Monitor pain levels\n'
                '• Mark as recovered when healed',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it',
              style: TextStyle(color: AppColors.secondry),
            ),
          ),
        ],
      ),
    );
  }
}
