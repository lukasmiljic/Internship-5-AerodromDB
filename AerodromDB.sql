--CREATE DATABASE Aerodrom
--
--USE Aerodrom
CREATE TYPE stanje AS ENUM('Aktivan','Na popravku','Razmontiran');
CREATE TABLE Avioni (
	IdAviona SERIAL PRIMARY KEY,
	Naziv VARCHAR(32) NOT NULL,
	Model VARCHAR(32) NOT NULL,
	VlasnikAviona VARCHAR(32) NOT NULL,
	Stanje stanje NOT NULL,
	Kapacitet INT NOT NULL
);
CREATE TYPE kategorija AS ENUM('Business','Economy');
CREATE TABLE Sjedala (
	IdSjedala VARCHAR(8) NOT NULL,
	AvionId INT REFERENCES Avioni(IdAviona) NOT NULL,
	KategorijaSjedala kategorija NOT NULL,
	PRIMARY KEY (AvionId, IdSjedala)
);
CREATE TABLE Aerodromi (
	IdAerodroma SERIAL PRIMARY KEY,
	Naziv VARCHAR(32) NOT NULL,
	Grad VARCHAR(32) NOT NULL,
	Koordinate POINT
	Kapactitet INT NOT NULL,
	Koordinate POINT
);
CREATE TABLE AvionSeNalazi (
	IdAviona INT REFERENCES Avioni(IdAviona) NOT NULL,
	IdAerodroma INT REFERENCES Aerodromi(IdAerodroma) NOT NULL,
	Lokacija VARCHAR(32) NOT NULL,
	Vrijeme TIMESTAMP NOT NULL
);
CREATE TABLE Letovi (
	IdLeta SERIAL PRIMARY KEY,
	DatumLeta TIMESTAMP NOT NULL,
	PocetniAerodromId INT REFERENCES Aerodromi(IdAerodroma) NOT NULL,
	KrajnjiAerodromId INT REFERENCES Aerodromi(IdAerodroma) NOT NULL,
	IdAviona INT REFERENCES Avioni(IdAviona) NOT NULL,
	--bolje bi bilo u odvojenu relaciju
	IdPilota INT REFERENCES Piloti(IdPilota) NOT NULL,
	TrajanjeLeta INT NOT NULL
);
CREATE TABLE Osobe (
	IdOsobe SERIAL PRIMARY KEY,
	Ime VARCHAR(32) NOT NULL,
	Prezime VARCHAR(32) NOT NULL,
	Spol CHAR(1) NOT NULL,
	Dob TIMESTAMP NOT NULL
);
CREATE TABLE KarticeVjernosti (
	IdKartice SERIAL PRIMARY KEY,
	IdOsobe INT REFERENCES Osobe(IdOsobe)
);
CREATE TABLE Osoblje (
	IdOsoblja INT REFERENCES Osobe(IdOsobe) NOT NULL,
	Ime VARCHAR(32) NOT NULL,
	Prezime VARCHAR(32) NOT NULL,
	Spol CHAR(1) NOT NULL,
	Dob TIMESTAMP NOT NULL,
	IdLeta INT REFERENCES Letovi(IdLeta) NOT NULL,
	PRIMARY KEY (IdOsoblja, IdLeta)
);
CREATE TABLE Piloti (
	IdPilota INT PRIMARY KEY,
	Ime VARCHAR(32) NOT NULL,
	Prezime VARCHAR(32) NOT NULL,
	Spol CHAR(1) NOT NULL,
	Dob TIMESTAMP NOT NULL,
	CONSTRAINT PilotDob CHECK (EXTRACT(YEAR FROM AGE(NOW(), Dob)) >= 20 AND EXTRACT(YEAR FROM AGE(NOW(), Dob)) <= 60),
	IdLeta INT REFERENCES Letovi(IdLeta) NOT NULL,
	Placa INT NOT NULL
);
CREATE TABLE Karte (
	IdKupca INT REFERENCES Osobe(IdOsobe) NOT NULL,
	IdPutnika INT REFERENCES Osobe(IdOsobe) NOT NULL,
	IdLeta INT REFERENCES Letovi(IdLeta) NOT NULL,
	PRIMARY KEY (IdKupca, IdPutnika, IdLeta),
	Cijena INT NOT NULL,
	DatumLeta DATE NOT NULL
);
CREATE TABLE Ocjene (
	IdPutnika INT REFERENCES Osobe(IdOsobe) NOT NULL,
	IdLeta INT REFERENCES Letovi(IdLeta) NOT NULL,
	PRIMARY KEY (IdPutnika, IdLeta),
	Ocjena INT NOT NULL
);

--ispis svih aviona s kapacitetom vecim od 100
SELECT Naziv, Model FROM Avioni
WHERE Kapacitet > 100

--ispis svih letova cija je cijena izmedu 100 i 200
SELECT * FROM Karte
WHERE Cijena BETWEEN 100 AND 200

--ispis svih pilotkinja sa vise od 20 odradenih letova
SELECT FROM Piloti
WHERE Spol = 'W' AND (COUNT(*) FROM (select ))>20

--ispis svih domaćina/ca zrakoplova koji su trenutno u zraku

--ispis broja letova u Split/iz Splita 2023. godine
select count (*) from(
select idleta from letovi l
where (select a.idaerodroma from aerodromi a where grad = 'Split') = l.krajnjiaerodromid
or (select a.idaerodroma from aerodromi a where grad = 'Split') = l.pocetniaerodromid
) as brojletova

--ispis svih letova za Beč u prosincu 2023.
select * from letovi l
where l.pocetniaerodromid = (select a.idaerodroma from aerodromi a where grad = 'Beč')
and extract (year from datumleta) = 2023 and extract(month from datumleta) = 12

--ispis broj prodanih Economy letova kompanije AirDUMP u 2021.
select count (*) from(
select idleta from letovi l
where (select a.idaviona from avioni a where(select s.avionid from sjedala s where kategorijasjedala = 'Economy' and a.vlasnikaviona = 'AirDUMP') = a.idaviona ) = l.idaviona
and extract (year from l.datumleta) = 2021
) as brojProdanihEconomyLetovaAirDUMP

--ispis prosječne ocjene letova kompanije AirDUMP
select avg (ocjena) from(
select ocjena from ocjene o
where (select l.idleta from letovi l where (select a.idaviona from avioni a where a.vlasnikaviona='AirDUMP')=l.idaviona) = o.idleta
) as prosjecnaocjenaLetovaAirDUMP

--ispis svih aerodroma u Londonu, sortiranih po broju Airbus aviona trenutno na njihovim pistama
select naziv from aerodromi ae 
where (
select (asn.idaerodroma) from avionsenalazi asn
where (select ae.idaerodroma from aerodromi ae where grad = 'London') = asn.idaerodroma
order by (select count (*) from (select av.idaviona from avioni av where asn.lokacija = 'Pista' and av.model = 'Airbus'))
) =ae.idaerodroma

--ispis svih aerodroma udaljenih od Splita manje od 1500km (ne radi a ni logika nije dobra tako da duplo ne radi)
select naziv from aerodromi ae 
where (ae.koordinate - (select av.koordinate from aerodromi av where grad = 'Split')) < 1500

--smanjite cijenu za 20% svim kartama čiji letovi imaju manje od 20 ljudi
--povisite plaću za 100 eura svim pilotima koji su ove godine imali više od 10 letova duljih od 10 sati (ne radi)
update piloti p
set placa = placa + 100
where (select count (*) from (select from piloti where(select l.idpilota from letovi l where l.trajanjeleta > 10) = p.idpilota)>10)

--razmontirajte avione starije od 20 godina koji nemaju letove pred sobom
--izbrišite sve letove koji nemaju ni jednu prodanu kartu

--izbrišite sve kartice vjernosti putnika čije prezime završava na -ov/a, -in/a
delete from karticevjernosti kv 
where (select o.idosobe from osobe o where o.prezime = '%ov' or o.prezime = '%ova' or o.prezime = '%in' or o.prezime = '%ina') = kv.idosobe
