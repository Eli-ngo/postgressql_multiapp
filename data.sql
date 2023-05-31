-- TABLE users
INSERT INTO users.users (username, email, password) VALUES
('eli-ngo', 'eli-ngo@gmail.com', 'password123'),
('erwan-marques', 'erwan-m@gmail.com', 'password456'),
('roxy', 'roxynou@gmail.com', 'password789');

-- TABLE gallery
INSERT INTO gallery.gallery (title, user_id, description, image_url) VALUES
('Nature', 1, 'Beautiful nature scenery', 'https://google.com/nature.jpg'),
('Animals', 1, 'Cute animals', 'https://google.com/animals.jpg'),
('City', 2, 'City skyline at night', 'https://google.com/city.jpg');

-- TABLE gallery.gallery_likes
INSERT INTO gallery.gallery_likes (gallery_id, user_id) VALUES
(1, 2),
(1, 3),
(2, 1);

-- TABLE gallery.comments
INSERT INTO gallery.comments (user_id, gallery_id, content) VALUES
(2, 1, 'Magnifique la photo!'),
(3, 1, 'Les couleurs ressortent de fou'),
(1, 2, 'Trop chou!');

-- TABLE gallery.gallery_comments
INSERT INTO gallery.gallery_comments (gallery_id, user_id) VALUES
(1, 2),
(1, 3),
(2, 1);

-- TABLE forum.forum
INSERT INTO forum.forum (title, user_id, description) VALUES
('Topo général', 1, 'Discutez de tout et de rien.'),
('Problèmes techniques bot', 2, 'Vous rencontrez un problème avec le bot ? C''est ici qu''il faut en parler !'),
('Les nouveautés', 3, 'Toutes les nouveautés de snearkers sont ici !');

-- TABLE forum.comments
INSERT INTO forum.comments (user_id, forum_id, content) VALUES
(2, 1, 'Je rencontre un souci.'),
(3, 1, 'Pareil pour moi !'),
(1, 2, 'J''ai un problème avec le bot.'),
(2, 2, 'Moi aussi !'),
(3, 3, 'J''ai vu la nouvelle mise à jour !');

-- TABLE forum.forum_comments
INSERT INTO forum.forum_comments (forum_id, user_id) VALUES
(1, 2),
(1, 3),
(2, 1);

-- TABLE shop.shop
INSERT INTO shop.shop (title, user_id, description, price) VALUES
('Nike Jordan 1 Retro Travis Scott Olive', 1, 'Travis Scott is back in 2023, following up his previous release of the Air Jordan 1 Retro Low Phantom in 2022, with another Air Jordan 1 Retro Low collaboration. The Jordan 1 Retro low OG SP Travis Scott Olive released exclusively in womens sizing.', 109.99),
('New Balance 2002R
Protection Pack Rain Cloud', 2, 'CThe New Balance 2002R Protection Pack Rain Cloud features a grey mesh upper with tonal jagged suede overlays and a reflective New Balance logo. From there, a cream Nrgy midsole and grey outsole complete the design.', 149.99),
('Nike SB Dunk Low
Jarritos
', 3, 'Rumors of a collaboration project between Nike and Mexican beverage company Jarritos started initially in 2022 and now in 2023 we are seeing the collection come to fruition, with the release of the Nike SB Dunk Low Jarritos.
', 99.99),
('Jordan 1 High OG
Spider-Man Across the Spider-Verse', 2, 'Nike and Jordan Brand are returning back to the Spider-Verse for their second Spider-Man themed Air Jordan 1, with the release of the Air Jordan 1 High OG Spider-Man Across the Spider-Verse.', 159.99);

-- TABLE shop.cart
INSERT INTO shop.cart (user_id) VALUES
(2),
(3),
(1);

-- TABLE shop.cart_items
INSERT INTO shop.cart_items (quantity, cart_id, shop_id) VALUES
(2, 1, 1),
(1, 1, 2),
(3, 2, 3);

