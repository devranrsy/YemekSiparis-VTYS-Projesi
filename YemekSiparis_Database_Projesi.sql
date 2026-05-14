-- 1. Veritabanýný oluþturuyoruz
CREATE DATABASE YemekSiparisDB;
GO

-- 2. Oluþturduðumuz veritabanýný seçiyoruz (Burasý çok önemli, yoksa tablolar yanlýþ yere gider)
USE YemekSiparisDB;
GO
CREATE TABLE Kullanicilar(
Kullanici_ID INT IDENTITY (1,1) PRIMARY KEY,
Kullanici_AdSoyad NVARCHAR(100) NOT NULL,
Telefon CHAR(11) UNIQUE NOT NULL,
Email NVARCHAR(100) UNIQUE NOT NULL,
Sifre NVARCHAR(500) NOT NULL,
Rol VARCHAR(20) DEFAULT 'MUSTERI' CHECK(Rol IN('MUSTERI','ADMIN','KURYE')),
IsActive BIT DEFAULT 1);

CREATE TABLE Restoranlar(
Restoran_ID INT IDENTITY(1,1) PRIMARY KEY,
RestoranAdi NVARCHAR(100) NOT NULL,
Adres NVARCHAR(255) NOT NULL,
Puan DECIMAL(3,1) DEFAULT 5.0 CHECK (Puan BETWEEN 1 AND 5),
Toplam_Bagis_Katkisi DECIMAL(10,2) DEFAULT 0,
IsActive BIT NOT NULL DEFAULT 1 
)

CREATE TABLE Yemekler(
Yemek_ID INT IDENTITY(1,1) PRIMARY KEY,
Restoran_ID INT NOT NULL,
YemekAdi NVARCHAR(100) NOT NULL,
Aciklama NVARCHAR(100),
Fiyat DECIMAL(10,2) NOT NULL CHECK(Fiyat>0),
IsActive BIT NOT NULL DEFAULT 1,

--iliþki kýsmý
--CONSTRAINT (Kural Koyuyorum)
CONSTRAINT FK_Yemek_HangiRestoran FOREIGN KEY (Restoran_ID)
REFERENCES Restoranlar(Restoran_ID)
);

CREATE TABLE Siparisler(
Siparis_ID INT IDENTITY(1,1) PRIMARY KEY,
Kullanici_ID INT NOT NULL,
Restoran_ID INT NOT NULL,
SiparisTarihi DATETIME DEFAULT GETDATE(),
SiparisTutari DECIMAL (10,2) NOT NULL CHECK(SiparisTutari>=0),
Durum NVARCHAR(50) DEFAULT 'Sipariþiniz Hazýrlanýyor',

CONSTRAINT FK_Siparis_HangiMusteri FOREIGN KEY (Kullanici_ID)
REFERENCES Kullanicilar(Kullanici_ID),

CONSTRAINT FK_Siparis_HangiRestoran FOREIGN KEY(Restoran_ID)
REFERENCES Restoranlar(Restoran_ID)
);

CREATE TABLE Siparis_Detaylari(
Siparis_Detay_ID INT IDENTITY(1,1) PRIMARY KEY,
Siparis_ID INT NOT NULL,
Yemek_ID INT NOT NULL,
Adet INT NOT NULL CHECK(Adet>0),
BirimFiyat DECIMAL(10,2) NOT NULL CHECK(BirimFiyat>0),

CONSTRAINT FK_Detay_HangiSiparis FOREIGN KEY (Siparis_ID)
REFERENCES Siparisler(Siparis_ID),

CONSTRAINT FK_Detay_HangiYemek FOREIGN KEY (Yemek_ID)
REFERENCES Yemekler(Yemek_ID)
);

CREATE TABLE Askida_Havuz(
Bagis_ID INT IDENTITY (1,1) PRIMARY KEY,
Bagisci_ID INT NULL,
Bagis_Turu VARCHAR(20) NOT NULL CHECK(Bagis_Turu IN('BAKIYE','URUN')),
Bakiye_Miktari DECIMAL(10,2) DEFAULT 0,
Yemek_ID INT NULL,
Adet INT DEFAULT 0,
Kalan_Miktar DECIMAL(10,2) NOT NULL,
Bagis_Tarihi DATETIME DEFAULT GETDATE(),
Durum VARCHAR(20) DEFAULT 'AKTIF' CHECK (Durum IN ('AKTIF','TUKENDI','DONUSTURULDU')),

CONSTRAINT FK_Havuz_Bagisci FOREIGN KEY(Bagisci_ID)
REFERENCES Kullanicilar(Kullanici_ID),

CONSTRAINT FK_Havuz_Yemek FOREIGN KEY (Yemek_ID)
REFERENCES Yemekler(Yemek_ID)

);
--burda türkçe karakter hatalarý yapmýþstým ve isimlendirme hatalarým vardý o yüzden tablolarý silip düzelttim
DROP TABLE Askida_Havuz;
DROP TABLE Siparis_Detaylari;
DROP TABLE Siparisler;
DROP TABLE Yemekler;
DROP TABLE Restoranlar;
DROP TABLE Kullaniciler;



---------------------------------------------------------
-- 20 KULLANICI EKLENMESÝ 
---------------------------------------------------------
INSERT INTO Kullanicilar (Kullanici_AdSoyad, Telefon, Email, Sifre, Rol)
VALUES 
('Beyza','05011406047','beyzadevran@gmail.com','1451','ADMIN'),
('Devran', '05011406147', 'devran.rsy.47@gmail.com', '1451', 'ADMIN'),
('Mami', '05551110002', 'mami@mail.com', '123', 'MUSTERI'),
('Talha', '05551110003', 'talha@kurye.com', '123', 'KURYE'),
('Çocuk Adam', '05052220004', 'cocukadam@mail.com', '123', 'MUSTERI'),
('Ayse Demir', '05052220005', 'ayse@mail.com', '123', 'MUSTERI'),
('Fatma Kaya', '05052220006', 'fatma@mail.com', '123', 'MUSTERI'),
('Ali Can', '05052220007', 'ali@mail.com', '123', 'MUSTERI'),
('Mehmet Oz', '05052220008', 'mehmet@mail.com', '123', 'MUSTERI'),
('Zeynep Celik', '05052220009', 'zeynep@mail.com', '123', 'MUSTERI'),
('Burak Yildiz', '05052220010', 'burak@mail.com', '123', 'MUSTERI'),
('Cemre Sahin', '05052220011', 'cemre@mail.com', '123', 'MUSTERI'),
('Omer Faruk', '05052220012', 'omer@mail.com', '123', 'MUSTERI'),
('Elif Kose', '05052220013', 'elif@mail.com', '123', 'MUSTERI'),
('Hasan Tekin', '05052220014', 'hasan@mail.com', '123', 'MUSTERI'),
('Murat Efe', '05052220015', 'murat@mail.com', '123', 'MUSTERI'),
('Buse Aydin', '05052220016', 'buse@mail.com', '123', 'MUSTERI'),
('Gokhan Guler', '05052220017', 'gokhan@mail.com', '123', 'MUSTERI'),
('Seda Yilmaz', '05052220018', 'seda@mail.com', '123', 'MUSTERI'),
('Kemal Sunal', '05052220019', 'kemal@mail.com', '123', 'MUSTERI'),
('Tarik Akan', '05052220020', 'tarik@mail.com', '123', 'MUSTERI');


INSERT INTO Restoranlar (RestoranAdi, Adres, Puan)
VALUES 
('Etsan Kebap Salonu', 'Kemalpaþa Mah. Namýk Kemal Cad.', 4.6),
('Dürümcü Metin Usta', 'Kemalpaþa Mah. Meydan', 4.8),
('Tadým Pide & Lahmacun', 'Güneþli Meydan', 4.5),
('Baðcýlar Burger', 'Çiftlik Duraðý', 4.2),
('Kardeþler Çorba & Ev Yemekleri', 'Yürüyüþ Yolu', 4.9);

-- 1: Etsan Kebap
INSERT INTO Yemekler (Restoran_ID, YemekAdi, Fiyat) VALUES 
(1, 'Adana Porsiyon', 220), (1, 'Urfa Porsiyon', 220), (1, 'Kuþbaþý Þiþ', 250), (1, 'Ciðer Þiþ', 200), (1, 'Tavuk Þiþ', 180), 
(1, 'Ali Nazik', 260), (1, 'Beyti Sarma', 280), (1, 'Gavurdaðý Salata', 90), (1, 'Künefe', 120), (1, 'Ayran', 30);

-- 2: Dürümcü Metin Usta
INSERT INTO Yemekler (Restoran_ID, YemekAdi, Fiyat) VALUES 
(2, 'Et Döner Dürüm', 180), (2, 'Tavuk Döner Dürüm', 120), (2, 'Zurna Döner', 150), (2, 'Tombik Et Döner', 190), (2, 'Tombik Tavuk', 130), 
(2, 'Porsiyon Döner', 250), (2, 'Ýskender', 280), (2, 'Patates Kýzartmasý', 60), (2, 'Kutu Kola', 40), (2, 'Þalgam', 30);

-- 3: Tadým Pide
INSERT INTO Yemekler (Restoran_ID, YemekAdi, Fiyat) VALUES 
(3, 'Kýymalý Pide', 150), (3, 'Kuþbaþýlý Pide', 180), (3, 'Kaþarlý Pide', 140), (3, 'Sucuklu Pide', 160), (3, 'Karýþýk Pide', 190), 
(3, 'Lahmacun', 60), (3, 'Cevizli Lahmacun', 75), (3, 'Ezogelin Çorbasý', 70), (3, 'Sütlaç', 80), (3, 'Meyve Suyu', 35);

-- 4: Baðcýlar Burger
INSERT INTO Yemekler (Restoran_ID, YemekAdi, Fiyat) VALUES 
(4, 'Klasik Burger', 180), (4, 'Cheeseburger', 200), (4, 'Mushroom Burger', 220), (4, 'Tavuk Burger', 150), (4, 'Double Burger', 280), 
(4, 'Soðan Halkasý', 60), (4, 'Nugget (6lý)', 70), (4, 'Çýtýr Tavuk', 90), (4, 'Büyük Boy Patates', 75), (4, 'Limonata', 45);

-- 5: Kardeþler Çorba
INSERT INTO Yemekler (Restoran_ID, YemekAdi, Fiyat) VALUES 
(5, 'Kelle Paça', 140), (5, 'Mercimek Çorbasý', 70), (5, 'Ýþkembe', 130), (5, 'Tavuk Suyu', 80), (5, 'Kuru Fasulye', 120), 
(5, 'Pilav', 60), (5, 'Kavurma', 250), (5, 'Musakka', 160), (5, 'Cacýk', 50), (5, 'Kemalpaþa Tatlýsý', 70);


--100 SÝPARÝÞ ve DETAYLARININ OLUÞTURULMASI 

DECLARE @Sayac INT = 1;
DECLARE @RastgeleMusteri INT;
DECLARE @RastgeleRestoran INT;
DECLARE @RastgeleYemek INT;
DECLARE @RastgeleAdet INT;
DECLARE @BirimFiyati DECIMAL(10,2);
DECLARE @YeniSiparisID INT;

WHILE @Sayac <= 100
BEGIN
    -- 1 ile 20 arasý rastgele müþteri ve 1 ile 5 arasý rastgele restoran seçimi
    SET @RastgeleMusteri = (ABS(CHECKSUM(NEWID())) % 21) + 1;
    SET @RastgeleRestoran = (ABS(CHECKSUM(NEWID())) % 5) + 1;

    -- Ana Sipariþi Ekle (Tutar þimdilik 0, detaylar eklenince hesaplanmalý ama test için rastgele atýyoruz)
    INSERT INTO Siparisler (Kullanici_ID, Restoran_ID, SiparisTutari, Durum)
    VALUES (@RastgeleMusteri, @RastgeleRestoran, 0, 'Teslim Edildi');
    
    SET @YeniSiparisID = SCOPE_IDENTITY(); -- Eklenen son sipariþin ID'sini al

    -- O restorana ait rastgele 1 yemek seç
    SELECT TOP 1 @RastgeleYemek = Yemek_ID, @BirimFiyati = Fiyat 
    FROM Yemekler WHERE Restoran_ID = @RastgeleRestoran ORDER BY NEWID();
    
    -- Rastgele 1 ile 3 arasý adet belirle
    SET @RastgeleAdet = (ABS(CHECKSUM(NEWID())) % 3) + 1;

    -- Sipariþ detayýný ekle
    INSERT INTO Siparis_Detaylari (Siparis_ID, Yemek_ID, Adet, BirimFiyat)
    VALUES (@YeniSiparisID, @RastgeleYemek, @RastgeleAdet, @BirimFiyati);

    -- Ana sipariþin toplam tutarýný güncelle
    UPDATE Siparisler 
    SET SiparisTutari = (@RastgeleAdet * @BirimFiyati)
    WHERE Siparis_ID = @YeniSiparisID;

    SET @Sayac = @Sayac + 1;
END;

-- 5. ASKIDA YEMEK HAVUZU ÝÞLEMLERÝ 

INSERT INTO Askida_Havuz (Bagisci_ID, Bagis_Turu, Bakiye_Miktari, Yemek_ID, Adet, Kalan_Miktar, Durum)
VALUES 
(1, 'BAKIYE', 500.00, NULL, 0, 500.00, 'AKTIF'),
(2, 'URUN', 0, 10, 5, 5.00, 'AKTIF'), -- 5 adet Ayran askýya
(3, 'BAKIYE', 250.00, NULL, 0, 0.00, 'TUKENDI'),
(4, 'URUN', 0, 26, 2, 2.00, 'AKTIF'), -- 2 adet Lahmacun askýya
(5, 'BAKIYE', 1000.00, NULL, 0, 850.00, 'AKTIF');

SELECT R.RestoranAdi, SUM(S.SiparisTutari) AS ToplamCiro
FROM Restoranlar R
JOIN Siparisler S ON R.Restoran_ID = S.Restoran_ID
GROUP BY R.RestoranAdi
ORDER BY ToplamCiro DESC;


SELECT K.Kullanici_AdSoyad, COUNT(S.Siparis_ID) AS SiparisSayisi
FROM Kullanicilar K
JOIN Siparisler S ON K.Kullanici_ID = S.Kullanici_ID
GROUP BY K.Kullanici_AdSoyad
ORDER BY SiparisSayisi DESC;


SELECT 
    CASE 
        WHEN A.Bagisci_ID IS NULL THEN 'Gizli Baðýþçý' 
        ELSE K.Kullanici_AdSoyad 
    END AS Bagisci_Adý,
    CASE 
        WHEN A.Bagis_Turu = 'BAKIYE' THEN 'Nakit Baðýþ' 
        ELSE 'Yemek Baðýþý' 
    END AS Tur,
    ISNULL(Y.YemekAdi, 'Nakit Para') AS Bagislanan_Urun,
    -- Ýþte sihirli dokunuþ: Türe göre yanýna birim ekliyoruz
    CASE 
        WHEN A.Bagis_Turu = 'BAKIYE' THEN CAST(A.Kalan_Miktar AS VARCHAR) + ' TL'
        ELSE CAST(CAST(A.Kalan_Miktar AS INT) AS VARCHAR) + ' Adet' -- .00'dan kurtulmak için önce INT'e çevirdik
    END AS Mevcut_Stok,
    A.Durum
FROM Askida_Havuz A
LEFT JOIN Kullanicilar K ON A.Bagisci_ID = K.Kullanici_ID
LEFT JOIN Yemekler Y ON A.Yemek_ID = Y.Yemek_ID
ORDER BY A.Durum ASC, A.Kalan_Miktar DESC;

