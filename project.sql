
--DROP TYPE person_typ;
CREATE TYPE person_typ AS OBJECT (
  id        NUMBER,
  nome      VARCHAR2(20),
  cpf       NUMBER
  --MAP MEMBER FUNCTION get_idno RETURN NUMBER,
  --MEMBER PROCEDURE display_details ( SELF IN OUT NOCOPY person_typ )
) NOT FINAL;

--DROP TYPE corretor_typ;
CREATE TYPE corretor_typ UNDER person_typ (
  corretora   VARCHAR2(20)
) FINAL;

--DROP TYPE segurado_typ;
CREATE TYPE segurado_typ UNDER person_typ (
  limite      NUMBER
) FINAL;

--DROP TABLE person_obj_table;
CREATE TABLE person_obj_table OF person_typ;


INSERT INTO person_obj_table VALUES (
  person_typ(1,'Joao Silva',123)
);
INSERT INTO person_obj_table VALUES (
  corretor_typ(2,'Gustavo Santos',234,'Corretora1')
);
INSERT INTO person_obj_table VALUES (
  segurado_typ(3,'Augusto',345,1000)
);

SELECT VALUE(p) FROM person_obj_table p;


-------------------
CREATE TYPE item_typ AS OBJECT (
  coordenada    NUMBER,
  produto       VARCHAR2(10),
  valor         NUMBER
)

CREATE TYPE apolice_typ AS OBJECT (
  id              NUMBER,
  listaItens      VARRAY,
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
