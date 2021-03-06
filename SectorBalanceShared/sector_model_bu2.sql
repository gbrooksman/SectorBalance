PGDMP     7                    w           sectormodel    11.2    11.2 (    ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            @           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            A           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            B           1262    16395    sectormodel    DATABASE     }   CREATE DATABASE sectormodel WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE sectormodel;
          
   gbrooksman    false            C           0    0    SCHEMA public    ACL     �   REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO gbrooksman;
GRANT ALL ON SCHEMA public TO PUBLIC;
               
   gbrooksman    false    4                        3079    16406 	   uuid-ossp 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    DROP EXTENSION "uuid-ossp";
                  false            D           0    0    EXTENSION "uuid-ossp"    COMMENT     W   COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';
                       false    2            �            1255    16434    update_updated_at()    FUNCTION     �   CREATE FUNCTION public.update_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
      NEW.updated_at = now();
      RETURN NEW;
  END;
  $$;
 *   DROP FUNCTION public.update_updated_at();
       public    
   gbrooksman    false            �            1259    16452    equities    TABLE     ,  CREATE TABLE public.equities (
    symbol character varying(10) NOT NULL,
    symbol_name character varying(200) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL
);
    DROP TABLE public.equities;
       public      
   gbrooksman    false    2            �            1259    16469    equity_group_items    TABLE       CREATE TABLE public.equity_group_items (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    group_id uuid NOT NULL,
    equity_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
 &   DROP TABLE public.equity_group_items;
       public      
   gbrooksman    false    2            �            1259    16461    equity_groups    TABLE     2  CREATE TABLE public.equity_groups (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    name character varying(200) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    active boolean DEFAULT true NOT NULL
);
 !   DROP TABLE public.equity_groups;
       public      
   gbrooksman    false    2            �            1259    16429    model_equities    TABLE     <  CREATE TABLE public.model_equities (
    model_id uuid NOT NULL,
    percent integer NOT NULL,
    updated_at timestamp(6) with time zone DEFAULT now() NOT NULL,
    created_at timestamp(6) with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    equity_id uuid NOT NULL
);
 "   DROP TABLE public.model_equities;
       public      
   gbrooksman    false    2            �            1259    16418    quotes    TABLE     ;  CREATE TABLE public.quotes (
    date date NOT NULL,
    price money NOT NULL,
    volume bigint NOT NULL,
    created_at timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated_at timestamp(6) with time zone DEFAULT now() NOT NULL,
    equity_id uuid NOT NULL,
    rate_of_change numeric(10,2) NOT NULL
);
    DROP TABLE public.quotes;
       public      
   gbrooksman    false            �            1259    16527    user_model_comments    TABLE     -  CREATE TABLE public.user_model_comments (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    user_id uuid NOT NULL,
    comment character varying(2000) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    model_id uuid NOT NULL
);
 '   DROP TABLE public.user_model_comments;
       public      
   gbrooksman    false    2            �            1259    16423    user_models    TABLE     �  CREATE TABLE public.user_models (
    id uuid DEFAULT public.uuid_generate_v1() NOT NULL,
    user_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated_at timestamp(6) with time zone DEFAULT now() NOT NULL,
    active boolean DEFAULT true NOT NULL,
    start_date date NOT NULL,
    stop_date date NOT NULL,
    start_value money NOT NULL,
    stop_value money NOT NULL,
    public boolean DEFAULT true NOT NULL
);
    DROP TABLE public.user_models;
       public      
   gbrooksman    false    2            �            1259    16401    users    TABLE     '  CREATE TABLE public.users (
    user_name character varying(25) NOT NULL,
    password character varying(15),
    active boolean,
    id uuid DEFAULT public.uuid_generate_v1(),
    created_at timestamp(6) with time zone DEFAULT now(),
    updated_at timestamp(6) with time zone DEFAULT now()
);
    DROP TABLE public.users;
       public      
   gbrooksman    false    2            �           2606    16540    equities equities_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.equities
    ADD CONSTRAINT equities_pkey PRIMARY KEY (symbol);
 @   ALTER TABLE ONLY public.equities DROP CONSTRAINT equities_pkey;
       public      
   gbrooksman    false    201            �           2606    16473 *   equity_group_items equity_group_items_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.equity_group_items
    ADD CONSTRAINT equity_group_items_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.equity_group_items DROP CONSTRAINT equity_group_items_pkey;
       public      
   gbrooksman    false    203            �           2606    16465     equity_groups equity_groups_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.equity_groups
    ADD CONSTRAINT equity_groups_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.equity_groups DROP CONSTRAINT equity_groups_pkey;
       public      
   gbrooksman    false    202            �           2606    16496 $   equity_groups ix_equity_grouips_name 
   CONSTRAINT     _   ALTER TABLE ONLY public.equity_groups
    ADD CONSTRAINT ix_equity_grouips_name UNIQUE (name);
 N   ALTER TABLE ONLY public.equity_groups DROP CONSTRAINT ix_equity_grouips_name;
       public      
   gbrooksman    false    202            �           2606    16494 %   equity_group_items ix_group_equity_id 
   CONSTRAINT     o   ALTER TABLE ONLY public.equity_group_items
    ADD CONSTRAINT ix_group_equity_id UNIQUE (group_id, equity_id);
 O   ALTER TABLE ONLY public.equity_group_items DROP CONSTRAINT ix_group_equity_id;
       public      
   gbrooksman    false    203    203            �           2606    16498 -   model_equities ix_model_equities_model_equity 
   CONSTRAINT     w   ALTER TABLE ONLY public.model_equities
    ADD CONSTRAINT ix_model_equities_model_equity UNIQUE (model_id, equity_id);
 W   ALTER TABLE ONLY public.model_equities DROP CONSTRAINT ix_model_equities_model_equity;
       public      
   gbrooksman    false    200    200            �           2606    16492    users ix_user_id 
   CONSTRAINT     I   ALTER TABLE ONLY public.users
    ADD CONSTRAINT ix_user_id UNIQUE (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT ix_user_id;
       public      
   gbrooksman    false    197            �           2606    16524 '   user_models ix_user_models_user_id_name 
   CONSTRAINT     k   ALTER TABLE ONLY public.user_models
    ADD CONSTRAINT ix_user_models_user_id_name UNIQUE (user_id, name);
 Q   ALTER TABLE ONLY public.user_models DROP CONSTRAINT ix_user_models_user_id_name;
       public      
   gbrooksman    false    199    199            �           2606    16480 "   model_equities model_equities_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.model_equities
    ADD CONSTRAINT model_equities_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.model_equities DROP CONSTRAINT model_equities_pkey;
       public      
   gbrooksman    false    200            �           2606    16490    quotes quotes_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.quotes
    ADD CONSTRAINT quotes_pkey PRIMARY KEY (equity_id, date);
 <   ALTER TABLE ONLY public.quotes DROP CONSTRAINT quotes_pkey;
       public      
   gbrooksman    false    198    198            �           2606    16535 &   user_model_comments user_comments_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.user_model_comments
    ADD CONSTRAINT user_comments_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.user_model_comments DROP CONSTRAINT user_comments_pkey;
       public      
   gbrooksman    false    204            �           2606    16428    user_models user_models_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.user_models
    ADD CONSTRAINT user_models_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.user_models DROP CONSTRAINT user_models_pkey;
       public      
   gbrooksman    false    199            �           2606    16405    users users_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_name);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public      
   gbrooksman    false    197            �           1259    16501    ix_quotes_date    INDEX     A   CREATE INDEX ix_quotes_date ON public.quotes USING btree (date);
 "   DROP INDEX public.ix_quotes_date;
       public      
   gbrooksman    false    198            �           1259    16502    ix_quotes_equity_id_date    INDEX     V   CREATE INDEX ix_quotes_equity_id_date ON public.quotes USING btree (equity_id, date);
 ,   DROP INDEX public.ix_quotes_equity_id_date;
       public      
   gbrooksman    false    198    198            �           2620    16459 #   equities update_equities_updated_at    TRIGGER     �   CREATE TRIGGER update_equities_updated_at BEFORE UPDATE ON public.equities FOR EACH ROW EXECUTE PROCEDURE public.update_updated_at();
 <   DROP TRIGGER update_equities_updated_at ON public.equities;
       public    
   gbrooksman    false    201    215            �           2620    16468 (   equity_groups update_equities_updated_at    TRIGGER     �   CREATE TRIGGER update_equities_updated_at BEFORE UPDATE ON public.equity_groups FOR EACH ROW EXECUTE PROCEDURE public.update_updated_at();
 A   DROP TRIGGER update_equities_updated_at ON public.equity_groups;
       public    
   gbrooksman    false    215    202            �           2620    16476 7   equity_group_items update_equity_group_items_updated_at    TRIGGER     �   CREATE TRIGGER update_equity_group_items_updated_at BEFORE UPDATE ON public.equity_group_items FOR EACH ROW EXECUTE PROCEDURE public.update_updated_at();
 P   DROP TRIGGER update_equity_group_items_updated_at ON public.equity_group_items;
       public    
   gbrooksman    false    203    215            �           2620    16538 -   equity_groups update_equity_groups_updated_at    TRIGGER     �   CREATE TRIGGER update_equity_groups_updated_at BEFORE UPDATE ON public.equity_groups FOR EACH ROW EXECUTE PROCEDURE public.update_updated_at();
 F   DROP TRIGGER update_equity_groups_updated_at ON public.equity_groups;
       public    
   gbrooksman    false    202    215            �           2620    16537 /   model_equities update_model_equities_updated_at    TRIGGER     �   CREATE TRIGGER update_model_equities_updated_at BEFORE UPDATE ON public.model_equities FOR EACH ROW EXECUTE PROCEDURE public.update_updated_at();
 H   DROP TRIGGER update_model_equities_updated_at ON public.model_equities;
       public    
   gbrooksman    false    215    200            �           2620    16442    quotes update_quotes_updated_at    TRIGGER     �   CREATE TRIGGER update_quotes_updated_at BEFORE UPDATE ON public.quotes FOR EACH ROW EXECUTE PROCEDURE public.update_updated_at();
 8   DROP TRIGGER update_quotes_updated_at ON public.quotes;
       public    
   gbrooksman    false    198    215            �           2620    16536 9   user_model_comments update_user_model_comments_updated_at    TRIGGER     �   CREATE TRIGGER update_user_model_comments_updated_at BEFORE UPDATE ON public.user_model_comments FOR EACH ROW EXECUTE PROCEDURE public.update_updated_at();
 R   DROP TRIGGER update_user_model_comments_updated_at ON public.user_model_comments;
       public    
   gbrooksman    false    215    204            �           2620    16439 )   user_models update_user_models_updated_at    TRIGGER     �   CREATE TRIGGER update_user_models_updated_at BEFORE UPDATE ON public.user_models FOR EACH ROW EXECUTE PROCEDURE public.update_updated_at();
 B   DROP TRIGGER update_user_models_updated_at ON public.user_models;
       public    
   gbrooksman    false    199    215            �           2620    16436    users update_users_updated_at    TRIGGER     �   CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE PROCEDURE public.update_updated_at();
 6   DROP TRIGGER update_users_updated_at ON public.users;
       public    
   gbrooksman    false    215    197           