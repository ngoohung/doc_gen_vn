import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../core/tokens/app_colors.dart';
import '../../../core/tokens/app_spacing.dart';
import '../../../core/tokens/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/dg_button.dart';
import '../../../shared/widgets/dg_misc.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _inputTabCtrl;
  late final TabController _mobileTabCtrl;

  final _codeCtrl = TextEditingController();
  String _selectedLang = 'auto';
  bool _generating  = false;
  bool _hasOutput   = false;
  String _output    = '';
  bool _editMode    = false;
  final _editCtrl   = TextEditingController();

  final _langs = const [
    ('auto', 'Tự động'),
    ('dart', 'Dart'),
    ('javascript', 'JavaScript'),
    ('typescript', 'TypeScript'),
    ('python', 'Python'),
    ('java', 'Java'),
    ('kotlin', 'Kotlin'),
    ('swift', 'Swift'),
    ('go', 'Go'),
    ('rust', 'Rust'),
    ('cpp', 'C++'),
    ('csharp', 'C#'),
  ];

  final _sampleOutput = '''## `UserService`

Lớp xử lý nghiệp vụ liên quan đến người dùng.

### `constructor(db: Database)`

Khởi tạo service với kết nối cơ sở dữ liệu.

**Tham số:**
- `db` — Instance kết nối database

---

### `getUser(id: string): Promise<User>`

Lấy thông tin người dùng theo ID.

**Tham số:**
- `id` — ID duy nhất của người dùng

**Trả về:** `Promise<User>` — Đối tượng người dùng hoặc `null` nếu không tìm thấy

**Ví dụ:**
```javascript
const user = await userService.getUser('abc-123');
console.log(user.name); // "Nguyễn Văn A"
```

---

### `updateUser(id: string, data: Partial<User>): Promise<User>`

Cập nhật thông tin người dùng.

**Tham số:**
- `id`   — ID người dùng
- `data` — Các trường cần cập nhật (partial object)

**Trả về:** Đối tượng người dùng sau khi cập nhật

**Lưu ý:** Trường `email` không thể thay đổi qua phương thức này.''';

  @override
  void initState() {
    super.initState();
    _inputTabCtrl  = TabController(length: 2, vsync: this);
    _mobileTabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _inputTabCtrl.dispose();
    _mobileTabCtrl.dispose();
    _codeCtrl.dispose();
    _editCtrl.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_codeCtrl.text.trim().isEmpty) {
      DgToast.show(context, 'Vui lòng nhập mã nguồn trước', type: ToastType.warning);
      return;
    }
    setState(() { _generating = true; _hasOutput = false; });
    await Future.delayed(const Duration(milliseconds: 1800));
    // TODO: gọi API POST /docs/generate
    // body: { code: _codeCtrl.text, language: _selectedLang }
    // response: { markdown: string, tokens_used: int }
    if (!mounted) return;
    setState(() {
      _generating = false;
      _hasOutput  = true;
      _output     = _sampleOutput;
    });
    // Auto-switch to output tab on mobile
    if (mounted && Responsive.isMobile(context)) {
      _mobileTabCtrl.animateTo(1);
    }
  }

  void _copyOutput() {
    Clipboard.setData(ClipboardData(text: _output));
    DgToast.show(context, 'Đã sao chép vào clipboard', type: ToastType.success);
  }

  void _saveHistory() {
    // TODO: gọi API POST /history  { markdown: _output }
    DgToast.show(context, 'Đã lưu vào lịch sử', type: ToastType.success);
  }

  void _exportMarkdown() {
    // TODO: tạo file .md và trigger download (web) hoặc share (mobile)
    DgToast.show(context, 'Tính năng xuất file đang phát triển', type: ToastType.info);
  }

  void _exportPdf() {
    // TODO: dùng package pdf để tạo PDF từ _output
    DgToast.show(context, 'Tính năng xuất PDF đang phát triển', type: ToastType.info);
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? _buildMobile()
        : _buildDesktop();
  }

  // ─── Desktop: side-by-side ─────────────────────────────────────────────────
  Widget _buildDesktop() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _InputPanel()),
          const SizedBox(width: AppSpacing.s4),
          Expanded(child: _OutputPanel()),
        ],
      ),
    );
  }

  // ─── Mobile: tabs ──────────────────────────────────────────────────────────
  Widget _buildMobile() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final fg     = isDark ? AppColors.fgDark     : AppColors.fgLight;
    final muted  = isDark ? AppColors.fgMutedDark : AppColors.fgMutedLight;

    return Column(
      children: [
        Container(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          child: TabBar(
            controller: _mobileTabCtrl,
            labelColor: AppColors.primary,
            unselectedLabelColor: muted,
            indicatorColor: AppColors.primary,
            dividerColor: border,
            labelStyle: AppTypography.bodyMedium,
            tabs: const [
              Tab(text: 'Nhập mã nguồn'),
              Tab(text: 'Tài liệu'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _mobileTabCtrl,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s4),
                child: _InputPanel(),
              ),
              _OutputPanel(),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Input panel ───────────────────────────────────────────────────────────
  Widget _InputPanel() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg     = isDark ? AppColors.cardDark    : AppColors.cardLight;
    final border = isDark ? AppColors.borderDark  : AppColors.borderLight;
    final fg     = isDark ? AppColors.fgDark      : AppColors.fgLight;
    final muted  = isDark ? AppColors.fgMutedDark : AppColors.fgMutedLight;
    final codeBg = isDark ? AppColors.bgDark      : AppColors.sunkenLight;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s4, vertical: 10,
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: border)),
            ),
            child: Row(
              children: [
                // Input type tabs
                _SmallTab(
                  label: 'Dán mã nguồn',
                  index: 0,
                  controller: _inputTabCtrl,
                  isDark: isDark,
                ),
                const SizedBox(width: AppSpacing.s2),
                _SmallTab(
                  label: 'Tải tệp lên',
                  index: 1,
                  controller: _inputTabCtrl,
                  isDark: isDark,
                ),
                const Spacer(),
                // Language selector
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: border),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedLang,
                      isDense: true,
                      icon: const Icon(Icons.keyboard_arrow_down, size: 14),
                      style: AppTypography.caption.copyWith(color: fg),
                      onChanged: (v) => setState(() => _selectedLang = v ?? 'auto'),
                      items: _langs.map((l) => DropdownMenuItem(
                        value: l.$1,
                        child: Text(l.$2),
                      )).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Tab content ───────────────────────────────────────────
          Flexible(
            child: AnimatedBuilder(
              animation: _inputTabCtrl,
              builder: (_, __) {
                if (_inputTabCtrl.index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.s3),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 280),
                      decoration: BoxDecoration(
                        color: codeBg,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: border),
                      ),
                      child: TextField(
                        controller: _codeCtrl,
                        maxLines: null,
                        minLines: 12,
                        style: AppTypography.code.copyWith(
                          color: fg, fontSize: 13,
                        ),
                        decoration: InputDecoration(
                          hintText: '// Dán mã nguồn của bạn vào đây...',
                          hintStyle: AppTypography.code.copyWith(
                            color: isDark ? AppColors.fgSubtleDark : AppColors.fgSubtleLight,
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.all(AppSpacing.s3),
                          isDense: true,
                        ),
                      ),
                    ),
                  );
                }
                // Upload file tab
                return _UploadZone(isDark: isDark, border: border, muted: muted);
              },
            ),
          ),

          // ── Generate button ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s4),
            child: DgButton.primary(
              label: _generating ? 'Đang sinh tài liệu...' : 'Sinh tài liệu',
              icon: _generating ? null : Icons.bolt,
              loading: _generating,
              fullWidth: true,
              onPressed: _generating ? null : _generate,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Output panel ──────────────────────────────────────────────────────────
  Widget _OutputPanel() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg     = isDark ? AppColors.cardDark   : AppColors.cardLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final fg     = isDark ? AppColors.fgDark     : AppColors.fgLight;
    final muted  = isDark ? AppColors.fgMutedDark : AppColors.fgMutedLight;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Toolbar ───────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s4, vertical: 10,
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: border)),
            ),
            child: Row(
              children: [
                Text(
                  'Tài liệu',
                  style: AppTypography.bodyMedium.copyWith(color: fg),
                ),
                const Spacer(),
                if (_hasOutput) ...[
                  _ActionBtn(
                    icon: _editMode
                        ? Icons.visibility_outlined
                        : Icons.edit_outlined,
                    label: _editMode ? 'Xem' : 'Chỉnh sửa',
                    onTap: () {
                      setState(() {
                        _editMode = !_editMode;
                        if (_editMode) _editCtrl.text = _output;
                        else _output = _editCtrl.text;
                      });
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(width: 4),
                  _ActionBtn(
                    icon: Icons.copy_outlined,
                    label: 'Sao chép',
                    onTap: _copyOutput,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 4),
                  _ActionBtn(
                    icon: Icons.bookmark_border,
                    label: 'Lưu',
                    onTap: _saveHistory,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 4),
                  _ExportMenu(
                    onExportMd:  _exportMarkdown,
                    onExportPdf: _exportPdf,
                    isDark: isDark,
                  ),
                ],
              ],
            ),
          ),

          // ── Content ───────────────────────────────────────────────
          Flexible(
            child: _generating
                ? _buildSkeletonOutput()
                : _hasOutput
                    ? _editMode
                        ? Padding(
                            padding: const EdgeInsets.all(AppSpacing.s4),
                            child: TextField(
                              controller: _editCtrl,
                              maxLines: null,
                              style: AppTypography.code.copyWith(
                                color: fg, fontSize: 13,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          )
                        : Markdown(
                            data: _output,
                            padding: const EdgeInsets.all(AppSpacing.s5),
                            styleSheet: MarkdownStyleSheet(
                              p: AppTypography.body.copyWith(color: fg),
                              h1: AppTypography.h2.copyWith(color: fg),
                              h2: AppTypography.h3.copyWith(color: fg),
                              h3: AppTypography.h4.copyWith(color: fg),
                              code: AppTypography.code.copyWith(color: fg),
                              codeblockDecoration: BoxDecoration(
                                color: isDark ? AppColors.bgDark : AppColors.sunkenLight,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: border),
                              ),
                            ),
                          )
                    : DgEmptyState(
                        icon: Icons.description_outlined,
                        message: 'Tài liệu sẽ hiển thị ở đây',
                        description: 'Nhập mã nguồn và nhấn "Sinh tài liệu" để bắt đầu.',
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonOutput() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DgSkeleton(width: 200, height: 22),
          const SizedBox(height: AppSpacing.s5),
          DgSkeleton.text(lines: 4),
          const SizedBox(height: AppSpacing.s5),
          DgSkeleton(width: 160, height: 18),
          const SizedBox(height: AppSpacing.s3),
          DgSkeleton.text(lines: 3),
          const SizedBox(height: AppSpacing.s5),
          DgSkeleton(width: 180, height: 18),
          const SizedBox(height: AppSpacing.s3),
          DgSkeleton.text(lines: 5),
        ],
      ),
    );
  }
}

// ─── Small tab ────────────────────────────────────────────────────────────────
class _SmallTab extends StatelessWidget {
  final String label;
  final int index;
  final TabController controller;
  final bool isDark;

  const _SmallTab({
    required this.label, required this.index,
    required this.controller, required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final active = controller.index == index;
        return GestureDetector(
          onTap: () => controller.animateTo(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: active ? AppColors.primarySoft : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: AppTypography.caption.copyWith(
                color: active ? AppColors.primary
                    : (isDark ? AppColors.fgMutedDark : AppColors.fgMutedLight),
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Upload zone ─────────────────────────────────────────────────────────────
class _UploadZone extends StatelessWidget {
  final bool isDark;
  final Color border;
  final Color muted;

  const _UploadZone({
    required this.isDark, required this.border, required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: GestureDetector(
        // TODO: gọi FilePicker.platform.pickFiles để chọn file code
        onTap: () => DgToast.show(
          context, 'Tính năng tải tệp đang phát triển', type: ToastType.info,
        ),
        child: Container(
          constraints: const BoxConstraints(minHeight: 200),
          decoration: BoxDecoration(
            border: Border.all(color: border, width: 1.5),
            borderRadius: BorderRadius.circular(6),
            color: isDark ? AppColors.bgDark : AppColors.sunkenLight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.upload_file_outlined,
                size: 32,
                color: muted,
              ),
              const SizedBox(height: AppSpacing.s3),
              Text(
                'Kéo tệp vào đây hoặc nhấn để chọn',
                style: AppTypography.body.copyWith(color: muted),
              ),
              const SizedBox(height: 4),
              Text(
                '.py · .js · .ts · .java · .kt · .go · .dart · .rs...',
                style: AppTypography.caption.copyWith(color: muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Action button ────────────────────────────────────────────────────────────
class _ActionBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _ActionBtn({
    required this.icon, required this.label,
    required this.onTap, required this.isDark,
  });

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final hover = widget.isDark ? AppColors.hoverDark : AppColors.hoverLight;
    final muted = widget.isDark ? AppColors.fgMutedDark : AppColors.fgMutedLight;

    return Tooltip(
      message: widget.label,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit:  (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: _hovered ? hover : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 14, color: muted),
                const SizedBox(width: 4),
                Text(
                  widget.label,
                  style: AppTypography.caption.copyWith(color: muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Export menu ──────────────────────────────────────────────────────────────
class _ExportMenu extends StatelessWidget {
  final VoidCallback onExportMd;
  final VoidCallback onExportPdf;
  final bool isDark;

  const _ExportMenu({
    required this.onExportMd, required this.onExportPdf, required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final muted = isDark ? AppColors.fgMutedDark : AppColors.fgMutedLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return PopupMenuButton<String>(
      onSelected: (v) {
        if (v == 'md')  onExportMd();
        if (v == 'pdf') onExportPdf();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: border),
      ),
      elevation: 0,
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download_outlined, size: 14, color: muted),
            const SizedBox(width: 4),
            Text('Xuất file', style: AppTypography.caption.copyWith(color: muted)),
            const SizedBox(width: 2),
            Icon(Icons.keyboard_arrow_down, size: 12, color: muted),
          ],
        ),
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'md',
          child: Row(
            children: [
              const Icon(Icons.description_outlined, size: 16),
              const SizedBox(width: 8),
              Text('Xuất Markdown', style: AppTypography.body),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'pdf',
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf_outlined, size: 16),
              const SizedBox(width: 8),
              Text('Xuất PDF', style: AppTypography.body),
            ],
          ),
        ),
      ],
    );
  }
}
