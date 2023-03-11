/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE TABLE `book-account` (
  `accountNum` bigint(10) NOT NULL,
  `citizenId` varchar(13) NOT NULL,
  `booktypeID` tinyint(4) NOT NULL DEFAULT '1',
  `balance` double NOT NULL DEFAULT '500',
  PRIMARY KEY (`accountNum`),
  KEY `booktypeID` (`booktypeID`),
  KEY `citizenId` (`citizenId`),
  CONSTRAINT `book-account_ibfk_1` FOREIGN KEY (`citizenId`) REFERENCES `customer-identification` (`citizenId`) ON DELETE CASCADE,
  CONSTRAINT `book-account_ibfk_2` FOREIGN KEY (`booktypeID`) REFERENCES `book-type` (`booktypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `book-type` (
  `booktypeID` tinyint(4) NOT NULL,
  `accountType` varchar(20) NOT NULL,
  `interestRate` float NOT NULL,
  PRIMARY KEY (`booktypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `card-subscription` (
  `cardId` bigint(16) NOT NULL,
  `subProductId` varchar(15) NOT NULL,
  PRIMARY KEY (`cardId`,`subProductId`),
  KEY `cardId` (`cardId`),
  KEY `subProductId` (`subProductId`),
  CONSTRAINT `card-Subscription_ibfk_1` FOREIGN KEY (`cardId`) REFERENCES `customer-card` (`cardId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `card-Subscription_ibfk_2` FOREIGN KEY (`subProductId`) REFERENCES `subscription-product` (`subProductId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `card-type` (
  `cardTypeId` tinyint(4) NOT NULL,
  `cardType` varchar(20) NOT NULL,
  `creditInterest` float DEFAULT NULL,
  `monthlyLimit` float NOT NULL,
  PRIMARY KEY (`cardTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `category-type` (
  `categoryId` int(11) NOT NULL AUTO_INCREMENT,
  `category` text NOT NULL,
  PRIMARY KEY (`categoryId`),
  UNIQUE KEY `categoryId` (`categoryId`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

CREATE TABLE `credit-card-transaction` (
  `transactionId` int(15) NOT NULL AUTO_INCREMENT,
  `fromCreditCardId` bigint(20) NOT NULL,
  `toAccount` bigint(20) NOT NULL DEFAULT '9999999999',
  `value` float NOT NULL,
  `dateAndTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `note` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `categoryId` int(11) NOT NULL DEFAULT '10',
  `transactionTypeId` tinyint(4) NOT NULL,
  `PaymentDueDate` date NOT NULL,
  `InstallmentPlan` float NOT NULL,
  `Interest` float NOT NULL,
  PRIMARY KEY (`transactionId`),
  UNIQUE KEY `transactionId` (`transactionId`),
  KEY `formCreditCardId` (`fromCreditCardId`),
  KEY `toAccount` (`toAccount`),
  KEY `transactionTypeId` (`transactionTypeId`),
  KEY `credit-Card-Transaction_ibfk_4_idx` (`categoryId`),
  CONSTRAINT `credit-Card-Transaction_ibfk_1` FOREIGN KEY (`toAccount`) REFERENCES `book-account` (`accountNum`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `credit-Card-Transaction_ibfk_2` FOREIGN KEY (`transactionTypeId`) REFERENCES `transaction-type` (`transactionTypeID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `credit-Card-Transaction_ibfk_3` FOREIGN KEY (`fromCreditCardId`) REFERENCES `customer-card` (`cardId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `credit-Card-Transaction_ibfk_4` FOREIGN KEY (`categoryId`) REFERENCES `category-type` (`categoryId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8;

CREATE TABLE `currency-exchange-transaction` (
  `transactionId` int(15) NOT NULL AUTO_INCREMENT,
  `citizenId` varchar(13) NOT NULL,
  `fromCurrency` varchar(5) NOT NULL,
  `toCurrency` varchar(5) NOT NULL,
  `value` float NOT NULL,
  `dateAndTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `note` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `rate` float NOT NULL,
  `fee` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`transactionId`),
  UNIQUE KEY `transactionId` (`transactionId`),
  KEY `citizenId` (`citizenId`),
  KEY `toCurrency` (`fromCurrency`),
  KEY `citizenId_3` (`citizenId`),
  KEY `toAccount` (`toCurrency`),
  KEY `toCurrency_2` (`fromCurrency`),
  KEY `toAccount_2` (`toCurrency`),
  CONSTRAINT `currency-Exchange-Transaction_ibfk_1` FOREIGN KEY (`citizenId`) REFERENCES `customer-identification` (`citizenId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `currency-Exchange-Transaction_ibfk_2` FOREIGN KEY (`fromCurrency`) REFERENCES `currency-information` (`currencyID`) ON UPDATE CASCADE,
  CONSTRAINT `currency-Exchange-Transaction_ibfk_3` FOREIGN KEY (`toCurrency`) REFERENCES `currency-information` (`currencyID`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8;

CREATE TABLE `currency-information` (
  `currencyID` varchar(5) NOT NULL,
  `countryName` text,
  `currencyFullname` text NOT NULL,
  PRIMARY KEY (`currencyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `customer-card` (
  `cardId` bigint(16) NOT NULL,
  `accountNum` bigint(10) NOT NULL,
  `cvv` int(3) NOT NULL,
  `cardTypeId` tinyint(4) NOT NULL DEFAULT '1',
  `registerDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `currentLimit` float NOT NULL DEFAULT '5000',
  PRIMARY KEY (`cardId`),
  KEY `accountNum` (`accountNum`),
  KEY `cardType` (`cardTypeId`),
  CONSTRAINT `customer-Card_ibfk_1` FOREIGN KEY (`accountNum`) REFERENCES `book-account` (`accountNum`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `customer-Card_ibfk_2` FOREIGN KEY (`cardTypeId`) REFERENCES `card-type` (`cardTypeId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `customer-identification` (
  `citizenId` varchar(13) NOT NULL,
  `prefix` varchar(8) NOT NULL,
  `fName` varchar(20) NOT NULL,
  `lName` varchar(20) NOT NULL,
  `dob` date NOT NULL,
  `gender` varchar(10) NOT NULL,
  `password` text NOT NULL,
  `pin` varchar(6) NOT NULL,
  `phoneNumber` varchar(10) NOT NULL,
  `address` text NOT NULL,
  `email` text NOT NULL,
  `kycStatus` tinyint(1) NOT NULL DEFAULT '0',
  `role` varchar(20) NOT NULL DEFAULT 'User',
  PRIMARY KEY (`citizenId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `customer's-foreign-currencies` (
  `citizenId` varchar(13) NOT NULL,
  `currencyId` varchar(5) NOT NULL,
  `balanceCurrency` double NOT NULL,
  PRIMARY KEY (`citizenId`,`currencyId`),
  KEY `citizenId` (`citizenId`),
  KEY `currencyAbb` (`currencyId`),
  CONSTRAINT `customer's-Foreign-Currencies_ibfk_1` FOREIGN KEY (`citizenId`) REFERENCES `customer-identification` (`citizenId`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `customer's-Foreign-Currencies_ibfk_2` FOREIGN KEY (`currencyId`) REFERENCES `currency-information` (`currencyID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `subscription-product` (
  `subProductId` varchar(15) NOT NULL,
  `productName` text NOT NULL,
  `monthlyPay` float NOT NULL,
  PRIMARY KEY (`subProductId`),
  UNIQUE KEY `subProductId` (`subProductId`),
  UNIQUE KEY `subProductId_2` (`subProductId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `transaction` (
  `transactionId` int(15) NOT NULL AUTO_INCREMENT,
  `fromAccount` bigint(20) NOT NULL,
  `toAccount` bigint(20) NOT NULL,
  `value` float NOT NULL,
  `dateAndTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `note` text CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `categoryId` int(11) NOT NULL DEFAULT '13',
  `transactionTypeId` tinyint(4) NOT NULL,
  PRIMARY KEY (`transactionId`),
  UNIQUE KEY `transactionId` (`transactionId`),
  KEY `formAccount` (`fromAccount`),
  KEY `toAccount` (`toAccount`),
  KEY `transactionTypeId` (`transactionTypeId`),
  KEY `categoryId` (`categoryId`),
  CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`fromAccount`) REFERENCES `book-account` (`accountNum`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`toAccount`) REFERENCES `book-account` (`accountNum`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `transaction_ibfk_3` FOREIGN KEY (`categoryId`) REFERENCES `category-type` (`categoryId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `transaction_ibfk_4` FOREIGN KEY (`transactionTypeId`) REFERENCES `transaction-type` (`transactionTypeID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1024 DEFAULT CHARSET=utf8;

CREATE TABLE `transaction-type` (
  `transactionTypeID` tinyint(4) NOT NULL,
  `transactionType` text NOT NULL,
  `fromCompany` varchar(10) NOT NULL,
  `toCompany` varchar(10) NOT NULL,
  `fee` float NOT NULL,
  PRIMARY KEY (`transactionTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `book-account` (`accountNum`, `citizenId`, `booktypeID`, `balance`) VALUES
(282827374, '1111199887213', 1, 287);
INSERT INTO `book-account` (`accountNum`, `citizenId`, `booktypeID`, `balance`) VALUES
(525497900, '9823128789523', 1, 1);
INSERT INTO `book-account` (`accountNum`, `citizenId`, `booktypeID`, `balance`) VALUES
(3454416723, '5555555555555', 1, 572);
INSERT INTO `book-account` (`accountNum`, `citizenId`, `booktypeID`, `balance`) VALUES
(5210073395, '1234567891011', 1, 70),
(5463210259, '1100987654321', 1, 53),
(7391022785, '2958602938529', 1, 185),
(7413695233, '1100987654321', 2, 0),
(7654898756, '1100987654321', 1, 578),
(8310604189, '1101901152460', 1, 230),
(9899038820, '9999999929991', 1, 375),
(9999999999, '9999999999999', 3, 10001246);

INSERT INTO `book-type` (`booktypeID`, `accountType`, `interestRate`) VALUES
(1, 'Saving Account', 0.25);
INSERT INTO `book-type` (`booktypeID`, `accountType`, `interestRate`) VALUES
(2, 'current account', 0);
INSERT INTO `book-type` (`booktypeID`, `accountType`, `interestRate`) VALUES
(3, 'Bank', 0);

INSERT INTO `card-subscription` (`cardId`, `subProductId`) VALUES
(3806135282749345, 'WeTV67928736452');
INSERT INTO `card-subscription` (`cardId`, `subProductId`) VALUES
(6323062414631138, '154296299885617');
INSERT INTO `card-subscription` (`cardId`, `subProductId`) VALUES
(6323062414631138, '789643557602527');
INSERT INTO `card-subscription` (`cardId`, `subProductId`) VALUES
(6738976542536784, 'FTTV76352987463'),
(6738976542536784, 'GA8925346745267'),
(6738976542536784, 'GG8329876542145'),
(6738976542536784, 'IQY890254309876'),
(6738976542536784, 'ST8298342156000'),
(6738976542536784, 'WeTV67928736452'),
(7785423688762135, 'WeTV67928736452'),
(9965423345112236, '631546266534842'),
(9965423345112236, 'WeTV67928736452');

INSERT INTO `card-type` (`cardTypeId`, `cardType`, `creditInterest`, `monthlyLimit`) VALUES
(1, 'Bronze', 5, 5000);
INSERT INTO `card-type` (`cardTypeId`, `cardType`, `creditInterest`, `monthlyLimit`) VALUES
(2, 'Silver', 7, 10000);
INSERT INTO `card-type` (`cardTypeId`, `cardType`, `creditInterest`, `monthlyLimit`) VALUES
(3, 'Gold', 9, 50000);
INSERT INTO `card-type` (`cardTypeId`, `cardType`, `creditInterest`, `monthlyLimit`) VALUES
(4, 'Platinum', 11, 100000),
(5, 'Diamond', 13, 250000);

INSERT INTO `category-type` (`categoryId`, `category`) VALUES
(1, 'Shopping');
INSERT INTO `category-type` (`categoryId`, `category`) VALUES
(2, 'Food & Drinks');
INSERT INTO `category-type` (`categoryId`, `category`) VALUES
(3, 'Entertainment');
INSERT INTO `category-type` (`categoryId`, `category`) VALUES
(4, 'Family & Personal'),
(5, 'Saving & Investment'),
(6, 'Auto & Transport'),
(7, 'Hotel & Travel'),
(8, 'Gift & Donation'),
(9, 'Bill & Utilities'),
(10, 'Others');

INSERT INTO `credit-card-transaction` (`transactionId`, `fromCreditCardId`, `toAccount`, `value`, `dateAndTime`, `note`, `categoryId`, `transactionTypeId`, `PaymentDueDate`, `InstallmentPlan`, `Interest`) VALUES
(4, 6738976542536784, 9999999999, 100, '2022-05-15 18:27:48', '', 1, 10, '2024-05-17', 5, 15);
INSERT INTO `credit-card-transaction` (`transactionId`, `fromCreditCardId`, `toAccount`, `value`, `dateAndTime`, `note`, `categoryId`, `transactionTypeId`, `PaymentDueDate`, `InstallmentPlan`, `Interest`) VALUES
(14, 9683718066103282, 9999999999, 100, '2022-05-15 20:39:02', 'kiki', 1, 10, '2024-05-17', 5, 15);
INSERT INTO `credit-card-transaction` (`transactionId`, `fromCreditCardId`, `toAccount`, `value`, `dateAndTime`, `note`, `categoryId`, `transactionTypeId`, `PaymentDueDate`, `InstallmentPlan`, `Interest`) VALUES
(24, 9965423345112236, 9999999999, 11, '2022-05-16 05:10:55', '', 1, 10, '2024-05-17', 5, 15);
INSERT INTO `credit-card-transaction` (`transactionId`, `fromCreditCardId`, `toAccount`, `value`, `dateAndTime`, `note`, `categoryId`, `transactionTypeId`, `PaymentDueDate`, `InstallmentPlan`, `Interest`) VALUES
(34, 7785423688762135, 9999999999, 1, '2022-05-16 06:47:50', '', 10, 10, '2024-05-17', 5, 15),
(44, 9965423345112236, 9999999999, 1000, '2022-05-16 07:11:00', 'ซื้อให้คุณแม่', 1, 10, '2024-05-17', 5, 15),
(54, 9137173528446080, 9999999999, 800, '2022-05-16 07:25:26', '', 1, 10, '2024-05-17', 5, 15),
(64, 6323062414631138, 9999999999, 90, '2022-05-16 09:56:23', 'ซื้อรองเท้า', 1, 10, '2024-05-17', 5, 15),
(74, 3806135282749345, 9999999999, 100, '2022-05-16 10:20:03', 'ซื้อรองเท้า', 1, 10, '2024-05-17', 5, 15);

INSERT INTO `currency-exchange-transaction` (`transactionId`, `citizenId`, `fromCurrency`, `toCurrency`, `value`, `dateAndTime`, `note`, `rate`, `fee`) VALUES
(4, '1234567891011', 'THB', 'USD', 320, '2022-05-15 20:43:16', 'Exchange from THB to USD', 9.2032, 0);
INSERT INTO `currency-exchange-transaction` (`transactionId`, `citizenId`, `fromCurrency`, `toCurrency`, `value`, `dateAndTime`, `note`, `rate`, `fee`) VALUES
(14, '1234567891011', 'USD', 'THB', 9.1, '2022-05-15 20:44:04', 'Exchange from USD to THB', 316.41, 0);
INSERT INTO `currency-exchange-transaction` (`transactionId`, `citizenId`, `fromCurrency`, `toCurrency`, `value`, `dateAndTime`, `note`, `rate`, `fee`) VALUES
(24, '1234567891011', 'THB', 'USD', 10, '2022-05-15 20:49:15', 'Exchange from THB to USD', 0.2876, 0);
INSERT INTO `currency-exchange-transaction` (`transactionId`, `citizenId`, `fromCurrency`, `toCurrency`, `value`, `dateAndTime`, `note`, `rate`, `fee`) VALUES
(34, '1234567891011', 'THB', 'USD', 299.1, '2022-05-15 20:49:55', 'Exchange from THB to USD', 8.6024, 0),
(44, '1100987654321', 'THB', 'AUD', 100, '2022-05-15 20:56:58', 'Exchange from THB to AUD', 4.1726, 0),
(54, '1100987654321', 'AUD', 'USD', 1, '2022-05-16 05:08:57', 'Exchange from AUD to USD', 0.68925, 0),
(64, '1111199887213', 'THB', 'EUR', 99, '2022-05-16 06:33:14', 'Exchange from THB to EUR', 2.7417, 0),
(74, '5555555555555', 'THB', 'USD', 49, '2022-05-16 06:50:42', 'Exchange from THB to USD', 1.4092, 0),
(84, '1100987654321', 'AUD', 'JPY', 1, '2022-05-16 07:11:54', 'Exchange from AUD to JPY', 88.88, 0),
(94, '1111199887213', 'THB', 'JPY', 90, '2022-05-16 09:51:02', 'Exchange from THB to JPY', 333.77, 0),
(104, '9999999929991', 'THB', 'EUR', 80, '2022-05-16 09:58:14', 'Exchange from THB to EUR', 2.2155, 0),
(114, '9823128789523', 'THB', 'GBP', 90, '2022-05-16 10:22:33', 'Exchange from THB to GBP', 2.1215, 0),
(124, '1101901152460', 'THB', 'GBP', 120, '2022-05-16 10:54:56', 'Exchange from THB to GBP', 2.8287, 0),
(134, '9823128789523', 'GBP', 'USD', 2, '2022-05-16 10:56:27', 'Exchange from GBP to USD', 2.4402, 0);

INSERT INTO `currency-information` (`currencyID`, `countryName`, `currencyFullname`) VALUES
('AUD', 'Australia', 'Australian Dollar');
INSERT INTO `currency-information` (`currencyID`, `countryName`, `currencyFullname`) VALUES
('BGN', 'Bulgaria', 'Bulgarian Lev');
INSERT INTO `currency-information` (`currencyID`, `countryName`, `currencyFullname`) VALUES
('BRL', 'Brazil', 'Brazilian Real');
INSERT INTO `currency-information` (`currencyID`, `countryName`, `currencyFullname`) VALUES
('CAD', 'Canada', 'Canadian Dollar'),
('CHF', 'Switzerland', 'Swiss Franc'),
('CNY', 'China', 'Chinese Renminbi Yuan'),
('CZK', 'Czechia', 'Czech Koruna'),
('DKK', 'Denmark', 'Danish Krone'),
('EUR', 'European Union', 'Euro'),
('GBP', 'United Kingdom', 'British Pound'),
('HKD', 'Hong Kong', 'Hong Kong Dollar'),
('HRK', 'Croatia', 'Croatian Kuna'),
('HUF', 'Hungary', 'Hungarian Forint'),
('IDR', 'Indonesia', 'Indonesian Rupiah'),
('ILS', 'Israel', 'Israeli New Sheqel'),
('INR', 'India', 'Indian Rupee'),
('ISK', 'Iceland', 'Icelandic Króna'),
('JPY', 'Japan', 'Japanese Yen'),
('KRW', 'South Korean', 'South Korean Won'),
('MXN', 'Mexico', 'Mexican Peso'),
('MYR', 'Malaysia', 'Malaysian Ringgit'),
('NOK', 'Norway', 'Norwegian Krone'),
('NZD', 'New Zealand', 'New Zealand Dollar'),
('PHP', 'Philippines', 'Philippine Peso'),
('PLN', 'Poland', 'Polish Złoty'),
('RON', 'Romania', 'Romanian Leu'),
('SEK', 'Sweden', 'Swedish Krona'),
('SGD', 'Singapore ', 'Singapore Dollar'),
('THB', 'Thailand', 'Thai Baht'),
('TRY', 'Turkey', 'Turkish Lira'),
('USD', 'United States', 'United States Dollar'),
('ZAR', 'South African', 'South African Rand');

INSERT INTO `customer-card` (`cardId`, `accountNum`, `cvv`, `cardTypeId`, `registerDate`, `currentLimit`) VALUES
(2709975095700998, 282827374, 220, 1, '2022-05-16 06:29:22', 5000);
INSERT INTO `customer-card` (`cardId`, `accountNum`, `cvv`, `cardTypeId`, `registerDate`, `currentLimit`) VALUES
(3452314518306054, 8310604189, 711, 1, '2022-05-15 20:15:06', 5000);
INSERT INTO `customer-card` (`cardId`, `accountNum`, `cvv`, `cardTypeId`, `registerDate`, `currentLimit`) VALUES
(3806135282749345, 525497900, 998, 1, '2022-05-16 10:20:02', 4900);
INSERT INTO `customer-card` (`cardId`, `accountNum`, `cvv`, `cardTypeId`, `registerDate`, `currentLimit`) VALUES
(6323062414631138, 9899038820, 435, 1, '2022-05-16 09:56:22', 4910),
(6738976542536784, 7654898756, 894, 1, '2022-05-15 18:27:48', 688),
(7785423688762135, 3454416723, 489, 1, '2022-05-16 06:47:49', 4999),
(9137173528446080, 7391022785, 142, 1, '2022-05-16 07:25:26', 4200),
(9683718066103282, 5210073395, 439, 1, '2022-05-15 20:39:01', 4900),
(9965423345112236, 5463210259, 203, 3, '2022-05-16 07:11:00', 48989),
(9965423345712366, 5463210259, 751, 5, '2022-05-15 22:28:43', 250000);

INSERT INTO `customer-identification` (`citizenId`, `prefix`, `fName`, `lName`, `dob`, `gender`, `password`, `pin`, `phoneNumber`, `address`, `email`, `kycStatus`, `role`) VALUES
('1100987654321', 'Ms', 'Peeraya', 'Khantaruangsakul', '2002-02-19', 'W', 'aimlnwza555+', '439210', '0929574869', '291 Taksin19 Taksin Samrae Thonbiri Bangkok 10600', 'wangaim@hotmail.com', 1, 'User');
INSERT INTO `customer-identification` (`citizenId`, `prefix`, `fName`, `lName`, `dob`, `gender`, `password`, `pin`, `phoneNumber`, `address`, `email`, `kycStatus`, `role`) VALUES
('1101901152460', 'M', 'Adam', 'Smith', '2006-06-16', 'M', 'ballball', '445885', '0954484747', '225 samrae taksin 19 bangkok 10600', 'ball@angel.com', 1, 'User');
INSERT INTO `customer-identification` (`citizenId`, `prefix`, `fName`, `lName`, `dob`, `gender`, `password`, `pin`, `phoneNumber`, `address`, `email`, `kycStatus`, `role`) VALUES
('1111199887213', 'M', 'Hello', 'Test', '2021-06-01', 'U', 'hello', '999999', '13', '12', 'hello@gmail.com', 1, 'User');
INSERT INTO `customer-identification` (`citizenId`, `prefix`, `fName`, `lName`, `dob`, `gender`, `password`, `pin`, `phoneNumber`, `address`, `email`, `kycStatus`, `role`) VALUES
('1234567891011', 'M', 'Junkai', 'Wang', '1999-09-21', 'M', 'Wangzaza111', '210999', '0998765678', 'China, Chongqing', 'Wangjunkai0921@gmail.com', 1, 'User'),
('2958602938529', 'M', 'S', 'C', '2000-09-27', 'U', 'jkl;\'', '039423', '0293849584', 'qwes', 'asdfgh@hotmail.com', 1, 'User'),
('5555555555555', 'M', 'MyFriend', 'Project', '2017-05-17', 'M', '12345678910', '123456', '0950000000', '49/499', 'kaopainaihuajai@ff.com', 1, 'User'),
('9823128789523', 'M', 'Sittinon', 'Present', '2022-01-07', 'M', 'sittinon', '999999', '0099123123', 'Baaan', 'sittinon@gmail.com', 1, 'User'),
('9999999929991', 'Ms', 'Ball2', 'Ball3', '2022-05-05', 'W', 'hello555', '999999', '99999123', 'Barn', 'Hello555@gmail.com', 1, 'User'),
('9999999999999', '-', 'Angel', 'Bank', '2002-02-14', 'U', 'P@ssword555!', '070501', '0888888888', 'KMUTT', 'FallenAngel@angel.com', 1, 'Admin'),
('Admin1', '-', 'Admin1', 'CPE', '2022-05-01', 'U', 'P@ssw0rd1', '-', '-', '-', 'Admin1@admin.com', 1, 'Admin'),
('Admin2', '-', 'Admin2', 'CPE', '2022-05-16', 'U', 'P@ssw0rd2', '-', '-', '-', 'Admin2@admin.com', 1, 'Admin'),
('Coordinator1', '-', 'Coordinator1', 'CPE', '2022-05-01', 'U', 'P@ssw0rd1', '-', '-', '-', 'Coordinator1@coordinator.com', 1, 'Coordinator');

INSERT INTO `customer's-foreign-currencies` (`citizenId`, `currencyId`, `balanceCurrency`) VALUES
('1100987654321', 'AUD', 2.1726);
INSERT INTO `customer's-foreign-currencies` (`citizenId`, `currencyId`, `balanceCurrency`) VALUES
('1100987654321', 'JPY', 88.88);
INSERT INTO `customer's-foreign-currencies` (`citizenId`, `currencyId`, `balanceCurrency`) VALUES
('1100987654321', 'THB', 140);
INSERT INTO `customer's-foreign-currencies` (`citizenId`, `currencyId`, `balanceCurrency`) VALUES
('1100987654321', 'USD', 0.68925),
('1101901152460', 'GBP', 2.8287),
('1101901152460', 'THB', 80),
('1111199887213', 'EUR', 0.7416999999999998),
('1111199887213', 'JPY', 333.77),
('1111199887213', 'THB', 10.741699999999994),
('1234567891011', 'THB', 10),
('1234567891011', 'USD', 0.10320000000000107),
('2958602938529', 'THB', 200),
('5555555555555', 'THB', 1),
('5555555555555', 'USD', 1.4092),
('9823128789523', 'GBP', 0.12150000000000016),
('9823128789523', 'THB', 30),
('9823128789523', 'USD', 2.4402),
('9999999929991', 'EUR', 2.2155),
('9999999929991', 'THB', 20);

INSERT INTO `subscription-product` (`subProductId`, `productName`, `monthlyPay`) VALUES
('131258795461157', 'CPE', 100);
INSERT INTO `subscription-product` (`subProductId`, `productName`, `monthlyPay`) VALUES
('154296299885617', 'Swimming pool', 20);
INSERT INTO `subscription-product` (`subProductId`, `productName`, `monthlyPay`) VALUES
('340371151067846', 'aim ลบ', 50);
INSERT INTO `subscription-product` (`subProductId`, `productName`, `monthlyPay`) VALUES
('434165116177114', 'Gym', 125),
('56735628879553', 'aim ลบ 2', 50),
('582395408094585', 'Gym 3', 90),
('631546266534842', 'Apple', 790),
('683676678224497', 'Swm2', 30),
('710102494510680', 'Swm1', 25),
('717052233293348', 'CPE231', 500),
('789643557602527', 'iStudio', 500),
('808737999900053', 'CPE2', 120),
('832895311051622', 'Sumsung', 450),
('FTTV76352987463', 'Football TV', 180),
('GA8925346745267', 'Garena', 325),
('GG8329876542145', 'Google', 100),
('IQY890254309876', 'IQIYI', 159),
('NF6729876302987', 'Netflix', 279),
('ROY751292791047', 'Roy6', 660),
('ST8298342156000', 'Stream', 80),
('WeTV67928736452', 'WeTV', 99),
('YT2465427980700', 'Youtube', 299);

INSERT INTO `transaction` (`transactionId`, `fromAccount`, `toAccount`, `value`, `dateAndTime`, `note`, `categoryId`, `transactionTypeId`) VALUES
(1, 9999999999, 7654898756, 1500, '2022-05-15 17:38:36', 'Create book', 10, 5);
INSERT INTO `transaction` (`transactionId`, `fromAccount`, `toAccount`, `value`, `dateAndTime`, `note`, `categoryId`, `transactionTypeId`) VALUES
(574, 7654898756, 9999999999, 1, '2022-05-15 17:44:53', 'ค่าเสื้อผ้า1', 1, 5);
INSERT INTO `transaction` (`transactionId`, `fromAccount`, `toAccount`, `value`, `dateAndTime`, `note`, `categoryId`, `transactionTypeId`) VALUES
(584, 7654898756, 9999999999, 100, '2022-05-15 18:10:07', '1', 2, 5);
INSERT INTO `transaction` (`transactionId`, `fromAccount`, `toAccount`, `value`, `dateAndTime`, `note`, `categoryId`, `transactionTypeId`) VALUES
(594, 7654898756, 9999999999, 88, '2022-05-15 18:10:41', '1', 1, 5),
(604, 7654898756, 9999999999, 111, '2022-05-15 18:12:51', '', 1, 5),
(614, 7654898756, 9999999999, 555, '2022-05-15 18:13:45', '', 2, 5),
(624, 7654898756, 9999999999, 12, '2022-05-15 18:14:03', '', 10, 5),
(634, 7654898756, 9999999999, 55, '2022-05-15 18:15:22', '', 10, 5),
(644, 9999999999, 8310604189, 500, '2022-05-15 20:14:55', 'Create book', 10, 5),
(654, 8310604189, 7654898756, 200, '2022-05-15 20:16:47', 'transfer to wangaim', 3, 5),
(664, 9999999999, 5210073395, 500, '2022-05-15 20:28:50', 'Create book', 10, 5),
(674, 5210073395, 8310604189, 100, '2022-05-16 10:41:30', 'hi', 4, 5),
(684, 8310604189, 5210073395, 20, '2022-05-15 20:32:54', '', 10, 5),
(694, 5210073395, 9999999999, 350, '2022-05-15 20:41:46', 'go go', 10, 14),
(704, 9999999999, 5463210259, 500, '2022-05-15 21:13:09', 'Create book', 10, 5),
(714, 9999999999, 7413695233, 2000, '2022-05-15 21:15:16', 'Create book', 10, 5),
(724, 7413695233, 5463210259, 100, '2022-05-15 22:06:47', 'ให้นะจ๊ะ', 5, 5),
(734, 5463210259, 7413695233, 50, '2022-05-15 22:27:38', 'ต่าขนมนะจ๊ะ', 3, 5),
(744, 7413695233, 5463210259, 50, '2022-05-15 22:28:40', 'กินข้าว', 2, 5),
(754, 5463210259, 9999999999, 12, '2022-05-16 05:38:26', '', 10, 5),
(764, 5463210259, 9999999999, 22, '2022-05-16 05:45:21', '', 10, 5),
(774, 5463210259, 9999999999, 1, '2022-05-16 05:51:46', '', 10, 5),
(784, 9999999999, 282827374, 500, '2022-05-16 06:29:22', 'Create book', 10, 5),
(794, 282827374, 9999999999, 12, '2022-05-16 06:31:19', '1', 1, 5),
(804, 282827374, 9999999999, 100, '2022-05-16 06:32:04', '', 5, 14),
(814, 9999999999, 3454416723, 500, '2022-05-16 06:34:09', 'Create book', 10, 5),
(824, 3454416723, 9999999999, 50, '2022-05-16 06:42:21', '', 4, 14),
(834, 282827374, 9999999999, 1, '2022-05-16 06:49:13', '', 1, 5),
(844, 9999999999, 7391022785, 500, '2022-05-16 07:18:50', 'Create book', 10, 5),
(854, 7391022785, 3454416723, 27, '2022-05-16 07:24:17', '', 5, 5),
(864, 7391022785, 3454416723, 80, '2022-05-16 07:24:30', '', 3, 5),
(874, 7391022785, 9999999999, 200, '2022-05-16 07:26:36', '', 10, 14),
(884, 7391022785, 3454416723, 15, '2022-05-16 07:43:04', '', 5, 5),
(894, 282827374, 9999999999, 100, '2022-05-16 09:50:47', '', 10, 14),
(904, 9999999999, 9899038820, 500, '2022-05-16 09:52:59', 'Create book', 10, 5),
(914, 9899038820, 9999999999, 25, '2022-05-16 09:55:06', 'ค่าเสื้อผ้า1', 1, 5),
(924, 9899038820, 9999999999, 100, '2022-05-16 09:57:24', 'เติมเงิน', 5, 14),
(934, 9999999999, 525497900, 500, '2022-05-16 10:15:35', 'Create book', 10, 5),
(944, 525497900, 8310604189, 50, '2022-05-16 10:18:33', 'ค่าเสื้อผ้า 50 บาท', 1, 5),
(954, 525497900, 9999999999, 120, '2022-05-16 10:21:31', 'เติมเงิน', 5, 14),
(964, 525497900, 9999999999, 111, '2022-05-16 10:50:44', '', 10, 5),
(974, 525497900, 9999999999, 11, '2022-05-16 10:51:10', '', 10, 5),
(984, 525497900, 9999999999, 12, '2022-05-16 10:51:29', '', 10, 5),
(994, 525497900, 9999999999, 96, '2022-05-16 10:51:49', '', 10, 5),
(1004, 525497900, 9999999999, 22, '2022-05-16 10:52:06', '', 10, 5),
(1014, 8310604189, 9999999999, 200, '2022-05-16 10:53:24', '', 4, 14);

INSERT INTO `transaction-type` (`transactionTypeID`, `transactionType`, `fromCompany`, `toCompany`, `fee`) VALUES
(1, 'top-up', 'angelAcc', 'trueWallet', 0);
INSERT INTO `transaction-type` (`transactionTypeID`, `transactionType`, `fromCompany`, `toCompany`, `fee`) VALUES
(2, 'top-up', 'angelAcc', 'shopeePay', 0);
INSERT INTO `transaction-type` (`transactionTypeID`, `transactionType`, `fromCompany`, `toCompany`, `fee`) VALUES
(3, 'top-up', 'angelAcc', 'easyPass', 0);
INSERT INTO `transaction-type` (`transactionTypeID`, `transactionType`, `fromCompany`, `toCompany`, `fee`) VALUES
(4, 'top-up', 'angelAcc', 'linePay', 0),
(5, 'Transfer', 'angelAcc', 'angleAcc', 0),
(6, 'Transfer', 'angelAcc', 'otherAcc', 0),
(7, 'Transfer', 'angelAcc', 'promptPay', 0),
(8, 'Payment', 'angelAcc', 'utilities', 10),
(9, 'Payment', 'angelAcc', 'internet', 10),
(10, 'PayCredit', 'angelAcc', 'angelBank', 0),
(11, 'Interest', 'angelBank', 'angelAcc', 0),
(12, 'creditCard', 'angelCard', 'Nike', 0),
(13, 'creditCard', 'angelCard', 'adidas', 0),
(14, 'currencyTopUp', 'angelAcc', 'angelBank', 0);


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;