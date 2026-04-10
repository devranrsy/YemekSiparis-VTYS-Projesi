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



