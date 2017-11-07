CREATE TABLE `admin_person_settings` (
  `setting_id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_person_id` int(11) NOT NULL,
  `setting_key` varchar(150) NOT NULL,
  `settings_value` varchar(500) NOT NULL,
  `last_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`setting_id`),
  UNIQUE KEY `admin_person_id_UNIQUE` (`admin_person_id`),
  CONSTRAINT `admin_person_id_FK` FOREIGN KEY (`admin_person_id`) REFERENCES `admin_persons` (`admin_person_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `admin_persons` (
  `admin_person_id` int(11) NOT NULL AUTO_INCREMENT,
  `identity_user_id` varchar(128) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone_number` varchar(50) NOT NULL,
  `active` bit(1) NOT NULL DEFAULT b'1',
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`admin_person_id`),
  UNIQUE KEY `identity_user_id_UNIQUE` (`identity_user_id`),
  CONSTRAINT `user_id_1` FOREIGN KEY (`identity_user_id`) REFERENCES `users` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL COMMENT 'english name',
  `visual_name` varchar(150) DEFAULT NULL COMMENT 'hebrew name',
  `title` varchar(500) NOT NULL,
  `image` varchar(500) DEFAULT NULL COMMENT 'the relative url to the image',
  `precedence` int(11) DEFAULT NULL COMMENT 'the precedence of the category (1-based)',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `companies` (
  `company_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `address` varchar(500) NOT NULL,
  `phone_number` varchar(150) NOT NULL,
  `contact_person_name` varchar(150) NOT NULL,
  `contact_person_phone` varchar(150) NOT NULL,
  `registration_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `logo` varchar(500) NOT NULL COMMENT 'relative url to the company logo',
  PRIMARY KEY (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `company_person_settings` (
  `setting_id` int(11) NOT NULL AUTO_INCREMENT,
  `company_person_id` int(11) NOT NULL,
  `setting_key` varchar(150) NOT NULL,
  `settings_value` varchar(500) NOT NULL,
  `last_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`setting_id`),
  KEY `company_person_id_FK_idx` (`company_person_id`),
  CONSTRAINT `company_person_id_FK` FOREIGN KEY (`company_person_id`) REFERENCES `company_persons` (`company_person_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `company_persons` (
  `company_person_id` int(11) NOT NULL AUTO_INCREMENT,
  `identity_user_id` varchar(128) NOT NULL,
  `company_id` int(11) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone_number` varchar(50) NOT NULL,
  `active` bit(1) NOT NULL DEFAULT b'1',
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`company_person_id`),
  UNIQUE KEY `identity_user_id_UNIQUE` (`identity_user_id`),
  KEY `company_id_idx` (`company_id`),
  CONSTRAINT `company_id_FK` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `user_id_3` FOREIGN KEY (`identity_user_id`) REFERENCES `users` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `global_settings` (
  `global_setting_id` int(11) NOT NULL AUTO_INCREMENT,
  `global_settings_key` varchar(150) NOT NULL,
  `value` text,
  PRIMARY KEY (`global_setting_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='global settings and data';

CREATE TABLE `order_payments` (
  `payment_id` int(11) NOT NULL AUTO_INCREMENT,
  `credit_card_type` int(11) NOT NULL,
  `cerdit_card_number` varchar(50) NOT NULL,
  `credit_card_exp_date` varchar(10) NOT NULL,
  `credit_card_cvv` varchar(10) NOT NULL,
  `request_charge_date` datetime NOT NULL,
  `payment_status` int(11) NOT NULL,
  PRIMARY KEY (`payment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_uid` char(38) NOT NULL COMMENT 'unique identifier',
  `worker_id` int(11) NOT NULL,
  `order_payment_id` int(11) NOT NULL,
  `charge_amount` decimal(10,0) NOT NULL,
  `order_date` datetime NOT NULL,
  `order_status` int(11) NOT NULL,
  `comments` varchar(500) DEFAULT NULL,
  `last_updated` datetime NOT NULL,
  `active` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `order_id_UNIQUE` (`order_uid`),
  KEY `workier_id_fk_idx` (`worker_id`),
  KEY `payment_id_1_idx` (`order_payment_id`),
  CONSTRAINT `payment_id_1` FOREIGN KEY (`order_payment_id`) REFERENCES `order_payments` (`payment_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `workier_id_fk` FOREIGN KEY (`worker_id`) REFERENCES `workers` (`worker_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='product orders (not including voucher requests)';

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_uid` char(38) DEFAULT NULL COMMENT 'unique identifier',
  `category_id` int(11) NOT NULL,
  `image` varchar(500) DEFAULT NULL,
  `title` varchar(500) NOT NULL,
  `precedence` int(11) DEFAULT NULL COMMENT 'precedence in category (1-based)',
  `description` varchar(500) DEFAULT NULL,
  `popup` varchar(500) DEFAULT NULL COMMENT 'the url to the product page',
  `initial_price` decimal(18,4) DEFAULT NULL,
  `discount` decimal(18,4) DEFAULT NULL COMMENT 'discount amount',
  `price` decimal(18,4) DEFAULT NULL COMMENT 'price (no shipping)',
  `shipping` decimal(18,4) DEFAULT NULL COMMENT 'shipping and handling',
  `final_price` decimal(18,4) NOT NULL COMMENT 'final price (include shipping)',
  `globalPrecedence` int(11) DEFAULT NULL COMMENT 'global precedence (1-based)',
  PRIMARY KEY (`product_id`),
  KEY `category_id_idx` (`category_id`),
  CONSTRAINT `category_id` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `products_in_orders` (
  `id` int(45) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `count` int(11) NOT NULL COMMENT 'the amount of items from this product',
  PRIMARY KEY (`id`),
  CONSTRAINT `order_id` FOREIGN KEY (`id`) REFERENCES `orders` (`order_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `product_id_2` FOREIGN KEY (`id`) REFERENCES `products` (`product_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `roles` (
  `Id` varchar(128) NOT NULL,
  `Name` varchar(256) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `userclaims` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `UserId` varchar(128) NOT NULL,
  `ClaimType` longtext,
  `ClaimValue` longtext,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Id` (`Id`),
  KEY `UserId` (`UserId`),
  CONSTRAINT `ApplicationUser_Claims` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `userlogins` (
  `LoginProvider` varchar(128) NOT NULL,
  `ProviderKey` varchar(128) NOT NULL,
  `UserId` varchar(128) NOT NULL,
  PRIMARY KEY (`LoginProvider`,`ProviderKey`,`UserId`),
  KEY `ApplicationUser_Logins` (`UserId`),
  CONSTRAINT `ApplicationUser_Logins` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `userroles` (
  `UserId` varchar(128) NOT NULL,
  `RoleId` varchar(128) NOT NULL,
  PRIMARY KEY (`UserId`,`RoleId`),
  KEY `IdentityRole_Users` (`RoleId`),
  CONSTRAINT `ApplicationUser_Roles` FOREIGN KEY (`UserId`) REFERENCES `users` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `IdentityRole_Users` FOREIGN KEY (`RoleId`) REFERENCES `roles` (`Id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `Id` varchar(128) NOT NULL,
  `Email` varchar(256) DEFAULT NULL,
  `EmailConfirmed` tinyint(1) NOT NULL,
  `PasswordHash` longtext,
  `SecurityStamp` longtext,
  `PhoneNumber` longtext,
  `PhoneNumberConfirmed` tinyint(1) NOT NULL,
  `TwoFactorEnabled` tinyint(1) NOT NULL,
  `LockoutEndDateUtc` datetime DEFAULT NULL,
  `LockoutEnabled` tinyint(1) NOT NULL,
  `AccessFailedCount` int(11) NOT NULL,
  `UserName` varchar(256) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `voucher_grants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `voucher_id` int(11) NOT NULL,
  `worker_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `company_id_3_idx` (`company_id`),
  KEY `worker_id_2_idx` (`worker_id`),
  KEY `voucher_id_idx` (`voucher_id`),
  CONSTRAINT `company_id_3` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `voucher_id` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`voucher_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `worker_id_2` FOREIGN KEY (`worker_id`) REFERENCES `workers` (`worker_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='holds all the grant-requests for voucehrs from companies to workers';

CREATE TABLE `voucher_requests` (
  `voucher_request_id` int(11) NOT NULL AUTO_INCREMENT,
  `worker_id` int(11) NOT NULL,
  `voucher_id` int(11) NOT NULL,
  `request_date` datetime NOT NULL,
  PRIMARY KEY (`voucher_request_id`),
  KEY `worker_id_4_idx` (`worker_id`),
  KEY `voucher_id_4_idx` (`voucher_id`),
  CONSTRAINT `voucher_id_4` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`voucher_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `worker_id_4` FOREIGN KEY (`worker_id`) REFERENCES `workers` (`worker_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='requests of the workers for vouchers';

CREATE TABLE `vouchers` (
  `voucher_id` int(11) NOT NULL AUTO_INCREMENT,
  `image` varchar(500) DEFAULT NULL,
  `valid_start_date` datetime NOT NULL,
  `valid_end_date` datetime DEFAULT NULL,
  `description` varchar(1500) NOT NULL,
  `active` bit(1) NOT NULL DEFAULT b'1',
  `last_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`voucher_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `worker_settings` (
  `setting_id` int(11) NOT NULL AUTO_INCREMENT,
  `worker_id` int(11) NOT NULL,
  `setting_key` varchar(150) NOT NULL,
  `settings_value` varchar(500) NOT NULL,
  `last_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`setting_id`),
  KEY `worker_id_fk1_idx` (`worker_id`),
  CONSTRAINT `worker_id_fk1` FOREIGN KEY (`worker_id`) REFERENCES `workers` (`worker_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `workers` (
  `worker_id` int(11) NOT NULL AUTO_INCREMENT,
  `identity_user_id` varchar(128) NOT NULL,
  `company_id` int(11) NOT NULL,
  `id_number` varchar(50) DEFAULT NULL COMMENT 'SET PRELMINARILY; worker may NOT update it.',
  `first_name` varchar(150) NOT NULL COMMENT 'SET PRELMINARILY; worker may update it.',
  `last_name` varchar(150) NOT NULL COMMENT 'SET PRELMINARILY; worker may update it.',
  `email` varchar(150) NOT NULL COMMENT 'SET PRELMINARILY; worker may NOT update it.',
  `phone_number` varchar(50) NOT NULL COMMENT 'SET PRELMINARILY; worker may NOT update it.',
  `worker_number` varchar(50) DEFAULT NULL COMMENT 'The internal worker number in the company.',
  `active` bit(1) DEFAULT b'1' COMMENT 'whether the record is active',
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'the last update time for the record',
  `registered` bit(1) DEFAULT b'0' COMMENT 'whether the worker has registered',
  `register_date` datetime DEFAULT NULL COMMENT 'the time the worker has registered (null at the beginning)',
  PRIMARY KEY (`worker_id`),
  UNIQUE KEY `identity_user_id_UNIQUE` (`identity_user_id`),
  KEY `company_id_idx` (`company_id`),
  CONSTRAINT `company_id` FOREIGN KEY (`company_id`) REFERENCES `companies` (`company_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `user_id_2` FOREIGN KEY (`identity_user_id`) REFERENCES `users` (`Id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
