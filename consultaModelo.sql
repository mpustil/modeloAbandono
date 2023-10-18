CREATE TABLE negocio.modelo1(
    persona int4 PRIMARY KEY,
    apellido VARCHAR (60) NOT NULL,
    fechanacimiento date not null,
    Edad int2 not null,
    sexo bpchar(1) ,
	nacionalidad int2,
    email VARCHAR (100) ,
    cant_eval_m3 int2,
    cant_eval_m2 int2,
    cant_eval_m1 int2,
    cant_eval_m0 int2,
    censo_cant_meses int4,
    censo_estado_civil int2,
    censo_unido_hecho bpchar(1) ,
    censo_situacion_padre bpchar(1) ,
    censo_situacion_madre bpchar(1) ,
    censo_cantidad_hijos int4,
    censo_cantidad_familia int4,
    censo_turno_preferido int4,
    censo_cobertura_salud int4,
    censo_tipo_vivienda int4,
    censo_vive_con int4,
    censo_celiaco bpchar(1) ,
    censo_calle VARCHAR (50), 
    censo_piso VARCHAR (3), 
    censo_localidad int4,
    censo_barrio VARCHAR (50), 
    censo_cp VARCHAR (15), 
    censo_cursada_calle VARCHAR (50), 
    censo_cursada_piso VARCHAR (3), 
    censo_cursada_localidad int4,
    censo_cursada_barrio VARCHAR (50), 
    censo_cursada_cp VARCHAR (15) ,
    Cant_Becas int4,
    Cant_HsSemTrabajo int4
);


insert into modelo1
select PER.persona, PER.apellido, PER.fecha_nacimiento, EXTRACT(YEAR from age(PER.fecha_nacimiento)) Edad, PER.sexo, PER.nacionalidad, 
(select   substring(PERCON.email,position('@' in PERCON.email)+1)  from negocio.mdp_personas_contactos PERCON where not(PERCON.email is null) and PERCON.persona = PER.persona limit 1) as email,
(select   count(ALU.persona) from negocio.sga_eval_detalle_cursadas SEDC 
	inner join negocio.sga_alumnos ALU on SEDC.alumno = ALU.alumno 
	inner join negocio.sga_planes_versiones SPV on SEDC.plan_version = SPV.plan_version 
	where SEDC.ultimo_cambio >= '20200101' and  SEDC.ultimo_cambio < '20200801'
	and ALU.Persona  = PER.Persona group by ALU.persona) as cant_eval_2020C1,
(select   count(ALU.persona) from negocio.sga_eval_detalle_cursadas SEDC 
	inner join negocio.sga_alumnos ALU on SEDC.alumno = ALU.alumno 
	inner join negocio.sga_planes_versiones SPV on SEDC.plan_version = SPV.plan_version 
	where SEDC.ultimo_cambio >= '20200801' and  SEDC.ultimo_cambio < '20201231'
	and ALU.Persona  = PER.Persona group by ALU.persona) as cant_eval_2020C2,
(select   count(ALU.persona) from negocio.sga_eval_detalle_cursadas SEDC 
	inner join negocio.sga_alumnos ALU on SEDC.alumno = ALU.alumno 
	inner join negocio.sga_planes_versiones SPV on SEDC.plan_version = SPV.plan_version 
	where SEDC.ultimo_cambio >= '20210101' and  SEDC.ultimo_cambio < '20210801'
	and ALU.Persona  = PER.Persona group by ALU.persona) as cant_eval_2021C1,
(select   count(ALU.persona) from negocio.sga_eval_detalle_cursadas SEDC 
	inner join negocio.sga_alumnos ALU on SEDC.alumno = ALU.alumno 
	inner join negocio.sga_planes_versiones SPV on SEDC.plan_version = SPV.plan_version 
	where  SEDC.ultimo_cambio >= '20210801' and  SEDC.ultimo_cambio < '20211231'
	and ALU.Persona  = PER.Persona group by ALU.persona) as cant_eval_2021C2,	
--MDC.fecha_relevamiento censo_fecha_alta, 
--MDC.fecha_actualizacion censo_fecha_actualizacion
	EXTRACT(YEAR from age(MDC.fecha_actualizacion))*12+EXTRACT(MONTH from age(MDC.fecha_actualizacion)) meses_censo,
MDP.estado_civil  censo_estado_civil, MDP.unido_hecho censo_unido_hecho, 
MDP.situacion_padre censo_situacion_padre, MDP.situacion_madre censo_situacion_madre, MDP.cantidad_hijos censo_cantidad_hijos, MDP.cantidad_familia censo_cantidad_familia,
MDP.turno_preferido censo_turno_preferido, MDP.cobertura_salud censo_cobertura_salud, MDP.tipo_vivienda censo_tipo_vivienda, MDP.vive_con censo_vive_con,
MDP.es_celiaco censo_celiaco,
MDP.procedencia_calle censo_calle, MDP.procedencia_piso censo_piso, MDP.procedencia_localidad censo_localidad, 
MDP.procedencia_barrio censo_barrio, MDP.procedencia_codigo_postal censo_cp,
MDP.periodo_lectivo_calle censo_cursada_calle, MDP.periodo_lectivo_piso censo_cursada_piso, MDP.periodo_lectivo_localidad censo_cursada_localidad, 
MDP.periodo_lectivo_barrio censo_cursada_barrio, MDP.periodo_lectivo_codigo_postal censo_cursada_cp ,
case when coalesce(MDE.beca,'N') = 'N' then 0 else 1 end +
case when coalesce(MDE.beca_fuente_universidad,'N') = 'N' then 0 else 1 end +
case when coalesce(MDE.beca_fuente_nacional,'N') = 'N' then 0 else 1 end +
case when coalesce(MDE.beca_fuente_provincial,'N') = 'N' then 0 else 1 end +
case when coalesce(MDE.beca_fuente_municipal,'N') = 'N' then 0 else 1 end +
case when coalesce(MDE.beca_fuente_internacional,'N') = 'N' then 0 else 1 end +
case when coalesce(MDE.beca_fuente_otra,'N') = 'N' then 0 else 1 end +
case when coalesce(MDE.beca_tipo_economica,'N') = 'N' then 0 else 1 end +
case when coalesce(MDE.beca_tipo_servicios,'N') = 'N' then 0 else 1 end +
case when coalesce(MDE.beca_tipo_investigacion,'N') = 'N' then 0 else 1 end +
case when coalesce(MDE.beca_economica_transporte,'N') = 'N' then 0 else 1 end +
case when coalesce(MDE.beca_economica_efectivo,'N') = 'N' then 0 else 1 end +
case when coalesce(MDE.beca_economica_fotocopias,'N') = 'N' then 0 else 1 end +
case when coalesce(MDE.beca_economica_efectivo,'N') = 'N' then 0 else 1 end +
case when coalesce(MDE.beca_economica_habitacional,'N') = 'N' then 0 else 1 end +
case when coalesce(MDE.beca_economica_comedor,'N') = 'N' then 0 else 1 end as CantBecas,
coalesce(MDE.trabajo_hora_sem, 0) as CantHsSemTrabajo
from negocio.mdp_personas PER
left join mdp_datos_censales MDC on PER.persona = MDC.persona
left join mdp_datos_personales MDP on MDC.dato_censal = MDP.dato_censal 
left join mdp_datos_economicos MDE on MDC.dato_censal = MDE.dato_censal 
where PER.persona in 
(select  ALU.persona from negocio.sga_eval_detalle_cursadas SEDC 
	inner join negocio.sga_alumnos ALU on SEDC.alumno = ALU.alumno 
	inner join negocio.sga_planes_versiones SPV on SEDC.plan_version = SPV.plan_version 
		-- que alguna vez haya sido alumno de sistemas...  plan 21 es el curso de ingreso
	where  SEDC.ultimo_cambio >= '20190101' and  SEDC.ultimo_cambio < '20211231'
	and ALU.Persona  = PER.Persona)
--agregar que traiga solo alumnos con algun parcial rendido  (al menos antes del periodo)
--SPV.plan in (23,42);
	
	
	--datos faltantes
update modelo1 set cant_eval_m3 = 0 where cant_eval_m3 is null;
update modelo1 set cant_eval_m2 = 0 where cant_eval_m2 is null;
update modelo1 set cant_eval_m1 = 0 where cant_eval_m1 is null;
update modelo1 set cant_eval_m0 = 0 where cant_eval_m0 is null;

   

--select censo_piso from modelo1 group by censo_piso

 -- convertir otras var a numerica, como el sexo
-- ponemos id negativos distintos cuando no hay datos, para que no correlacionen los ceros(0) entre si
update modelo1 set Edad = 0 where Edad is null;  --deberia ser la media...
update modelo1 set censo_cant_meses = 255 where censo_cant_meses is null;
update modelo1 set censo_turno_preferido = 0 where censo_turno_preferido is null;  -- +infinito
update modelo1 set censo_estado_civil = 0 where censo_estado_civil is null;
update modelo1 set censo_cantidad_hijos = 0 where censo_cantidad_hijos is null;  --deberia ser la media...  pero es 0,7...
update modelo1 set censo_cantidad_familia = 0 where censo_cantidad_familia is null;  --deberia ser la media...
update modelo1 set censo_cobertura_salud = -1 where censo_cobertura_salud is null;
update modelo1 set censo_tipo_vivienda = -2 where censo_tipo_vivienda is null;
update modelo1 set censo_vive_con = -3 where censo_vive_con is null;
update modelo1 set censo_localidad = -4 where censo_localidad is null;
update modelo1 set censo_localidad = -4 where censo_localidad > 10000;
update modelo1 set censo_cursada_localidad = -4 where censo_cursada_localidad is null;
update modelo1 set censo_cursada_localidad = -4 where censo_cursada_localidad > 10000;
update modelo1 set censo_cursada_cp = -5 where censo_cursada_cp is null;
update modelo1 set censo_cp = -5 where censo_cursada_cp is null;

--clase: cant_eval_m0

update modelo1 set cant_eval_m0 = 1 where cant_eval_m0 > 0;
