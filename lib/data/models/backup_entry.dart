enum BackupSource { manual, imported }

class BackupEntry {
  const BackupEntry({
    required this.fileName,
    required this.createdAt,
    required this.sizeBytes,
    required this.source,
  });

  final String fileName;
  final DateTime createdAt;
  final int sizeBytes;
  final BackupSource source;

  factory BackupEntry.fromJson(Map<String, dynamic> json) {
    return BackupEntry(
      fileName: json['fileName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sizeBytes: json['sizeBytes'] as int,
      source: BackupSource.values.firstWhere(
        (s) => s.name == json['source'],
        orElse: () => BackupSource.manual,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'fileName': fileName,
        'createdAt': createdAt.toIso8601String(),
        'sizeBytes': sizeBytes,
        'source': source.name,
      };
}
