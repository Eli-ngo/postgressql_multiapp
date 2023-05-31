-- Active: 1684762799193@@127.0.0.1@5432@multiapp

-- CREATION DES SCHEMAS
-- suppression du schéma users s'il existe
DROP SCHEMA IF EXISTS users CASCADE;
-- création du schéma users
CREATE SCHEMA users ;

-- suppression du schéma gallery s'il existe
DROP SCHEMA IF EXISTS gallery CASCADE;
-- création du schéma gallery
CREATE SCHEMA gallery ;
-- suppression du schéma forum s'il existe
DROP SCHEMA IF EXISTS forum CASCADE;
-- création du schéma forum
CREATE SCHEMA forum ;

-- suppression du schéma shop s'il existe
DROP SCHEMA IF EXISTS shop CASCADE;
-- création du schéma shop
CREATE SCHEMA shop ;

-- CREATION DES DOMAINS TYPES pour la vérification des données
DROP DOMAIN IF EXISTS email_type CASCADE;
-- création d'un domain type email
CREATE DOMAIN email_type AS VARCHAR
CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );
DROP DOMAIN IF EXISTS password_type CASCADE;
-- création d'un domain type password
CREATE DOMAIN password_type AS VARCHAR
CHECK ( value ~ '^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$' );
DROP DOMAIN IF EXISTS price_type CASCADE;
-- création d'un domain type price
CREATE DOMAIN price_type AS NUMERIC(10, 2)
CHECK (VALUE >= 0);

-- CREATION DES TABLES
-- création de la table users
DROP TABLE IF EXISTS users.users CASCADE;
CREATE TABLE users.users(
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    username VARCHAR(100) NOT NULL UNIQUE,
    email email_type NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    created_at timestamp NOT NULL DEFAULT (now()),
    updated_at timestamp NOT NULL DEFAULT (now())
);

-- Création de la table gallery
DROP TABLE IF EXISTS gallery.gallery CASCADE;

CREATE TABLE gallery.gallery (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    title VARCHAR(100) NOT NULL,
    -- création d'une colonne user_id qui référence la table users. Relation Many to One (Plusieurs galleries d'images pour un utilisateur)
    user_id BIGINT NOT NULL REFERENCES users.users(id) ON UPDATE CASCADE ON DELETE CASCADE, 
    description TEXT,
    image_url VARCHAR(100) NOT NULL,
    created_at timestamp NOT NULL DEFAULT (now()),
    updated_at timestamp NOT NULL DEFAULT (now())
);

-- Création de la table des likes
DROP TABLE IF EXISTS gallery.likes CASCADE;
CREATE TABLE gallery.likes (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    user_id BIGINT NOT NULL REFERENCES users.users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    gallery_id BIGINT NOT NULL REFERENCES gallery.gallery(id) ON UPDATE CASCADE ON DELETE CASCADE,
    created_at timestamp NOT NULL DEFAULT (now()),
    updated_at timestamp NOT NULL DEFAULT (now())
);

DROP TABLE IF EXISTS gallery.gallery_likes CASCADE;
-- Création de la table de jointure entre gallery et likes. Relation Many to Many (Plusieurs utilisateurs peuvent liker plusieurs galleries)
CREATE TABLE gallery.gallery_likes (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    gallery_id BIGINT NOT NULL REFERENCES gallery.gallery(id) ON UPDATE CASCADE ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users.users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS gallery.comments CASCADE;
-- Création de la table des commentaires.
CREATE TABLE gallery.comments (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    user_id BIGINT NOT NULL REFERENCES users.users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    gallery_id BIGINT NOT NULL REFERENCES gallery.gallery(id) ON UPDATE CASCADE ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at timestamp NOT NULL DEFAULT (now()),
    updated_at timestamp NOT NULL DEFAULT (now())
);

DROP TABLE IF EXISTS gallery.gallery_comments CASCADE;
-- Création de la table de jointure entre gallery et comments. Relation Many to Many (Plusieurs utilisateurs peuvent commenter plusieurs galleries)
CREATE TABLE gallery.gallery_comments (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    gallery_id BIGINT NOT NULL REFERENCES gallery.gallery(id) ON UPDATE CASCADE ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users.users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS forum.forum CASCADE;
-- Création de la table forum
CREATE TABLE forum.forum (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    title VARCHAR(100) NOT NULL,
    user_id BIGINT NOT NULL REFERENCES users.users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    description TEXT,
    created_at timestamp NOT NULL DEFAULT (now()),
    updated_at timestamp NOT NULL DEFAULT (now())
);

DROP TABLE IF EXISTS forum.comments CASCADE;
-- Création de la table des commentaires.
CREATE TABLE forum.comments (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    user_id BIGINT NOT NULL REFERENCES users.users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    forum_id BIGINT NOT NULL REFERENCES forum.forum(id) ON UPDATE CASCADE ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at timestamp NOT NULL DEFAULT (now()),
    updated_at timestamp NOT NULL DEFAULT (now())
);

DROP TABLE IF EXISTS forum.forum_comments CASCADE;
-- Création de la table de jointure entre forum et comments. Relation Many to Many (Plusieurs utilisateurs peuvent commenter plusieurs forums)
CREATE TABLE forum.forum_comments (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    forum_id BIGINT NOT NULL REFERENCES forum.forum(id) ON UPDATE CASCADE ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users.users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS shop.shop CASCADE;
-- Création de la table shop
CREATE TABLE shop.shop (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    title VARCHAR(100) NOT NULL,
    user_id BIGINT NOT NULL REFERENCES users.users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    description TEXT,
    price price_type NOT NULL,
    created_at timestamp NOT NULL DEFAULT (now()),
    updated_at timestamp NOT NULL DEFAULT (now())
);

DROP TABLE IF EXISTS shop.cart CASCADE;
-- Création de la table des paniers.
CREATE TABLE shop.cart (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    user_id BIGINT NOT NULL REFERENCES users.users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    created_at timestamp NOT NULL DEFAULT (now()),
    updated_at timestamp NOT NULL DEFAULT (now())
);

DROP TABLE IF EXISTS shop.cart_items CASCADE;
-- Création de la table de jointure entre shop et cart. Relation Many to Many (Plusieurs utilisateurs peuvent avoir plusieurs paniers)
CREATE TABLE shop.cart_items (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    quantity INT NOT NULL,
    cart_id BIGINT NOT NULL REFERENCES shop.cart(id) ON UPDATE CASCADE ON DELETE CASCADE,
    shop_id BIGINT NOT NULL REFERENCES shop.shop(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- CREATION DES VIEWS
-- création de la vue user_galleries
-- Ceci est une vue pour afficher les galleries d'images associées aux utilisateurs
DROP VIEW IF EXISTS user_galleries CASCADE;
CREATE OR REPLACE VIEW user_galleries AS
SELECT
    u.id AS user_id,
    u.username,
    g.id AS gallery_id,
    g.title AS gallery_title,
    g.description AS gallery_description
FROM
    users.users u
    JOIN gallery.gallery g ON u.id = g.user_id;

SELECT * FROM user_galleries;

-- création de la vue shop_item_counts
-- Ceci est une vue pour afficher les articles du shop avec le nombre de fois qu'ils ont été ajoutés au panier
DROP VIEW IF EXISTS shop_item_counts CASCADE;
CREATE OR REPLACE VIEW shop_item_counts AS
SELECT
    s.id AS shop_id,
    s.title AS item_title,
    COUNT(ci.shop_id) AS cart_count
FROM
    shop.shop s
    LEFT JOIN shop.cart_items ci ON s.id = ci.shop_id
GROUP BY
    s.id, s.title;

SELECT * FROM shop_item_counts;

-- CREATION DES TRIGGER
-- Fonction pour mettre à jour le prix total du panier
CREATE OR REPLACE FUNCTION calculate_total_price()
    RETURNS TRIGGER AS
    $$
    BEGIN
    UPDATE shop.cart
    SET total_price = (
        SELECT SUM(shop.price * shop.cart_items.quantity)
        FROM shop.shop
        JOIN shop.cart_items ON shop.shop.id = shop.cart_items.shop_id
        WHERE shop.cart_items.cart_id = NEW.cart_id
    )
    WHERE shop.cart.id = NEW.cart_id;
    
    RETURN NEW;
    END;
$$
LANGUAGE plpgsql;

-- Trigger pour mettre à jour le prix total du panier
DROP TRIGGER IF EXISTS calculate_total_price_trigger ON shop.cart_items;
CREATE TRIGGER calculate_total_price_trigger
    AFTER INSERT OR UPDATE OR DELETE ON shop.cart_items
    FOR EACH ROW
    EXECUTE PROCEDURE calculate_total_price();



