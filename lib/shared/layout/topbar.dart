import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/tokens/app_colors.dart';
import '../../core/tokens/app_typography.dart';
import '../../core/theme/theme_provider.dart';

const _memberTitles = ['Sinh tài liệu', 'Lịch sử', 'Cài đặt'];
const _adminTitles  = ['Dashboard', 'Người dùng', 'Cài đặt'];

/// TopBar — 56px, breadcrumb + search + theme toggle + avatar
class TopBar extends ConsumerStatefulWidget {
  final int selectedIndex;
  final bool isAdmin;
  final bool showMenuButton;

  const TopBar({
    super.key,
    required this.selectedIndex,
    this.isAdmin = false,
    this.showMenuButton = false,
  });

  @override
  ConsumerState<TopBar> createState() => _TopBarState();
}

class _TopBarState extends ConsumerState<TopBar> {
  final _searchCtrl = TextEditingController();
  bool _searchFocused = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark     = ref.watch(themeModeProvider) == ThemeMode.dark;

    final bg     = AppColors.card(brightness);
    final border = AppColors.border(brightness);
    final fg     = AppColors.fg(brightness);
    final subtle = AppColors.fgSubtle(brightness);

    final titles = widget.isAdmin ? _adminTitles : _memberTitles;
    final title  = titles.elementAtOrNull(widget.selectedIndex) ?? '';

    return Container(
      height: 56,
      color: bg,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // ── Left: hamburger (mobile) + breadcrumb ────────────────
                  if (widget.showMenuButton)
                    IconButton(
                      icon: const Icon(Icons.menu, size: 20),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      tooltip: 'Menu',
                    ),
                  _Breadcrumb(title: title, fg: fg, subtle: subtle),

                  const Spacer(),

                  // ── Center: search ───────────────────────────────────────
                  Flexible(
                    flex: 3,
                    child: _SearchBar(
                      controller: _searchCtrl,
                      focused: _searchFocused,
                      onFocusChange: (v) => setState(() => _searchFocused = v),
                      brightness: brightness,
                    ),
                  ),

                  const Spacer(),

                  // ── Right: theme toggle + avatar ─────────────────────────
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _TopBarIconBtn(
                        icon: isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
                        tooltip: isDark ? 'Chuyển Light mode' : 'Chuyển Dark mode',
                        brightness: brightness,
                        onTap: () => ref.read(themeModeProvider.notifier).toggle(),
                      ),
                      const SizedBox(width: 8),
                      _TopBarAvatar(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: border),
        ],
      ),
    );
  }
}

// ── Breadcrumb ────────────────────────────────────────────────────────────────
class _Breadcrumb extends StatelessWidget {
  final String title;
  final Color fg, subtle;
  const _Breadcrumb({required this.title, required this.fg, required this.subtle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'DocGen VN',
          style: AppTypography.bodySm.copyWith(color: subtle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(Icons.chevron_right, size: 14, color: subtle),
        ),
        Text(
          title,
          style: AppTypography.bodySm.copyWith(
            color: fg,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool focused;
  final ValueChanged<bool> onFocusChange;
  final Brightness brightness;

  const _SearchBar({
    required this.controller,
    required this.focused,
    required this.onFocusChange,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    final bg     = AppColors.bg(brightness);
    final border = focused ? AppColors.primary : AppColors.border(brightness);
    final subtle = AppColors.fgSubtle(brightness);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      height: 34,
      constraints: const BoxConstraints(maxWidth: 480),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border, width: focused ? 1.5 : 1),
        borderRadius: BorderRadius.circular(6),
        boxShadow: focused
            ? [BoxShadow(color: AppColors.primary.withOpacity(0.12), blurRadius: 0, spreadRadius: 3)]
            : null,
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(Icons.search, size: 14, color: subtle),
          const SizedBox(width: 8),
          Expanded(
            child: Focus(
              onFocusChange: onFocusChange,
              child: TextField(
                controller: controller,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.fg(brightness),
                ),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm...',
                  hintStyle: AppTypography.bodySm.copyWith(color: subtle),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border(brightness)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '⌘K',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                color: subtle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Icon button ───────────────────────────────────────────────────────────────
class _TopBarIconBtn extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Brightness brightness;
  const _TopBarIconBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.brightness,
  });

  @override
  State<_TopBarIconBtn> createState() => _TopBarIconBtnState();
}

class _TopBarIconBtnState extends State<_TopBarIconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit:  (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.hover(widget.brightness)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Icon(
              widget.icon,
              size: 18,
              color: AppColors.fgSubtle(widget.brightness),
            ),
          ),
        ),
      ),
    );
  }
}

// ── User avatar (TopBar) ──────────────────────────────────────────────────────
class _TopBarAvatar extends StatefulWidget {
  @override
  State<_TopBarAvatar> createState() => _TopBarAvatarState();
}

class _TopBarAvatarState extends State<_TopBarAvatar> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999),
            border: _hovered
                ? Border.all(color: AppColors.primary, width: 1.5)
                : Border.all(color: Colors.transparent, width: 1.5),
          ),
          child: Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(9999),
            ),
            alignment: Alignment.center,
            child: Text(
              'DV',
              style: AppTypography.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
