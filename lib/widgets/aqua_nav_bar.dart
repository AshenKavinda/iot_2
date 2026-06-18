import 'package:flutter/material.dart';
import '../theme/aqua_theme.dart';

class AquaNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const AquaNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  static const _tabs = [
    _TabDef(icon: Icons.water_drop_outlined, activeIcon: Icons.water_drop, label: 'Monitor'),
    _TabDef(icon: Icons.timeline_outlined, activeIcon: Icons.timeline, label: 'Activity'),
    _TabDef(icon: Icons.tune_outlined, activeIcon: Icons.tune, label: 'Config'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: AquaColors.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AquaColors.primary.withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: List.generate(_tabs.length, (i) {
              return Expanded(
                child: _NavItem(
                  tab: _tabs[i],
                  selected: selectedIndex == i,
                  onTap: () => onTabSelected(i),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TabDef {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _TabDef({required this.icon, required this.activeIcon, required this.label});
}

class _NavItem extends StatelessWidget {
  final _TabDef tab;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({required this.tab, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: selected ? AquaColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? tab.activeIcon : tab.icon,
              color: selected ? AquaColors.onPrimary : AquaColors.textHint,
              size: 20,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: selected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        tab.label,
                        style: const TextStyle(
                          color: AquaColors.onPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
