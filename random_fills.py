import json
from random import randrange, uniform

def gerar_pessoas():
  f = open('pessoas.json')
  data = json.load(f)

  for i in range(25):
    id = i+1
    nome = data[i]['nome']
    cpf = data[i]['cpf']
    corretora = data[i]['cidade']
    sql_prefix='INSERT INTO pessoa_obj_table VALUES (corretor_typ('
    sql_dados=f'{id},\'{nome}\', {cpf}, \'{corretora}\''
    sql_posfix='));'
    print(f'{sql_prefix}{sql_dados}{sql_posfix}')
  #

  for i in range(25, 50):
    id = i+1
    nome = data[i]['nome']
    cpf = data[i]['cpf']
    limite = randrange(1000,100000)
    sql_prefix='INSERT INTO pessoa_obj_table VALUES (segurado_typ('
    sql_dados=f'{id},\'{nome}\', {cpf}, {limite}'
    sql_posfix='));'
    print(f'{sql_prefix}{sql_dados}{sql_posfix}')
  #

  for i in range(50,60):
    id = i+1
    nome = data[i]['nome']
    cpf = data[i]['cpf']
    sql_prefix='INSERT INTO pessoa_obj_table VALUES (pessoa_typ('
    sql_dados=f'{id},\'{nome}\', {cpf}'
    sql_posfix='));'
    print(f'{sql_prefix}{sql_dados}{sql_posfix}')

  f.close()
###

def gerar_itens(quant_a_gerar):
  list_items = ['Café','Soja','Trigo','Laranja','Maça','Milho','Cana','Feijão']
  for i in range(quant_a_gerar):
    ido = randrange(1000,10000)
    itens = []
    valor_total = 0
    for j in range(randrange(1,11)):
      latitude = "{0:0=2d}".format(randrange(1000))
      longitude = "{0:0=2d}".format(randrange(1000))
      item_name = list_items[randrange(len(list_items))]
      valor = randrange(100000,1000000)/100.0
      valor_total = valor_total + valor
      str_item = f'item_typ({latitude},{longitude},\'{item_name}\',{valor})'
      itens.append(str_item)
    valor_total = round(valor_total,2)
    ps_id = randrange(1,26)
    pc_id = randrange(26,51)
    print(f'INSERT INTO apolice_obj_table SELECT {ido}, item_array({",".join(i for i in itens)}), {valor_total}, ref(ps), ref(pc), SYSDATE, \'A\' FROM pessoa_obj_table ps, pessoa_obj_table pc WHERE ps.ID={ps_id} AND pc.ID={pc_id};')
###

def gerar_item_config(quant_config):
  ids = list(range(1,quant_config+1))
  for i in range(quant_config):
    ido = ids.pop(randrange(len(ids)))
    base_de_calculo = (randrange(1,100)*100)/100.00
    valor_minimo = (randrange(1,1000)*100)/100.00
    print(f'INSERT INTO produto_config_obj_table VALUES (produto_config_typ({ido},{base_de_calculo},{valor_minimo}));')
###


#gerar_pessoas()
#gerar_itens(quant_a_gerar=150)
#gerar_item_config(quant_config=25)
