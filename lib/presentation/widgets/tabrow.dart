import 'package:flutter/material.dart';
import 'package:athlicare/presentation/widgets/buildTabButton.dart';

class TabsRow extends StatefulWidget {
  final int selected;
  final Function(int)? onTabChanged;
  final bool enableNavigation;

  const TabsRow({
    Key? key,
    required this.selected,
    this.onTabChanged,
    this.enableNavigation = false,
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
    if (oldWidget.selected != widget.selected) {
      setState(() {
        selectedTab = widget.selected;
      });
    }
  }

  void _onTabChanged(int index) {
    // Don't do anything if already on this tab
    if (selectedTab == index) return;

    setState(() {
      selectedTab = index;
    });

    // Notify parent first
    widget.onTabChanged?.call(index);

    // If navigation is enabled and we're on a detail screen
    if (widget.enableNavigation && Navigator.canPop(context)) {
      // Pop back to the main list screen
      Navigator.pop(context);
    }
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
