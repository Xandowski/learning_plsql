-- TABELAS

CREATE TABLE veiculo (
    id      NUMBER(5) PRIMARY KEY,
    placa   VARCHAR2(7),
    ano     NUMBER(4) NOT NULL
);

CREATE TABLE viagem (
   numero       NUMBER(5) PRIMARY KEY,
   data         DATE NOT NULL,
   cidade       VARCHAR2(100) NOT NULL,
   idveiculo    NUMBER(5) NOT NULL REFERENCES veiculo(id),
   km           NUMBER (5) CHECK(km > 0)
);

-- SEQUENCES

CREATE SEQUENCE seqviagem 
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seqveiculo
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE PROCEDURE insere_veiculo (
    placa   VARCHAR2,
    ano     NUMBER
)IS
BEGIN
    INSERT INTO veiculo (id, placa, ano)
    VALUES (seqveiculo.NEXTVAL, placa, ano);
    
    COMMIT WORK;
END insere_veiculo;

-- PROCEDURES
CREATE OR REPLACE PROCEDURE insere_viagem (
    data        DATE,
    cidade      VARCHAR2,
    idveiculo   NUMBER,
    km          NUMBER
)IS
BEGIN
    INSERT INTO viagem (numero, data, cidade, idveiculo, km)
    VALUES(seqnumero.NEXTVAL, data, cidade, idveiculo, km);
    
    COMMIT WORK;
END insere_viagem;

-- INSERTS
BEGIN
    insere_veiculo('ABC0001', 2021);
    insere_veiculo('GJH9563', 2015);
END;

BEGIN
    insere_viagem(SYSDATE, 'Araraquara', 2, 150);
    insere_viagem(TO_DATE('15/08/2021', 'dd/mm/yyyy'), 'São Paulo', 3, 250);
END;