CREATE TABLE peca (
    codigo  NUMBER(5) PRIMARY KEY,
    descricao VARCHAR2(100) NOT NULL,
    preco NUMBER(10, 2) CHECK (preco > 0) 
);

CREATE TABLE repositorio (
    id  NUMBER(5) PRIMARY KEY,
    endereco    VARCHAR2(100) NOT NULL,
    codpeca    NUMBER(5) NOT NULL REFERENCES peca(codigo),
    estoque     NUMBER(3) CHECK (estoque >= 0)
);

CREATE SEQUENCE seqpeca
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

INSERT INTO peca (codigo, descricao, preco)
VALUES (seqpeca.NEXTVAL, 'Girabrequim 6 cilindros', 890.00);

INSERT INTO peca (codigo, descricao, preco)
VALUES (seqpeca.NEXTVAL, 'Parafuso de Carter', 45.00);

CREATE SEQUENCE seqrepo
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

INSERT INTO repositorio (id, endereco, codpreca, estoque)
VALUES (seqrepo.NEXTVAL, 'Av rios, 94', 1, 50);

INSERT INTO repositorio (id, endereco, codpreca, estoque)
VALUES (seqrepo.NEXTVAL, 'Rua são paulo, 56', 2, 65);

CREATE TABLE curso (
    codigo  NUMBER(5) PRIMARY KEY,
    nome    VARCHAR2(100) NOT NULL,
    preco   NUMBER(10, 2) CHECK(preco > 0)
);

CREATE TABLE venda (
    numero      NUMBER(5),
    data        DATE NOT NULL,
    codcurso    NUMBER(5) NOT NULL REFERENCES curso(codigo),
    quantidade  NUMBER(3) CHECK(quantidade >=0)
);

CREATE SEQUENCE seqcurso
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seqnumero
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

INSERT INTO curso(codigo, nome, preco)
VALUES (seqcurso.NEXTVAL, 'JavaScript 2021', 100.00);

INSERT INTO curso(codigo, nome, preco)
VALUES (seqcurso.NEXTVAL, 'Python 2021', 97.00);

INSERT INTO venda(numero, data, codcurso, quantidade)
VALUES (seqnumero.NEXTVAL, SYSDATE, 2, 10);

INSERT INTO venda(numero, data, codcurso, quantidade)
VALUES (seqnumero.NEXTVAL, SYSDATE, 3, 20);

CREATE OR REPLACE PROCEDURE insere_curso (
    nome_curso   VARCHAR2,
    preco_curso  DECIMAL
) IS
BEGIN
    INSERT INTO curso (codigo, nome, preco)
    VALUES (seqcurso.NEXTVAL, nome_curso, preco_curso);
    
    COMMIT WORK;
    
END insere_curso;

BEGIN
    insere_curso('Java 2021', 15000);
    insere_curso('Banco de dados 2021', 12000);
END;