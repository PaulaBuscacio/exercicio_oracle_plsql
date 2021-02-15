-- tabelas, sequences e  triggers por paula buscacio

----------------------------------------------- tabelas ------------------------------------------------------------------

-- tabela funcionario --------------------------------------------------------------------------------------------------
create table "func" (
	"id_func" number(2) not null,
	"nome_func" varchar2(50) not null,
	"data_nas" date,
	"cpf" number(11) unique not null,
	"identidade" number(12),
	"endereco" varchar2(500),
	"data_adm" date,
	"home_office" varchar2(1),
	"total_pontos" number(3),
	"salario" number(9),
	"status" varchar2(1),
	"id_dept" number(2));

alter table func add constraint pk_func primary key(id_func);
alter table func add constraint fk_id_dept foreign key(id_dept) references dept(id_dept);
alter table func add constraint check_home_office check (home_office in ('s', 'n'));
alter table func add constraint check_status check (status in ('s', 'n'));

-- tabela departamento ----------------------------------------------------------------------------------------------
create table "dept" (
	"id_dept" number(2) not null,
	"nome_dept" varchar2(50) not null,
	"loc_dept" varchar2(30),
	"id_responsavel" number(2));

alter table dept add constraint pk_dept primary key(id_dept);

-- tabela beneficios ----------------------------------------------------------------------------------------------------
create table "beneficios" (
	"id_beneficio" number(1) not null,
	"nome_beneficio" varchar2(20) not null,
	"pontos_beneficio" number(2));

alter table beneficios add constraint pk_benecicios primary key(id_beneficio);

-- tabela funcionario e beneficios ---------------------------------------------------------------------------------
create table "fun_ben" (
	"id_func" number not null,
	"id_ben" number not null);

alter table fun_ben add constraint fk_id_func foreign key(id_func) references func(id_func);
alter table fun_ben add constraint fk_id_beneficio foreign key(id_ben) references beneficios(id_beneficio);

-- tabela de log dept_log ------------------------------------------------------------------------------------------
create table dept_log (
            id_dept_log number(4),
            id_dept number(2),
            tipo_alteracao varchar2(1),
            data_alteracao date,
            nome_dept varchar2(50),  
            loc_dept  varchar2(30),          
            id_responsavel number(2));        

alter table dept_log add constraint pk_dept_log primary key(id_dept_log);

-- tabela de log func_log ---------------------------------------------------------------------------------------------
create table func_log (
   	id_log_func number(3) not null, 
	id_func number(2), 
	tipo_alteracao varchar2(1), 
	data_alteracao date, 
	nome_func varchar2(50), 
	data_nasc date, 
	cpf number(11), 
	identidade number(12), 
	endereco varchar2(500), 
	id_dept number(2), 
	data_adm date, 
	data_des date, 
	home_office varchar2(1), 
	beneficio number(1), 
	total_pontos  number(3), 
	salario number(9), 
	status varchar2(1));

	alter table func_log add constraint pk_func_log"primary key (id_log_func);


-------------------------------------------------- sequences ------------------------------------------------------------

-- sequence tabela departamento ---------------------------------------------------------------------------------
create sequence seq_dept
minvalue 1
maxvalue 99999
start with 1
increment by 1; 

-- sequence da tabela funcionario ---------------------------------------------------------------------------------
create sequence seq_func
minvalue 1
maxvalue 99999
start with 1
increment by 1; 

-- sequence da tabela beneficios ----------------------------------------------------------------------------------
create sequence seq_ben
minvalue 1
maxvalue 99999
start with 1
increment by 1; 

-- sequence da tabela log_dept ------------------------------------------------------------------------------------
create sequence seq_log_dept
minvalue 1
maxvalue 99999
start with 1
increment by 1; 

-- sequence da tabela func_log -------------------------------------------------------------------------------------
create sequence seq_func_log
minvalue 1
maxvalue 99999
start with 1
increment by 1; 

--------------------------------------------------- triggers ---------------------------------------------------------------
-- trigger que atualiza total_pontos em func ------------------------------------------------------------------------------
create or replace noneditionable trigger t_beneficio after
    insert or update or delete on fun_ben
    for each row
declare
    v_total_pontos   number;
    v_soma           number;
    total_pontos     number;
begin

    if inserting or updating then
        select
            pontos_beneficio
        into v_total_pontos
        from
            beneficios
        where
            id_beneficio = :new.id_ben;

        select
            total_pontos
        into v_soma
        from
            func
        where
            id_func = :new.id_func;

        if (v_total_pontos + v_soma)  > 100 then
          raise_application_error(-20999, 'não foi possível incluir o beneficio');


        else
         update func
            set
                total_pontos = total_pontos + v_total_pontos
            where
                id_func = :new.id_func;

        end if;

    else
        select
            pontos_beneficio
        into v_total_pontos
        from
            beneficios
        where
            id_beneficio = :old.id_ben;

        update func
        set
            total_pontos = total_pontos - v_total_pontos
        where
            id_func = :old.id_func;

    end if;

end t_beneficio;

-- trigger de log das alterações na tabela de funcionarios -------------------------------------------------------------------
create or replace trigger log_func1
after insert or update or delete on func
for each row
declare
v_tipo_alteracao varchar2(1);
begin

if inserting then
    v_tipo_alteracao := 'i';
    insert into func_log1
        (id_log_func,
        id_func,
        tipo_alteracao,
        data_alteracao,
        nome_func,  
        data_nasc,          
        cpf,    
        identidade,   
        endereco, 
        id_dept,     
        data_adm,          
        data_des,          
        home_office,          
        total_pontos,     
        salario,   
        status)
        values
        (seq_log_func1.nextval,
        :old.id_func,
        v_tipo_alteracao,
         sysdate,
        :new.nome_func,  
        :new.data_nasc,          
        :new.cpf,    
        :new.identidade,   
        :new.endereco, 
        :new.id_dept,     
        :new.data_adm,          
        :new.data_des,          
        :new.home_office,          
        :new.total_pontos,     
        :new.salario,   
        :new.status);
elsif updating then
v_tipo_alteracao := 'u';
         insert into func_log1
        (id_log_func,
        id_func,
        tipo_alteracao,
        data_alteracao,
        nome_func,  
        data_nasc,          
        cpf,    
        identidade,   
        endereco, 
        id_dept,     
        data_adm,          
        data_des,          
        home_office,           
        total_pontos,     
        salario,   
        status)
        values
        (seq_log_func1.nextval,
        :old.id_func,
        v_tipo_alteracao,
        sysdate,
        :new.nome_func,  
        :new.data_nasc,          
        :new.cpf,    
        :new.identidade,   
        :new.endereco, 
        :new.id_dept,     
        :new.data_adm,          
        :new.data_des,          
        :new.home_office,     
        :new.total_pontos,     
        :new.salario,   
        :new.status);
elsif deleting then
v_tipo_alteracao := 'd';
        insert into func_log1
        (id_log_func,
         id_func,
        tipo_alteracao,
        data_alteracao,
        nome_func,  
        data_nasc,          
        cpf,    
        identidade,   
        endereco, 
        id_dept,     
        data_adm,          
        data_des,          
        home_office,              
        total_pontos,     
        salario,   
        status)
        values
        (seq_log_func1.nextval,
        :old.id_func,
        v_tipo_alteracao,
         sysdate,
        :old.nome_func,  
        :old.data_nasc,          
        :old.cpf,    
        :old.identidade,   
        :old.endereco, 
        :old.id_dept,     
        :old.data_adm,          
        :old.data_des,          
        :old.home_office,      
        :old.total_pontos,     
        :old.salario,   
        :old.status);
end if;

end log_func1;

