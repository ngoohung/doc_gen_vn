// lib/features/profile/presentation/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/tokens/app_colors.dart';
import '../../../core/tokens/app_spacing.dart';
import '../../../core/tokens/app_typography.dart';
import '../../../shared/widgets/dg_button.dart';
import '../../../shared/widgets/dg_card.dart';
import '../../../shared/widgets/dg_input.dart';
import '../../../shared/widgets/dg_misc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameCtrl      = TextEditingController(text: 'Nguyễn Văn A');
  final _emailCtrl     = TextEditingController(text: 'nva@example.com');
  final _oldPassCtrl   = TextEditingController();
  final _newPassCtrl   = TextEditingController();
  final _confirmCtrl   = TextEditingController();
  bool _savingProfile  = false;
  bool _savingPassword = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _oldPassCtrl.dispose(); _newPassCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _savingProfile = true);
    await Future.delayed(const Duration(milliseconds: 900));
    // TODO: gọi API PATCH /users/me  { name: _nameCtrl.text }
    if (!mounted) return;
    setState(() => _savingProfile = false);
    DgToast.show(context, 'Đã cập nhật thông tin', type: ToastType.success);
  }

  Future<void> _savePassword() async {
    if (_newPassCtrl.text != _confirmCtrl.text) {
      DgToast.show(context, 'Mật khẩu xác nhận không khớp', type: ToastType.error);
      return;
    }
    setState(() => _savingPassword = true);
    await Future.delayed(const Duration(milliseconds: 900));
    // TODO: gọi API POST /auth/change-password { old: _oldPassCtrl.text, new: _newPassCtrl.text }
    if (!mounted) return;
    setState(() => _savingPassword = false);
    _oldPassCtrl.clear(); _newPassCtrl.clear(); _confirmCtrl.clear();
    DgToast.show(context, 'Đã đổi mật khẩu thành công', type: ToastType.success);
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem có đang ở route admin không
    final isAdminView = GoRouterState.of(context).matchedLocation.startsWith('/admin');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg     = isDark ? AppColors.fgDark     : AppColors.fgLight;
    final muted  = isDark ? AppColors.fgMutedDark : AppColors.fgMutedLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s6),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cài đặt', style: AppTypography.h2.copyWith(color: fg)),
            Text(
              'Quản lý thông tin tài khoản',
              style: AppTypography.body.copyWith(color: muted),
            ),
            const SizedBox(height: AppSpacing.s6),

            // ── Profile card ──────────────────────────────────────────
            DgCard(
              padding: const EdgeInsets.all(AppSpacing.s6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin cá nhân',
                    style: AppTypography.h4.copyWith(color: fg),
                  ),
                  const SizedBox(height: AppSpacing.s5),

                  // Avatar row
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 64, height: 64,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                'N',
                                style: TextStyle(
                                  fontFamily: 'Inter', fontSize: 24,
                                  fontWeight: FontWeight.w700, color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: GestureDetector(
                              // TODO: FilePicker để chọn avatar, upload lên /users/me/avatar
                              onTap: () => DgToast.show(
                                context,
                                'Tính năng đổi avatar đang phát triển',
                                type: ToastType.info,
                              ),
                              child: Container(
                                width: 22, height: 22,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.cardDark
                                        : AppColors.cardLight,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt, size: 11, color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: AppSpacing.s4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nameCtrl.text,
                            style: AppTypography.bodySemibold.copyWith(color: fg),
                          ),
                          Text(
                            _emailCtrl.text,
                            style: AppTypography.caption.copyWith(color: muted),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  Divider(color: border),
                  const SizedBox(height: AppSpacing.s5),

                  DgInput(
                    label: 'Họ và tên',
                    controller: _nameCtrl,
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  DgInput(
                    label: 'Email',
                    controller: _emailCtrl,
                    readOnly: true,
                    // Email không thể đổi
                    helperText: 'Email không thể thay đổi',
                    prefixIcon: Icons.mail_outline,
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: DgButton.primary(
                      label: _savingProfile ? 'Đang lưu...' : 'Lưu thay đổi',
                      loading: _savingProfile,
                      onPressed: _savingProfile ? null : _saveProfile,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s4),

            // ── Change password card ──────────────────────────────────
            DgCard(
              padding: const EdgeInsets.all(AppSpacing.s6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Đổi mật khẩu', style: AppTypography.h4.copyWith(color: fg)),
                  const SizedBox(height: AppSpacing.s5),
                  DgInput.password(
                    label: 'Mật khẩu hiện tại',
                    controller: _oldPassCtrl,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  DgInput.password(
                    label: 'Mật khẩu mới',
                    hint: 'Ít nhất 8 ký tự',
                    controller: _newPassCtrl,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  DgInput.password(
                    label: 'Xác nhận mật khẩu mới',
                    controller: _confirmCtrl,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: DgButton.primary(
                      label: _savingPassword ? 'Đang lưu...' : 'Đổi mật khẩu',
                      loading: _savingPassword,
                      onPressed: _savingPassword ? null : _savePassword,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s4),

            // ── Usage stats card (Chỉ hiện nếu không phải Admin view) ──
            if (!isAdminView) ...[
              DgCard(
                padding: const EdgeInsets.all(AppSpacing.s6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Thống kê sử dụng', style: AppTypography.h4.copyWith(color: fg)),
                    const SizedBox(height: AppSpacing.s4),
                    _StatRow(label: 'Tài liệu đã tạo', value: '24', muted: muted, fg: fg),
                    Divider(height: AppSpacing.s4, color: border),
                    _StatRow(label: 'Tệp đã xử lý', value: '38', muted: muted, fg: fg),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
            ],

            // ── Danger zone ───────────────────────────────────────────
            DgCard(
              padding: const EdgeInsets.all(AppSpacing.s6),
              backgroundColor: isDark ? const Color(0xFF1C1420) : AppColors.errorSoft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vùng nguy hiểm',
                    style: AppTypography.h4.copyWith(color: AppColors.error),
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  Text(
                    'Xóa tài khoản sẽ xóa toàn bộ dữ liệu và không thể khôi phục.',
                    style: AppTypography.body.copyWith(color: muted),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  DgButton.destructive(
                    label: 'Xóa tài khoản',
                    icon: Icons.delete_forever_outlined,
                    onPressed: () async {
                      final ok = await DgConfirmDialog.show(
                        context,
                        title: 'Xóa tài khoản',
                        message:
                        'Toàn bộ tài liệu và dữ liệu sẽ bị xóa vĩnh viễn. Bạn có chắc không?',
                        confirmLabel: 'Xóa tài khoản',
                        destructive: true,
                      );
                      if (ok && mounted) {
                        // TODO: gọi API DELETE /users/me → logout → về landing
                        DgToast.show(context, 'Tính năng đang phát triển', type: ToastType.info);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color muted;
  final Color fg;

  const _StatRow({
    required this.label, required this.value,
    required this.muted, required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.body.copyWith(color: muted)),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(color: fg),
        ),
      ],
    );
  }
}