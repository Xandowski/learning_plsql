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


BEGIN
    insere_funcionario ('Altair mendes', 390000, SYSDATE);
    insere_funcionario ('Ana Cristina', 545000, TO_DATE('20/01/2019', 'dd/mm/yyyy'));
    insere_funcionario ('Eliseu Resende', 272000, TO_DATE('15/10/2020', 'dd/mm/yyyy'));
END;

CREATE OR REPLACE PROCEDURE altera_nome (
    numero_func  NUMBER,
    nome_func   VARCHAR2
) IS
BEGIN
    UPDATE funcionario
    SET nome = nome_func
    WHERE numero = numero_func;
    
    COMMIT WORK;

END altera_nome;

BEGIN
    altera_nome (3, 'Elizeu Resende');
END;

SELECT *
FROM funcionario


CREATE OR REPLACE PROCEDURE aumento_salarial (
    numero_func     NUMBER,
    porcentagem    NUMBER
)IS
BEGIN
    UPDATE funcionario
    SET salario = salario * (1+porcentagem/100)
    WHERE numero = numero_func;
    
    COMMIT WORK;
END aumento_salarial;

BEGIN
    aumento_salarial (3, 5);
END;


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

CREATE OR REPLACE PROCEDURE remover_funcionario (
    numero_func NUMBER
)IS
BEGIN
    DELETE FROM funcionario
    WHERE numero = numero_func;
    
    COMMIT WORK;
END remover_funcionario;