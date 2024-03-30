-- Membuat tabel baru dengan nama 'analisa_table' di dataset 'dataset'
CREATE TABLE kimia_farma.analisa_table AS
-- Memilih kolom-kolom yang akan dimasukkan ke dalam tabel baru
SELECT 
  -- Memilih ID transaksi dari tabel 'kf_final_transaction'
  ft.transaction_id,
  -- Memilih tanggal transaksi dari tabel 'kf_final_transaction'
  ft.date,
  -- Memilih ID cabang dari tabel 'kf_final_transaction'
  ft.branch_id,
  -- Memilih nama cabang dari tabel 'kf_kantor_cabang'
  kc.branch_name,
  -- Memilih kota dari tabel 'kf_kantor_cabang'
  kc.kota,
  -- Memilih provinsi dari tabel 'kf_kantor_cabang'
  kc.provinsi,
  -- Memilih rating cabang dari tabel 'kf_kantor_cabang' dan menamainya sebagai 'rating_cabang'
  kc.rating AS rating_cabang,
  -- Memilih nama pelanggan dari tabel 'kf_final_transaction'
  ft.customer_name,
  -- Memilih ID produk dari tabel 'kf_final_transaction'
  ft.product_id,
  -- Memilih nama produk dari tabel 'kf_product'
  kp.product_name,
  -- Memilih harga aktual produk dari tabel 'kf_product' dan menamainya sebagai 'actual_price'
  kp.price AS actual_price,
  -- Memilih persentase diskon dari tabel 'kf_final_transaction'
  ft.discount_percentage,
  -- Menghitung persentase gross laba berdasarkan harga produk dengan kondisi tertentu
  CASE 
    WHEN kp.price <= 50000 THEN kp.price * 0.1
    WHEN kp.price > 50000 AND kp.price <= 100000 THEN kp.price * 0.15
    WHEN kp.price > 100000 AND kp.price <= 300000 THEN kp.price * 0.2
    WHEN kp.price > 300000 AND kp.price <= 500000 THEN kp.price * 0.25
    ELSE kp.price * 0.3
  END AS persentase_gross_laba,
  -- Menghitung nett sales berdasarkan harga aktual produk dan diskon
  (kp.price - (kp.price * ft.discount_percentage)) AS nett_sales,
  -- Menghitung nett profit berdasarkan nett sales dan persentase gross laba
  ((kp.price - (kp.price * ft.discount_percentage)) - 
   (CASE 
      WHEN kp.price <= 50000 THEN kp.price * 0.1
      WHEN kp.price > 50000 AND kp.price <= 100000 THEN kp.price * 0.15
      WHEN kp.price > 100000 AND kp.price <= 300000 THEN kp.price * 0.2
      WHEN kp.price > 300000 AND kp.price <= 500000 THEN kp.price * 0.25
      ELSE kp.price * 0.3
    END)) AS nett_profit,
  -- Memilih rating transaksi dari tabel 'kf_final_transaction'
  ft.rating AS rating_transaksi
-- Menggabungkan tabel 'kf_final_transaction', 'kf_product', dan 'kf_kantor_cabang' menggunakan operasi JOIN
FROM 
  kimia_farma.kf_final_transaction ft
JOIN 
  kimia_farma.kf_product kp ON ft.product_id = kp.product_id
JOIN 
  kimia_farma.kf_kantor_cabang kc ON ft.branch_id = kc.branch_id;
