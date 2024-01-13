USE [master]
GO

CREATE DATABASE TrabalhoEstacio27;
GO

USE TrabalhoEstacio27;
GO

CREATE TABLE [Produto] (
  idProduto INTEGER IDENTITY(1,1) NOT NULL,
  nome VARCHAR(255) NOT NULL,
  quantidade INTEGER NOT NULL,
  precoVenda NUMERIC(10, 2) NOT NULL,
  PRIMARY KEY(idProduto)
);
GO

CREATE TABLE [Pessoa] (
  idPessoa INTEGER IDENTITY(1,1) NOT NULL,
  nome VARCHAR(255) NOT NULL,
  logradouro VARCHAR(255) NOT NULL,
  cidade VARCHAR(255) NOT NULL,
  estado CHAR(2) NOT NULL,
  telefone VARCHAR(11),
  email VARCHAR(255),
  PRIMARY KEY(idPessoa)
);
GO

CREATE TABLE [Usuario] (
  idUsuario INTEGER IDENTITY(1,1) NOT NULL,
  login VARCHAR(255) NOT NULL UNIQUE,
  senha VARCHAR(255) NOT NULL,
  PRIMARY KEY(idUsuario)
);
GO

CREATE TABLE [PessoaJuridica] (
  idPessoaJuridica INTEGER IDENTITY(1,1) NOT NULL,
  Pessoa_idPessoa INTEGER NOT NULL,
  cnpj VARCHAR(20) NOT NULL,
  PRIMARY KEY(idPessoaJuridica),
  FOREIGN KEY(Pessoa_idPessoa) REFERENCES Pessoa(idPessoa)
);
GO

CREATE INDEX F_PessoaJuridicaPesso ON PessoaJuridica (Pessoa_idPessoa);
GO

CREATE TABLE [PessoaFisica] (
  idPessoaFisica INTEGER IDENTITY(1,1) NOT NULL,
  Pessoa_idPessoa INTEGER NOT NULL,
  cpf VARCHAR(20) NOT NULL,
  PRIMARY KEY(idPessoaFisica),
  FOREIGN KEY(Pessoa_idPessoa) REFERENCES Pessoa(idPessoa)
);
GO

CREATE INDEX FK_PessoaFisicaPessoa ON PessoaFisica (Pessoa_idPessoa);
GO

CREATE TABLE [Movimento] (
  idMovimento INTEGER IDENTITY(1,1) NOT NULL,
  Pessoa_idPessoa INTEGER NOT NULL,
  Usuario_idUsuario INTEGER NOT NULL,
  Produto_idProduto INTEGER NOT NULL,
  tipo VARCHAR(4) NOT NULL,
  quantidade INTEGER NOT NULL,
  precoUnitario NUMERIC(10, 2) NOT NULL,
  PRIMARY KEY(idMovimento),
  FOREIGN KEY(Produto_idProduto) REFERENCES Produto(idProduto),
  FOREIGN KEY(Usuario_idUsuario) REFERENCES Usuario(idUsuario),
  FOREIGN KEY(Pessoa_idPessoa) REFERENCES Pessoa(idPessoa)
);
GO

CREATE INDEX FK_MovimentoProduto ON Movimento (Produto_idProduto);
GO

CREATE INDEX FK_MovimentoUsuario ON Movimento (Usuario_idUsuario);
GO

CREATE INDEX FK_MovimentoPessoa ON Movimento (Pessoa_idPessoa);
GO