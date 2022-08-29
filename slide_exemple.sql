

/*
  Estudo de Objeto-Relacional
  Exemplos do Slide
*/

--================= Exemplo implementação Oracle Slide =================--
  CREATE TYPE ENDERECO AS OBJECT (
    rua     VARCHAR2(20),
    cidade  VARCHAR2(10),
    estado  CHAR(2),
    cep     VARCHAR2(10)
  );

  CREATE TYPE FONE_LISTA AS 
    VARRAY(10) OF VARCHAR2(20)
  ;

  CREATE TYPE CLIENTE AS OBJECT (
    codigo    NUMBER,
    nome      VARCHAR2(200),
    endereco  ENDERECO,
    listaFone FONE_LISTA
  );

  CREATE TYPE ITEM_LISTA AS TABLE 
    OF ITEM
  ;

  CREATE TYPE PEDIDO AS OBJECT (
    codigo          NUMBER,
    cliente_ref     REF CLIENTE,
    data            DATE,
    dataEntrega     DATE,
    listaItens      ITEM_LISTA,
    enderecoEntrega ENDERECO
  );

  CREATE TYPE PRODUTO AS OBJECT (
    codigo  NUMBER,
    preco   NUMBER,
    taxa    NUMBER
  );

  CREATE TYPE ITEM AS OBJECT (
    codigo        NUMBER,
    produto_ref   REF PRODUTO,
    quantidade    NUMBER,
    desconto      NUMBER
  );
--================= END Implementação =================--

--======= Exemplo de tipo de objeto =======--
  -- Cria o object type
  CREATE TYPE person_typ AS OBJECT (
    idno        NUMBER,
    first_name  VARCHAR2(20),
    last_name   VARCHAR2(25),
    email       VARCHAR2(25),
    phone       VARCHAR2(20),
    MAP MEMBER FUNCTION get_idno RETURN NUMBER,
    MEMBER PROCEDURE display_details ( SELF IN OUT NOCOPY person_typ )
  );

  -- Define or implement the member methods defined in the object type specification1
  CREATE TYPE BODY person_typ AS 
    MAP MEMBER FUNCTION get_idno RETURN NUMBER IS
    BEGIN
      RETURN idno;
    END;
    MEMBER PROCEDURE display_details ( SELF IN OUT NOCOPY person_typ ) IS
    BEGIN
      -- use the PUT_LINE procedure of the DBMS_OUTPUT package to display details
      DBMS_OUTPUT.PUT_LINE(TO_CHAR(idno) || ' ' || first_name || ' ' || last_name);
      DBMS_OUTPUT.PUT_LINE(email || ' ' || phone);
    END;
  END;
--======= END Exemplo de tipo de objeto =======--





/* O Oracle suporta 2 tipos de tabelas:
 * - Tabela Relacional
 * - Tabela de Objetos (Object Table)
*/

--======= Tabela Relacional com um atributo de tipo de objeto =======--
  CREATE TABLE contacts (
    contact       person_typ,
    contact_date  DATE
  );

  INSERT INTO contacts VALUES (
    person_typ (65, 'Verna', 'Mills', 'vmills@example.com', '1-650-555-0125'),
    '24 Jun 2003'
  );

  SELECT * FROM contacts c;
  SELECT c.contact.get_idno() FROM contacts c;
--======= Tabela Relacional com um atributo de tipo de objeto =======--


--========== Tabela de Objetos ==========--
  CREATE TABLE person_obj_table OF person_typ;

  INSERT INTO person_obj_table VALUES (
    person_typ(101, 'John', 'Smith', 'jsmith@exemple.com', '1-650-555-0135')
  );
  INSERT INTO person_obj_table VALUES (
    person_typ(102, 'Joao', 'Silva', 'jsilva@exemple.com', '2-761-666-1246')
  );

  SELECT VALUE(p) FROM person_obj_table p WHERE p.last_name = 'Smith';
  SELECT VALUE(p) FROM person_obj_table p;
  SELECT * FROM person_obj_table p;

  DECLARE person person_typ;
  BEGIN 
    SELECT VALUE(p) INTO person FROM person_obj_table p WHERE p.idno = 101;
    person.display_details();
  END;
--========== END Tabela de Objetos ==========--

