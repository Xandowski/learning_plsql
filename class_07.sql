CREATE TABLE peca ( 
    codigo  NUMBER(5) PRIMARY KEY, 
    nome    VARCHAR2(100) NOT NULL, 
    estoque_atual NUMBER(3) CHECK (estoque_atual >= 0), 
    estoque_minimo NUMBER(3) CHECK (estoque_minimo >= 0), 
    estoque_maximo NUMBER(3) CHECK (estoque_maximo >= 0), 
    preco  NUMBER(10,2)
)


CREATE SEQUENCE seqpeca 
START WITH 1 
INCREMENT BY 1 
NOCACHE 
NOCYCLE;


CREATE OR REPLACE PROCEDURE insere_peca ( 
                nomep IN VARCHAR2, 
                atuap IN NUMBER, 
                minip IN NUMBER, 
                maxip IN NUMBER, 
                precp IN DECIMAL)
IS 
BEGIN 
    INSERT INTO peca (codigo, nome, estoque_atual, estoque_minimo, estoque_maximo, preco) 
    VALUES (seqpeca.NEXTVAL, nomep, atuap, minip, maxip, precp); 
     
    COMMIT WORK; 
END insere_peca;


CREATE TABLE orcamento ( 
    numero  NUMBER(5) PRIMARY KEY, 
    data    DATE, 
    codpeca NUMBER(5) REFERENCES peca (codigo), 
    quantidade NUMBER(3), 
    total   NUMBER(10,2), 
    status  VARCHAR2(100) 
);


CREATE SEQUENCE seqorcamento 
START WITH 1 
INCREMENT BY 1 
NOCACHE 
NOCYCLE;


CREATE OR REPLACE PROCEDURE insere_orcamento ( 
        datao IN DATE, 
        codpo IN NUMBER, 
        quano IN NUMBER, 
        totao IN NUMBER, 
        stato IN VARCHAR2) IS 
BEGIN 
    INSERT INTO orcamento (numero, data, codpeca, quantidade, total, status) 
    VALUES (seqorcamento.NEXTVAL, datao, codpo, quano, totao, stato); 
     
    COMMIT WORK; 
END insere_orcamento;


CREATE TABLE notafiscal ( 
    numero  NUMBER(5) PRIMARY KEY, 
    data    DATE, 
    total   NUMBER(10,2), 
    numorcamento NUMBER(5) REFERENCES orcamento (numero) 
);


CREATE SEQUENCE seqnotafiscal 
START WITH 1 
INCREMENT BY 1 
NOCACHE 
NOCYCLE;


CREATE OR REPLACE PROCEDURE insere_notafiscal ( 
    datanf IN DATE, 
    totanf IN DECIMAL, 
    numonf IN NUMBER) IS 
BEGIN 
    INSERT INTO notafiscal (numero, data, total, numorcamento) 
    VALUES (seqnotafiscal.NEXTVAL, datanf, totanf, numonf); 
     
    COMMIT WORK; 
END insere_notafiscal;


CREATE OR REPLACE PROCEDURE insere_notafiscal_sem_commit ( 
    datanf IN DATE, 
    totanf IN DECIMAL, 
    numonf IN NUMBER) IS 
BEGIN 
    INSERT INTO notafiscal (numero, data, total, numorcamento) 
    VALUES (seqnotafiscal.NEXTVAL, datanf, totanf, numonf); 
     
END insere_notafiscal_sem_commit;


CREATE OR REPLACE TRIGGER gera_nota
AFTER UPDATE OF status ON orcamento
FOR EACH ROW
BEGIN
    dbms_output.put_line('trigger executado para o orcamento: ' || :NEW.numero);
    
    UPDATE peca
    SET estoque_atual = estoque_atual - :NEW.quantidade
    WHERE codigo = :NEW.codpeca;
    
    insere_notafiscal(SYSDATE, :NEW.total, :NEW.numero);
        
END gera_nota;

CREATE TABLE compra (
    numero NUMBER(5) PRIMARY KEY,
    data DATE,
    codpeca NUMBER(5) REFERENCES peca (codigo),
    quantidade NUMBER(3)
);

CREATE SEQUENCE seqcompra
START WITH 1
INCREMENT BY 1
NOCYCLE
NOCACHE;

CREATE OR REPLACE PROCEDURE insere_compra_sem_commit (
    datac IN DATE,
    codpe IN NUMBER,
    quanp IN NUMBER) 
IS
BEGIN
    INSERT INTO compra (numero, data, codpeca, quantidade)
    VALUES (seqcompra.NEXTVAL, datac, codpe, quanp);
END insere_compra_sem_commit;


CREATE OR REPLACE TRIGGER gera_compra
AFTER UPDATE OF estoque_atual ON peca
FOR EACH ROW
BEGIN
    dbms_output.put_line('trigger executado para a peça: ' || :NEW.codigo);
    
    IF (:NEW.estoque_atual <= :NEW.estoque_minimo) THEN
        insere_compra_sem_commit(SYSDATE, :NEW.codigo, :NEW.estoque_maximo - :NEW.estoque_atual);
    END IF;
        
END gera_compra;