
-- consulta original de vendas pagas no dinheiro:
explain select * 
from venda v, item_venda iv, produto p, cliente c, funcionario f
where v.id = iv.venda_id and c.id = v.cliente_id and p.id = iv.produto_id and f.id = v.funcionario_id 
and tipo_pagamento = 'd';

-- consulta otimizada:
create index idx_venda_tipo_pagamento on venda(tipo_pagamento);
create index idx_data_envio on venda(data_envio);

explain select 
    v.data_envio, 
    v.valor_total, 
    p.nome as produto, 
    iv.quantidade, 
    iv.valor_unitario, 
    c.nome as cliente, 
    c.cpf, 
    c.telefone 
from  
    venda v
    join item_venda iv on v.id = iv.venda_id
    join produto p on p.id = iv.produto_id
    join cliente c on c.id = v.cliente_id
    join funcionario f on f.id = v.funcionario_id
where 
    v.tipo_pagamento = 'd'
order by 
    v.data_envio desc;


-- consulta original de vendas de produto de fabricante especifico:
explain select * 
from produto p, item_venda iv, venda v
where p.id = iv.produto_id and v.id = iv.venda_id and p.fabricante like '%lar%';

-- consulta otimizada:
create index idx_produto_fabricante on produto(fabricante);

explain select 
    p.nome as produto, 
    iv.quantidade, 
    v.data_envio
from 
    produto p
    join item_venda iv on p.id = iv.produto_id
    join venda v on v.id = iv.venda_id
where
    p.fabricante like '%lar%'
order by 
    p.nome;


-- consulta original de vendas de produto por cliente:
explain select sum(iv.subtotal), sum(iv.quantidade)
from produto p, item_venda iv, venda v, cliente c
where p.id = iv.produto_id and v.id = iv.venda_id and c.id = v.cliente_id
group by c.nome, p.nome;

-- consulta otimizada:
create index idx_cliente_nome on cliente(nome);
create index idx_produto_nome on produto(nome);

explain select 
    c.nome as cliente, 
    p.nome as produto, 
    sum(iv.subtotal) as total_vendido, 
    sum(iv.quantidade) as total_quantidade 
from 
    cliente c
    join venda v on c.id = v.cliente_id
    join item_venda iv on v.id = iv.venda_id
    join produto p on p.id = iv.produto_id
group by 
    c.nome, p.nome;


