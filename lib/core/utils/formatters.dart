import 'package:intl/intl.dart';

final _currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

String formatCurrency(num value) => _currencyFormatter.format(value);
