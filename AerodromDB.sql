CREATE DATABASE Aerodrom
--
USE Aerodrom

CREATE TABLE Avioni (
	IdAviona SERIAL PRIMARY KEY,
	Model VARCHAR(32) NOT NULL,
	Vlasnik VARCHAR(32) NOT NULL,
	Stanje VARCHAR(32) NOT NULL,
	Kapacitet INT NOT NULL
);
CREATE TABLE Sjedala (
	IdSjedala VARCHAR(8) NOT NULL,
	AvionId INT REFERENCES Avioni(IdAviona) NOT NULL,
	Katergorija VARCHAR(8) NOT NULL,
	PRIMARY KEY (AvionId, IdSjedala)
);
CREATE TABLE Aerodromi (
	IdAerodroma SERIAL PRIMARY KEY,
	Naziv VARCHAR(32) NOT NULL,
	Grad VARCHAR(32) NOT NULL,
	Kapactitet INT NOT NULL
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
	KrajnjiAedromId INT REFERENCES Aerodromi(IdAerodroma) NOT NULL,
	IdAviona INT REFERENCES Avioni(IdAviona) NOT NULL,
	TrajanjeLeta INT NOT NULL
);
CREATE TABLE Osobe (
	IdOsobe SERIAL PRIMARY KEY,
	Ime VARCHAR(32) NOT NULL,
	Prezime VARCHAR(32) NOT NULL,
	Spol CHAR(1) NOT NULL,
	Dob TIMESTAMP NOT NULL
);

CREATE TABLE Osoblje (
	IdOsoblja INT REFERENCES Osobe(IdOsobe) NOT NULL,
	IdLeta INT REFERENCES Letovi(IdLeta) NOT NULL,
	PRIMARY KEY (IdOsoblja, IdLeta)
);
CREATE TABLE Kupci (
	IdKupca INT REFERENCES Osobe(IdOsobe) NOT NULL,
	IdPutnika INT REFERENCES Osobe(IdOsobe) NOT NULL,
	IdLeta INT REFERENCES Letovi(IdLeta) NOT NULL,
	PRIMARY KEY (IdKupca, IdPutnika, IdLeta),
	Cijena INT NOT NULL,
	DatumLeta DATE NOT NULL
);
CREATE TABLE Ocjene(
	IdPutnika INT REFERENCES Osobe(IdOsobe) NOT NULL,
	IdLeta INT REFERENCES Letovi(IdLeta) NOT NULL,
	PRIMARY KEY (IdPutnika, IdLeta),
	Ocjena INT NOT NULL
);