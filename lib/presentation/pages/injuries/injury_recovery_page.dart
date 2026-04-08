import 'package:flutter/material.dart';
import 'package:athlicare/presentation/widgets/CustomBottomNavBar.dart';
import 'package:athlicare/core/constants/colors.dart';
import 'package:athlicare/presentation/pages/injuries/expandable_injury_card.dart';
import 'package:athlicare/presentation/pages/injuries/custom_dropdown.dart';
import 'package:athlicare/presentation/pages/injuries/custom_slider.dart';
import 'package:athlicare/presentation/pages/injuries/custom_number_input.dart';
import 'package:athlicare/presentation/pages/injuries/recovery_progress_bar.dart';
import 'package:athlicare/presentation/pages/injuries/section_header.dart';
import 'package:athlicare/presentation/pages/injuries/info_card.dart';

class InjuryRecoveryPage extends StatefulWidget {
  const InjuryRecoveryPage({Key? key}) : super(key: key);

  @override
  State<InjuryRecoveryPage> createState() => _InjuryRecoveryPageState();
}

class _InjuryRecoveryPageState extends State<InjuryRecoveryPage> {
  int _selectedIndex = 2; // Injuries tab
  String? selectedInjuryType;
  double painLevel = 5.0;
  int daysResting = 3;
  double recoveryProgress = 0.3;

  // Sample data for injury types
  final List<String> injuryTypes = [
    'Muscle Strain',
    'Sprain',
    'Fracture',
    'Tendonitis',
    'Bruise',
    'Dislocation',
    'Torn Ligament',
    'Back Injury',
  ];

  // Injury information data
  final Map<String, String> injuryInfo = {
    'Muscle Strain':
        'A muscle strain occurs when muscle fibers are overstretched or torn. Severity levels: Mild (slight discomfort), Moderate (pain with movement), Severe (significant pain and loss of function).',
    'Sprain':
        'A sprain is a stretching or tearing of ligaments. Common in ankles, knees, and wrists. Rest, ice, compression, and elevation are key treatments.',
    'Fracture':
        'A fracture is a broken bone. Can range from a hairline crack to a complete break. Requires immediate medical attention and immobilization.',
    'Tendonitis':
        'Inflammation of a tendon, often caused by repetitive motion. Common in shoulders, elbows, wrists, knees, and ankles.',
    'Bruise':
        'A bruise occurs when small blood vessels break and leak blood into surrounding tissue. Usually heals on its own with rest and ice.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Injury Information Section
                    SectionHeader(
                      title: 'Injury Information',
                      icon: Icons.keyboard_arrow_up,
                      onIconTap: () {
                        // Collapse all expandable cards
                      },
                    ),
                    const SizedBox(height: 12),

                    // Expandable Injury Cards
                    _buildInjuryInformationCards(),

                    const SizedBox(height: 24),

                    // Log Your Injury Section
                    const SectionHeader(title: 'Log Your Injury'),
                    const SizedBox(height: 16),

                    // Injury Type Dropdown
                    CustomDropdown(
                      label: 'Injury Type',
                      value: selectedInjuryType,
                      items: injuryTypes,
                      onChanged: (value) {
                        setState(() {
                          selectedInjuryType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Pain Level Slider
                    CustomSlider(
                      label: 'Pain Level',
                      value: painLevel,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          painLevel = value;
                        });
                      },
                      valueFormatter: (value) {
                        if (value <= 3) return 'Mild';
                        if (value <= 7) return 'Moderate';
                        return 'Severe Pain';
                      },
                    ),
                    const SizedBox(height: 20),

                    // Days Resting
                    CustomNumberInput(
                      label: 'Days Resting',
                      value: daysResting,
                      min: 0,
                      max: 365,
                      onChanged: (value) {
                        setState(() {
                          daysResting = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Recovery Advice
                    InfoCard(
                      title: 'Recovery Advice',
                      content:
                          'For most injuries, focus on R.I.C.E: Rest, Ice, Compression, and Elevation. Avoid activities that cause pain.',
                      icon: Icons.lightbulb_outline,
                    ),
                    const SizedBox(height: 20),

                    // Recovery Progress
                    RecoveryProgressBar(progress: recoveryProgress),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Expanded(
            child: Text(
              'Injury & Recovery',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              _showHelpDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInjuryInformationCards() {
    return Column(
      children: [
        ExpandableInjuryCard(
          title: 'Muscle Strain',
          description: injuryInfo['Muscle Strain']!,
        ),
        ExpandableInjuryCard(
          title: 'Sprain',
          description: injuryInfo['Sprain']!,
        ),
        ExpandableInjuryCard(
          title: 'Fracture',
          description: injuryInfo['Fracture']!,
        ),
        ExpandableInjuryCard(
          title: 'Tendonitis',
          description: injuryInfo['Tendonitis']!,
        ),
        ExpandableInjuryCard(
          title: 'Bruise',
          description: injuryInfo['Bruise']!,
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Help & Information',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Track your injuries and recovery progress here. Log your injury type, pain level, and days resting to monitor your healing journey.',
          style: TextStyle(color: Colors.white70),
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
