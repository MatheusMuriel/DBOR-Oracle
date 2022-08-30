
-- Matheus Muriel
-- Banco de Dados não Convencionais
-- Mestrado UEL - 2022
-- ToDo 01 - DBOR Oracle
-- Caso de uso baseado em Seguros


-------------------------------------------------------------------------------------------------------------------------
----------------------------------------- Pessoa, Corretor, Segurado ----------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
CREATE TYPE pessoa_typ AS OBJECT (
  id        NUMBER,
  nome      VARCHAR2(50),
  cpf       NUMBER,
  MEMBER PROCEDURE display_details (SELF IN OUT NOCOPY pessoa_typ)
) NOT FINAL;
CREATE TYPE BODY pessoa_typ AS 
  MEMBER PROCEDURE display_details ( SELF IN OUT NOCOPY pessoa_typ ) IS
  BEGIN
    if SELF IS OF (CORRETOR_TYP) THEN
      DBMS_OUTPUT.PUT_LINE('Corretor: ');
    end if;
    if SELF IS OF (SEGURADO_TYP) THEN
      DBMS_OUTPUT.PUT_LINE('Segurado: ');
    end if;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(id) || ' ' || nome || ' ' || TO_CHAR(cpf));
  END;
END;

CREATE TYPE corretor_typ UNDER pessoa_typ (
  corretora   VARCHAR2(20)
) FINAL;

CREATE TYPE segurado_typ UNDER pessoa_typ (
  limite      NUMBER
) FINAL;

CREATE TABLE pessoa_obj_table OF pessoa_typ (
  id PRIMARY KEY,
  cpf UNIQUE,
  CHECK (nome IS NOT NULL)
);

-- TODO - Inserts do outro ARQUIVO
-- TODO fazer VIEW do object

SELECT * FROM pessoa_obj_table; -- Padrão
SELECT p.* FROM pessoa_obj_table p; --Alias
SELECT p.* FROM pessoa_obj_table p WHERE VALUE(P) IS OF (CORRETOR_TYP); -- Filtrando por tipo
SELECT p.* FROM pessoa_obj_table p WHERE VALUE(P) IS OF (PESSOA_TYP); -- Mostrando os supertipos
SELECT p.* FROM pessoa_obj_table p WHERE VALUE(P) IS OF (ONLY PESSOA_TYP); -- Filtrando por is only de um super tipo

-- Diferentes object viewer
DECLARE pessoa pessoa_typ;
BEGIN 
  SELECT VALUE(p) INTO pessoa FROM pessoa_obj_table p WHERE p.id = 1;
  pessoa.display_details();
  DBMS_OUTPUT.PUT_LINE('------------');
  SELECT VALUE(p) INTO pessoa FROM pessoa_obj_table p WHERE p.id = 2;
  pessoa.display_details();
  DBMS_OUTPUT.PUT_LINE('------------');
  SELECT VALUE(p) INTO pessoa FROM pessoa_obj_table p WHERE p.id = 3;
  pessoa.display_details();
END;


-------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- Item e Apolice ----------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
CREATE TYPE item_typ AS OBJECT (
  latitude      NUMBER,
  longitude     NUMBER,
  produto       VARCHAR2(10),
  valor         NUMBER
);

CREATE TYPE item_array AS 
  VARRAY(10) OF item_typ
;

CREATE OR REPLACE TYPE apolice_typ AS OBJECT (
  id              NUMBER,
  listaItens      item_array,
  valor           NUMBER,
  segurado        REF PESSOA_TYP,
  corretor        REF PESSOA_TYP,
  dataEfetivacao  DATE,
  status          VARCHAR2(1)
) NOT FINAL;

CREATE TYPE proposta_typ UNDER apolice_typ (
  valorBoleto       NUMBER,
  vencimentoBoleto  DATE
) NOT FINAL;

CREATE TYPE cotacao_typ UNDER proposta_typ (
  dataCotacao       DATE
);

CREATE TABLE apolice_obj_table OF apolice_typ;


-- Inserts do outro arquivo

SELECT VALUE(ap) FROM apolice_obj_table ap;
SELECT ap.* FROM apolice_obj_table ap;
select ap.SEGURADO from apolice_obj_table ap;



-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------


--- Tabela composta de Auditoria
CREATE TYPE produto_config_typ AS OBJECT (
  produto_id      NUMBER,
  base_de_calculo NUMBER,
  valor_minimo    NUMBER
) FINAL;

CREATE TABLE produto_config_obj_table OF produto_config_typ (
  produto_id PRIMARY KEY
);

CREATE TABLE produto_config_auditoria (
  data_alteracao    NUMBER,
  config_produto    produto_config_typ
);

INSERT INTO produto_config_obj_table VALUES (produto_config_typ(1,2,3));
INSERT INTO produto_config_auditoria VALUES (1, produto_config_typ(10,20,30));

CREATE OR REPLACE TRIGGER produto_config_update_trigger
AFTER UPDATE
  ON produto_config_obj_table
FOR EACH ROW
DECLARE old_config produto_config_typ;
BEGIN
  INSERT INTO produto_config_auditoria 
  VALUES (1, produto_config_typ(
      :old.produto_id,
      :old.base_de_calculo,
      :old.valor_minimo
      )
  );
END;

UPDATE produto_config_obj_table p SET p.base_de_calculo=10 WHERE p.produto_id=1;
SELECT * FROM produto_config_auditoria;



