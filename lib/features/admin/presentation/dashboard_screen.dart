import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/tokens/app_colors.dart';
import '../../../core/tokens/app_spacing.dart';
import '../../../core/tokens/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/dg_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg     = isDark ? AppColors.fgDark     : AppColors.fgLight;
    final muted  = isDark ? AppColors.fgMutedDark : AppColors.fgMutedLight;
    final cols   = Responsive.isDesktop(context) ? 3 : (Responsive.isTablet(context) ? 2 : 1);

    // Đã xóa phần Tokens
    final stats = [
      _Stat(label: 'Tổng người dùng', value: '1,248', icon: Icons.people_outline, delta: '+12%'),
      _Stat(label: 'Tài liệu đã tạo', value: '8,432', icon: Icons.description_outlined, delta: '+24%'),
      _Stat(label: 'Yêu cầu hôm nay', value: '342',   icon: Icons.bolt_outlined, delta: '+8%'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard', style: AppTypography.h2.copyWith(color: fg)),
          Text(
            'Tổng quan hệ thống',
            style: AppTypography.body.copyWith(color: muted),
          ),
          const SizedBox(height: AppSpacing.s6),

          GridView.count(
            crossAxisCount: cols,
            crossAxisSpacing: AppSpacing.s3,
            mainAxisSpacing: AppSpacing.s3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: Responsive.isMobile(context) ? 2.0 : 2.5,
            children: stats.map((s) => _StatCard(stat: s, isDark: isDark, fg: fg, muted: muted)).toList(),
          ),
          const SizedBox(height: AppSpacing.s6),

          // Giữ nguyên phần Charts
          Responsive.isDesktop(context)
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _LineChartCard(isDark: isDark, fg: fg, muted: muted)),
              const SizedBox(width: AppSpacing.s4),
              Expanded(flex: 2, child: _PieChartCard(isDark: isDark, fg: fg, muted: muted)),
            ],
          )
              : Column(
            children: [
              _LineChartCard(isDark: isDark, fg: fg, muted: muted),
              const SizedBox(height: AppSpacing.s4),
              _PieChartCard(isDark: isDark, fg: fg, muted: muted),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Stat model ───────────────────────────────────────────────────────────────
class _Stat {
  final String label, value, delta;
  final IconData icon;
  const _Stat({required this.label, required this.value, required this.icon, required this.delta});
}

// ─── Stat card ────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final _Stat stat;
  final bool isDark;
  final Color fg, muted;

  const _StatCard({required this.stat, required this.isDark, required this.fg, required this.muted});

  @override
  Widget build(BuildContext context) {
    return DgCard(
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(stat.label, style: AppTypography.caption.copyWith(color: muted)),
              Icon(stat.icon, size: 16, color: AppColors.primary),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                stat.value,
                style: AppTypography.h3.copyWith(color: fg),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.successSoft,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  stat.delta,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.success, fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Line chart card ──────────────────────────────────────────────────────────
class _LineChartCard extends StatefulWidget {
  final bool isDark;
  final Color fg, muted;
  const _LineChartCard({required this.isDark, required this.fg, required this.muted});

  @override
  State<_LineChartCard> createState() => _LineChartCardState();
}

class _LineChartCardState extends State<_LineChartCard> {
  // TODO: dữ liệu thực từ API GET /admin/stats/requests?period=week
  final _data = const [42.0, 68.0, 55.0, 89.0, 120.0, 98.0, 145.0];
  final _labels = const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
  String _period = 'week';

  @override
  Widget build(BuildContext context) {
    final border = widget.isDark ? AppColors.borderDark : AppColors.borderLight;
    final gridColor = widget.isDark
        ? AppColors.borderDark
        : const Color(0xFFF3F4F6);

    return DgCard(
      padding: const EdgeInsets.all(AppSpacing.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Yêu cầu sinh tài liệu',
                  style: AppTypography.h4.copyWith(color: widget.fg),
                ),
              ),
              // Period selector
              for (final p in [('week', 'Tuần'), ('month', 'Tháng'), ('year', 'Năm')])
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: GestureDetector(
                    onTap: () => setState(() => _period = p.$1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _period == p.$1 ? AppColors.primarySoft : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        p.$2,
                        style: AppTypography.caption.copyWith(
                          color: _period == p.$1 ? AppColors.primary : widget.muted,
                          fontWeight: _period == p.$1 ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.s5),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 40,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: gridColor, strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (v, _) {
                        final i = v.toInt();
                        if (i < 0 || i >= _labels.length) return const SizedBox();
                        return Text(
                          _labels[i],
                          style: AppTypography.caption.copyWith(color: widget.muted),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 40,
                      reservedSize: 36,
                      getTitlesWidget: (v, _) => Text(
                        v.toInt().toString(),
                        style: AppTypography.caption.copyWith(color: widget.muted),
                      ),
                    ),
                  ),
                  topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _data.asMap().entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 2,
                    dotData: FlDotData(
                      getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                        radius: 3,
                        color: AppColors.primary,
                        strokeWidth: 0,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withOpacity(0.15),
                          AppColors.primary.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
                minY: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Pie chart card ───────────────────────────────────────────────────────────
class _PieChartCard extends StatefulWidget {
  final bool isDark;
  final Color fg, muted;
  const _PieChartCard({required this.isDark, required this.fg, required this.muted});

  @override
  State<_PieChartCard> createState() => _PieChartCardState();
}

class _PieChartCardState extends State<_PieChartCard> {
  int _touched = -1;

  // TODO: dữ liệu thực từ API GET /admin/stats/languages
  final _items = const [
    _PieItem('TypeScript', 28.0, AppColors.primary),
    _PieItem('Python',     22.0, Color(0xFF22C55E)),
    _PieItem('JavaScript', 18.0, Color(0xFFF59E0B)),
    _PieItem('Java',       14.0, Color(0xFFEF4444)),
    _PieItem('Go',          10.0, Color(0xFF3B82F6)),
    _PieItem('Khác',        8.0,  Color(0xFF94A3B8)),
  ];

  @override
  Widget build(BuildContext context) {
    return DgCard(
      padding: const EdgeInsets.all(AppSpacing.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ngôn ngữ phổ biến',
            style: AppTypography.h4.copyWith(color: widget.fg),
          ),
          const SizedBox(height: AppSpacing.s5),
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (_, res) => setState(() {
                    _touched = res?.touchedSection?.touchedSectionIndex ?? -1;
                  }),
                ),
                sections: _items.asMap().entries.map((e) {
                  final isTouched = e.key == _touched;
                  return PieChartSectionData(
                    value: e.value.value,
                    color: e.value.color,
                    radius: isTouched ? 60 : 50,
                    title: '${e.value.value.toInt()}%',
                    titleStyle: AppTypography.caption.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600,
                    ),
                    showTitle: isTouched || e.value.value >= 15,
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          // Legend
          Wrap(
            spacing: AppSpacing.s3,
            runSpacing: AppSpacing.s2,
            children: _items.map((item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 5),
                Text(item.label, style: AppTypography.caption.copyWith(color: widget.muted)),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _PieItem {
  final String label;
  final double value;
  final Color color;
  const _PieItem(this.label, this.value, this.color);
}
