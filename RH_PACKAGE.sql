--------------------------------------------------------
--  Arquivo criado - Segunda-feira-Fevereiro-15-2021   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package RH_PACKAGE
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "PAULADB"."RH_PACKAGE" is

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
                      p_status      in func.status%type);


-- procedure que deleta um funcionario
procedure delete_func(n_id_func   in   func.id_func%type);                                           

-- procedure que recebe o id do funcionario e retorna nome do funcionário, da tabela funcionario, e nome do departamento da tabela de departamentos
procedure n_dept (v_id_func   in  func.id_func%type,
                  v_nome      out func.nome_func%type,
                  v_nome_dept out dept.nome_dept%type);

--- procedure que recebe campos da tabela de departamentos, menos o id (incrementável na sequência)  e insere dados na tabela de departamentos
 procedure insere_dept(p_nome_dept      in dept.nome_dept%type, 
                       p_loc_dept       in dept.loc_dept%type, 
                       p_id_responsavel in dept.id_dept%type);

-- procedure que recebe todos os campos da tabela de departamentos e atualiza conforme o id
procedure atualiza_dept( p_id_dept        in dept.id_dept%type,
                         p_nome_dept      in dept.nome_dept%type, 
                         p_loc_dept       in dept.loc_dept%type, 
                         p_id_responsavel in dept.id_dept%type);

-- procedure que deleta um departamento
procedure delete_dept(n_id_dept   in   dept.id_dept%type);                                           

--- procedure que recebe campos da tabela de beneficios, menos o id (incrementável na sequência) e insere dados na tabela de beneficios
procedure insere_ben (n_nome_beneficio   in beneficios.nome_beneficio%type,
                      n_pontos_beneficio in beneficios.pontos_beneficio%type);

-- procedure que recebe todos os campos da tabela beneficios e atualiza conforme o id
procedure atualiza_ben( p_id_beneficio     in beneficios.id_beneficio%type,
                        p_nome_beneficio   in beneficios.nome_beneficio%type,
                        p_pontos_beneficio in beneficios.pontos_beneficio%type);

-- procedure que recebe o id do beneficio e deleta o beneficio
procedure delete_ben(n_id_beneficio   in   beneficios.id_beneficio%type);                                           

-- procedure que recebe o id do funcionario e o id do beneficio e insere na tabela fun_ben
procedure insere_fun_ben(n_id_func   in   fun_ben.id_func%type,
                         n_id_ben    in  fun_ben.id_ben%type);

-- procedure que recebe o id do funcionario e o id do beneficio e deleta o beneficio do funcionario
procedure delete_fun_ben(n_id_func   in   fun_ben.id_func%type,
                         n_id_ben    in  fun_ben.id_ben%type);

-- function que recebe o id do funcionario e retorna o valor total de beneficios do funcionario
function total_ben(v_id_func number)
return number;

-- function que recebe o id do departamento e retorna a média salarial do departamento
function media_dept_sal(d_id_dept number)
return number;

-- function que retorna o menor salario da empresa
function menor_sal
return number;

-- function que retorna o maior salario da empresa
function maior_sal
return number;

-- function que retorna o tempo de casa do funcionario ativo
function devolve_tempo_func(v_id_func number)
return varchar2;

end rh_package;

/
