USE [TrabalhoEstacio27]
GO

--Usuarios

INSERT INTO [Usuario] (login, senha) VALUES ('op1','op1')
GO
INSERT INTO [Usuario] (login, senha) VALUES ('op2','op2')
GO
INSERT INTO [Usuario] (login, senha) VALUES ('op3','op3')
GO

SELECT * FROM [Usuario]
GO

-- Produtos
INSERT INTO [Produto] ([nome],[quantidade], [precoVenda]) VALUES('Banana','100','5')
GO

INSERT INTO [Produto] ([nome],[quantidade], [precoVenda]) VALUES('Laranja','500','2')
GO

INSERT INTO [Produto] ([nome],[quantidade], [precoVenda]) VALUES('Manga','800','4')
GO

INSERT INTO [Produto] ([nome],[quantidade], [precoVenda]) VALUES('Maracuja','200','3.30')
GO

-- Selecionando os produtos
SELECT * FROM [Produto]
GO

-- Adicionando Pessoas
INSERT INTO [Pessoa] (nome, logradouro, cidade, estado, telefone, email)
VALUES
('João Silva', 'Rua Exemplo 1', 'Cidade Exemplo', 'RJ', '12345678901', 'joao.silva@email.com'),
('Maria Souza', 'Avenida Exemplo 2', 'Cidade Exemplo', 'SC', '10987654321', 'maria.souza@email.com'),
('Marcio Silva', 'Rua Exemplo 3', 'Cidade Exemplo', 'RS', '12345678901', 'marciosilva@example.com'),
('Carlos Souza', 'Travessa Exemplo 4', 'Cidade Exemplo', 'SP', '09876543210', 'carlossouza@example.com');
GO

-- Adicionando Pessoa Fisica
INSERT INTO [PessoaFisica] (Pessoa_idPessoa, cpf)
VALUES
(1, '22222221121'),  
(4, '33334412231');  
GO

-- Adicionando Pessoa Juridica
INSERT INTO [PessoaJuridica] (Pessoa_idPessoa, cnpj)
VALUES
(2, '888888123123'),  
(3, '999999123121');  
GO

-- Listar todas as pessoas
SELECT * FROM [Pessoa]
GO

-- Consulta de Pessoas Fisicas
SELECT Pessoa.idPessoa, Pessoa.nome, Pessoa.logradouro, Pessoa.cidade, Pessoa.estado, Pessoa.telefone, Pessoa.email, PF.cpf 
FROM Pessoa AS Pessoa JOIN PessoaFisica AS PF ON Pessoa.idPessoa = PF.Pessoa_idPessoa;
GO

-- Consulta de Pessoas Juridicas
SELECT Pessoa.idPessoa, Pessoa.nome, Pessoa.logradouro, Pessoa.cidade, Pessoa.estado, Pessoa.telefone, Pessoa.email, PJ.cnpj
FROM Pessoa AS Pessoa JOIN PessoaJuridica AS PJ ON Pessoa.idPessoa = PJ.Pessoa_idPessoa;
GO

--- Inserindo Movimentos
INSERT INTO [Movimento] (Usuario_idUsuario, Pessoa_idPessoa , Produto_idProduto, quantidade, tipo, precoUnitario)
VALUES
(1, 2, 3, 8, 'E', 2),
(1, 1, 4, 2, 'E', 3.30),
(1, 4, 2, 12, 'S', 2),
(2, 4, 3, 2, 'E', 4),
(1, 4, 3, 8, 'E', 4);
GO

SELECT * FROM Movimento;
GO

---  Movimentações de entrada, com produto, fornecedor, quantidade, preço unitário e valor total.
SELECT 
    pe.nome AS NomePessoa,
    produto.nome AS NomeProduto,
    mov.quantidade,
    mov.precoUnitario AS ValorUnitario,
    mov.quantidade * mov.precoUnitario AS Total
FROM Movimento mov
JOIN Produto produto ON mov.Produto_idProduto = produto.idProduto
JOIN Pessoa pe ON mov.Pessoa_idPessoa = pe.idPessoa
WHERE mov.tipo = 'E';


--- Total de Entradas agrupadas por produtos
SELECT Produto_idProduto, SUM(precoUnitario) AS TotalPrecoUnitario
FROM Movimento
WHERE tipo = 'E'
GROUP BY Produto_idProduto;
GO

---  Valor total das entradas agrupadas por produto.
SELECT 
    produto.nome AS NomeProduto,
    mov.Produto_idProduto, 
    SUM(mov.quantidade * mov.precoUnitario) AS TotalValor
FROM Movimento mov
JOIN Produto produto ON mov.Produto_idProduto = produto.idProduto
WHERE mov.tipo = 'E'
GROUP BY mov.Produto_idProduto, produto.nome;
GO

---  Valor total das saidas agrupadas por produto.
SELECT 
    produto.nome AS NomeProduto,
    mov.Produto_idProduto, 
    SUM(mov.quantidade * mov.precoUnitario) AS TotalValor
FROM Movimento mov
JOIN Produto produto ON mov.Produto_idProduto = produto.idProduto
WHERE mov.tipo = 'S'
GROUP BY mov.Produto_idProduto, produto.nome;
GO

--- Operadores (Usuarios) que não possuem saida na tabela movimento
SELECT DISTINCT usuarios.*
FROM Usuario usuarios
LEFT JOIN Movimento mov ON usuarios.idUsuario = mov.Usuario_idUsuario AND mov.tipo = 'S'
WHERE mov.Usuario_idUsuario IS NULL;
GO

--- Valor total de entrada, agrupado por operador.
SELECT 
    Usuario_idUsuario, 
    SUM(quantidade * precoUnitario) AS TotalValor
FROM Movimento
WHERE tipo = 'E'
GROUP BY Usuario_idUsuario;

--- Valor total de saida, agrupado por operador.
SELECT 
    Usuario_idUsuario, 
    SUM(quantidade * precoUnitario) AS TotalValor
FROM Movimento
WHERE tipo = 'S'
GROUP BY Usuario_idUsuario;

--- Valor médio de venda por produto, utilizando média ponderada.
SELECT 
    produto.nome AS NomeProduto,
    mov.Produto_idProduto, 
    AVG(mov.precoUnitario) AS MediaPrecoUnitario
FROM Movimento mov
JOIN Produto produto ON mov.Produto_idProduto = produto.idProduto
GROUP BY mov.Produto_idProduto, produto.nome;
GO

