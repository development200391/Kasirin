import 'package:flutter/foundation.dart';

import '../../data/models/period_report.dart';
import '../../data/repositories/report_repository.dart';

class PeriodReportProvider extends ChangeNotifier {
  PeriodReportProvider({ReportRepository? repository}) : _repository = repository ?? ReportRepository() {
    load();
  }

  final ReportRepository _repository;

  ReportPeriodType _type = ReportPeriodType.weekly;
  ReportPeriodType get type => _type;

  DateTime _anchor = DateTime.now();

  PeriodReport? _report;
  PeriodReport? get report => _report;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get canGoNext {
    final (start, _) = periodBoundsFor(_type, _anchor);
    final (currentStart, _) = periodBoundsFor(_type, DateTime.now());
    return start.isBefore(currentStart);
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _report = await _repository.getPeriodReport(type: _type, anchor: _anchor);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setType(ReportPeriodType type) async {
    if (type == _type) return;
    _type = type;
    _anchor = DateTime.now();
    await load();
  }

  Future<void> goToPrevious() async {
    _anchor = _type == ReportPeriodType.weekly
        ? _anchor.subtract(const Duration(days: 7))
        : DateTime(_anchor.year, _anchor.month - 1, 1);
    await load();
  }

  Future<void> goToNext() async {
    if (!canGoNext) return;
    _anchor = _type == ReportPeriodType.weekly
        ? _anchor.add(const Duration(days: 7))
        : DateTime(_anchor.year, _anchor.month + 1, 1);
    await load();
  }
}
