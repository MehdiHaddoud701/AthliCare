import 'package:flutter/material.dart';

class ExpandableInjuryCard extends StatefulWidget {
  final String title;
  final String description;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const ExpandableInjuryCard({
    Key? key,
    required this.title,
    required this.description,
    this.backgroundColor = const Color(0xFF2A2A2A),
    this.textColor = Colors.white,
    this.borderColor = Colors.grey,
  }) : super(key: key);

  @override
  State<ExpandableInjuryCard> createState() => _ExpandableInjuryCardState();
}

class _ExpandableInjuryCardState extends State<ExpandableInjuryCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.borderColor, width: 1),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            widget.title,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: widget.textColor,
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              isExpanded = expanded;
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.description,
                style: TextStyle(
                  color: widget.textColor.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
