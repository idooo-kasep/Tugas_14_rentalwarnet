-- ============================================================
--  DATABASE: db_rental_warnet
--  Tugas 14 - Backup & Restore Database
--  Mata Kuliah: Sistem Basis Data
-- ============================================================

-- Buat database
CREATE DATABASE IF NOT EXISTS db_rental_warnet
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE db_rental_warnet;

-- ============================================================
-- TABEL 1: users (Login & Akun Sistem)
-- ============================================================
DROP TABLE IF EXISTS transaksi;
DROP TABLE IF EXISTS sesi;
DROP TABLE IF EXISTS paket;
DROP TABLE IF EXISTS komputer;
DROP TABLE IF EXISTS pelanggan;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id        INT AUTO_INCREMENT PRIMARY KEY,
    username       VARCHAR(50)  NOT NULL UNIQUE,
    password_hash  VARCHAR(255) NOT NULL,
    nama_lengkap   VARCHAR(100) NOT NULL,
    role           ENUM('admin','operator') NOT NULL DEFAULT 'operator',
    status         ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
    terakhir_login DATETIME DEFAULT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABEL 2: pelanggan
-- ============================================================
CREATE TABLE pelanggan (
    pelanggan_id  INT AUTO_INCREMENT PRIMARY KEY,
    nama          VARCHAR(100)  NOT NULL,
    no_hp         VARCHAR(15)   UNIQUE,
    email         VARCHAR(100)  UNIQUE,
    tgl_daftar    DATE          NOT NULL,
    saldo         DECIMAL(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABEL 3: komputer
-- ============================================================
CREATE TABLE komputer (
    komputer_id  INT AUTO_INCREMENT PRIMARY KEY,
    nomor_unit   VARCHAR(10) NOT NULL UNIQUE,
    spesifikasi  TEXT,
    status       ENUM('tersedia','digunakan','rusak') DEFAULT 'tersedia',
    lokasi       VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABEL 4: paket
-- ============================================================
CREATE TABLE paket (
    paket_id     INT AUTO_INCREMENT PRIMARY KEY,
    nama_paket   VARCHAR(100)  NOT NULL,
    durasi_menit INT           NOT NULL,
    harga        DECIMAL(10,2) NOT NULL,
    deskripsi    TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABEL 5: sesi
-- ============================================================
CREATE TABLE sesi (
    sesi_id       INT AUTO_INCREMENT PRIMARY KEY,
    pelanggan_id  INT NOT NULL,
    komputer_id   INT NOT NULL,
    paket_id      INT NOT NULL,
    waktu_mulai   DATETIME NOT NULL,
    waktu_selesai DATETIME DEFAULT NULL,
    status_sesi   ENUM('aktif','selesai') DEFAULT 'aktif',
    FOREIGN KEY (pelanggan_id) REFERENCES pelanggan(pelanggan_id),
    FOREIGN KEY (komputer_id)  REFERENCES komputer(komputer_id),
    FOREIGN KEY (paket_id)     REFERENCES paket(paket_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABEL 6: transaksi
-- ============================================================
CREATE TABLE transaksi (
    transaksi_id    INT AUTO_INCREMENT PRIMARY KEY,
    sesi_id         INT           NOT NULL,
    user_id         INT           NOT NULL,
    total_bayar     DECIMAL(10,2) NOT NULL,
    metode_bayar    ENUM('tunai','transfer','saldo') NOT NULL,
    waktu_transaksi DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sesi_id)  REFERENCES sesi(sesi_id),
    FOREIGN KEY (user_id)  REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- INSERT DATA SAMPLE
-- ============================================================

-- Data users (password: admin123, operator123)
INSERT INTO users (username, password_hash, nama_lengkap, role) VALUES
('admin',     SHA2('admin123',256),    'Budi Santoso',   'admin'),
('operator1', SHA2('operator123',256), 'Siti Rahayu',    'operator'),
('operator2', SHA2('operator123',256), 'Deni Kurniawan', 'operator');

-- Data pelanggan
INSERT INTO pelanggan (nama, no_hp, email, tgl_daftar, saldo) VALUES
('Andi Firmansyah', '081234567801', 'andi@email.com',   '2024-01-10', 20000.00),
('Bela Safitri',    '081234567802', 'bela@email.com',   '2024-01-15', 15000.00),
('Candra Wijaya',   '081234567803', 'candra@email.com', '2024-02-01',     0.00),
('Dewi Lestari',    '081234567804', NULL,               '2024-02-10',  5000.00),
('Eko Prasetyo',    '081234567805', 'eko@email.com',    '2024-03-01', 30000.00);

-- Data komputer
INSERT INTO komputer (nomor_unit, spesifikasi, lokasi) VALUES
('PC-01', 'Intel i5 Gen12, RAM 16GB, RTX 3060', 'Zona Gaming'),
('PC-02', 'Intel i5 Gen12, RAM 16GB, RTX 3060', 'Zona Gaming'),
('PC-03', 'Intel i3 Gen11, RAM 8GB, GTX 1650',  'Zona Reguler'),
('PC-04', 'Intel i3 Gen11, RAM 8GB, GTX 1650',  'Zona Reguler'),
('PC-05', 'Intel i3 Gen11, RAM 8GB, Onboard',   'Zona Reguler');

-- Data paket
INSERT INTO paket (nama_paket, durasi_menit, harga, deskripsi) VALUES
('Paket 1 Jam Reguler',  60,  5000.00, 'Akses internet standar 1 jam'),
('Paket 2 Jam Reguler', 120,  9000.00, 'Akses internet standar 2 jam'),
('Paket 1 Jam Gaming',   60,  7000.00, 'Zona gaming, resolusi tinggi'),
('Paket 3 Jam Gaming',  180, 18000.00, 'Paket hemat zona gaming 3 jam'),
('Paket Malam (8 jam)', 480, 20000.00, 'Paket overnight 20:00 - 04:00');

-- Data sesi
INSERT INTO sesi (pelanggan_id, komputer_id, paket_id, waktu_mulai, waktu_selesai, status_sesi) VALUES
(1, 1, 3, '2025-01-15 10:00:00', '2025-01-15 11:00:00', 'selesai'),
(2, 3, 1, '2025-01-15 11:30:00', '2025-01-15 12:30:00', 'selesai'),
(3, 2, 4, '2025-01-15 14:00:00', '2025-01-15 17:00:00', 'selesai'),
(4, 4, 2, '2025-01-16 09:00:00', '2025-01-16 11:00:00', 'selesai'),
(5, 1, 5, '2025-01-16 20:00:00', '2025-01-17 04:00:00', 'selesai');

-- Data transaksi
INSERT INTO transaksi (sesi_id, user_id, total_bayar, metode_bayar) VALUES
(1, 2,  7000.00, 'tunai'),
(2, 2,  5000.00, 'saldo'),
(3, 3, 18000.00, 'transfer'),
(4, 2,  9000.00, 'tunai'),
(5, 3, 20000.00, 'tunai');

-- ============================================================
-- VERIFIKASI DATA
-- ============================================================
SELECT 'users'      AS tabel, COUNT(*) AS jumlah FROM users      UNION ALL
SELECT 'pelanggan',            COUNT(*) FROM pelanggan            UNION ALL
SELECT 'komputer',             COUNT(*) FROM komputer             UNION ALL
SELECT 'paket',                COUNT(*) FROM paket                UNION ALL
SELECT 'sesi',                 COUNT(*) FROM sesi                 UNION ALL
SELECT 'transaksi',            COUNT(*) FROM transaksi;
