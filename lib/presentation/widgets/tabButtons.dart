import 'package:flutter/material.dart';
import 'package:athlicare/presentation/widgets/buildTabButton.dart';

class TabsRow extends StatefulWidget {
  final int selected;
  final Function(int)? onTabChanged;
  final String? screenpage;
  final bool enableNavigation; // New parameter to control navigation behavior

  const TabsRow({
    Key? key,
    required this.selected,
    this.onTabChanged,
    this.screenpage,
    this.enableNavigation =
        false, // Default: don't navigate, just notify parent
  }) : super(key: key);

  @override
  State<TabsRow> createState() => _TabsRowState();
}

class _TabsRowState extends State<TabsRow> {
  late int selectedTab;

  @override
  void initState() {
    super.initState();
    selectedTab = widget.selected;
  }

  @override
  void didUpdateWidget(TabsRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected tab if parent changes it
    if (oldWidget.selected != widget.selected) {
      setState(() {
        selectedTab = widget.selected;
      });
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      selectedTab = index;
    });

    if (widget.enableNavigation) {
      // If in detail screen, pop back to list
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }

    // Always notify parent widget
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: BuildTabButton(
              text: 'Vitamines',
              isSelected: selectedTab == 0,
              onTap: () => _onTabChanged(0),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: BuildTabButton(
              text: 'Articles & Tips',
              isSelected: selectedTab == 1,
              onTap: () => _onTabChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}
