CREATE TABLE pessoa ( 
    cpf         VARCHAR2(11) PRIMARY KEY, 
    nome        VARCHAR2(100) NOT NULL, 
    salario     NUMBER(10,2) CHECK (salario > 0), 
    email       VARCHAR2(100) NOT NULL, 
    telefone    VARCHAR2(50) NOT NULL 
);

INSERT INTO pessoa (cpf, nome, salario, email, telefone) 
VALUES ('15975385287', 'Joao Silva', 2000.00, 'joao@email.com', '999999999');

INSERT INTO pessoa (cpf, nome, salario, email, telefone) 
VALUES ('25875365281', 'Alexandre Morais', 12000.00, 'alexandre@email.com', '989999999');

INSERT INTO pessoa (cpf, nome, salario, email, telefone) 
VALUES ('55365395284', 'Maria Souza', 18000.00, 'maria@email.com', '989999998');


CREATE TABLE carro ( 
    codigo          NUMBER(5) PRIMARY KEY, 
    marca           VARCHAR2(100) NOT NULL, 
    modelo          VARCHAR2(100) NOT NULL, 
    ano             NUMBER(4) NOT NULL, 
    cpfproprietario VARCHAR2(11) NOT NULL REFERENCES pessoa (cpf)    
);

INSERT INTO carro (codigo, marca, modelo, ano, cpfproprietario) 
VALUES (1, 'BMW', 'M3', 2020, '25875365281');

INSERT INTO carro (codigo, marca, modelo, ano, cpfproprietario) 
VALUES (2, 'HONDA', 'CIVIC', 2008, '15975385287');

INSERT INTO carro (codigo, marca, modelo, ano, cpfproprietario) 
VALUES (3, 'TESLA', 'S', 2021, '55365395284');

SELECT nome, email 
FROM pessoa;

SELECT carro.marca, pessoa.nome 
FROM carro 
JOIN pessoa 
ON carro.cpfproprietario = pessoa.cpf 
ORDER BY nome;

SELECT ano, modelo 
FROM CARRO;

SELECT marca, modelo 
FROM carro 
WHERE ano > 2020;

SELECT cpfproprietario 
FROM carro 
WHERE marca = 'BMW';

SELECT carro.marca, pessoa.nome 
FROM carro 
JOIN pessoa 
ON carro.cpfproprietario = pessoa.cpf 
WHERE salario > 10000.00 
ORDER BY nome;

SELECT carro.marca, pessoa.nome 
FROM carro 
JOIN pessoa 
ON carro.cpfproprietario = pessoa.cpf 
WHERE marca = 'HONDA' 
ORDER BY nome;

SELECT nome, email 
FROM pessoa 
WHERE salario > 15000.00;

SELECT nome, email, telefone 
FROM pessoa 
WHERE salario < 10000.00;

