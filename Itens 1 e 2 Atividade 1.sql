create role 'relatorio', 'funcionario';

grant select on uc4atividades.* to 'relatorio';
flush privileges;

grant select, insert, update, delete on uc4atividades.venda to 'funcionario';
grant select, insert, update, delete on uc4atividades.cliente to 'funcionario';
grant select, insert, update, delete on uc4atividades.produto to 'funcionario';
flush privileges;

create user 'user_relatorio'@'localhost';
create user 'user_funcionario'@'localhost';

grant 'relatorio' to 'user_relatorio'@'localhost';
set default role 'relatorio' TO 'user_relatorio'@'localhost';
flush privileges;

grant 'funcionario' to 'user_funcionario'@'localhost';
set default role 'funcionario' to 'user_funcionario'@'localhost';
flush privileges;

select * from mysql.user;