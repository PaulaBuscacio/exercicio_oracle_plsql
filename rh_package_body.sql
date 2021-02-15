--------------------------------------------------------
--  Arquivo criado - Segunda-feira-Fevereiro-15-2021   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body RH_PACKAGE
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "PAULADB"."RH_PACKAGE" as

--- procedure que recebe campos da tabela funcionário, menos o id (incrementável na sequência) e o total_pontos (preenchido por um trigger), e insere ou atualiza (se o cpf já existir) dados na tabela de funcionarios
procedure insere_func(p_nome_func   in   func.nome_func%type,
                      p_data_nasc   in   func.data_nasc%type,
                      p_cpf         in   func.cpf%type,
                      p_identidade  in   func.identidade%type,
                      p_endereco    in   func.endereco%type,
                      p_id_dept     in   func.id_dept%type,
                      p_data_adm    in   func.data_adm%type,
                      p_data_des    in   func.data_des%type,
                      p_home_office in   func.home_office%type,
                      p_salario     in   func.salario%type,                       
                      p_status      in func.status%type)
    is
    begin
     begin
       insert into func(id_func, nome_func, data_nasc, cpf, identidade, endereco, id_dept, data_adm, data_des, home_office, status)
       values (seq_func.nextval, p_nome_func, p_data_nasc, p_cpf, p_identidade, p_endereco, p_id_dept, p_data_adm, p_data_des, p_home_office, p_status);
     exception
       when dup_val_on_index then
       update func set nome_func = p_nome_func, data_nasc = p_data_nasc, identidade = p_identidade, endereco = p_endereco, id_dept = p_id_dept, data_adm = p_data_adm, data_des = p_data_des, home_office = p_home_office, status = p_status 
       where cpf = p_cpf;
    end; 
end insere_func;

-- procedure que deleta um funcionario
procedure delete_func(n_id_func   in   func.id_func%type)                                           
is
 begin
    delete from func where id_func = n_id_func;

end delete_func;

-- procedure que recebe o id do funcionario e retorna nome do funcionário, da tabela funcionario, e nome do departamento da tabela de departamentos
procedure n_dept (v_id_func   in  func.id_func%type,
                  v_nome      out func.nome_func%type,
                  v_nome_dept out dept.nome_dept%type)
    is
    begin
       select f.nome_func, d.nome_dept
       into
       v_nome, v_nome_dept
       from func f, dept d
       where  f.id_func = v_id_func and f.id_dept = d.id_dept;
end n_dept;    

--- procedure que recebe campos da tabela de departamentos, menos o id (incrementável na sequência)  e insere dados na tabela de departamentos
 procedure insere_dept(p_nome_dept      in dept.nome_dept%type, 
                       p_loc_dept       in dept.loc_dept%type, 
                       p_id_responsavel in dept.id_dept%type)
    is
    begin

        insert into dept (id_dept, nome_dept, loc_dept, id_responsavel) 
        values (seq_dept.nextval, p_nome_dept, p_loc_dept, p_id_responsavel);

end  insere_dept;

-- procedure que recebe todos os campos da tabela de departamentos e atualiza conforme o id
procedure atualiza_dept( p_id_dept        in dept.id_dept%type,
                         p_nome_dept      in dept.nome_dept%type, 
                         p_loc_dept       in dept.loc_dept%type, 
                         p_id_responsavel in dept.id_dept%type)
    is
    begin
         update dept set nome_dept = p_nome_dept, loc_dept = p_loc_dept, id_responsavel = p_id_responsavel
         where id_dept =  p_id_dept ;
end  atualiza_dept;

-- procedure que deleta um departamento
procedure delete_dept(n_id_dept   in   dept.id_dept%type)                                           
is
 begin
    delete from dept where id_dept = n_id_dept;

end delete_dept;

--- procedure que recebe campos da tabela de beneficio, menos o id (incrementável na sequência) e insere dados na tabela de beneficios
procedure insere_ben (n_nome_beneficio   in beneficios.nome_beneficio%type,
                                        n_pontos_beneficio in beneficios.pontos_beneficio%type)

is
  begin
    insert into beneficios (id_beneficio, nome_beneficio, pontos_beneficio) 
        values (seq_ben.nextval, n_nome_beneficio, n_pontos_beneficio);
end insere_ben;

-- procedure que recebe todos os campos da tabela beneficios e atualiza conforme o id
procedure atualiza_ben( p_id_beneficio     in beneficios.id_beneficio%type,
                        p_nome_beneficio   in beneficios.nome_beneficio%type,
                        p_pontos_beneficio in beneficios.pontos_beneficio%type)
is
 begin
      update beneficios set nome_beneficio = p_nome_beneficio, pontos_beneficio = p_pontos_beneficio
      where  id_beneficio = p_id_beneficio;
end atualiza_ben;

-- procedure que recebe o id do beneficio e deleta o beneficio
procedure delete_ben(n_id_beneficio   in   beneficios.id_beneficio%type)                                           
is
 begin
    delete from beneficios where id_beneficio = n_id_beneficio;

end delete_ben;

-- procedure que recebe o id do funcionario e o id do beneficio e insere na tabela fun_ben
procedure insere_fun_ben(n_id_func   in   fun_ben.id_func%type,
                         n_id_ben    in  fun_ben.id_ben%type)
    is
     begin
       insert into fun_ben(id_func, id_ben)
       values (n_id_func, n_id_ben);

end insere_fun_ben;

-- procedure que recebe o id do funcionario e o id do beneficio e deleta o beneficio do funcionario
procedure delete_fun_ben(n_id_func   in   fun_ben.id_func%type,
                         n_id_ben    in  fun_ben.id_ben%type)
    is
     begin
        delete from fun_ben where id_func = n_id_func and id_ben =  n_id_ben;  


end delete_fun_ben;

-- function que recebe o id do funcionario e retorna o valor total de beneficios do funcionario
function total_ben(v_id_func number)
return number
is
v_total_pontos number;
begin
    select f.total_pontos
    into v_total_pontos
    from func f
    where f.id_func = v_id_func;
    return v_total_pontos;
end total_ben;

-- function que recebe o id do departamento e retorna a média salarial do departamento
function media_dept_sal(d_id_dept number)
return number
is
media_dept number;
begin
    select avg(f.salario) 
    into media_dept
    from func f
    where f.id_dept = d_id_dept;

    return media_dept;
end media_dept_sal;

-- function que retorna o menor salario da empresa
function menor_sal
return number
is
v_menor_salario number;
begin
    select min(f.salario) 
    into v_menor_salario
    from func f
    where f.salario = salario;

    return v_menor_salario;
end menor_sal;

-- function que retorna o maior salario da empresa
function maior_sal
return number
is
v_maior_salario number;
begin
    select max(f.salario) 
    into v_maior_salario
    from func f
    where f.salario = salario;

    return v_maior_salario;
end maior_sal;

-- function que retorna o tempo de casa do funcionario ativo
function devolve_tempo_func(v_id_func number)
return varchar2
is

tempo_func varchar2(3);

begin

  select trunc(months_Between(sysdate, f.data_adm),0)
    into tempo_func
    from func f
    where f.id_func = v_id_func and f.status = 's';
    return tempo_func;

    exception
    when others then
   return 'Funcionario inexistente ou com status inativo ou nulo';

  end devolve_tempo_func;


end rh_package;

/
