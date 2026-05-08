# Quick Start - Cylindr Track

## Instalasi & Setup
```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Testing Default Scenario

### 1. Lihat Dashboard
- Tap **"Beranda"** di bottom navigation
- Lihat ringkasan: Total Penjualan, Transaksi Pending, dll
- Lihat produk stok rendah

### 2. Input Pengiriman Pertama
- Tap **"Pengiriman"** tab
- Klik tombol FAB **"+"**
- **Pilih Mitra**: "PT Maju Jaya"
- **Tambah Item**: 
  - Produk: "Silinder Gas LPG 3kg"
  - Jumlah: 20
- **Catatan**: "Pengiriman rutin"
- Tap **"Simpan Pengiriman"**
- ✓ Pengiriman recorded, stok mitra auto-updated

### 3. Lihat Stock Per Klien
- Tap **"Mitra"** tab
- Lihat daftar semua mitra
  - **PT Maju Jaya**: ~5 hari tanpa pengiriman (baru dikirim)
  - **Toko Mitra Usaha**: 12 hari tanpa pengiriman
  - **CV Bersama Maju**: 35 hari tanpa pengiriman ⚠️ **ALERT**
- Tap **CV Bersama Maju** → Lihat detail stok & riwayat pengiriman

### 4. Cek Alert Repurchasing
- Tap **"Repurchase"** tab
- Lihat **"Alert Pending"** = ada 1 alert
  - CV Bersama Maju: 35 hari tanpa pengiriman
- Tap **"Ambil Tindakan"**
  - Pilih **"Kirim Sekarang"** → akan jadwalkan pengiriman baru

### 5. Evaluasi Lanjutan
- Check **"Sudah Ditindak"** tab untuk riwayat tindakan
- Atau tap **"Evaluasi"** untuk laporan lengkap performa

---

## Navigation Map

```
┌─ Beranda (Dashboard)
│  └─ KPI cards, recent transactions, low stock alert
│
├─ Pengiriman (Delivery Management)
│  ├─ List semua pengiriman
│  ├─ Tap untuk lihat detail
│  └─ FAB button untuk input pengiriman baru
│
├─ Mitra (Partner Monitoring)
│  ├─ List all partners dengan tracking hari
│  └─ Tap untuk lihat detail stok & riwayat pengiriman
│
├─ Repurchase (Alert & Action)
│  ├─ Tab 1: Alert Pending (yang perlu ditindak)
│  └─ Tab 2: Sudah Ditindak (riwayat tindakan)
│
├─ Transaksi (Transaction Management)
│  ├─ Filter by type (Penjualan, Pembelian, Retur)
│  └─ Tap untuk lihat detail
│
├─ Monitoring (Analytics)
│  ├─ Inventory overview
│  ├─ Stock chart per produk
│  └─ Sales performance
│
└─ Evaluasi (Performance Report)
   ├─ Customer performance
   ├─ Transaction analysis
   ├─ Product status distribution
   └─ Health indicators
```

---

## Key Features Demo

### Feature 1: Automatic Stock Update ✅
**What**: Stok mitra auto bertambah saat pengiriman dicatat
**Demo**:
1. Input pengiriman ke PT Maju Jaya dengan 20 unit Silinder 3kg
2. Buka Mitra > PT Maju Jaya > lihat "Stok Terpinjam"
3. Akan ada entry baru atau updated untuk Silinder 3kg

### Feature 2: Days Since Last Delivery ✅
**What**: Sistem tracking hari sejak pengiriman terakhir
**Demo**:
1. Buka Mitra tab
2. Lihat masing-mitra punya field "Hari Tanpa Pengiriman"
3. Progress bar menunjukkan 0-30 hari
4. CV Bersama Maju sudah 35 hari (red alert)

### Feature 3: 30-Day Alert System ✅
**What**: Alert otomatis saat mitra >30 hari tanpa pengiriman
**Demo**:
1. Buka Mitra tab
2. Lihat CV Bersama Maju dengan badge merah "⚠️ Alert"
3. Buka Repurchase tab
4. Ada 1 alert pending untuk CV Bersama Maju

### Feature 4: Evaluation & Action Workflow ✅
**What**: Tim bisa ambil tindakan (follow-up atau pengiriman)
**Demo**:
1. Buka Repurchase > Alert Pending
2. Tap "Ambil Tindakan" pada CV Bersama Maju alert
3. Pilih **"Follow Up"** → alert status berubah
4. Atau pilih **"Kirim Sekarang"** → go to pengiriman screen
5. Input pengiriman → alert otomatis di-resolve

---

## Data Model Summary

| Screen | Data Source | Key Fields |
|--------|-------------|-----------|
| Beranda | Produk, Transaksi | total, pending, stok |
| Pengiriman | Pengiriman list | nomor, mitra, items, tanggal |
| Mitra | Mitra, StokMitra | nama, hari, stok per produk |
| Repurchase | EvaluasiRepurchasing | alert, status, tindakan |
| Transaksi | Transaksi | type, customer, items, total |
| Monitoring | Produk, Transaksi | inventory, sales metrics |
| Evaluasi | All above | KPI, health score |

---

## Mock Data Reference

### Mitra (3 partners)
1. **PT Maju Jaya** (Surabaya)
   - Kerjasama: 120 hari lalu
   - Pengiriman terakhir: 5 hari lalu
   - Status: OK ✓

2. **Toko Mitra Usaha** (Sidoarjo)
   - Kerjasama: 90 hari lalu
   - Pengiriman terakhir: 12 hari lalu
   - Status: OK ✓

3. **CV Bersama Maju** (Gresik) ⚠️
   - Kerjasama: 60 hari lalu
   - Pengiriman terakhir: 35 hari lalu
   - Status: ALERT (>30 days)

### Produk (5 items)
1. Silinder Gas LPG 3kg - Rp 35.000
2. Silinder Gas LPG 12kg - Rp 95.000
3. Regulator Gas - Rp 65.000
4. Selang Gas 2m - Rp 25.000
5. Manometer Gas - Rp 85.000

---

## Troubleshooting

### Alert tidak muncul
- Refresh screen (keluar-masuk tab)
- Check apakah `hariTanpaPengiriman >= 30`
- Buka Mitra detail untuk verifikasi tanggal

### Stok tidak terupdate
- Pastikan pengiriman berhasil disimpan
- Check notification "Pengiriman berhasil ditambahkan"
- Buka Mitra > lihat StokMitra section

### Evaluasi tidak di-remove saat pengiriman
- Feature: alert auto-remove jika pengiriman ditambahkan
- Check Repurchase > "Sudah Ditindak" tab untuk riwayat

---

## Next Steps

### Untuk Development:
1. Connect ke database (Firebase/Supabase)
2. Add authentication
3. Export/import data
4. Push notifications untuk alerts
5. GPS tracking untuk delivery

### Untuk User:
1. Customize product list
2. Add more partners
3. Set custom alert thresholds
4. Generate PDF reports
5. Integration dengan accounting system

---

## File Structure
```
lib/
├── main.dart (App entry point)
├── config/
│   └── theme.dart (Material Design 3 theme)
├── models/
│   └── models.dart (Mitra, Pengiriman, StokMitra, Evaluasi, etc)
├── services/
│   └── data_service.dart (Data management & business logic)
└── screens/
    ├── home_screen.dart (Bottom navigation shell)
    ├── beranda_screen.dart (Dashboard)
    ├── pengiriman_screen.dart (Delivery management)
    ├── mitra_monitoring_screen.dart (Partner monitoring)
    ├── repurchasing_screen.dart (Alert & evaluation)
    ├── transaksi_screen.dart (Transaction management)
    ├── monitoring_screen.dart (Analytics)
    └── evaluasi_screen.dart (Performance report)
```

---

## Contact & Support
For issues or features request, check the code comments or FEATURES.md for detailed documentation.
