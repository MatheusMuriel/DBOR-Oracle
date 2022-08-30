
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

-- Inserts do outro arquivo

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

SELECT ap.* FROM apolice_obj_table ap;
SELECT VALUE(ap) FROM apolice_obj_table ap;
SELECT ap.SEGURADO.ID FROM apolice_obj_table ap;
SELECT DEREF(ap.SEGURADO) FROM apolice_obj_table ap;
SELECT ap.* FROM apolice_obj_table ap WHERE ap.SEGURADO.ID = 14;

-------------------------------------------------------------------------------------------------------------------------
--------------------------------------------- Config e Auditoria --------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
--- Tabela composta de Auditoria
CREATE TYPE produto_config_typ AS OBJECT (
  produto_id      NUMBER,
  base_de_calculo NUMBER,
  valor_minimo    NUMBER,
  MAP MEMBER FUNCTION get_produto_id RETURN NUMBER
) FINAL;
CREATE TYPE BODY produto_config_typ AS
  MAP MEMBER FUNCTION get_produto_id RETURN NUMBER IS
  BEGIN
    RETURN produto_id;
  END;
END;

CREATE TABLE produto_config_obj_table OF produto_config_typ (
  produto_id PRIMARY KEY
);

-- Tabela relacional com atributo de objeto
CREATE TABLE produto_config_auditoria (
  data_alteracao    DATE,
  config_produto    produto_config_typ
);

CREATE OR REPLACE TRIGGER produto_config_update_trigger
AFTER UPDATE
  ON produto_config_obj_table
FOR EACH ROW
DECLARE old_config produto_config_typ;
BEGIN
  INSERT INTO produto_config_auditoria 
  VALUES (SYSDATE, produto_config_typ(
      :old.produto_id,
      :old.base_de_calculo,
      :old.valor_minimo
      )
  );
END;

-- Inserts do outro arquivo

SELECT pc.* FROM produto_config_obj_table pc;
SELECT * FROM produto_config_auditoria;
SELECT pc.* FROM produto_config_obj_table pc WHERE pc.produto_id=21;
UPDATE produto_config_obj_table p SET p.base_de_calculo=20 WHERE p.produto_id=21;
SELECT * FROM produto_config_auditoria;



