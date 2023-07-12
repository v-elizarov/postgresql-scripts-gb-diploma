BEGIN;

CREATE TABLE IF NOT EXISTS public.transaction
(
    "ID" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    event_id integer NOT NULL,
    collector_id integer NOT NULL,
    user_id integer NOT NULL,
    operation_type boolean NOT NULL,
    amount bigint NOT NULL DEFAULT 0,
    operation_date date NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT transaction_pkey PRIMARY KEY ("ID")
);

CREATE TABLE IF NOT EXISTS public."user"
(
    "ID" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    discord_id character varying(255) COLLATE pg_catalog."default" NOT NULL,
    discord_tag character varying(255) COLLATE pg_catalog."default" NOT NULL,
    password character varying(255) COLLATE pg_catalog."default" NOT NULL,
    balance bigint NOT NULL DEFAULT 0,
    join_date date NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT user_pkey PRIMARY KEY ("ID")
);

CREATE TABLE IF NOT EXISTS public.build
(
    "ID" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    weapon character varying(255) COLLATE pg_catalog."default",
    head character varying(255) COLLATE pg_catalog."default",
    chest character varying(255) COLLATE pg_catalog."default",
    feet character varying(255) COLLATE pg_catalog."default",
    cape character varying(255) COLLATE pg_catalog."default",
    food character varying(255) COLLATE pg_catalog."default",
    off_hand character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT build_pkey PRIMARY KEY ("ID")
);

CREATE TABLE IF NOT EXISTS public.role
(
    "ID" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    role_label character varying(255) COLLATE pg_catalog."default" NOT NULL,
    build_id integer NOT NULL,
    CONSTRAINT role_pkey PRIMARY KEY ("ID")
);

CREATE TABLE IF NOT EXISTS public.role_list
(
    event_type_id integer NOT NULL,
    role_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS public.event_type
(
    "ID" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    event_label character varying(255) COLLATE pg_catalog."default" NOT NULL,
    event_description text COLLATE pg_catalog."default",
    group_size integer NOT NULL,
    recommended_ip integer NOT NULL,
    CONSTRAINT event_type_pkey PRIMARY KEY ("ID")
);

CREATE TABLE IF NOT EXISTS public.event
(
    "ID" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    creator_id integer NOT NULL,
    event_type_id integer NOT NULL,
    event_date date NOT NULL,
    event_time time with time zone NOT NULL,
    is_started boolean DEFAULT false,
    is_finished boolean DEFAULT false,
    is_lootsplit boolean DEFAULT false,
    CONSTRAINT event_pkey PRIMARY KEY ("ID")
);

CREATE TABLE IF NOT EXISTS public.participants_list
(
    event_id integer NOT NULL,
    user_id integer NOT NULL,
    role_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS public.lootsplit
(
    collector_id integer NOT NULL,
    event_id integer NOT NULL,
    place_id integer NOT NULL,
    silver bigint NOT NULL,
    is_checked boolean NOT NULL DEFAULT false
);

CREATE TABLE IF NOT EXISTS public.place
(
    "ID" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    location character varying(255) COLLATE pg_catalog."default" NOT NULL,
    chest_or_tab character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT place_pkey PRIMARY KEY ("ID")
);

ALTER TABLE IF EXISTS public.transaction
    ADD FOREIGN KEY (user_id)
    REFERENCES public."user" ("ID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.transaction
    ADD FOREIGN KEY (event_id)
    REFERENCES public.event ("ID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.role
    ADD FOREIGN KEY (build_id)
    REFERENCES public.build ("ID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.role_list
    ADD FOREIGN KEY (role_id)
    REFERENCES public.role ("ID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.role_list
    ADD FOREIGN KEY (event_type_id)
    REFERENCES public.event_type ("ID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.event
    ADD FOREIGN KEY (creator_id)
    REFERENCES public."user" ("ID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.event
    ADD FOREIGN KEY (event_type_id)
    REFERENCES public.event_type ("ID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.participants_list
    ADD FOREIGN KEY (user_id)
    REFERENCES public."user" ("ID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.participants_list
    ADD FOREIGN KEY (role_id)
    REFERENCES public.role ("ID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.participants_list
    ADD FOREIGN KEY (event_id)
    REFERENCES public.event ("ID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.lootsplit
    ADD FOREIGN KEY (place_id)
    REFERENCES public.place ("ID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.lootsplit
    ADD FOREIGN KEY (collector_id)
    REFERENCES public."user" ("ID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.lootsplit
    ADD FOREIGN KEY (event_id)
    REFERENCES public.event ("ID") MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;