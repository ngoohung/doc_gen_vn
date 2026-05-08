import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/tokens/app_colors.dart';
import '../../core/tokens/app_typography.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/app_theme.dart';

const _memberTitles = ['Sinh tài liệu', 'Lịch sử', 'Cài đặt'];
const _adminTitles  = ['Dashboard', 'Người dùng', 'Cài đặt'];

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

    return AnimatedContainer(
      duration: AppTheme.themeTransitionDuration,
      curve: AppTheme.themeCurve,
      height: 56,
      color: bg,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  if (widget.showMenuButton)
                    IconButton(
                      icon: const Icon(Icons.menu, size: 20),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  _Breadcrumb(title: title, fg: fg, subtle: subtle),
                  const Spacer(),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _TopBarIconBtn(
                        icon: isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
                        onTap: () => ref.read(themeModeProvider.notifier).toggle(),
                        brightness: brightness,
                      ),
                      const SizedBox(width: 8),
                      const _TopBarAvatar(),
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
      duration: AppTheme.themeTransitionDuration,
      curve: AppTheme.themeCurve,
      height: 34,
      constraints: const BoxConstraints(maxWidth: 480),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border, width: focused ? 1.5 : 1),
        borderRadius: BorderRadius.circular(6),
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
                style: AppTypography.bodySmall.copyWith(color: AppColors.fg(brightness)),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm...',
                  hintStyle: AppTypography.bodySmall.copyWith(color: subtle),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBarAvatar extends StatelessWidget {
  const _TopBarAvatar();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/profile'),
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
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  final String title;
  final Color fg, subtle;
  const _Breadcrumb({required this.title, required this.fg, required this.subtle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('DocGen VN', style: AppTypography.bodySmall.copyWith(color: subtle)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(Icons.chevron_right, size: 14, color: subtle),
        ),
        Text(title, style: AppTypography.bodySmall.copyWith(color: fg, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _TopBarIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Brightness brightness;
  const _TopBarIconBtn({required this.icon, required this.onTap, required this.brightness});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: AppColors.fgSubtle(brightness)),
      ),
    );
  }
}