# Kasirin

Aplikasi POS (Point of Sale) Android untuk toko/kasir kecil-menengah, database lokal, dibangun dengan Flutter.

Detail fitur, skema database, dan tahapan pengembangan ada di [detail-pembuatan-pos-app.md](./detail-pembuatan-pos-app.md). Progres pengerjaan per fase dicatat di [Todo.md](./Todo.md).

## Stack

- Flutter (Android only)
- SQLite (`sqflite`) — database lokal
- Provider — state management

## Struktur Project

```
lib/
  main.dart
  core/            # tema, konstanta, util
  data/
    db/            # database helper & migrations
    models/
    repositories/
  features/
    auth/
    products/
    pos/           # layar kasir (inti aplikasi)
    stock/
    reports/
    settings/
  widgets/         # komponen UI yang dipakai bersama
```

## Menjalankan Project

```
flutter pub get
flutter run
```

## Testing

```
flutter analyze
flutter test
```
