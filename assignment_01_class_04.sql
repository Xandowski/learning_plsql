CREATE TABLE funcionario (
    numero      NUMBER(5) PRIMARY KEY,
    nome        VARCHAR2(100) NOT NULL,
    salario     NUMBER(10,2) CHECK(salario >0),
    admissao    DATE NOT NULL
);

CREATE SEQUENCE seqfuncionario
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE PROCEDURE insere_funcionario (
    nome_fun        VARCHAR2,
    salario_fun     DECIMAL,
    admissao_fun    DATE
) IS
BEGIN
    INSERT INTO funcionario (numero, nome, salario, admissao)
    VALUES (seqfuncionario.NEXTVAL, nome_fun, salario_fun, admissao_fun);
    
    COMMIT WORK;

END insere_funcionario;

CREATE OR REPLACE PROCEDURE remover_funcionario (
    numero_func NUMBER
)IS
BEGIN
    DELETE FROM funcionario
    WHERE numero = numero_func;
    
    remover_holerite(numero_func);
    
    COMMIT WORK;
END remover_funcionario;

CREATE TABLE holerite (
    numero          NUMBER(5) PRIMARY KEY,
    data            DATE NOT NULL,
    salario_base    NUMBER(10,2) CHECK(salario_base > 0),
    ir              NUMBER(10,2) CHECK(ir > 0),
    fgts            NUMBER(10,2) CHECK(fgts > 0),
    salario_liquido NUMBER(10,2) CHECK(salario_liquido > 0),
    codfuncionario  NUMBER(5) NOT NULL REFERENCES funcionario(numero)
);

CREATE SEQUENCE seqholerite
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE PROCEDURE insere_holerite (
    data_hol            DATE,
    salario_base_hol    DECIMAL,
    ir_hol              NUMBER,
    fgts_hol            NUMBER,
    salario_liq_hol     NUMBER,
    cod_func_hol        NUMBER
) IS
BEGIN
    INSERT INTO holerite (numero, data, salario_base, ir, fgts, salario_liquido, codfuncionario)
    VALUES (seqholerite.NEXTVAL, data_hol, salario_base_hol, ir_hol, fgts_hol, salario_liq_hol, cod_func_hol);
    
    COMMIT WORK;

END insere_holerite;

CREATE OR REPLACE PROCEDURE remover_holerite (
    numero_cod_func NUMBER
)IS
BEGIN
    DELETE FROM holerite
    WHERE numero = numero_cod_func;
    
    COMMIT WORK;
END remover_funcionario;