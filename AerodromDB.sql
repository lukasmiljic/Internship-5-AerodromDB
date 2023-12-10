CREATE DATABASE Aerodrom

USE Aerodrom

CREATE TABLE Avioni (
	IdAviona SERIAL PRIMARY KEY,
	Model VARCHAR(32) NOT NULL,
	Vlasnik VARCHAR(32) NOT NULL,
	Stanje VARCHAR(32) NOT NULL,
	Kapacitet INT NOT NULL
)

CREATE TABLE Sjedala (
	IdSjedala VARCHAR(8) NOT NULL,
	AvionId INT REFERENCES Avioni(IdAviona),
	Katergorija VARCHAR(8) NOT NULL,
	PRIMARY KEY (AvionId, IdSjedala)
)

CREATE TABLE Aerodromi (
	IdAedroma SERIAL PRIMARY KEY,
	Naziv VARCHAR(32) NOT NULL,
	Grad VARCHAR(32) NOT NULL,
	Kapactitet INT NOT NULL
)

CREATE TABLE AvionSeNalazi (
	IdAviona INT REFERENCES Avioni(IdAviona),
	IdAerodroma INT REFERENCES Aerodromi(IdAerodroma),
	Lokacija VARCHAR(32),
	Vrijeme TIMESTAMP
)

CREATE TABLE Letovi (
	IdLeta SERIAL PRIMARY KEY,
	DatumLeta TIMESTAMP,
	PocetniAerodromId INT REFERENCES Aerodromi(IdAerodroma),
	KrajnjiAedromId INT REFERENCES Aerodromi(IdAerodroma),
	IdAviona INT REFERENCES Avioni(IdAviona),
	TrajanjeLeta INT
)

CREATE TABLE Osobe (
	IdOsobe SERIAL PRIMARY KEY,
	Ime VARCHAR(32) NOT NULL,
	Prezime VARCHAR(32) NOT NULL,
	Spol CHAR(1) NOT NULL,
	Dob TIMESTAMP NOT NULL
)

CREATE TABLE Osoblje (
	IdOsoblja INT REFERENCES Osobe(IdOsobe),
	IdLeta INT REFERENCES Letovi(IdLeta),
	PRIMARY KEY (IdOsoblja, IdLeta)
)

CREATE TABLE Kupci (
	IdKupca INT REFERENCES Osobe(IdOsobe),
	IdPutnika INT REFERENCES Osobe(IdOsobe),
	IdLeta INT REFERENCES Letovi(IdLeta),
	PRIMARY KEY (IdKupca, IdPutnika, IdLeta),
	Cijena INT NOT NULL,
	DatumLeta DATE NOT NULL
)

CREATE TABLE Ocjene(
	IdPutnika INT REFERENCES Osobe(IdOsobe),
	IdLeta INT REFERENCES Letovi(IdLeta),
	PRIMARY KEY (IdPutnika, IdLeta),
	Ocjena INT NOT NULL
)
