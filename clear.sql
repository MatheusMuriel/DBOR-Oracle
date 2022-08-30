

-- Drop all defined to restart environment

-- Drop trigger
DROP TRIGGER produto_config_update_trigger;

-- Drop tables
DROP TABLE person_obj_table;
DROP TABLE apolice_obj_table;
DROP TABLE produto_config_obj_table;
DROP TABLE produto_config_auditoria;

-- Drop types

DROP TYPE pessoa_typ;
DROP TYPE corretor_typ;
DROP TYPE segurado_typ;

DROP TYPE item_array;
DROP TYPE item_typ;
DROP TYPE apolice_typ;
DROP TYPE proposta_typ;
DROP TYPE cotacao_typ;

DROP TYPE produto_config_typ;

