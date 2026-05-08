# Cylindr Track - Fitur Lengkap

## Ringkasan Sistem
Cylindr Track adalah sistem manajemen inventory dan CRM untuk tracking pengiriman gas LPG dan aksesori ke mitra bisnis dengan monitoring stok real-time dan alert system.

---

## 1. DASHBOARD BERANDA 📊
Halaman utama dengan ringkasan bisnis:
- **Total Penjualan**: Menampilkan total revenue dari transaksi yang selesai
- **Transaksi Pending**: Jumlah transaksi yang belum dikonfirmasi
- **Total Produk**: Jumlah jenis produk yang tersedia
- **Total Pelanggan**: Jumlah pelanggan terdaftar
- **Transaksi Terbaru**: 3 transaksi terakhir dengan status dan nominal
- **Produk Stok Rendah**: Alert otomatis untuk produk dengan stok < 50 unit

---

## 2. PENGIRIMAN (Delivery Management) 🚚

### 2.1 Input Pengiriman Harian
**Fitur**: Form input untuk mencatat pengiriman barang ke klien

**Data yang dicatat:**
- Nomor pengiriman (otomatis generate)
- Tanggal & waktu pengiriman
- Mitra tujuan (dropdown list)
- Lokasi pengiriman
- Item pengiriman (produk dan jumlah)
- Catatan pengiriman

**Proses:**
1. Klik tombol "+" di screen Pengiriman
2. Pilih mitra dari dropdown
3. Tambahkan item (bisa multiple items)
4. Tulis catatan (opsional)
5. Simpan - data langsung tersimpan

### 2.2 Update Stok Otomatis
**Fitur**: Sistem otomatis menambah stok mitra saat pengiriman tercatat

**Logika:**
- Setiap kali pengiriman ditambahkan, stok mitra bertambah otomatis
- Stok disimpan dalam tabel "StokMitra" dengan tracking:
  - mitraId, produkId
  - jumlah stok terpinjam
  - tanggal pengiriman terakhir
- Jika produk belum ada di mitra, entri baru dibuat
- Jika produk sudah ada, stok ditambahkan

### 2.3 Riwayat Pengiriman
**Fitur**: Daftar semua pengiriman yang pernah dilakukan

**Info yang ditampilkan:**
- Nomor pengiriman
- Mitra & lokasi
- Tanggal pengiriman
- Jumlah item
- Status pengiriman
- Detail setiap item

---

## 3. MONITORING STOK PER KLIEN 📦

### 3.1 Dashboard Mitra
**Fitur**: Pantau inventory setiap mitra dengan detail

**Filter & View:**
- Tampilkan semua mitra atau filter per mitra
- List semua mitra dengan info:
  - Nama & lokasi
  - Hari tanpa pengiriman
  - Tanggal pengiriman terakhir
  - Progress bar untuk tracking 30 hari

### 3.2 Detail Stok Per Mitra
**Fitur**: Lihat stok detail setiap produk di mitra

**Info ditampilkan:**
- Data mitra lengkap (nama, lokasi, alamat, telepon)
- **Stok Terpinjam** dengan kolom:
  - Nama produk
  - Jumlah unit
  - Tanggal pengiriman terakhir
- **Riwayat Pengiriman** (5 pengiriman terakhir)

---

## 4. TRACKING WAKTU PENGIRIMAN ⏰

### 4.1 Hitung Hari Sejak Pengiriman Terakhir
**Fitur**: Sistem otomatis menghitung berapa hari tanpa pengiriman

**Cara kerja:**
- Setiap mitra punya `tanggalPengirimanTerakhir`
- Sistem menghitung: `DateTime.now() - tanggalPengirimanTerakhir = hariTanpaPengiriman`
- Update otomatis setiap kali pengiriman baru ditambahkan
- Jika belum pernah pengiriman, dihitung dari tanggal kerjasama

**Tampilan:**
- Mitra Monitoring screen: progress bar menunjukkan 0-30 hari
- Detail mitra: exact number of days

### 4.2 Progress Visual
- **0-15 hari**: Hijau (stok baik)
- **15-30 hari**: Orange (perlu perhatian)
- **>30 hari**: Merah + Alert badge

---

## 5. ALERT 30 HARI ⚠️

### 5.1 Trigger Alert
**Kondisi**: Mitra tidak menerima pengiriman selama 30 hari

**Logika:**
- `hariTanpaPengiriman >= 30` → `perluAlert = true`
- Alert badge muncul otomatis di Mitra Monitoring
- Alert dicatat di tabel "EvaluasiRepurchasing"
- Alert generated saat first time kondisi tercapai

### 5.2 Alert Badge
- Muncul di Mitra Monitoring screen untuk mitra dengan >30 hari
- Warna merah dengan icon warning
- Klik mitra untuk lihat detail & ambil tindakan

---

## 6. EVALUASI & AKSI REPURCHASING 🎯

### 6.1 Screen Repurchasing
**Fitur**: Manajemen alert dan tindakan follow-up

**Tab 1: Alert Pending**
- Menampilkan semua alert yang belum ditindak
- Info: nama mitra, hari tanpa pengiriman, tanggal alert
- Tombol "Ambil Tindakan"

**Tab 2: Sudah Ditindak**
- Riwayat semua alert yang sudah ditangani
- Info: tindakan yang diambil, tanggal tindakan
- Status: follow_up atau pengiriman_dijadwalkan

### 6.2 Workflow Tindakan
Tim dapat memilih 2 opsi:

**Opsi 1: Follow Up**
- Catat bahwa tim sudah hubungi klien
- Status berubah menjadi "follow_up"
- Dicatat tanggal follow-up

**Opsi 2: Kirim Sekarang**
- Navigasi ke screen Pengiriman
- Jadwalkan pengiriman baru ke mitra
- Saat pengiriman tercatat:
  - Status alert berubah "pengiriman_dijadwalkan"
  - Alert dihapus dari pending list
  - Tanggal pengiriman terakhir update

### 6.3 Alert Recovery
**Saat pengiriman ditambahkan:**
- Sistem cek apakah ada pending alert untuk mitra tsb
- Jika ada, alert otomatis dihapus
- `tanggalPengirimanTerakhir` update
- Hitung ulang `hariTanpaPengiriman` (reset ke 0 hari)

---

## 7. TRANSAKSI 💳

### 7.1 Manajemen Transaksi
- Filter by type: Penjualan, Pembelian, Retur
- Lihat detail transaksi dengan breakdown items
- Status: Pending, Selesai, Batal

### 7.2 Detail View
- Nomor transaksi
- Tanggal & waktu
- Pelanggan
- Tipe transaksi
- List items dengan harga
- Total & status

---

## 8. MONITORING ANALYTICS 📈

### 8.1 Inventory Analysis
- Total stok semua produk
- Produk dengan stok baik (≥50 unit)
- Produk dengan stok rendah (<50 unit)
- Produk habis

### 8.2 Stock Chart
- Visualisasi bar chart setiap produk
- Persentase vs kapasitas (max 200 unit)
- Color coding: hijau, orange, merah

### 8.3 Sales Performance
- Total penjualan (rupiah)
- Breakdown: Selesai, Pending, Batal
- Top 5 produk by quantity sold

---

## 9. EVALUASI PERFORMA 📊

### 9.1 Customer Performance
- Total pelanggan
- Rata-rata belanja per pelanggan
- Top 3 pelanggan by revenue

### 9.2 Transaction Analysis
- Total transaksi by type
- Success rate transaksi
- Transaction status breakdown

### 9.3 Product Health
- Status stok produk
- Kategori: Bagus (≥100), Sedang (50-99), Rendah (<50)
- Progress bar per kategori

### 9.4 Business Health Indicators
- **Tingkat Keberhasilan Transaksi**: % transaksi selesai
  - ≥80% = Bagus (hijau)
  - 60-80% = Cukup (orange)
  - <60% = Perlu perbaikan (merah)
- **Rata-rata Stok Produk**: Average unit per produk
  - ≥75 = Bagus
  - 50-75 = Cukup
  - <50 = Perlu restock

---

## DATA MODELS

### Mitra (Partner)
```dart
class Mitra {
  String id, nama, lokasi, nomorTelepon, alamat
  DateTime tanggalKerjasama
  DateTime? tanggalPengirimanTerakhir
  bool aktif
  
  // Computed
  int get hariTanpaPengiriman
  bool get perluAlert (hariTanpaPengiriman >= 30)
}
```

### Pengiriman (Delivery)
```dart
class Pengiriman {
  String id, nomorPengiriman, mitraId, mitraNama, lokasi
  DateTime tanggal
  List<ItemPengiriman> items
  String catatan, status
}

class ItemPengiriman {
  String produkId, namaProduk
  int jumlah
}
```

### StokMitra (Partner Inventory)
```dart
class StokMitra {
  String mitraId, mitraNama, produkId, namaProduk
  int stokTerpinjam
  DateTime tanggalPengirimanTerakhir
}
```

### EvaluasiRepurchasing
```dart
class EvaluasiRepurchasing {
  String id, mitraId, mitraNama
  int hariTanpaPengiriman
  DateTime tanggalAlert
  String status (belum_ditindak, follow_up, pengiriman_dijadwalkan)
  String? tindakan
  DateTime? tanggalTindakan
}
```

---

## THEME & DESIGN 🎨

### Warna Utama
- **Primary**: Navy Blue (#1E3A5F)
- **Secondary**: Cyan (#00BCD4)
- **Background**: White (#FFFFFF)
- **Light Gray**: #F5F5F5
- **Dark Gray**: #757575

### Material Design 3
- Modern typography
- Proper spacing & elevation
- Status-specific colors
- Responsive layout

---

## NAVIGATION 🧭

**Bottom Navigation (7 screen):**
1. Beranda (Dashboard)
2. Pengiriman (Delivery input & history)
3. Mitra (Partner monitoring with stock per client)
4. Repurchase (Alert & evaluation)
5. Transaksi (Transaction management)
6. Monitoring (Analytics)
7. Evaluasi (Performance report)

---

## WORKFLOW CONTOH

### Scenario: Pengiriman Rutin & Alert
1. **Hari 1**: Tim input pengiriman ke PT Maju Jaya
   - 10 unit Silinder 12kg
   - Auto update stok PT Maju Jaya = 10 unit
   - tanggalPengirimanTerakhir = 1 Januari 2024

2. **Hari 15**: Tim lihat di Mitra Monitoring
   - PT Maju Jaya: 14 hari tanpa pengiriman (progress bar 50%)

3. **Hari 30**: Alert triggered
   - PT Maju Jaya: 30 hari tanpa pengiriman (progress bar 100%)
   - Badge "Alert" muncul merah
   - Alert masuk ke Repurchasing screen

4. **Hari 31**: Tim ambil tindakan
   - Pilih "Kirim Sekarang"
   - Input pengiriman baru ke PT Maju Jaya
   - Saat disubmit:
     - Status alert = "pengiriman_dijadwalkan"
     - Alert hilang dari pending
     - hariTanpaPengiriman reset ke 0
     - tanggalPengirimanTerakhir update

---

## MOCK DATA
Sistem sudah include:
- 5 Produk LPG & aksesori
- 3 Mitra dengan berbagai status pengiriman
- 2 Pengiriman terbaru
- Stock data untuk setiap mitra
- 1 Evaluasi alert (CV Bersama Maju: 35 hari no delivery)
- 3 Transaksi sample

**CV Bersama Maju**: Sudah 35 hari tanpa pengiriman (ready untuk alert demo)
