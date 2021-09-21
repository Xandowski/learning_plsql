CREATE TABLE produto (
    codigo          NUMBER(5) PRIMARY KEY,
    nome            VARCHAR2(100) NOT NULL,
    regiao          CHAR(1) NOT NULL,
    estoque         NUMBER(3) CHECK(estoque >= 0),
    preco_compra    NUMBER(10, 2),
    margem_lucro    NUMBER(10, 2),
    preco_venda     NUMBER(10, 2)
);

CREATE TABLE VENDA (
    numero      NUMBER(5) PRIMARY KEY,
    data        DATE NOT NULL,
    codproduto  NUMBER(5) NOT NULL REFERENCES produto(codigo),
    quantidade  NUMBER(3) CHECK(quantidade > 0)
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

CREATE OR REPLACE FUNCTION calcula_icms (
    valor   IN NUMBER,
    regiao  IN CHAR)RETURN NUMBER
IS
    icms NUMBER(10, 2);
BEGIN
    IF (regiao = 'A') THEN
        icms := valor * 0.08;
    ELSIF (regiao = 'B') THEN
        icms := valor * 0.12;
    ELSE
        icms := valor * 0.15;
    END IF;
    RETURN icms;
END calcula_icms;

CREATE OR REPLACE FUNCTION calcula_total_estoque (
        quantidade IN NUMBER,
        preco_venda IN NUMBER) RETURN NUMBER
IS
    total NUMBER(10,2);
BEGIN
    total := quantidade * preco_venda;
    RETURN total;
END calcula_total_estoque;

CREATE OR REPLACE FUNCTION calcula_margem_lucro (
    regiao IN CHAR,
    preco IN NUMBER) RETURN NUMBER
IS
    margem NUMBER(10,2);
BEGIN
    IF (regiao = 'A') AND (preco < 200) THEN
        margem := 0.27;
    ELSIF (regiao = 'B') AND (preco >= 200) THEN
        margem := 0.34;
    ELSIF (regiao = 'C') AND (preco >= 300) THEN
        margem := 0.40;
    ELSE
        margem := 0.43;
    END IF;
    RETURN MARGEM;
END calcula_margem_lucro;

CREATE OR REPLACE FUNCTION calcula_preco_venda (
    preco_compra IN NUMBER,
    margem_lucro IN NUMBER,
    icms IN NUMBER) RETURN NUMBER
IS 
    preco_venda NUMBER(10,2);
BEGIN
    preco_venda := preco_compra * (1 + margem_lucro) - icms;
    RETURN preco_venda;
END calcula_preco_venda;

CREATE OR REPLACE PROCEDURE insere_produto(
    nome_prod            VARCHAR2,
    regiao_prod          CHAR,
    estoque_prod         VARCHAR2,
    preco_compra_prod    NUMBER
)IS
    icms_prod NUMBER(10,2);
    margem_prod NUMBER(10,2);
    preco_venda_prod NUMBER(10, 2);
BEGIN
    margem_prod := calcula_margem_lucro(regiao_prod, preco_compra_prod);
    icms_prod := calcula_icms(preco_compra_prod, regiao_prod);
    preco_venda_prod := calcula_preco_venda(preco_compra_prod, margem_prod, icms_prod);
    
    INSERT INTO produto (codigo, nome, regiao, estoque, preco_compra, margem_lucro, preco_venda)
    VALUES(seqproduto.NEXTVAL, nome_prod, regiao_prod, estoque_prod, preco_compra_prod, margem_prod, preco_venda_prod);
    
    COMMIT WORK;
END insere_produto;