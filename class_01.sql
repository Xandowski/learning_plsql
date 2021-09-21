--CREATE TABLE

CREATE TABLE produto (
    codigo  NUMBER(5) PRIMARY KEY,
    nome    VARCHAR(100) NOT NULL,
    estoque NUMBER(3) CHECK(estoque >=0),
    preco   NUMBER(10, 2) CHECK(preco >= 0)
);

--INSERT

INSERT INTO produto (codigo, nome, estoque, preco)
VALUES (1, 'Coca Cola 350ml', 300, 4.50);

INSERT INTO produto (codigo, nome, estoque, preco)
VALUES (2, 'Pizza', 100, 45.50);

INSERT INTO produto (codigo, nome, estoque, preco)
VALUES (3, 'Suco de Laranja', 500, 7.80);

INSERT INTO produto (codigo, nome, estoque, preco)
VALUES (4, 'Misto Quente', 200, 5.00);

--SELECT

-- 1) consultar tudo
SELECT *
FROM produto;

-- 2)nome e estoque
SELECT nome, estoque
FROM produto;

-- 3)nome e preço
SELECT nome, preco
FROM produto;

-- 4)campos dos produtos com preço abaixo de 5
SELECT * 
FROM produto
WHERE preco < 5;

-- 5)nome e preço dos produtos com preço acima de 10
SELECT nome, preco
FROM produto
WHERE preco > 10;

--6)nome e preco e estoque dos produtos com estoque abaixo de 200
SELECT nome, preco, estoque
FROM produto
WHERE estoque < 200;

-- 7)nome e preço dos produtos com estoque acima de 100 e preco abaixo de 10
SELECT nome, preco
FROM produto
WHERE estoque > 100 
AND preco < 10;

--CRIAR TABELA CLIENTE

CREATE TABLE cliente ( 
    codigo  NUMBER(5) PRIMARY KEY, 
    nome    VARCHAR2(100) NOT NULL, 
    cpf     VARCHAR2(11) NOT NULL, 
    cidade  VARCHAR2(100) NOT NULL, 
    saldo   NUMBER(10,2)
);

--CRAR A TABELA PEDIDO

CREATE TABLE pedido ( 
    numero  NUMBER(5) PRIMARY KEY, 
    data    DATE NOT NULL, 
    codproduto  NUMBER(5) NOT NULL REFERENCES produto (codigo), 
    quantidade  NUMBER(5) CHECK (quantidade > 0), 
    codcliente  NUMBER(5) NOT NULL REFERENCES cliente (codigo) 
);
