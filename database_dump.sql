-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: pedidos
-- ------------------------------------------------------
-- Server version	5.7.44-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `codigo` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cidade` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `uf` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`codigo`),
  KEY `idx_nome` (`nome`),
  KEY `idx_cidade` (`cidade`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'João Silva Santos','São Paulo','SP','2025-09-15 03:46:03'),(2,'Maria Oliveira Costa','Rio de Janeiro','RJ','2025-09-15 03:46:03'),(3,'Pedro Almeida Souza','Belo Horizonte','MG','2025-09-15 03:46:03'),(4,'Ana Carolina Lima','Salvador','BA','2025-09-15 03:46:03'),(5,'Carlos Eduardo Mendes','Brasília','DF','2025-09-15 03:46:03'),(6,'Fernanda Rodrigues','Curitiba','PR','2025-09-15 03:46:03'),(7,'Roberto Carlos Pereira','Porto Alegre','RS','2025-09-15 03:46:03'),(8,'Juliana Ferreira','Recife','PE','2025-09-15 03:46:03'),(9,'Marcos Antonio Silva','Fortaleza','CE','2025-09-15 03:46:03'),(10,'Luciana Gomes','Goiânia','GO','2025-09-15 03:46:03'),(11,'Rafael Barbosa','Belém','PA','2025-09-15 03:46:03'),(12,'Camila Santos','Manaus','AM','2025-09-15 03:46:03'),(13,'Thiago Martins','Vitória','ES','2025-09-15 03:46:03'),(14,'Patrícia Rocha','São Luís','MA','2025-09-15 03:46:03'),(15,'Daniel Costa','Natal','RN','2025-09-15 03:46:03'),(16,'Larissa Cunha','João Pessoa','PB','2025-09-15 03:46:03'),(17,'Bruno Cardoso','Aracaju','SE','2025-09-15 03:46:03'),(18,'Vanessa Dias','Maceió','AL','2025-09-15 03:46:03'),(19,'Gustavo Ribeiro','Teresina','PI','2025-09-15 03:46:03'),(20,'Priscila Moura','Campo Grande','MS','2025-09-15 03:46:03'),(21,'Rodrigo Lopes','Cuiabá','MT','2025-09-15 03:46:03'),(22,'Bianca Farias','Palmas','TO','2025-09-15 03:46:03'),(23,'Felipe Monteiro','Boa Vista','RR','2025-09-15 03:46:03'),(24,'Carolina Nunes','Macapá','AP','2025-09-15 03:46:03'),(25,'Leonardo Teixeira','Rio Branco','AC','2025-09-15 03:46:03');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `controle_numeracao`
--

DROP TABLE IF EXISTS `controle_numeracao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `controle_numeracao` (
  `tabela` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ultimo_numero` bigint(20) NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`tabela`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `controle_numeracao`
--

LOCK TABLES `controle_numeracao` WRITE;
/*!40000 ALTER TABLE `controle_numeracao` DISABLE KEYS */;
INSERT INTO `controle_numeracao` VALUES ('pedidos',3,'2025-09-16 21:51:45');
/*!40000 ALTER TABLE `controle_numeracao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `numero_pedido` bigint(20) NOT NULL,
  `data_emissao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `codigo_cliente` int(11) NOT NULL,
  `valor_total` decimal(12,2) NOT NULL DEFAULT '0.00',
  `status` enum('ATIVO','CANCELADO') COLLATE utf8mb4_unicode_ci DEFAULT 'ATIVO',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`numero_pedido`),
  KEY `idx_data_emissao` (`data_emissao`),
  KEY `idx_status` (`status`),
  KEY `codigo_cliente` (`codigo_cliente`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`codigo_cliente`) REFERENCES `clientes` (`codigo`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,'2025-09-16 18:51:19',1,2499.99,'ATIVO','2025-09-16 21:51:19'),(2,'2025-09-16 18:51:36',5,6499.95,'ATIVO','2025-09-16 21:51:36'),(3,'2025-09-16 18:51:45',1,24999.90,'CANCELADO','2025-09-16 21:51:45');
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_produtos`
--

DROP TABLE IF EXISTS `pedidos_produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_produtos` (
  `autoincrem` bigint(20) NOT NULL AUTO_INCREMENT,
  `numero_pedido` bigint(20) NOT NULL,
  `codigo_produto` int(11) NOT NULL,
  `quantidade` decimal(10,3) NOT NULL,
  `vlr_unitario` decimal(10,2) NOT NULL,
  `vlr_total` decimal(12,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`autoincrem`),
  KEY `idx_numero_pedido` (`numero_pedido`),
  KEY `idx_codigo_produto` (`codigo_produto`),
  CONSTRAINT `pedidos_produtos_ibfk_1` FOREIGN KEY (`numero_pedido`) REFERENCES `pedidos` (`numero_pedido`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pedidos_produtos_ibfk_2` FOREIGN KEY (`codigo_produto`) REFERENCES `produtos` (`codigo`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_produtos`
--

LOCK TABLES `pedidos_produtos` WRITE;
/*!40000 ALTER TABLE `pedidos_produtos` DISABLE KEYS */;
INSERT INTO `pedidos_produtos` VALUES (1,1,1,1.000,2499.99,2499.99,'2025-09-16 21:51:19'),(2,2,5,5.000,1299.99,6499.95,'2025-09-16 21:51:36'),(3,3,1,10.000,2499.99,24999.90,'2025-09-16 21:51:45');
/*!40000 ALTER TABLE `pedidos_produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `codigo` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `preco_venda` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`codigo`),
  KEY `idx_descricao` (`descricao`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'Notebook Dell Inspiron 15 3000',2499.99,'2025-09-15 03:46:03'),(2,'Mouse Logitech MX Master 3',349.90,'2025-09-15 03:46:03'),(3,'Teclado Mecânico Corsair K70',599.99,'2025-09-15 03:46:03'),(4,'Monitor LG 24 Polegadas Full HD',899.00,'2025-09-15 03:46:03'),(5,'Smartphone Samsung Galaxy A54',1299.99,'2025-09-15 03:46:03'),(6,'Tablet Apple iPad 9ª Geração',2199.00,'2025-09-15 03:46:03'),(7,'Headset Gamer HyperX Cloud II',399.99,'2025-09-15 03:46:03'),(8,'Webcam Logitech C920 HD',199.99,'2025-09-15 03:46:03'),(9,'SSD Kingston 480GB',299.90,'2025-09-15 03:46:03'),(10,'Memória RAM DDR4 16GB Corsair',449.99,'2025-09-15 03:46:03'),(11,'Placa de Vídeo GTX 1660 Super',1899.00,'2025-09-15 03:46:03'),(12,'Processador Intel i5-12400F',999.99,'2025-09-15 03:46:03'),(13,'Placa Mãe ASUS Prime B550M',599.99,'2025-09-15 03:46:03'),(14,'Fonte Corsair 650W 80 Plus Bronze',399.90,'2025-09-15 03:46:03'),(15,'Gabinete Gamer RGB Cooler Master',349.99,'2025-09-15 03:46:03'),(16,'Impressora HP LaserJet Pro',899.99,'2025-09-15 03:46:03'),(17,'Roteador TP-Link Archer C6',199.99,'2025-09-15 03:46:03'),(18,'Pen Drive SanDisk 64GB',39.99,'2025-09-15 03:46:03'),(19,'HD Externo Seagate 1TB',299.99,'2025-09-15 03:46:03'),(20,'Cabo HDMI 2.0 Premium 2m',49.99,'2025-09-15 03:46:03'),(21,'Hub USB-C 7 em 1',149.99,'2025-09-15 03:46:03'),(22,'Carregador Sem Fio Qi 15W',89.99,'2025-09-15 03:46:03'),(23,'Caixa de Som Bluetooth JBL',299.99,'2025-09-15 03:46:03'),(24,'Microfone Condensador Blue Yeti',899.99,'2025-09-15 03:46:03'),(25,'Cadeira Gamer DT3Sports Elite',1299.99,'2025-09-15 03:46:03');
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'pedidos'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-16 18:52:44
