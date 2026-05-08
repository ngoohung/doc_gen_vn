import 'package:flutter/material.dart';
import '../../core/tokens/app_colors.dart';
import '../../core/tokens/app_typography.dart';

/// Variant của DgButton
enum DgButtonVariant { primary, secondary, ghost, danger }

/// DgButton — nút cơ bản của DocGen VN
///
/// Dùng:
///   DgButton(label: 'Sinh tài liệu', onPressed: _submit)
///   DgButton(label: 'Xuất PDF', variant: DgButtonVariant.secondary, ...)
///   DgButton(label: 'Hủy', variant: DgButtonVariant.ghost, ...)
///   DgButton(label: 'Xóa', variant: DgButtonVariant.danger, ...)
///   DgButton(label: '...', loading: true, onPressed: null)
class DgButton extends StatefulWidget {
  final String label;
  final DgButtonVariant variant;
  final VoidCallback? onPressed;
  final bool loading;
  final bool disabled;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double? width;

  const DgButton({
    super.key,
    required this.label,
    this.variant = DgButtonVariant.primary,
    this.onPressed,
    this.loading = false,
    this.disabled = false,
    this.leadingIcon,
    this.trailingIcon,
    this.width,
  });

  /// Named constructors cho tiện
  const DgButton.primary({
    super.key,
    required String label,
    VoidCallback? onPressed,
    bool loading = false,
    IconData? leadingIcon,
    double? width,
  }) : this(
    label: label,
    variant: DgButtonVariant.primary,
    onPressed: onPressed,
    loading: loading,
    leadingIcon: leadingIcon,
    width: width,
  );

  const DgButton.secondary({
    super.key,
    required String label,
    VoidCallback? onPressed,
    bool loading = false,
    IconData? leadingIcon,
  }) : this(
    label: label,
    variant: DgButtonVariant.secondary,
    onPressed: onPressed,
    loading: loading,
    leadingIcon: leadingIcon,
  );

  const DgButton.ghost({
    super.key,
    required String label,
    VoidCallback? onPressed,
    IconData? leadingIcon,
  }) : this(
    label: label,
    variant: DgButtonVariant.ghost,
    onPressed: onPressed,
    leadingIcon: leadingIcon,
  );

  const DgButton.danger({
    super.key,
    required String label,
    VoidCallback? onPressed,
  }) : this(
    label: label,
    variant: DgButtonVariant.danger,
    onPressed: onPressed,
  );

  @override
  State<DgButton> createState() => _DgButtonState();
}

class _DgButtonState extends State<DgButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  bool _hovered = false;

  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.99)
        .animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  bool get _isDisabled => widget.disabled || widget.loading || widget.onPressed == null;

  void _onTapDown(_) {
    if (_isDisabled) return;
    // Primary: scale press effect. Ghost: skip scale
    if (widget.variant != DgButtonVariant.ghost) {
      _scaleCtrl.forward();
    }
    setState(() => _pressed = true);
  }

  void _onTapUp(_) {
    _scaleCtrl.reverse();
    setState(() => _pressed = false);
  }

  void _onTapCancel() {
    _scaleCtrl.reverse();
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final _Styles s  = _resolveStyle(widget.variant, brightness, _hovered, _pressed, _isDisabled);

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.loading) ...[
          SizedBox(
            width: 14, height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              valueColor: AlwaysStoppedAnimation(s.fgColor),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (widget.leadingIcon != null) ...[
          Icon(widget.leadingIcon, size: 16, color: s.fgColor),
          const SizedBox(width: 6),
        ],
        Text(
          widget.label,
          style: AppTypography.bodyMd.copyWith(color: s.fgColor),
        ),
        if (widget.trailingIcon != null) ...[
          const SizedBox(width: 6),
          Icon(widget.trailingIcon, size: 16, color: s.fgColor),
        ],
      ],
    );

    return ScaleTransition(
      scale: _scaleAnim,
      child: MouseRegion(
        cursor: _isDisabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit:  (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: _isDisabled ? null : widget.onPressed,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: widget.width,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: s.bgColor,
              borderRadius: BorderRadius.circular(6),
              border: s.border,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

// ── Style resolver ─────────────────────────────────────────────────────────────
class _Styles {
  final Color bgColor;
  final Color fgColor;
  final BoxBorder? border;
  const _Styles({required this.bgColor, required this.fgColor, this.border});
}

_Styles _resolveStyle(
  DgButtonVariant v,
  Brightness b,
  bool hovered,
  bool pressed,
  bool disabled,
) {
  if (disabled) {
    return _Styles(
      bgColor: v == DgButtonVariant.primary
          ? AppColors.fgDisabled(b)
          : Colors.transparent,
      fgColor: AppColors.fgDisabled(b),
      border: v == DgButtonVariant.secondary
          ? Border.all(color: AppColors.border(b))
          : null,
    );
  }

  switch (v) {
    case DgButtonVariant.primary:
      Color bg = AppColors.primary;
      if (pressed) bg = AppColors.primaryPress;
      else if (hovered) bg = AppColors.primaryHover;
      return _Styles(bgColor: bg, fgColor: Colors.white);

    case DgButtonVariant.secondary:
      Color bg = Colors.transparent;
      if (pressed || hovered) bg = AppColors.hover(b);
      return _Styles(
        bgColor: bg,
        fgColor: AppColors.fg(b),
        border: Border.all(color: AppColors.border(b)),
      );

    case DgButtonVariant.ghost:
      Color bg = Colors.transparent;
      if (pressed || hovered) bg = AppColors.hover(b);
      return _Styles(bgColor: bg, fgColor: AppColors.fgMuted(b));

    case DgButtonVariant.danger:
      Color bg = pressed
          ? AppColors.error.withOpacity(0.15)
          : hovered
              ? AppColors.errorSoft
              : Colors.transparent;
      return _Styles(
        bgColor: bg,
        fgColor: AppColors.error,
        border: Border.all(color: AppColors.error.withOpacity(0.4)),
      );
  }
}
