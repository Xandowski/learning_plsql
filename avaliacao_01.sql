CREATE TABLE financiamento (
    numero          NUMBER(5) PRIMARY KEY,
    data            DATE,
    total           NUMBER(10,2),
    prestacoes      NUMBER(3),
    saldo           NUMBER(10,2),
    financiadora    VARCHAR2(100) NOT NULL
);

CREATE TABLE parcela (
    numero      NUMBER(5) PRIMARY KEY,
    data        DATE,
    valor       NUMBER(10,2),
    numfincanciamento   NUMBER(5) NOT NULL REFERENCES financiamento(numero),
    desconto            NUMBER(5) CHECK(desconto >=0)
);


CREATE SEQUENCE seqfinanciamento
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE seqparcela
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE PROCEDURE insere_financiamento (
    data_fin            DATE,
    total_fin           NUMBER,
    prestacoes_fin      NUMBER,
    saldo_fin           NUMBER,
    financiadora_fin    VARCHAR2
)IS
BEGIN
    INSERT INTO financiamento(numero, data, total, prestacoes, saldo, financiadora)
    VALUES(seqfinanciamento.NEXTVAL, data_fin, total_fin, prestacoes_fin, saldo_fin, financiadora_fin);
    
    COMMIT WORK;
END insere_financiamento;

CREATE OR REPLACE FUNCTION calcula_juros (
    valor   IN NUMBER,
    quantidade_dias  IN NUMBER
) RETURN NUMBER
IS
    juros NUMBER(10, 2);
BEGIN
    juros := quantidade_dias * 0.01 * valor;
    
    RETURN juros;
END calcula_juros;

CREATE OR REPLACE TRIGGER baixa_saldo
AFTER INSERT ON parcela
FOR EACH ROW
BEGIN
    dbms_output.put_line ('trigger baixa_saldo executado com sucesso');
    UPDATE financiamento
    SET saldo = saldo - :NEW.valor
    WHERE numero = :NEW.numfincanciamento;
END baixa_saldo;

CREATE OR REPLACE PROCEDURE insere_parcela (
    data_par                DATE,
    valor_par               NUMBER,
    numfincanciamento_par   NUMBER,
    desconto_par            NUMBER
)IS
BEGIN
    INSERT INTO parcela(numero, data, valor, numfinanciamento, desconto)
    VALUES(seqparcela.NEXTVAL, data_par, valor_par, numfincanciamento_par, desconto_par);
    
    COMMIT WORK;
END insere_parcela;

