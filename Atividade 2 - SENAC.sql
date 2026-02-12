use uc4atividades;

-- ETAPA 1
delimiter //

create procedure listaDeCompras (
    in p_cliente_id int,
    in p_data_inicial datetime,
    in p_data_final datetime
)
begin
    select 
        c.nome as Nome_Cliente,
        v.id as ID_Compra,
        sum(iv.subtotal) as Total_Compra,
        p.nome as Nome_Produto,
        iv.quantidade as Quantidade_Produto
    from 
        venda v 
	inner join
        cliente c on v.cliente_id = c.id
    inner join 
        item_venda iv on v.id = iv.venda_id
    inner join 
        produto p on iv.produto_id = p.id
    where 
        v.cliente_id = p_cliente_id
        and v.data between p_data_inicial and p_data_final
    group by 
        c.nome, v.id, p.nome, iv.quantidade;
end
//

delimiter ;

call listaDeCompras(1, '2020-01-01 00:00:00', '2024-12-31 23:59:59');

use uc4atividades;

-- ETAPA 2
delimiter //

create function ClassificarCliente (p_cliente_id int)
returns varchar(10)
deterministic
begin
    declare total_compras decimal(10,2);
    
    select sum(iv.subtotal) into total_compras
    from venda v
    inner join item_venda iv on v.id = iv.venda_id
    where v.cliente_id = p_cliente_id;
    
    if total_compras > 10000 then
        return 'PREMIUM';
    else
        return 'REGULAR';
    end if;
end
//

delimiter ;

SELECT ClassificarCliente(1);

use uc4atividades;

-- ETAPA 3
delimiter //

create trigger CriptografarSenha
before insert on usuario
for each row
begin
    set new.senha = md5(new.senha);
end
//

delimiter ;

insert into usuario (login, senha, ultimo_login) values ('novo_usuario', 'senha123', now());

select * from usuario where login = 'novo_usuario';
