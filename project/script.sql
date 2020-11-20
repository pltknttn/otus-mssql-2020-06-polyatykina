
USE master
go


DROP DATABASE IF  EXISTS [FitnessClub]
GO

CREATE DATABASE [FitnessClub]
CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = FitnessClub, FILENAME =N'D:\Working\Database\SQL Server\FitnessClub.mdf' , 
	SIZE = 8MB , 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 65536KB )
 LOG ON 
( NAME = FitnessClub_log, FILENAME = N'D:\Working\Database\SQL Server\FitnessClub.ldf' , 
	SIZE = 8MB , 
	MAXSIZE = 50GB , 
	FILEGROWTH = 65536KB )
 COLLATE Cyrillic_General_CI_AS
GO

USE [FitnessClub]
GO
 