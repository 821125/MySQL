/* Требования к курсовому проекту:
 
- Составить общее текстовое описание БД и решаемых ею задач;
- минимальное количество таблиц - 10;
- скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами);
- создать ERDiagram для БД;
- скрипты наполнения БД данными;
- скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);
- представления (минимум 2);
- хранимые процедуры / триггеры; */

/* Основные сущности:

- товар (имеет одноименную таблицу)
содержит информацию о предмете торговли (компьютерные комплектующие)
	
	атрибуты:
	- наименование
	- группа товара
	- описание (для ускорения запросов в одтельной таблице)
	- изображение (также в отдельной таблице)
	- цена
	- количество

- товарные группы (категории)
назначение данной сущности базы данных интернет-магазина является группировка товаров

	атрибуты:
	- название
	
- пользователи (покупатели)
таблица, соответствующая данной сущности, хранит в базе данных интернет-магазина
информацию о покупателе, которую он указывает при регистрации на сайте

	атрибуты:
	- ФИО
	- пароль
	- телефон
	- электроннная почта
	- скидка (имеет одноименную таблицу)
	
- заказы
Таблица базы данных Интернет-магазина, соответствующая данной сущности,
хранит в себе информацию о заказах покупателей. Предназначение данной сущности —
информирование покупателей и помощь администраторам, которые рассматривают заказы

	атрибуты:
	- покупатель (хранит идентификатор покупателя из одноименной таблицы)
	- товар (аналогично предыдущему пункту)
	- количество
	- цена

*/

DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;

USE shop;

DROP TABLE IF EXISTS `catalogs`;
CREATE TABLE `catalogs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) DEFAULT NULL COMMENT 'catalogs name',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `unique_name` (`name`(10)),
  INDEX `catalogs_id_idx`(`id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`firstname` VARCHAR(100),
	`lastname` VARCHAR(100),
	`email` VARCHAR(120) UNIQUE,
	`password_hash` VARCHAR(100),
	`phone` BIGINT UNSIGNED,
	PRIMARY KEY (`id`),
	INDEX `users_lastname_firstname_idx`(`lastname`, `firstname`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) DEFAULT NULL,
  `price` DECIMAL(11,2) DEFAULT NULL,
  `catalog_id` BIGINT UNSIGNED DEFAULT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `index_of_catalog_id` (`catalog_id`),
  FOREIGN KEY (`catalog_id`) REFERENCES `catalogs`(`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 COMMENT='commodity position';

DROP TABLE IF EXISTS `discounts`;
CREATE TABLE `discounts` (
  `id` BIGINT unsigned NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `product_id` BIGINT unsigned DEFAULT NULL,
  `discount` float unsigned DEFAULT NULL COMMENT 'discount value from 0.0 to 1.0',
  `started_at` DATETIME DEFAULT NULL,
  `finished_at` DATETIME DEFAULT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `index_of_user_id` (`user_id`),
  KEY `index_of_product_id` (`product_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='discounts';

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `index_of_user_id` (`user_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='orders';

DROP TABLE IF EXISTS `description`;
CREATE TABLE `description` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(510),
  `filename` VARCHAR(255) COMMENT 'picture',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  FOREIGN KEY (`id`) REFERENCES `products`(`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `orders_products`;
CREATE TABLE `orders_products` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `product_id` BIGINT UNSIGNED NOT NULL,
  `total` INT UNSIGNED DEFAULT '1' COMMENT 'value of orders products',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='order composition';

DROP TABLE IF EXISTS `storehouses`;
CREATE TABLE `storehouses` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) DEFAULT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB COMMENT='storehouses';

DROP TABLE IF EXISTS `storehouses_products`;
CREATE TABLE `storehouses_products` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `storehouse_id` BIGINT UNSIGNED DEFAULT NULL,
  `product_id` BIGINT UNSIGNED DEFAULT NULL,
  `value` INT UNSIGNED DEFAULT NULL COMMENT 'inventory in stock',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (`storehouse_id`) REFERENCES `storehouses`(`id`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='inventory in stock';

DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs` (
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`created_at` DATETIME NOT NULL,
	`table_name` VARCHAR(25) NOT NULL,
	`primary_key_id` BIGINT NOT NULL,
	`name_value` VARCHAR(25) NOT NULL
) ENGINE=ARCHIVE;

-- триггеры

DROP TRIGGER IF EXISTS change_users;
DELIMITER //
CREATE TRIGGER change_users AFTER INSERT ON `users`
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, primary_key_id, name_value)
	VALUES (NOW(), 'users', NEW.id, NEW.firstname);
END //
DELIMITER ;

DROP TRIGGER IF EXISTS change_catalogs;
DELIMITER //
CREATE TRIGGER change_catalogs AFTER INSERT ON `catalogs`
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, primary_key_id, name_value)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END //
DELIMITER ;

DROP TRIGGER IF EXISTS change_products;
DELIMITER //
CREATE TRIGGER change_products AFTER INSERT ON `products`
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, primary_key_id, name_value)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END //
DELIMITER ;


LOCK TABLES `catalogs` WRITE;
INSERT INTO `catalogs`(name)
VALUES
	('CPU'),
	('Mainboards'),
	('Video cards'),
	('SSD'),
	('RAM');
UNLOCK TABLES;

LOCK TABLES `products` WRITE;
INSERT INTO `products`
VALUES
	(1,'nemo',1059.10,1,'2021-01-16 10:23:19','2001-01-29 02:09:34'),
	(2,'ut',839.90,2,'1981-08-20 19:53:57','2003-08-22 10:31:03'),
	(3,'aspernatur',373.05,3,'2015-09-26 20:27:54','1995-09-01 09:26:42'),
	(4,'beatae',1270.00,4,'1985-10-13 09:12:53','1973-03-31 15:10:16'),
	(5,'et',1920.00,5,'1997-07-04 13:27:07','2017-09-28 02:43:09');
UNLOCK TABLES;

LOCK TABLES `storehouses` WRITE;
INSERT INTO `storehouses`
VALUES
	(1,'quia','2011-01-08 13:46:23','1977-10-15 09:08:29'),
	(2,'omnis','1999-04-02 05:51:30','1975-12-07 06:22:53'),
	(3,'non','2017-06-14 22:26:25','2004-02-21 15:10:07'),
	(4,'facilis','2018-11-04 10:38:04','1990-11-07 09:46:07'),
	(5,'quis','2018-06-16 19:53:07','1974-02-02 15:31:38');
UNLOCK TABLES;

LOCK TABLES `storehouses_products` WRITE;
INSERT INTO `storehouses_products`
VALUES
	(1,1,1,14,'2020-08-29 20:53:36','2014-06-02 19:19:59'),
	(2,2,2,5,'1990-07-28 20:14:54','1980-06-27 15:55:29'),
	(3,3,3,2,'2021-03-22 04:29:12','1977-07-14 12:42:00'),
	(4,4,4,17,'2016-08-14 13:25:44','2011-11-09 10:45:09'),
	(5,5,5,20,'2014-06-17 23:19:28','1976-07-26 23:11:24');
UNLOCK TABLES;

LOCK TABLES `description` WRITE;
INSERT INTO `description`
VALUES
	(1,'Explicabo molestiae minima et ullam. Dolores est tenetur aperiam voluptatum odit qui eos tenetur. Itaque corrupti recusandae voluptates dolore eligendi dicta magni.','http://kingkris.org/'),
	(2,'Sed libero placeat et architecto. Vel delectus temporibus ut ex. Sit tempore beatae iusto sequi vel accusantium et. Tenetur culpa ea consectetur accusantium vel.','http://walter.biz/'),
	(3,'Eos molestiae ut error delectus blanditiis molestias atque sed. Eligendi repudiandae culpa id deserunt vel consequuntur. Accusantium quod qui dolore itaque sunt.','http://bechtelar.net/'),
	(4,'Ipsa necessitatibus odio dolorem voluptatem reiciendis non recusandae. Dolorem tempore ullam explicabo. Id quisquam cumque voluptatem rerum. Suscipit voluptatem tempora tenetur ad amet voluptatem id exercitationem.','http://www.trompryan.biz/'),
	(5,'Temporibus minima et earum fugiat sint. Eum odio cumque consequatur eaque molestias et magnam. Quis eos qui cumque quae et quos odio quis.','http://www.haag.com/');
UNLOCK TABLES;

LOCK TABLES `users` WRITE;
INSERT INTO `users`
VALUES
	(1,'Alphonso','Pacocha','walter.roberta@example.net','cb3a0321c08622acf8f0b67b21771ea45455c392',89039750038),
	(2,'Amya','Langworth','mclaughlin.antwon@example.com','dc98c5fe5d424f72114c7e32e8f2b51c23ef7ceb',89052177752),
	(3,'Alverta','Jakubowski','hlesch@example.net','dfeae860a1aac04d11660ad89910bb7a9d277b6d',89053004664),
	(4,'Jaydon','Buckridge','litzy.watsica@example.net','87b73cc801a9d0d92cb28aef2ff6bb704483db93',89051793934),
	(5,'Forrest','Mills','gino.mills@example.org','48d50031305450dbfa563d5433eedb3cbaa8608f',89043703836);
UNLOCK TABLES;

LOCK TABLES `discounts` WRITE;
INSERT INTO `discounts`
VALUES
	(1,1,1,7,'1979-04-19 19:35:02','1983-03-12 12:00:00','2014-01-16 15:49:56','1988-10-11 22:49:20'),
	(2,2,2,9,'2009-11-16 04:46:55','1999-08-17 01:14:11','1990-12-19 19:23:34','1977-03-17 20:04:57'),
	(3,3,3,8,'1996-06-26 16:39:01','1983-01-20 11:58:19','1971-03-20 11:05:58','2004-03-02 11:32:00'),
	(4,4,4,10,'2014-09-16 10:17:38','2007-12-13 02:19:40','1977-01-11 01:02:29','1992-02-17 03:36:49'),
	(5,5,5,9,'2021-04-27 21:51:05','1993-06-04 18:39:03','1999-06-17 20:30:04','1976-01-23 08:51:49');
UNLOCK TABLES;

LOCK TABLES `orders` WRITE;
INSERT INTO `orders`
VALUES
	(1,1,'2013-09-14 22:08:37','2017-01-06 03:54:24'),
	(2,2,'1996-02-14 07:56:32','1983-08-14 09:22:22'),
	(3,3,'1983-05-27 05:18:50','2013-12-04 17:31:53'),
	(4,4,'1990-05-06 05:33:47','2001-08-05 18:45:49'),
	(5,5,'2009-10-24 06:58:26','2014-08-30 00:24:16');
UNLOCK TABLES;

LOCK TABLES `orders_products` WRITE;
INSERT INTO `orders_products`
VALUES
	(1,1,1,5,'2018-09-28 05:30:06','1973-06-18 15:13:16'),
	(2,2,2,5,'2017-08-17 04:53:55','2007-09-24 12:44:02'),
	(3,3,3,1,'1995-02-10 06:47:03','2010-02-09 20:03:27'),
	(4,4,4,5,'1990-04-17 13:52:51','2006-05-22 21:51:50'),
	(5,5,5,3,'1972-12-10 21:48:17','2012-01-17 20:42:23');
UNLOCK TABLES;

-- скрипты характерных выборок

-- список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине

SELECT  u.firstname, u.lastname 
  FROM users u
    JOIN orders o ON u.id = o.user_id GROUP BY u.firstname LIMIT 3;

-- список товаров products и разделов catalogs, который соответствует товару

SELECT  *
  FROM products p 
    JOIN catalogs c ON p.catalog_id = c.id;
   
-- представления
   
-- представление соответствия товаров и товарных групп

CREATE OR REPLACE VIEW pos AS
	SELECT p.name p_name, c.name c_name
	FROM products p
	JOIN catalogs c
	ON p.catalog_id = c.id;

SELECT * FROM pos;

-- представление списка товаров products и разделов catalogs, который соответствует товару

CREATE OR REPLACE VIEW pos AS
	SELECT p.id, p.name, c.name AS 'catalog_name', p.price, p.created_at, p.updated_at
	FROM products p 
	JOIN catalogs c
	ON p.catalog_id = c.id;

SELECT * FROM pos;

-- хранимые процедуры

DELIMITER //
DROP PROCEDURE IF EXISTS insert_to_catalog//
CREATE PROCEDURE insert_to_catalog (IN id BIGINT, IN name VARCHAR(255))
BEGIN
DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET @error = 'ERROR';
INSERT INTO catalogs VALUES(id, name);
IF @error IS NOT NULL THEN
SELECT @error;
END IF;
END//
DELIMITER ;

SELECT * FROM catalogs;
CALL insert_to_catalog(4, 'RAM');
CALL insert_to_catalog(1, 'CPU');