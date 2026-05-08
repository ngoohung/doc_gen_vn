import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/tokens/app_colors.dart';
import '../../core/tokens/app_spacing.dart';
import '../../core/tokens/app_typography.dart';
import '../../core/theme/theme_provider.dart';

// ── Nav items ─────────────────────────────────────────────────────────────────
class _NavItem {
  final String label;
  final IconData icon;
  final int? count;
  const _NavItem(this.label, this.icon, {this.count});
}

const _memberNav = [
  _NavItem('Sinh tài liệu', Icons.bolt_outlined),
  _NavItem('Lịch sử',       Icons.history),
  _NavItem('Cài đặt',       Icons.settings_outlined),
];

const _adminNav = [
  _NavItem('Dashboard',     Icons.bar_chart_outlined),
  _NavItem('Người dùng',    Icons.people_outline),
  _NavItem('Cài đặt',       Icons.settings_outlined),
];

/// Sidebar navigation — 240px (full) / 56px (collapsed)
/// Dùng ConsumerWidget để đọc theme cho icon toggle
class SidebarNav extends ConsumerWidget {
  final int selectedIndex;
  final bool isAdmin;
  final bool collapsed;
  final ValueChanged<int> onItemTap;
  final VoidCallback? onToggleCollapse;

  const SidebarNav({
    super.key,
    required this.selectedIndex,
    required this.collapsed,
    required this.onItemTap,
    this.isAdmin = false,
    this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final items = isAdmin ? _adminNav : _memberNav;

    final bg     = AppColors.card(brightness);
    final border = AppColors.border(brightness);

    return Container(
      color: bg,
      child: Column(
        children: [
          // ── Brand ──────────────────────────────────────────────────────────
          _Brand(collapsed: collapsed),
          Divider(height: 1, color: border),

          // ── Nav items ──────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                children: [
                  ...items.asMap().entries.map((e) => _NavTile(
                    item: e.value,
                    selected: selectedIndex == e.key,
                    collapsed: collapsed,
                    onTap: () => onItemTap(e.key),
                    brightness: brightness,
                  )),
                ],
              ),
            ),
          ),

          // ── Bottom: user + collapse toggle ─────────────────────────────────
          Divider(height: 1, color: border),
          _SidebarBottom(
            collapsed: collapsed,
            onToggleCollapse: onToggleCollapse,
            brightness: brightness,
          ),
        ],
      ),
    );
  }
}

// ── Brand block ───────────────────────────────────────────────────────────────
class _Brand extends StatelessWidget {
  final bool collapsed;
  const _Brand({required this.collapsed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56, // topbar-h align
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            // Logo mark — squircle with <> glyph
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                '</>',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            if (!collapsed) ...[
              const SizedBox(width: 10),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: Color(0xFF111827),
                  ),
                  children: [
                    TextSpan(text: 'DocGen'),
                    TextSpan(
                      text: ' VN',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Nav tile ──────────────────────────────────────────────────────────────────
class _NavTile extends StatefulWidget {
  final _NavItem item;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;
  final Brightness brightness;

  const _NavTile({
    required this.item,
    required this.selected,
    required this.collapsed,
    required this.onTap,
    required this.brightness,
  });

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final b    = widget.brightness;
    final sel  = widget.selected;

    Color bg = Colors.transparent;
    if (sel)     bg = AppColors.primarySoft;
    if (_hovered && !sel) bg = AppColors.hover(b);

    final textColor = sel
        ? AppColors.primary
        : AppColors.fgMuted(b);
    final iconColor = sel
        ? AppColors.primary
        : AppColors.fgMuted(b);

    final tile = GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit:  (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: EdgeInsets.symmetric(
            horizontal: widget.collapsed ? 0 : 10,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: widget.collapsed
              ? Center(
            child: Icon(widget.item.icon, size: 20, color: iconColor),
          )
              : Row(
            children: [
              Icon(widget.item.icon, size: 18, color: iconColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.item.label,
                  style: AppTypography.bodySm.copyWith(
                    color: textColor,
                    fontWeight: sel
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ),
              if (widget.item.count != null)
                Text(
                  '${widget.item.count}',
                  style: AppTypography.caption.copyWith(
                    color: sel
                        ? AppColors.primary
                        : AppColors.fgSubtle(b),
                    fontFamily: 'JetBrainsMono',
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (widget.collapsed) {
      return Tooltip(
        message: widget.item.label,
        preferBelow: false,
        child: SizedBox(width: double.infinity, height: 40, child: tile),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: tile,
    );
  }
}

// ── Sidebar bottom (user avatar + collapse btn) ───────────────────────────────
class _SidebarBottom extends ConsumerWidget {
  final bool collapsed;
  final VoidCallback? onToggleCollapse;
  final Brightness brightness;

  const _SidebarBottom({
    required this.collapsed,
    required this.onToggleCollapse,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fgSubtle = AppColors.fgSubtle(brightness);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // User avatar row
          if (!collapsed)
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 6),
              child: Row(
                children: [
                  _Avatar(initials: 'DV', color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dev User',
                            style: AppTypography.bodySm.copyWith(
                              fontWeight: FontWeight.w600,
                            )),
                        Text('dev@docgenvn.com',
                            style: AppTypography.caption.copyWith(
                              color: fgSubtle,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Collapse toggle (desktop only)
          if (onToggleCollapse != null)
            _IconBtn(
              icon: collapsed
                  ? Icons.keyboard_double_arrow_right
                  : Icons.keyboard_double_arrow_left,
              tooltip: collapsed ? 'Mở rộng sidebar' : 'Thu gọn sidebar',
              onTap: onToggleCollapse!,
              brightness: brightness,
            ),
        ],
      ),
    );
  }
}

// ── Small reusable pieces ─────────────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final String initials;
  final Color color;
  const _Avatar({required this.initials, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28, height: 28,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(9999),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _IconBtn extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Brightness brightness;
  const _IconBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.brightness,
  });

  @override
  State<_IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<_IconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit:  (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: double.infinity,
            height: 32,
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.hover(widget.brightness)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Icon(
              widget.icon,
              size: 16,
              color: AppColors.fgSubtle(widget.brightness),
            ),
          ),
        ),
      ),
    );
  }
}