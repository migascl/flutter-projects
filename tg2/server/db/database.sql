PGDMP     )                    {            tg2    15.1    15.1 <    L           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            M           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            N           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            O           1262    26246    tg2    DATABASE        CREATE DATABASE tg2 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United Kingdom.1252';
    DROP DATABASE tg2;
                postgres    false            �            1259    26247    club    TABLE     =  CREATE TABLE public.club (
    id integer NOT NULL,
    name character varying NOT NULL,
    nickname character varying,
    stadium integer NOT NULL,
    phone character varying,
    fax character varying,
    email character varying,
    color integer[],
    logo character varying,
    playing boolean NOT NULL
);
    DROP TABLE public.club;
       public         heap    postgres    false            �            1259    26252    club_id_seq    SEQUENCE     �   ALTER TABLE public.club ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.club_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    214            �            1259    26253    contract    TABLE     �   CREATE TABLE public.contract (
    id integer NOT NULL,
    player integer NOT NULL,
    club integer NOT NULL,
    shirtnumber integer NOT NULL,
    "position" integer NOT NULL,
    period daterange NOT NULL,
    passport character varying NOT NULL
);
    DROP TABLE public.contract;
       public         heap    postgres    false            �            1259    26258    contract_id_seq    SEQUENCE     �   ALTER TABLE public.contract ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.contract_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    216            �            1259    26259    country    TABLE     ^   CREATE TABLE public.country (
    id integer NOT NULL,
    name character varying NOT NULL
);
    DROP TABLE public.country;
       public         heap    postgres    false            �            1259    26264    country_id_seq    SEQUENCE     �   ALTER TABLE public.country ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.country_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    218            �            1259    26265    exam    TABLE     �   CREATE TABLE public.exam (
    id integer NOT NULL,
    player integer NOT NULL,
    date date NOT NULL,
    result boolean NOT NULL
);
    DROP TABLE public.exam;
       public         heap    postgres    false            �            1259    26268    exam_id_seq    SEQUENCE     �   ALTER TABLE public.exam ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.exam_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    220            �            1259    26269    match    TABLE     &  CREATE TABLE public.match (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    matchweek integer NOT NULL,
    homeclub integer NOT NULL,
    homescore integer,
    awayclub integer NOT NULL,
    awayscore integer,
    duration integer,
    stadium integer NOT NULL
);
    DROP TABLE public.match;
       public         heap    postgres    false            �            1259    26272    match_id_seq    SEQUENCE     �   ALTER TABLE public.match ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.match_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    222            �            1259    26273    player    TABLE       CREATE TABLE public.player (
    id integer NOT NULL,
    name character varying NOT NULL,
    nickname character varying,
    country integer NOT NULL,
    birthday date NOT NULL,
    height integer,
    weight integer,
    schooling integer,
    picture character varying
);
    DROP TABLE public.player;
       public         heap    postgres    false            �            1259    26278    player_id_seq    SEQUENCE     �   ALTER TABLE public.player ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.player_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    224            �            1259    26279    position    TABLE     a   CREATE TABLE public."position" (
    id integer NOT NULL,
    name character varying NOT NULL
);
    DROP TABLE public."position";
       public         heap    postgres    false            �            1259    26284    position_id_seq    SEQUENCE     �   ALTER TABLE public."position" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.position_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    226            �            1259    26285 	   schooling    TABLE     `   CREATE TABLE public.schooling (
    id integer NOT NULL,
    name character varying NOT NULL
);
    DROP TABLE public.schooling;
       public         heap    postgres    false            �            1259    26290    schooling_id_seq    SEQUENCE     �   ALTER TABLE public.schooling ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.schooling_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    228            �            1259    26291    stadium    TABLE     �   CREATE TABLE public.stadium (
    id integer NOT NULL,
    name character varying NOT NULL,
    address character varying,
    city character varying NOT NULL,
    country integer NOT NULL
);
    DROP TABLE public.stadium;
       public         heap    postgres    false            �            1259    26296    stadium_id_seq    SEQUENCE     �   ALTER TABLE public.stadium ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.stadium_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    230            8          0    26247    club 
   TABLE DATA                 public          postgres    false    214   �A       :          0    26253    contract 
   TABLE DATA                 public          postgres    false    216   �A       <          0    26259    country 
   TABLE DATA                 public          postgres    false    218   �A       >          0    26265    exam 
   TABLE DATA                 public          postgres    false    220   �I       @          0    26269    match 
   TABLE DATA                 public          postgres    false    222   �I       B          0    26273    player 
   TABLE DATA                 public          postgres    false    224   �I       D          0    26279    position 
   TABLE DATA                 public          postgres    false    226   �I       F          0    26285 	   schooling 
   TABLE DATA                 public          postgres    false    228   �J       H          0    26291    stadium 
   TABLE DATA                 public          postgres    false    230   8K       P           0    0    club_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.club_id_seq', 0, false);
          public          postgres    false    215            Q           0    0    contract_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.contract_id_seq', 0, false);
          public          postgres    false    217            R           0    0    country_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.country_id_seq', 196, true);
          public          postgres    false    219            S           0    0    exam_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.exam_id_seq', 0, false);
          public          postgres    false    221            T           0    0    match_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.match_id_seq', 0, false);
          public          postgres    false    223            U           0    0    player_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.player_id_seq', 13, true);
          public          postgres    false    225            V           0    0    position_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.position_id_seq', 3, true);
          public          postgres    false    227            W           0    0    schooling_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.schooling_id_seq', 4, true);
          public          postgres    false    229            X           0    0    stadium_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.stadium_id_seq', 0, false);
          public          postgres    false    231            �           2606    26298    club club_pk 
   CONSTRAINT     J   ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_pk PRIMARY KEY (id);
 6   ALTER TABLE ONLY public.club DROP CONSTRAINT club_pk;
       public            postgres    false    214            �           2606    26300    contract contract_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.contract
    ADD CONSTRAINT contract_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.contract DROP CONSTRAINT contract_pk;
       public            postgres    false    216            �           2606    26302    country country_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.country DROP CONSTRAINT country_pk;
       public            postgres    false    218            �           2606    26304    exam exam_pk 
   CONSTRAINT     J   ALTER TABLE ONLY public.exam
    ADD CONSTRAINT exam_pk PRIMARY KEY (id);
 6   ALTER TABLE ONLY public.exam DROP CONSTRAINT exam_pk;
       public            postgres    false    220            �           2606    26306    match match_pk 
   CONSTRAINT     L   ALTER TABLE ONLY public.match
    ADD CONSTRAINT match_pk PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.match DROP CONSTRAINT match_pk;
       public            postgres    false    222            �           2606    26308    player player_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.player DROP CONSTRAINT player_pk;
       public            postgres    false    224            �           2606    26310    position position_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public."position"
    ADD CONSTRAINT position_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public."position" DROP CONSTRAINT position_pk;
       public            postgres    false    226            �           2606    26312    schooling schooling_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.schooling
    ADD CONSTRAINT schooling_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.schooling DROP CONSTRAINT schooling_pk;
       public            postgres    false    228            �           2606    26314    stadium stadium_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.stadium
    ADD CONSTRAINT stadium_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.stadium DROP CONSTRAINT stadium_pk;
       public            postgres    false    230            �           2606    26315    club club_stadium_fk    FK CONSTRAINT     u   ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_stadium_fk FOREIGN KEY (stadium) REFERENCES public.stadium(id);
 >   ALTER TABLE ONLY public.club DROP CONSTRAINT club_stadium_fk;
       public          postgres    false    3230    214    230            �           2606    26320    contract contract_club_fk    FK CONSTRAINT     t   ALTER TABLE ONLY public.contract
    ADD CONSTRAINT contract_club_fk FOREIGN KEY (club) REFERENCES public.club(id);
 C   ALTER TABLE ONLY public.contract DROP CONSTRAINT contract_club_fk;
       public          postgres    false    216    3214    214            �           2606    26325    contract contract_player_fk    FK CONSTRAINT     z   ALTER TABLE ONLY public.contract
    ADD CONSTRAINT contract_player_fk FOREIGN KEY (player) REFERENCES public.player(id);
 E   ALTER TABLE ONLY public.contract DROP CONSTRAINT contract_player_fk;
       public          postgres    false    224    3224    216            �           2606    26330    contract contract_position_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.contract
    ADD CONSTRAINT contract_position_fk FOREIGN KEY ("position") REFERENCES public."position"(id);
 G   ALTER TABLE ONLY public.contract DROP CONSTRAINT contract_position_fk;
       public          postgres    false    216    3226    226            �           2606    26335    exam exam_player_fk    FK CONSTRAINT     r   ALTER TABLE ONLY public.exam
    ADD CONSTRAINT exam_player_fk FOREIGN KEY (player) REFERENCES public.player(id);
 =   ALTER TABLE ONLY public.exam DROP CONSTRAINT exam_player_fk;
       public          postgres    false    220    3224    224            �           2606    26340    match match_clubaway_fk    FK CONSTRAINT     v   ALTER TABLE ONLY public.match
    ADD CONSTRAINT match_clubaway_fk FOREIGN KEY (awayclub) REFERENCES public.club(id);
 A   ALTER TABLE ONLY public.match DROP CONSTRAINT match_clubaway_fk;
       public          postgres    false    3214    214    222            �           2606    26345    match match_clubhome_fk    FK CONSTRAINT     v   ALTER TABLE ONLY public.match
    ADD CONSTRAINT match_clubhome_fk FOREIGN KEY (homeclub) REFERENCES public.club(id);
 A   ALTER TABLE ONLY public.match DROP CONSTRAINT match_clubhome_fk;
       public          postgres    false    222    3214    214            �           2606    26350    match match_stadium_fk    FK CONSTRAINT     w   ALTER TABLE ONLY public.match
    ADD CONSTRAINT match_stadium_fk FOREIGN KEY (stadium) REFERENCES public.stadium(id);
 @   ALTER TABLE ONLY public.match DROP CONSTRAINT match_stadium_fk;
       public          postgres    false    222    230    3230            �           2606    26355    player player_country_fk    FK CONSTRAINT     y   ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_country_fk FOREIGN KEY (country) REFERENCES public.country(id);
 B   ALTER TABLE ONLY public.player DROP CONSTRAINT player_country_fk;
       public          postgres    false    218    3218    224            �           2606    26360    player player_schooling_fk    FK CONSTRAINT        ALTER TABLE ONLY public.player
    ADD CONSTRAINT player_schooling_fk FOREIGN KEY (schooling) REFERENCES public.schooling(id);
 D   ALTER TABLE ONLY public.player DROP CONSTRAINT player_schooling_fk;
       public          postgres    false    3228    228    224            �           2606    26365    stadium stadium_country_fk    FK CONSTRAINT     {   ALTER TABLE ONLY public.stadium
    ADD CONSTRAINT stadium_country_fk FOREIGN KEY (country) REFERENCES public.country(id);
 D   ALTER TABLE ONLY public.stadium DROP CONSTRAINT stadium_country_fk;
       public          postgres    false    218    230    3218            8   
   x���          :   
   x���          <   �  x�������{_�tI�8�/�jז�2$Y��.w=Kc��9C��.���S[��s���C��N��1\��$ߏ�f-���z�-�۷��������t���G]��٨�����������*�˷�Uv{�����̳{?g?\�W�4���_�����lA!�H�wz'��f��y�~u]��FKu �j��#R��jJ�:��5�9�ӕ�Tv)]�K"}��.-�\�RwD��*<���0;SU�C�
d�5ၺ{E
܅o�8��i}$9��X��^�B��ʓ"w)�d#["u��jY�O�硴��N�����)i�1gU,�Dl�ڥ��=q^�=@�&���)d�Zձ��/m�D?�����t�bX��6V�X�_+w�*{���>g��K*�s��̻��Q�E�|]�#�H��7�>��^�+��dvf�/�$N� ����� ��,lv�\I,�>�M���S��;�������A5�G"uj'�9�^ƝKn,)k/�$uL��5�9;3�q�;3��8�!���6�x�-�X�L�ɲ��y���{y�5sن�X�Fߺ��c�G��S��!2g[{ �m89C;�w%�{�}j8}�_So�C���p�1����R3����s�)z/c�sZG)|/m�u�F)s�Jwč;JI�7ڥ�*8Y�6�1��e�R��}|����͝�R� bS��mm��e&y�D��� �s�ɍ��]���/��>�]�Y)���U�}{4<=��nNO�h�fr<<?(<r��tx�S�)����ZN���>. �d����:|��sR_9i����)�W����')�W�3��9�c�̸MRܮTxtu�)\W.urL���@��LR��b�T�d~o�L�������&<��'h����:-��i���R���DvJ��xa%V�i��kkJq���ڛ��
m����2DhJڢ��mj��R���a�Ҷ0������z��p��a:S~��6k����Ysg)_��~����:��;k����g)aob�I��F��k���F�Yg)Zo�+�>�,%k)=���R�����N[�z��[�K�Z�S!u�)ZK]���:��?��R�m�)�>m�_�{#�;O޹��r���TSxWQ/�m%w��n��hEo�G��
�v��*"z3�����\O,lNIĖ�@U)��D.u��3��	�$����f@&YI�ګ	�$	�;v�!����'�cJ�*v�5iPJVz��^�de�߲)4��*���l]�#U�KV�dJ��A.YYS�G�s6<�㩧*Gr��Z6�s^�:&�ؼx%k�g��R�:^�]8V�:)t�p�3�0Jֺb�� ��˃W�� �w��
�%o����¶��Ԫ6������^��5󭖀_���_3M�d#�^fXA��D�d���d#���fޫ��l���8�ؚ�0�8��v�WԊ	��W�6����굫���Ib�>��|�!��\+m���#=z�$��^����/�+�����'�)�����K�؝K+q�9&�� �|���AT��;�U�=�Ŭ��rͶ�\�\�q������J"`�䲱�I� j:�-�nK%����p�,>��U�V�G(��9���掹��V�ަ���ob�ovzO�����[���R��?*s��%Wzw�j��f�S�G=���ʹ�=u�C_�c'�mϡ���T�������Ē��s�ǝM�����l)�8�Ē��[�a���t�W@f�=Y�Z"�D����ܻ��2K�����FZK${j+�e+?�����m�Js�~��e��/UK���ek�w](-�x�f���mܿ�,�9����:o�M8q��[���l��?���Ш�F��A���
p\nb�E����ܟ@r�q�����M[��P� ��J�e�\7�.�2�����]n����+��(`��jՑO;8/��Z����N7E8��UϞ��!�      >   
   x���          @   
   x���          B   
   x���          D   �   x���v
Q���W((M��L�S*�/�,���SR��L�Q�K�M�T�s
�t��sW�q�Us�	u���
:
�E)��A�)����\��2�h�KjZjq"U�5�{xeJf>U�5�X��wxyb
�d.. 7j      F   �   x���v
Q���W((M��L�+N������KW��L�Q�K�M�T�s
�t��sW�q�Us�	u���
:
�yřy�
N�g&�+�*ڥ�������i��I%���dD����dL��6�&��^X�IUL�l(-H�^2�� 5�'      H   
   x���         