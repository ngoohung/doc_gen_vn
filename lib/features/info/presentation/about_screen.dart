// lib/features/info/presentation/about_screen.dart
// Trang Giới thiệu - yêu cầu I.13

import 'package:flutter/material.dart';

import '../../../core/tokens/app_colors.dart';
import '../../../core/tokens/app_spacing.dart';
import '../../../core/tokens/app_typography.dart';
import '_info_shell.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoShell(
      title: 'Giới thiệu dự án',
      subtitle:
      'DocGen VN - Hệ thống AI sinh tài liệu mã nguồn bằng Tiếng Việt sử dụng GraphRAG',
      icon: Icons.school_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoSection(
            title: 'Về dự án',
            children: const [
              InfoParagraph(
                'DocGen VN là sản phẩm của nhóm sinh viên trong khuôn khổ học phần Khai phá dữ liệu '
                    'tại Trường Đại học Khoa học Tự nhiên, ĐHQGHN. Mục tiêu của dự án là xây dựng một hệ thống AI có khả năng '
                    'phân tích mã nguồn và tự động sinh tài liệu kỹ thuật bằng Tiếng Việt, hỗ trợ '
                    'cộng đồng lập trình viên Việt Nam.',
              ),
              InfoParagraph(
                'Hệ thống áp dụng kiến trúc GraphRAG (Graph-based Retrieval-Augmented Generation), '
                    'kết hợp phân tích cây cú pháp trừu tượng (AST) với mô hình ngôn ngữ lớn (Llama 3.1) '
                    'để hiểu sâu cấu trúc và ngữ nghĩa của mã nguồn trước khi sinh tài liệu.',
              ),
            ],
          ),
          InfoSection(
            title: 'Giảng viên hướng dẫn',
            children: [
              _TeacherCard(),
            ],
          ),
          InfoSection(
            title: 'Môn học',
            children: const [
              InfoParagraph(
                'Khai phá dữ liệu (Data Mining) - Trường Đại học Khoa học Tự nhiên, '
                    'Đại học Quốc gia Hà Nội. Học phần cung cấp kiến thức nền tảng và nâng cao về '
                    'các kỹ thuật trích xuất tri thức từ dữ liệu lớn: phân lớp, phân cụm, hồi quy, '
                    'khai phá luật kết hợp, và các kiến trúc Deep Learning hiện đại.',
              ),
            ],
          ),
          InfoSection(
            title: 'Công nghệ sử dụng',
            children: [
              _TechGroup(
                title: 'Frontend',
                items: const [
                  'Flutter Web - Framework UI đa nền tảng của Google',
                  'Riverpod - Quản lý state',
                  'GoRouter - Định tuyến',
                  'flutter_markdown - Hiển thị Markdown',
                  'fl_chart - Biểu đồ Admin Dashboard',
                ],
              ),
              _TechGroup(
                title: 'Backend',
                items: const [
                  'FastAPI (Python 3.11) - REST API hiệu năng cao',
                  'SQLAlchemy 2.0 - ORM',
                  'PostgreSQL + pgvector - Cơ sở dữ liệu',
                  'Tree-sitter - Phân tích AST đa ngôn ngữ',
                  'WeasyPrint + python-docx - Xuất PDF / DOCX',
                  'Bcrypt + JWT-like sessions - Xác thực',
                ],
              ),
              _TechGroup(
                title: 'AI / ML',
                items: const [
                  'Llama 3.1 8B Instant - Groq Cloud',
                  'Llama 3.1 finetuned on Kaggle',
                  'sentence-transformers - Embedding',
                  'GraphRAG - Truy xuất đồ thị tri thức',
                  'PyTorch + Transformers',
                ],
              ),
              _TechGroup(
                title: 'Hạ tầng',
                items: const [
                  'AWS EC2 (Ubuntu) - Máy chủ',
                  'Docker + Docker Compose - Đóng gói',
                  'Nginx - Web server / Reverse proxy',
                  'Cloudflare - CDN + bảo mật',
                  'GitHub - Quản lý mã nguồn',
                ],
              ),
            ],
          ),
          InfoSection(
            title: 'Ngôn ngữ lập trình được hỗ trợ',
            children: const [
              InfoBullet('Python (.py)'),
              InfoBullet('Java (.java)'),
              InfoBullet('JavaScript (.js, .jsx)'),
              InfoBullet('TypeScript (.ts, .tsx)'),
              InfoBullet('C++ (.cpp, .cc, .h, .hpp)'),
              InfoBullet('Rust (.rs)'),
            ],
          ),
          InfoSection(
            title: 'Tính năng nổi bật',
            children: const [
              InfoBullet(
                  'Phân tích AST kết hợp đồ thị tri thức để hiểu chính xác cấu trúc code.'),
              InfoBullet(
                  'Sinh tài liệu Tiếng Việt với thuật ngữ kỹ thuật chuẩn xác.'),
              InfoBullet(
                  'Cảnh báo lỗi cú pháp nhưng cho phép người dùng tự quyết định.'),
              InfoBullet(
                  'Xuất tài liệu sang Markdown, PDF, Word - tích hợp dễ dàng vào quy trình làm việc.'),
              InfoBullet(
                  'Lưu trữ phiên bản - chỉnh sửa và so sánh lịch sử tài liệu.'),
              InfoBullet(
                  'Đăng nhập đa nền tảng - Web, Android, iOS.'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TeacherCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppColors.cardDark : AppColors.cardLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final fg = isDark ? AppColors.fgDark : AppColors.fgLight;
    final muted = isDark ? AppColors.fgMutedDark : AppColors.fgMutedLight;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s5),
      decoration: BoxDecoration(
        color: card,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SỬA ĐỔI CHÍNH: Thay đổi bố cục từ Row sang Column
          // và làm cho ảnh to ra.
          ClipRRect(
            borderRadius: BorderRadius.circular(12), // Bo góc ảnh để khớp với thẻ
            child: Image.asset(
              'assets/img/thaygiao.png',
              // Loại bỏ các ràng buộc chiều rộng và chiều cao cố định (64x64)
              // và sử dụng BoxFit.cover với một chiều cao lớn cố định để "to ra".
              // Bạn có thể điều chỉnh chiều cao này (ví dụ: 400) để đạt được kích thước mong muốn
              // trong khi vẫn duy trì tỷ lệ gốc (956x759).
              height: 400, // Chiều cao lớn để làm cho ảnh "to ra" đáng kể
              fit: BoxFit.cover, // Chiếm toàn bộ chiều rộng thẻ
              errorBuilder: (context, error, stackTrace) {
                // Hiển thị fallback nếu không tìm thấy ảnh
                return Container(
                  width: double.infinity,
                  height: 400,
                  color: Colors.grey.withOpacity(0.2),
                  child: Icon(Icons.person, color: muted, size: 64),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.s4), // Lề giữa ảnh và văn bản
          // Bắt đầu phần thông tin văn bản
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PGS.TS Lê Hoàng Sơn',
                  style: AppTypography.h4.copyWith(color: fg, fontSize: 20)), // Tăng kích thước phông chữ một chút
              const SizedBox(height: 6),
              Text(
                'Phó Viện trưởng Viện Công nghệ Thông tin',
                style: AppTypography.bodyMedium.copyWith(color: muted, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                'Đại học Quốc gia Hà Nội',
                style: AppTypography.bodySmall.copyWith(color: muted, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Giảng viên hướng dẫn',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.primary, fontSize: 14)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TechGroup extends StatelessWidget {
  final String title;
  final List<String> items;
  const _TechGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? AppColors.fgDark : AppColors.fgLight;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTypography.h4
                  .copyWith(color: fg, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...items.map((i) => InfoBullet(i)),
        ],
      ),
    );
  }
}