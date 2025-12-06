// lib/features/baby/presentation/pages/growth_tracker_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/database/models/baby_growth_model.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_state.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class GrowthTrackerPage extends StatefulWidget {
  final String? babyId;
  
  const GrowthTrackerPage({super.key, this.babyId});

  @override
  State<GrowthTrackerPage> createState() => _GrowthTrackerPageState();
}

class _GrowthTrackerPageState extends State<GrowthTrackerPage> {
  bool showWeight = true;
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<BabyCubit>();
    if (cubit.currentBabyId != null) {
      cubit.loadGrowthRecords();
      _hasLoadedData = true;
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  List<FlSpot> _getChartSpots(List<BabyGrowthModel> records, bool isWeight) {
    final sortedRecords = records
        .where((r) => isWeight ? r.weight != null : r.height != null)
        .toList()
      ..sort((a, b) => a.recordedDate.compareTo(b.recordedDate));

    return List.generate(
      sortedRecords.length,
      (index) => FlSpot(
        index.toDouble(),
        (isWeight ? sortedRecords[index].weight : sortedRecords[index].height)?.toDouble() ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      body: SafeArea(
        child: BlocConsumer<BabyCubit, BabyState>(
          listener: (context, state) {
            if (state is BabyLoaded && !_hasLoadedData) {
              _hasLoadedData = true;
              context.read<BabyCubit>().loadGrowthRecords();
            }
            if (state is BabyOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is BabyLoading || state is GrowthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is BabyError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<BabyCubit>().loadBabyProfile(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            if (state is NoBabyProfile) {
              return const Center(
                child: Text('No baby profile found. Please add your baby first.'),
              );
            }
            
            List<BabyGrowthModel> growthRecords = [];
            if (state is GrowthLoaded) {
              growthRecords = state.growthRecords;
            }
            
            final weightRecords = growthRecords
                .where((r) => r.weight != null)
                .toList()
              ..sort((a, b) => b.recordedDate.compareTo(a.recordedDate));
            
            final heightRecords = growthRecords
                .where((r) => r.height != null)
                .toList()
              ..sort((a, b) => b.recordedDate.compareTo(a.recordedDate));
            
            final filteredRecords = showWeight ? weightRecords : heightRecords;
            final chartSpots = _getChartSpots(growthRecords, showWeight);
            
            final latestValue = filteredRecords.isNotEmpty
                ? (showWeight ? filteredRecords.first.weight : filteredRecords.first.height)
                : null;
            final latestDate = filteredRecords.isNotEmpty ? filteredRecords.first.recordedDate : null;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: AppColors.main500, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Growth Tracker',
                            style: AppTextStyles.headline1.copyWith(color: AppColors.main500),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: AppColors.shadow1,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => showWeight = true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        color: showWeight ? AppColors.main500 : Colors.transparent,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Weight',
                                          style: AppTextStyles.subtitle1.copyWith(
                                            color: showWeight ? AppColors.white : AppColors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => showWeight = false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        color: !showWeight ? AppColors.main500 : Colors.transparent,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Height',
                                          style: AppTextStyles.subtitle1.copyWith(
                                            color: !showWeight ? AppColors.white : AppColors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: showWeight 
                                    ? [AppColors.pink500, AppColors.pink300]
                                    : [AppColors.blue500, AppColors.blue300],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: AppColors.shadow1,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  showWeight ? 'Current Weight' : 'Current Height',
                                  style: AppTextStyles.body1.copyWith(color: AppColors.white.withValues(alpha: 0.7)),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  latestValue != null 
                                      ? '${latestValue.toStringAsFixed(1)} ${showWeight ? 'kg' : 'cm'}'
                                      : 'No data',
                                  style: AppTextStyles.numberHighlight.copyWith(fontSize: 36),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  latestDate != null 
                                      ? 'Last updated: ${DateFormat('MMM d, yyyy').format(latestDate)}'
                                      : 'No records yet',
                                  style: AppTextStyles.smallLabel.copyWith(color: AppColors.white.withValues(alpha: 0.7)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          if (chartSpots.isNotEmpty)
                            Container(
                              height: 280,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: AppColors.shadow1,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    showWeight ? 'Weight Progress' : 'Height Progress',
                                    style: AppTextStyles.subtitle1.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Expanded(
                                    child: LineChart(
                                      LineChartData(
                                        gridData: FlGridData(
                                          show: true,
                                          drawVerticalLine: true,
                                          horizontalInterval: null,
                                          verticalInterval: null,
                                          getDrawingHorizontalLine: (value) {
                                            return FlLine(
                                              color: Colors.grey.withValues(alpha: 0.1),
                                              strokeWidth: 1,
                                            );
                                          },
                                          getDrawingVerticalLine: (value) {
                                            return FlLine(
                                              color: Colors.grey.withValues(alpha: 0.1),
                                              strokeWidth: 1,
                                            );
                                          },
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 30,
                                              interval: chartSpots.length > 5 ? (chartSpots.length / 5).ceilToDouble() : 1,
                                              getTitlesWidget: (value, meta) {
                                                if (value.toInt() >= chartSpots.length) return const SizedBox();
                                                return Text(
                                                  '${value.toInt() + 1}',
                                                  style: AppTextStyles.smallLabel,
                                                );
                                              },
                                            ),
                                          ),
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              interval: null,
                                              getTitlesWidget: (value, meta) {
                                                return Text(
                                                  '${value.toInt()}',
                                                  style: AppTextStyles.smallLabel,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        borderData: FlBorderData(show: true),
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: chartSpots,
                                            isCurved: true,
                                            color: showWeight ? AppColors.pink500 : AppColors.blue500,
                                            barWidth: 3,
                                            isStrokeCapRound: true,
                                            dotData: FlDotData(
                                              show: true,
                                              getDotPainter: (spot, percent, barData, index) {
                                                return FlDotCirclePainter(
                                                  radius: 4,
                                                  color: showWeight ? AppColors.pink500 : AppColors.blue500,
                                                  strokeWidth: 2,
                                                  strokeColor: AppColors.white,
                                                );
                                              },
                                            ),
                                            belowBarData: BarAreaData(
                                              show: true,
                                              color: (showWeight ? AppColors.pink500 : AppColors.blue500).withValues(alpha: 0.1),
                                            ),
                                          ),
                                        ],
                                        minY: null,
                                        maxY: null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              height: 250,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: AppColors.shadow1,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'No Data Yet',
                                    style: AppTextStyles.subtitle1.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Expanded(
                                    child: Center(
                                      child: Icon(
                                        Icons.show_chart,
                                        size: 80,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Add records to see chart visualization',
                                    style: AppTextStyles.smallLabel,
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 24),

                          Text(
                            'Recent Logs',
                            style: AppTextStyles.headline2,
                          ),
                          const SizedBox(height: 12),
                          if (filteredRecords.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  showWeight ? 'No weight records yet' : 'No height records yet',
                                  style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
                                ),
                              ),
                            )
                          else
                            ...filteredRecords.take(10).map((record) => _buildLogItem(
                              '${(showWeight ? record.weight : record.height)?.toStringAsFixed(1)} ${showWeight ? 'kg' : 'cm'}',
                              DateFormat('MMM d, yyyy').format(record.recordedDate),
                              record == filteredRecords.first,
                              showWeight,
                            )),
                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _showAddLogDialog(context),
                              icon: const Icon(Icons.add),
                              label: Text(showWeight ? 'Add Weight Log' : 'Add Height Log'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: showWeight ? AppColors.pink500 : AppColors.blue500,
                                foregroundColor: AppColors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogItem(String value, String date, bool isLatest, bool isWeight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLatest 
            ? (isWeight ? AppColors.pink300 : AppColors.blue300).withValues(alpha: 0.3)
            : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLatest ? (isWeight ? AppColors.pink500 : AppColors.blue500) : Colors.transparent,
          width: 2,
        ),
        boxShadow: AppColors.shadow1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: isLatest 
                    ? (isWeight ? AppColors.pink500 : AppColors.blue500)
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                value,
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: isLatest ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
          Text(date, style: AppTextStyles.body1),
        ],
      ),
    );
  }

  void _showAddLogDialog(BuildContext context) {
    _valueController.clear();
    _selectedDate = DateTime.now();
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.bg_1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                showWeight ? 'Add Weight Log' : 'Add Height Log',
                style: AppTextStyles.headline2,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _valueController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: showWeight ? 'Weight (kg)' : 'Height (cm)',
                      labelStyle: AppTextStyles.body1,
                      hintText: showWeight ? 'e.g., 5.5' : 'e.g., 65',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.main500, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setDialogState(() => _selectedDate = picked);
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: AppTextStyles.body1,
                          hintText: DateFormat('MMM d, yyyy').format(_selectedDate),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          suffixIcon: const Icon(Icons.calendar_today, color: AppColors.main500),
                        ),
                        controller: TextEditingController(
                          text: DateFormat('MMM d, yyyy').format(_selectedDate),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final value = double.tryParse(_valueController.text);
                    if (value != null) {
                      if (showWeight) {
                        context.read<BabyCubit>().addGrowthRecord(
                          recordedDate: _selectedDate,
                          weight: value,
                        );
                      } else {
                        context.read<BabyCubit>().addGrowthRecord(
                          recordedDate: _selectedDate,
                          height: value,
                        );
                      }
                      Navigator.pop(dialogContext);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showWeight ? AppColors.pink500 : AppColors.blue500,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
