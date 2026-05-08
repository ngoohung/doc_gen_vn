// ─────────────────────────────────────────────────────────────────────────────
// dg_card.dart
// Save as: lib/shared/widgets/dg_card.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import '../../core/tokens/app_colors.dart';
import '../../core/tokens/app_spacing.dart';
import '../../core/theme/app_theme.dart';

/// Standard DocGen VN card.
/// background: card surface | 1px border | 8px radius | shadow-sm
class DgCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool elevated; // uses shadow-md instead of shadow-sm
  final Color? backgroundColor;

  const DgCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.elevated = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final bg      = backgroundColor ?? (isDark ? AppColors.cardDark  : AppColors.cardLight);
    final border  = isDark ? AppColors.borderDark : AppColors.borderLight;
    final shadows = elevated ? AppTheme.shadowMd : AppTheme.shadowSm;

    final inner = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
      child: child,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
        boxShadow: shadows,
      ),
      child: onTap != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: onTap,
                child: inner,
              ),
            )
          : inner,
    );
  }
}
