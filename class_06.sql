--TRIGGERS Oracle são programas PL/SQL disparados quando ocorre um determinado 
-- evento em uma determinada tabela:
-- insert
-- delete
-- update

CREATE TABLE produto (
    codigo          NUMBER(5) PRIMARY KEY,
    nome            VARCHAR2(100) NOT NULL,
    estoque_atual   NUMBER(3) CHECK(estoque_atual >=0),
    estoque_minimo  NUMBER(3) CHECK(estoque_minimo >=0),
    estoque_maximo  NUMBER(3) CHECK(estoque_maximo >=0),
    preco           NUMBER(10, 2)
);

CREATE TABLE venda(
    numero      NUMBER(5) PRIMARY KEY,
    data        DATE,
    codproduto  number(5) NOT NULL REFERENCES produto(codigo),
    quantidade  NUMBER(3)
);

CREATE TABLE compra (
    numero      NUMBER(5) PRIMARY KEY,
    data        DATE,
    codproduto  NUMBER(5) NOT NULL REFERENCES produto(codigo),
    quantidade  NUMBER(3)
);

CREATE SEQUENCE seqproduto
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seqvenda
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seqcompra
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE PROCEDURE insere_produto(
    nome_prod            VARCHAR2,
    estoque_atuaL_prod   NUMBER,
    estoque_minimo_prod  NUMBER,
    estoque_maximo_prod  NUMBER,
    preco_prod           NUMBER
)IS
BEGIN
    INSERT INTO produto(codigo, nome, estoque_atual, estoque_minimo, estoque_maximo, preco)
    VALUES(seqproduto.NEXTVAL, nome_prod, estoque_atuaL_prod, estoque_minimo_prod, estoque_maximo_prod, preco_prod);
    
    COMMIT WORK;
END insere_produto;

CREATE OR REPLACE PROCEDURE insere_venda(
    data_ven        DATE,
    codproduto_ven  NUMBER,
    quantidade_ven  NUMBER
)IS
BEGIN
    INSERT INTO venda(numero, data, codproduto, quantidade)
    VALUES(seqvenda.NEXTVAL, data_ven, codproduto_ven, quantidade_ven);
    
    COMMIT WORK;
END insere_venda;

CREATE OR REPLACE PROCEDURE insere_compra(
    data_com        DATE,
    codproduto_com  NUMBER,
    quantidade_com  NUMBER
)IS
BEGIN
    INSERT INTO compra(numero, data, codproduto, quantidade)
    VALUES(seqcompra.NEXTVAL, data_com, codproduto_com, quantidade_com);
    
    COMMIT WORK;
END insere_compra;


CREATE OR REPLACE TRIGGER test
AFTER INSERT ON produto
FOR EACH ROW
BEGIN
    dbms_output.put_line ('trigger teste executado');
    dbms_output.put_line ('nome: ' || :NEW.nome);
    dbms_output.put_line ('preco: ' || :NEW.preco);
    dbms_output.put_line ('estoque atual: ' || :NEW.estoque_atual);
END produto;

CREATE OR REPLACE TRIGGER baixa_estoque
AFTER INSERT ON venda
FOR EACH ROW
BEGIN
    dbms_output.put_line ('trigger baixa_estoque executado com sucesso');
    UPDATE produto
    SET estoque_atual = estoque_atual - :NEW.quantidade
    WHERE codigo = :NEW.codproduto;
END baixa_estoque;


BEGIN
    insere_venda(SYSDATE(), 1, 3);
END;

CREATE OR REPLACE TRIGGER repor_estoque
AFTER INSERT ON compra
FOR EACH ROW
BEGIN
    dbms_output.put_line ('trigger repor_estoque executado com sucesso');
    
    :NEW.produto
    SET estoque_atual = estoque_atual + :NEW.quantidade
    WHERE codigo = :NEW.codproduto;
END repor_estoque;

BEGIN
    insere_compra(SYSDATE(), 1, 4);
END;


CREATE OR REPLACE TRIGGER gerar_compra
AFTER UPDATE OF estoque_atual ON produto
FOR EACH ROW
BEGIN
    dbms_output.put_line ('trigger gerar_compra executado com sucesso');
    
    if (:NEW.estoque_atual <= :NEW.estoque_minimo) THEN
        insere_compra(SYSDATE(), :NEW.codigo, :NEW.estoque_maximo - :NEW.estoque_atual);
    END IF;
END gerar_compra;

BEGIN
    insere_venda(SYSDATE(), 1, 10);
END;