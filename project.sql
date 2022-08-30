
CREATE TYPE person_typ AS OBJECT (
  id        NUMBER,
  nome      VARCHAR2(20),
  cpf       NUMBER
  --MAP MEMBER FUNCTION get_idno RETURN NUMBER,
  --MEMBER PROCEDURE display_details ( SELF IN OUT NOCOPY person_typ )
) NOT FINAL;

CREATE TYPE corretor_typ UNDER person_typ (
  corretora   VARCHAR2(20)
) FINAL;

CREATE TYPE segurado_typ UNDER person_typ (
  limite      NUMBER
) FINAL;

CREATE TABLE person_obj_table OF person_typ (
  id PRIMARY KEY,
  cpf UNIQUE
);


INSERT INTO person_obj_table VALUES (person_typ(1,'Joao Silva',123));
INSERT INTO person_obj_table VALUES (corretor_typ(2,'Gustavo Santos',234,'Corretora1'));
INSERT INTO person_obj_table VALUES (segurado_typ(3,'Augusto',345,1000));

SELECT VALUE(p) FROM person_obj_table p;


-------------------
CREATE TYPE item_typ AS OBJECT (
  coordenada    NUMBER,
  produto       VARCHAR2(10),
  valor         NUMBER
)

CREATE TYPE item_array AS 
  VARRAY(10) OF item_typ
;

CREATE TYPE apolice_typ AS OBJECT (
  id              NUMBER,
  listaItens      item_array,
  valor           NUMBER,
  segurado        SEGURADO_TYP,
  corretor        CORRETOR_TYP,
  dataEfetivacao  DATE,
  status          VARCHAR2(1)
) NOT FINAL;

CREATE TYPE proposta_typ UNDER apolice_typ (
  valorBoleto       NUMBER,
  vencimentoBoleto  DATE
) NOT FINAL;

CREATE TYPE cotacao_typ UNDER proposta_typ (
  dataCotacao       DATE
)

CREATE TABLE apolice_obj_table OF apolice_typ;


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



