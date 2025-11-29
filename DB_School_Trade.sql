/*
 Navicat Premium Dump SQL

 Source Server         : MySQL
 Source Server Type    : MySQL
 Source Server Version : 80037 (8.0.37)
 Source Host           : localhost:3306
 Source Schema         : db_school_trade

 Target Server Type    : MySQL
 Target Server Version : 80037 (8.0.37)
 File Encoding         : 65001

 Date: 29/11/2025 17:25:52
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for private_message
-- ----------------------------
DROP TABLE IF EXISTS `private_message`;
CREATE TABLE `private_message`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `sender_id` bigint NOT NULL COMMENT '发送者ID',
  `receiver_id` bigint NOT NULL COMMENT '接收者ID',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '私信内容',
  `send_time` datetime NOT NULL COMMENT '发送时间',
  `is_read` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否已读',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sender`(`sender_id` ASC) USING BTREE,
  INDEX `idx_receiver`(`receiver_id` ASC) USING BTREE,
  INDEX `idx_time`(`send_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 106 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户私信表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of private_message
-- ----------------------------
INSERT INTO `private_message` VALUES (1, 11, 12, '方法是', '2025-11-05 13:47:30', b'1');
INSERT INTO `private_message` VALUES (2, 11, 12, '方法是', '2025-11-05 13:47:31', b'1');
INSERT INTO `private_message` VALUES (3, 11, 12, '方法是', '2025-11-05 13:47:47', b'1');
INSERT INTO `private_message` VALUES (4, 11, 12, '你好', '2025-11-05 13:51:55', b'1');
INSERT INTO `private_message` VALUES (5, 11, 12, '你好', '2025-11-05 13:59:01', b'1');
INSERT INTO `private_message` VALUES (6, 11, 12, '我不是你啊', '2025-11-05 14:15:00', b'1');
INSERT INTO `private_message` VALUES (7, 11, 12, '我不是你啊', '2025-11-05 14:15:16', b'1');
INSERT INTO `private_message` VALUES (8, 11, 12, '我不是你啊', '2025-11-05 14:17:54', b'1');
INSERT INTO `private_message` VALUES (9, 11, 12, '你好啊拉佩蒂', '2025-11-05 14:26:28', b'1');
INSERT INTO `private_message` VALUES (10, 11, 12, '你好，这是一条测试私信！', '2025-11-05 15:10:31', b'1');
INSERT INTO `private_message` VALUES (11, 12, 11, '你好，这是一条测试私信！', '2025-11-05 15:20:01', b'1');
INSERT INTO `private_message` VALUES (12, 12, 11, '你好，这是一条测试私信！', '2025-11-05 15:20:10', b'1');
INSERT INTO `private_message` VALUES (13, 11, 12, '你好，这是一条测试私信2！', '2025-11-06 04:26:45', b'1');
INSERT INTO `private_message` VALUES (14, 11, 12, '', '2025-11-06 04:27:29', b'1');
INSERT INTO `private_message` VALUES (15, 11, 12, '6', '2025-11-06 04:27:58', b'1');
INSERT INTO `private_message` VALUES (16, 11, 12, '6', '2025-11-06 04:28:02', b'1');
INSERT INTO `private_message` VALUES (17, 11, 12, '6', '2025-11-06 04:28:04', b'1');
INSERT INTO `private_message` VALUES (18, 11, 12, '6', '2025-11-06 04:28:06', b'1');
INSERT INTO `private_message` VALUES (19, 11, 12, '6', '2025-11-06 04:28:07', b'1');
INSERT INTO `private_message` VALUES (20, 11, 12, '法国', '2025-11-06 11:46:32', b'1');
INSERT INTO `private_message` VALUES (21, 12, 11, 'hello', '2025-11-06 11:48:30', b'1');
INSERT INTO `private_message` VALUES (22, 12, 11, '你好', '2025-11-06 11:48:54', b'1');
INSERT INTO `private_message` VALUES (23, 11, 11, '你好', '2025-11-06 12:14:59', b'1');
INSERT INTO `private_message` VALUES (24, 12, 11, '我是360', '2025-11-06 12:15:44', b'1');
INSERT INTO `private_message` VALUES (25, 11, 12, '困境', '2025-11-06 14:16:23', b'1');
INSERT INTO `private_message` VALUES (26, 12, 11, '顶顶顶顶', '2025-11-06 14:19:11', b'1');
INSERT INTO `private_message` VALUES (27, 11, 12, '那好的', '2025-11-06 14:35:14', b'1');
INSERT INTO `private_message` VALUES (28, 11, 12, '地方', '2025-11-06 23:24:13', b'1');
INSERT INTO `private_message` VALUES (29, 11, 12, '顶顶顶顶', '2025-11-06 23:24:23', b'1');
INSERT INTO `private_message` VALUES (30, 11, 12, '66', '2025-11-06 23:43:32', b'1');
INSERT INTO `private_message` VALUES (31, 11, 12, '99', '2025-11-06 23:43:40', b'1');
INSERT INTO `private_message` VALUES (32, 11, 12, 'sss', '2025-11-07 15:57:50', b'1');
INSERT INTO `private_message` VALUES (33, 12, 11, 'ddddd', '2025-11-07 15:58:20', b'1');
INSERT INTO `private_message` VALUES (34, 11, 12, '尼科拉', '2025-11-07 16:17:34', b'1');
INSERT INTO `private_message` VALUES (35, 11, 12, '方法', '2025-11-07 18:09:58', b'1');
INSERT INTO `private_message` VALUES (36, 11, 12, '得到', '2025-11-07 18:53:22', b'1');
INSERT INTO `private_message` VALUES (37, 11, 12, '的', '2025-11-07 19:01:54', b'1');
INSERT INTO `private_message` VALUES (38, 11, 12, '你好', '2025-11-07 19:02:51', b'1');
INSERT INTO `private_message` VALUES (39, 12, 11, '测试', '2025-11-07 19:03:06', b'1');
INSERT INTO `private_message` VALUES (40, 12, 11, '3333', '2025-11-07 19:04:32', b'1');
INSERT INTO `private_message` VALUES (41, 12, 11, '333', '2025-11-07 19:04:45', b'1');
INSERT INTO `private_message` VALUES (42, 12, 11, '56', '2025-11-07 19:04:59', b'1');
INSERT INTO `private_message` VALUES (43, 11, 12, '宝宝', '2025-11-07 19:05:04', b'1');
INSERT INTO `private_message` VALUES (44, 12, 11, '是', '2025-11-07 19:12:56', b'1');
INSERT INTO `private_message` VALUES (45, 11, 12, '得到', '2025-11-07 19:13:39', b'1');
INSERT INTO `private_message` VALUES (46, 12, 11, '得到', '2025-11-07 19:13:52', b'1');
INSERT INTO `private_message` VALUES (47, 12, 11, 'ddd', '2025-11-07 19:25:33', b'1');
INSERT INTO `private_message` VALUES (48, 11, 12, '顶顶顶顶', '2025-11-07 19:25:45', b'1');
INSERT INTO `private_message` VALUES (49, 11, 12, '方法', '2025-11-07 19:26:00', b'1');
INSERT INTO `private_message` VALUES (50, 12, 11, '发', '2025-11-07 19:26:03', b'1');
INSERT INTO `private_message` VALUES (51, 12, 11, '得到', '2025-11-07 19:29:56', b'1');
INSERT INTO `private_message` VALUES (52, 12, 11, '得到', '2025-11-07 19:30:00', b'1');
INSERT INTO `private_message` VALUES (53, 12, 11, '的', '2025-11-07 19:30:06', b'1');
INSERT INTO `private_message` VALUES (54, 11, 12, '得到的', '2025-11-07 19:30:13', b'1');
INSERT INTO `private_message` VALUES (55, 12, 11, '顶顶顶顶', '2025-11-07 19:30:17', b'1');
INSERT INTO `private_message` VALUES (56, 12, 11, '为', '2025-11-07 19:30:21', b'1');
INSERT INTO `private_message` VALUES (57, 12, 11, '谔谔', '2025-11-07 19:30:31', b'1');
INSERT INTO `private_message` VALUES (58, 11, 12, '呃呃呃呃呃呃呃呃呃呃呃呃', '2025-11-07 19:30:35', b'1');
INSERT INTO `private_message` VALUES (59, 11, 12, '的', '2025-11-13 14:28:15', b'1');
INSERT INTO `private_message` VALUES (60, 11, 12, '得到', '2025-11-13 14:28:28', b'1');
INSERT INTO `private_message` VALUES (61, 11, 12, '还好', '2025-11-13 15:22:29', b'1');
INSERT INTO `private_message` VALUES (62, 11, 12, '刚刚', '2025-11-13 15:24:59', b'1');
INSERT INTO `private_message` VALUES (63, 12, 11, '是', '2025-11-13 16:46:08', b'1');
INSERT INTO `private_message` VALUES (64, 11, 12, 'ddd', '2025-11-13 16:46:23', b'1');
INSERT INTO `private_message` VALUES (65, 11, 12, 'dvd', '2025-11-13 16:46:48', b'1');
INSERT INTO `private_message` VALUES (66, 11, 12, 'dv', '2025-11-13 16:46:52', b'1');
INSERT INTO `private_message` VALUES (67, 12, 11, '的v', '2025-11-13 16:46:59', b'1');
INSERT INTO `private_message` VALUES (68, 11, 12, '得到', '2025-11-15 14:16:12', b'1');
INSERT INTO `private_message` VALUES (69, 11, 12, '是', '2025-11-15 14:32:22', b'1');
INSERT INTO `private_message` VALUES (70, 12, 11, '实时', '2025-11-15 14:32:32', b'1');
INSERT INTO `private_message` VALUES (71, 11, 12, '顶顶顶', '2025-11-15 14:32:40', b'1');
INSERT INTO `private_message` VALUES (72, 11, 12, '杀杀杀', '2025-11-15 14:47:59', b'1');
INSERT INTO `private_message` VALUES (73, 11, 12, '老弟', '2025-11-15 14:57:03', b'1');
INSERT INTO `private_message` VALUES (74, 12, 11, '你好', '2025-11-15 14:57:09', b'1');
INSERT INTO `private_message` VALUES (75, 12, 11, '可以的', '2025-11-15 14:57:14', b'1');
INSERT INTO `private_message` VALUES (76, 11, 12, '得到', '2025-11-15 15:03:55', b'1');
INSERT INTO `private_message` VALUES (77, 11, 12, '的', '2025-11-16 17:00:35', b'1');
INSERT INTO `private_message` VALUES (78, 11, 14, '你好', '2025-11-16 18:09:57', b'0');
INSERT INTO `private_message` VALUES (79, 11, 14, '东西还在吗', '2025-11-16 18:10:01', b'0');
INSERT INTO `private_message` VALUES (80, 11, 14, '33', '2025-11-17 16:48:41', b'0');
INSERT INTO `private_message` VALUES (81, 11, 12, '2', '2025-11-17 16:55:03', b'1');
INSERT INTO `private_message` VALUES (82, 11, 12, '322', '2025-11-17 16:55:50', b'1');
INSERT INTO `private_message` VALUES (83, 11, 12, 'u', '2025-11-17 16:58:48', b'1');
INSERT INTO `private_message` VALUES (84, 12, 11, '33', '2025-11-17 17:00:39', b'1');
INSERT INTO `private_message` VALUES (85, 11, 12, '5555', '2025-11-17 17:00:51', b'1');
INSERT INTO `private_message` VALUES (86, 12, 11, '455', '2025-11-17 17:00:54', b'1');
INSERT INTO `private_message` VALUES (87, 11, 12, '44', '2025-11-17 17:00:58', b'1');
INSERT INTO `private_message` VALUES (88, 12, 11, '解决', '2025-11-17 17:01:17', b'1');
INSERT INTO `private_message` VALUES (89, 12, 11, '解决', '2025-11-17 17:01:23', b'1');
INSERT INTO `private_message` VALUES (90, 11, 12, '就', '2025-11-17 17:01:43', b'1');
INSERT INTO `private_message` VALUES (91, 11, 12, '解决', '2025-11-17 17:01:50', b'1');
INSERT INTO `private_message` VALUES (92, 11, 12, '还好', '2025-11-17 17:02:17', b'1');
INSERT INTO `private_message` VALUES (93, 12, 11, '好好好', '2025-11-17 17:02:51', b'1');
INSERT INTO `private_message` VALUES (94, 11, 12, '，，，', '2025-11-17 17:03:02', b'1');
INSERT INTO `private_message` VALUES (95, 12, 11, '633', '2025-11-17 17:03:06', b'1');
INSERT INTO `private_message` VALUES (96, 11, 12, '看看', '2025-11-17 17:03:32', b'1');
INSERT INTO `private_message` VALUES (97, 11, 12, '看看', '2025-11-17 17:03:37', b'1');
INSERT INTO `private_message` VALUES (98, 12, 11, '看', '2025-11-17 17:03:42', b'1');
INSERT INTO `private_message` VALUES (99, 11, 12, '33', '2025-11-17 17:12:05', b'1');
INSERT INTO `private_message` VALUES (100, 11, 12, '刚刚', '2025-11-17 17:12:24', b'1');
INSERT INTO `private_message` VALUES (101, 11, 12, '刚刚', '2025-11-17 17:12:27', b'1');
INSERT INTO `private_message` VALUES (102, 11, 12, '给', '2025-11-17 17:12:32', b'1');
INSERT INTO `private_message` VALUES (103, 11, 12, '给', '2025-11-17 17:12:38', b'1');
INSERT INTO `private_message` VALUES (104, 11, 12, '分', '2025-11-17 17:12:46', b'1');
INSERT INTO `private_message` VALUES (105, 11, 14, '得到的', '2025-11-26 16:09:36', b'0');

-- ----------------------------
-- Table structure for sh_address
-- ----------------------------
DROP TABLE IF EXISTS `sh_address`;
CREATE TABLE `sh_address`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `consignee_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '收货人姓名',
  `consignee_phone` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '收货人手机号',
  `province_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '省',
  `city_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '市',
  `region_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '区',
  `detail_address` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '详细地址',
  `default_flag` tinyint NOT NULL COMMENT '是否默认地址',
  `user_id` bigint NOT NULL COMMENT '用户主键id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id_index`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of sh_address
-- ----------------------------
INSERT INTO `sh_address` VALUES (30, '陈xx', '17777777777', '天津市', '市辖区', '和平区', '浙江省杭州市余杭区xx街道xx小区', 1, 11);
INSERT INTO `sh_address` VALUES (31, '陈xx', '18888888888', '北京市', '市辖区', '西城区', '北京xx路xx小区', 1, 12);

-- ----------------------------
-- Table structure for sh_admin
-- ----------------------------
DROP TABLE IF EXISTS `sh_admin`;
CREATE TABLE `sh_admin`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `account_number` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '管理员账号',
  `admin_password` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '密码',
  `admin_name` varchar(8) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '管理员名字',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `account_number`(`account_number` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of sh_admin
-- ----------------------------
INSERT INTO `sh_admin` VALUES (13, '1866666666', '123456', 'admin');

-- ----------------------------
-- Table structure for sh_favorite
-- ----------------------------
DROP TABLE IF EXISTS `sh_favorite`;
CREATE TABLE `sh_favorite`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键id',
  `create_time` datetime NOT NULL COMMENT '加入收藏的时间',
  `user_id` bigint NOT NULL COMMENT '用户主键id',
  `idle_id` bigint NOT NULL COMMENT '闲置物主键id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC, `idle_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 63 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of sh_favorite
-- ----------------------------
INSERT INTO `sh_favorite` VALUES (52, '2025-07-31 13:18:49', 12, 115);
INSERT INTO `sh_favorite` VALUES (53, '2025-07-31 13:18:52', 12, 116);
INSERT INTO `sh_favorite` VALUES (56, '2025-07-31 13:19:12', 11, 120);
INSERT INTO `sh_favorite` VALUES (57, '2025-11-26 13:13:46', 11, 115);
INSERT INTO `sh_favorite` VALUES (58, '2025-11-26 13:13:46', 11, 116);
INSERT INTO `sh_favorite` VALUES (59, '2025-11-26 13:13:46', 12, 120);
INSERT INTO `sh_favorite` VALUES (60, '2025-11-26 13:13:46', 12, 121);
INSERT INTO `sh_favorite` VALUES (61, '2025-11-26 16:07:53', 12, 118);
INSERT INTO `sh_favorite` VALUES (62, '2025-11-27 22:43:01', 11, 131);

-- ----------------------------
-- Table structure for sh_idle_item
-- ----------------------------
DROP TABLE IF EXISTS `sh_idle_item`;
CREATE TABLE `sh_idle_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `idle_name` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '闲置物名称',
  `idle_details` varchar(2048) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '详情',
  `picture_list` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '图集',
  `idle_price` decimal(10, 2) NOT NULL COMMENT '价格',
  `idle_place` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '发货地区',
  `idle_label` int NOT NULL COMMENT '分类标签',
  `release_time` datetime NOT NULL COMMENT '发布时间',
  `idle_status` tinyint NOT NULL COMMENT '状态（发布1、下架2、删除0）',
  `user_id` bigint NOT NULL COMMENT '用户主键id',
  `view_count` int NULL DEFAULT 0 COMMENT '浏览量',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id_index`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 134 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of sh_idle_item
-- ----------------------------
INSERT INTO `sh_idle_item` VALUES (115, '手机', '95新', '[\"http://47.98.173.43/image?imageName=file17539661029981003OIP-C.webp\"]', 1600.00, '秦皇岛市', 1, '2025-07-31 12:48:32', 1, 11, 0);
INSERT INTO `sh_idle_item` VALUES (116, '电脑', '9成新，2023年买的，挺好用，无磕碰', '[\"http://47.98.173.43/image?imageName=file17539662438691004OIP-C (1).webp\"]', 2340.00, '秦皇岛市', 1, '2025-07-31 12:50:46', 1, 11, 0);
INSERT INTO `sh_idle_item` VALUES (117, '风扇', '自用，无故障', '[\"http://47.98.173.43/image?imageName=file175396636320110059717.png_860.png\"]', 50.00, '市辖区', 2, '2025-07-31 12:52:48', 1, 11, 0);
INSERT INTO `sh_idle_item` VALUES (118, '红楼梦', '新书，挺不错的', '[\"http://47.98.173.43/image?imageName=file17539665237971006R-C.jpg\"]', 20.00, '唐山市', 4, '2025-07-31 12:55:25', 1, 11, 0);
INSERT INTO `sh_idle_item` VALUES (119, '帐篷', '户外使用，很方便', '[\"http://47.98.173.43/image?imageName=file17539666452571007OIP-C (2).webp\"]', 80.00, '市辖区', 3, '2025-07-31 12:57:27', 1, 12, 0);
INSERT INTO `sh_idle_item` VALUES (120, '哑铃', '健身用的', '[\"http://47.98.173.43/image?imageName=file17539667373001008OIP-C (3).webp\"]', 35.00, '秦皇岛市', 5, '2025-07-31 12:58:59', 1, 12, 0);
INSERT INTO `sh_idle_item` VALUES (121, '篮球', '9新，很少玩', '[\"http://47.98.173.43/image?imageName=file17539671069101010OIP-C (4).webp\"]', 90.00, '铜川市', 5, '2025-07-31 13:05:10', 1, 12, 0);
INSERT INTO `sh_idle_item` VALUES (122, '平板', '看电视，打游戏都ok', '[\"http://47.98.173.43/image?imageName=file17539672196041011OIP-C (5).webp\"]', 1000.00, '秦皇岛市', 1, '2025-07-31 13:07:02', 1, 12, 0);
INSERT INTO `sh_idle_item` VALUES (123, '杯子', '666', '[\"http://47.98.173.43/image?imageName=file17623212145271002pelagrina.jpg\",\"http://47.98.173.43/image?imageName=file17623212193851003lenna.png\"]', 99.00, '市辖区', 2, '2025-11-05 05:40:21', 0, 11, 0);
INSERT INTO `sh_idle_item` VALUES (124, 'ff', 'ff', '[]', 256.00, '市辖区', 1, '2025-11-05 07:51:16', 0, 11, 0);
INSERT INTO `sh_idle_item` VALUES (125, '手机', '深度', '[\"http://47.98.173.43/image?imageName=file17623483087181002foreground.png\"]', 1888.00, '市辖区', 1, '2025-11-05 13:11:52', 0, 11, 0);
INSERT INTO `sh_idle_item` VALUES (126, '顶顶顶顶', '大大', '[]', 330.00, '市辖区', 1, '2025-11-06 11:49:36', 0, 12, 0);
INSERT INTO `sh_idle_item` VALUES (127, '66', '55', '[]', 450.00, '市辖区', 4, '2025-11-06 23:23:56', 0, 11, 0);
INSERT INTO `sh_idle_item` VALUES (128, '汽车模型', '汽车玩具模型', '[\"http://47.98.173.43/image?imageName=file17632868338871002fillbytes.jpg\"]', 55.00, '市辖区', 5, '2025-11-16 17:54:21', 1, 12, 0);
INSERT INTO `sh_idle_item` VALUES (129, '人偶玩具', '玩偶模型', '[\"http://47.98.173.43/image?imageName=file17632868784611003cops.jpg\"]', 100.00, '福州市', 5, '2025-11-16 17:55:22', 1, 12, 0);
INSERT INTO `sh_idle_item` VALUES (130, '蛋白粉', '蛋白粉', '[\"http://47.98.173.43/image?imageName=file17632872639831006QQ_1763287242906.png\"]', 177.00, '唐山市', 2, '2025-11-16 18:01:19', 2, 12, 0);
INSERT INTO `sh_idle_item` VALUES (131, '键盘', '键盘', '[\"http://47.98.173.43/image?imageName=file17632877543101008QQ_1763287742223.png\"]', 150.00, '市辖区', 1, '2025-11-16 18:09:29', 1, 14, 0);
INSERT INTO `sh_idle_item` VALUES (132, '蛋白粉', '蛋白粉', '[\"http://47.98.173.43/image?imageName=file1764148521962100217632872639831006QQ_1763287242906.png\"]', 566.00, '大同市', 5, '2025-11-26 17:15:24', 1, 11, 0);
INSERT INTO `sh_idle_item` VALUES (133, '..', '..', '[\"http://47.98.173.43/image?imageName=file17641503209961002file16868385807991003风扇.jpg\"]', 50.01, '邯郸市', 1, '2025-11-26 17:45:32', 2, 11, 0);

-- ----------------------------
-- Table structure for sh_message
-- ----------------------------
DROP TABLE IF EXISTS `sh_message`;
CREATE TABLE `sh_message`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `user_id` bigint NOT NULL COMMENT '用户主键id',
  `idle_id` bigint NULL DEFAULT NULL COMMENT '闲置物品ID（留言用，私聊可为null）',
  `content` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '留言内容',
  `create_time` datetime NOT NULL COMMENT '留言时间',
  `to_user` bigint NOT NULL COMMENT '所回复的用户',
  `to_message` bigint NULL DEFAULT NULL COMMENT '所回复的留言',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id_index`(`user_id` ASC) USING BTREE,
  INDEX `idle_id_index`(`idle_id` ASC) USING BTREE,
  INDEX `to_user_index`(`to_user` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 64 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of sh_message
-- ----------------------------
INSERT INTO `sh_message` VALUES (59, 11, 122, '搞好', '2025-11-05 12:47:11', 12, NULL);
INSERT INTO `sh_message` VALUES (60, 11, 122, '得到', '2025-11-05 12:47:51', 12, NULL);
INSERT INTO `sh_message` VALUES (61, 11, 122, '66', '2025-11-05 13:47:21', 12, NULL);
INSERT INTO `sh_message` VALUES (62, 11, 122, '风格', '2025-11-06 09:09:55', 12, NULL);
INSERT INTO `sh_message` VALUES (63, 11, 126, '得到', '2025-11-13 14:28:00', 12, NULL);

-- ----------------------------
-- Table structure for sh_order
-- ----------------------------
DROP TABLE IF EXISTS `sh_order`;
CREATE TABLE `sh_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `order_number` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '订单编号',
  `user_id` bigint NOT NULL COMMENT '用户主键id',
  `idle_id` bigint NOT NULL COMMENT '闲置物品主键id',
  `order_price` decimal(10, 2) NOT NULL COMMENT '订单总价',
  `payment_status` tinyint NOT NULL COMMENT '支付状态',
  `payment_way` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '支付方式',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `payment_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `order_status` tinyint NOT NULL COMMENT '订单状态',
  `is_deleted` tinyint NULL DEFAULT NULL COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 96 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of sh_order
-- ----------------------------
INSERT INTO `sh_order` VALUES (90, '175396738919210004', 11, 120, 35.00, 1, '支付宝', '2025-07-31 13:09:49', '2025-07-31 13:10:02', 3, NULL);
INSERT INTO `sh_order` VALUES (91, '176235054057310002', 11, 121, 90.00, 0, NULL, '2025-11-05 13:49:01', NULL, 4, NULL);
INSERT INTO `sh_order` VALUES (92, '176244269594010002', 11, 126, 330.00, 0, NULL, '2025-11-06 23:24:56', NULL, 4, NULL);
INSERT INTO `sh_order` VALUES (93, '176244272284210003', 11, 121, 90.00, 0, NULL, '2025-11-06 23:25:23', NULL, 4, NULL);
INSERT INTO `sh_order` VALUES (94, '176244281931710004', 11, 121, 90.00, 0, NULL, '2025-11-06 23:26:59', NULL, 4, NULL);
INSERT INTO `sh_order` VALUES (95, '176244283222710005', 11, 121, 90.00, 0, NULL, '2025-11-06 23:27:12', NULL, 4, NULL);

-- ----------------------------
-- Table structure for sh_order_address
-- ----------------------------
DROP TABLE IF EXISTS `sh_order_address`;
CREATE TABLE `sh_order_address`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `order_id` bigint NOT NULL COMMENT '订单id',
  `consignee_name` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '收货人',
  `consignee_phone` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '电话',
  `detail_address` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '收货地址',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `orderId`(`order_id` ASC) USING BTREE,
  INDEX `order_id_index`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of sh_order_address
-- ----------------------------
INSERT INTO `sh_order_address` VALUES (21, 86, '陈xx', '18888888888', '北京市市辖区西城区北京xx路xx小区');
INSERT INTO `sh_order_address` VALUES (22, 85, '陈xx', '18888888888', '北京市市辖区西城区北京xx路xx小区');
INSERT INTO `sh_order_address` VALUES (23, 87, '陈xx', '18888888888', '北京市市辖区西城区北京xx路xx小区');
INSERT INTO `sh_order_address` VALUES (24, 88, '陈xx', '18888888888', '北京市市辖区西城区北京xx路xx小区');
INSERT INTO `sh_order_address` VALUES (25, 89, '陈xx', '18888888888', '北京市市辖区西城区北京xx路xx小区');
INSERT INTO `sh_order_address` VALUES (26, 90, '陈xx', '17777777777', '天津市市辖区和平区浙江省杭州市余杭区xx街道xx小区');
INSERT INTO `sh_order_address` VALUES (27, 91, '陈xx', '17777777777', '天津市市辖区和平区浙江省杭州市余杭区xx街道xx小区');
INSERT INTO `sh_order_address` VALUES (28, 92, '陈xx', '17777777777', '天津市市辖区和平区浙江省杭州市余杭区xx街道xx小区');
INSERT INTO `sh_order_address` VALUES (29, 93, '陈xx', '17777777777', '天津市市辖区和平区浙江省杭州市余杭区xx街道xx小区');
INSERT INTO `sh_order_address` VALUES (30, 94, '陈xx', '17777777777', '天津市市辖区和平区浙江省杭州市余杭区xx街道xx小区');
INSERT INTO `sh_order_address` VALUES (31, 95, '陈xx', '17777777777', '天津市市辖区和平区浙江省杭州市余杭区xx街道xx小区');

-- ----------------------------
-- Table structure for sh_private_message
-- ----------------------------
DROP TABLE IF EXISTS `sh_private_message`;
CREATE TABLE `sh_private_message`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `sender_id` bigint NOT NULL COMMENT '发送者ID',
  `receiver_id` bigint NOT NULL COMMENT '接收者ID',
  `content` varchar(1024) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '消息内容',
  `send_time` datetime NOT NULL COMMENT '发送时间',
  `is_read` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已读(0:未读,1:已读)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sender_id_index`(`sender_id` ASC) USING BTREE,
  INDEX `receiver_id_index`(`receiver_id` ASC) USING BTREE,
  INDEX `send_time_index`(`send_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of sh_private_message
-- ----------------------------

-- ----------------------------
-- Table structure for sh_user
-- ----------------------------
DROP TABLE IF EXISTS `sh_user`;
CREATE TABLE `sh_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `account_number` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '账号（手机号）',
  `user_password` varchar(16) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '登录密码',
  `nickname` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '昵称',
  `avatar` varchar(256) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '头像',
  `sign_in_time` datetime NOT NULL COMMENT '注册时间',
  `user_status` tinyint NULL DEFAULT NULL COMMENT '状态（1代表封禁）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `account_number`(`account_number` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of sh_user
-- ----------------------------
INSERT INTO `sh_user` VALUES (11, '18777777777', '123456', '王语嫣', 'http://47.98.173.43/image?imageName=file17539673076991012file168663143432210030.png', '2025-07-31 13:20:06', 0);
INSERT INTO `sh_user` VALUES (12, '18888888888', '123456', '韩立', 'http://47.98.173.43/image?imageName=file17632871887611005QQ_1763287173630.png', '2025-07-31 14:29:24', NULL);
INSERT INTO `sh_user` VALUES (13, '14725', '123456', '王林', 'https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png', '2025-11-05 05:41:34', NULL);
INSERT INTO `sh_user` VALUES (14, '1234567', '123456', '徐成仙', 'http://47.98.173.43/image?imageName=file17632877092791007flower.gif', '2025-11-05 05:42:57', 0);

-- ----------------------------
-- Table structure for user_browse_history
-- ----------------------------
DROP TABLE IF EXISTS `user_browse_history`;
CREATE TABLE `user_browse_history`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `idle_id` bigint NOT NULL COMMENT '商品ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '浏览时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_user_idle`(`user_id` ASC, `idle_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 107 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户浏览历史表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_browse_history
-- ----------------------------
INSERT INTO `user_browse_history` VALUES (1, 11, 115, '2025-11-26 14:18:31');
INSERT INTO `user_browse_history` VALUES (2, 11, 116, '2025-11-26 14:18:31');
INSERT INTO `user_browse_history` VALUES (3, 11, 122, '2025-11-26 14:18:31');
INSERT INTO `user_browse_history` VALUES (4, 12, 120, '2025-11-26 14:18:31');
INSERT INTO `user_browse_history` VALUES (5, 12, 121, '2025-11-26 14:18:31');
INSERT INTO `user_browse_history` VALUES (6, 11, 115, '2025-11-26 15:26:06');
INSERT INTO `user_browse_history` VALUES (7, 11, 116, '2025-11-26 15:27:02');
INSERT INTO `user_browse_history` VALUES (8, 11, 118, '2025-11-26 15:27:05');
INSERT INTO `user_browse_history` VALUES (9, 11, 120, '2025-11-26 15:27:09');
INSERT INTO `user_browse_history` VALUES (10, 12, 122, '2025-11-26 16:06:16');
INSERT INTO `user_browse_history` VALUES (11, 12, 131, '2025-11-26 16:06:21');
INSERT INTO `user_browse_history` VALUES (12, 12, 129, '2025-11-26 16:06:25');
INSERT INTO `user_browse_history` VALUES (13, 12, 131, '2025-11-26 16:06:29');
INSERT INTO `user_browse_history` VALUES (14, 12, 122, '2025-11-26 16:06:34');
INSERT INTO `user_browse_history` VALUES (15, 12, 119, '2025-11-26 16:07:24');
INSERT INTO `user_browse_history` VALUES (16, 12, 118, '2025-11-26 16:07:49');
INSERT INTO `user_browse_history` VALUES (17, 11, 129, '2025-11-26 16:09:44');
INSERT INTO `user_browse_history` VALUES (18, 11, 128, '2025-11-26 16:09:53');
INSERT INTO `user_browse_history` VALUES (19, 11, 121, '2025-11-26 16:09:55');
INSERT INTO `user_browse_history` VALUES (20, 11, 120, '2025-11-26 16:09:57');
INSERT INTO `user_browse_history` VALUES (21, 11, 121, '2025-11-26 16:09:58');
INSERT INTO `user_browse_history` VALUES (22, 11, 119, '2025-11-26 16:10:00');
INSERT INTO `user_browse_history` VALUES (23, 11, 119, '2025-11-26 16:10:02');
INSERT INTO `user_browse_history` VALUES (24, 11, 131, '2025-11-26 16:35:42');
INSERT INTO `user_browse_history` VALUES (25, 11, 122, '2025-11-26 16:35:46');
INSERT INTO `user_browse_history` VALUES (26, 11, 122, '2025-11-26 16:35:50');
INSERT INTO `user_browse_history` VALUES (27, 11, 122, '2025-11-26 16:35:52');
INSERT INTO `user_browse_history` VALUES (28, 11, 131, '2025-11-26 16:38:22');
INSERT INTO `user_browse_history` VALUES (29, 11, 128, '2025-11-26 16:56:04');
INSERT INTO `user_browse_history` VALUES (30, 11, 132, '2025-11-26 17:15:35');
INSERT INTO `user_browse_history` VALUES (31, 11, 132, '2025-11-26 17:15:53');
INSERT INTO `user_browse_history` VALUES (32, 11, 132, '2025-11-26 17:18:14');
INSERT INTO `user_browse_history` VALUES (33, 11, 131, '2025-11-26 17:20:21');
INSERT INTO `user_browse_history` VALUES (34, 11, 132, '2025-11-26 17:20:49');
INSERT INTO `user_browse_history` VALUES (35, 11, 131, '2025-11-26 17:20:53');
INSERT INTO `user_browse_history` VALUES (36, 11, 131, '2025-11-26 17:21:43');
INSERT INTO `user_browse_history` VALUES (37, 11, 128, '2025-11-26 17:21:45');
INSERT INTO `user_browse_history` VALUES (38, 11, 116, '2025-11-26 17:22:50');
INSERT INTO `user_browse_history` VALUES (39, 11, 120, '2025-11-26 17:22:51');
INSERT INTO `user_browse_history` VALUES (40, 11, 122, '2025-11-26 17:22:54');
INSERT INTO `user_browse_history` VALUES (41, 11, 122, '2025-11-26 17:22:55');
INSERT INTO `user_browse_history` VALUES (42, 11, 122, '2025-11-26 17:22:56');
INSERT INTO `user_browse_history` VALUES (43, 11, 129, '2025-11-26 17:43:57');
INSERT INTO `user_browse_history` VALUES (44, 11, 121, '2025-11-26 17:43:59');
INSERT INTO `user_browse_history` VALUES (45, 11, 119, '2025-11-26 17:44:02');
INSERT INTO `user_browse_history` VALUES (46, 11, 132, '2025-11-26 17:44:03');
INSERT INTO `user_browse_history` VALUES (47, 11, 129, '2025-11-26 17:45:02');
INSERT INTO `user_browse_history` VALUES (48, 11, 129, '2025-11-26 18:55:04');
INSERT INTO `user_browse_history` VALUES (49, 11, 129, '2025-11-26 19:15:36');
INSERT INTO `user_browse_history` VALUES (50, 11, 129, '2025-11-26 19:16:52');
INSERT INTO `user_browse_history` VALUES (51, 11, 131, '2025-11-26 19:17:04');
INSERT INTO `user_browse_history` VALUES (52, 11, 120, '2025-11-26 19:17:07');
INSERT INTO `user_browse_history` VALUES (53, 11, 116, '2025-11-26 19:17:11');
INSERT INTO `user_browse_history` VALUES (54, 11, 131, '2025-11-26 19:17:14');
INSERT INTO `user_browse_history` VALUES (55, 11, 133, '2025-11-26 19:17:16');
INSERT INTO `user_browse_history` VALUES (56, 11, 120, '2025-11-26 19:22:15');
INSERT INTO `user_browse_history` VALUES (57, 11, 122, '2025-11-26 19:53:51');
INSERT INTO `user_browse_history` VALUES (58, 11, 122, '2025-11-26 19:53:53');
INSERT INTO `user_browse_history` VALUES (59, 11, 122, '2025-11-26 19:53:55');
INSERT INTO `user_browse_history` VALUES (60, 11, 122, '2025-11-26 19:53:56');
INSERT INTO `user_browse_history` VALUES (61, 11, 131, '2025-11-27 21:54:18');
INSERT INTO `user_browse_history` VALUES (62, 11, 121, '2025-11-27 21:54:29');
INSERT INTO `user_browse_history` VALUES (63, 11, 120, '2025-11-27 21:54:31');
INSERT INTO `user_browse_history` VALUES (64, 11, 121, '2025-11-27 21:54:33');
INSERT INTO `user_browse_history` VALUES (65, 11, 121, '2025-11-27 21:54:35');
INSERT INTO `user_browse_history` VALUES (66, 11, 121, '2025-11-27 21:54:37');
INSERT INTO `user_browse_history` VALUES (67, 11, 128, '2025-11-27 21:55:04');
INSERT INTO `user_browse_history` VALUES (68, 11, 120, '2025-11-27 22:09:21');
INSERT INTO `user_browse_history` VALUES (69, 11, 132, '2025-11-27 22:42:29');
INSERT INTO `user_browse_history` VALUES (70, 11, 131, '2025-11-27 22:42:37');
INSERT INTO `user_browse_history` VALUES (71, 11, 132, '2025-11-27 22:42:38');
INSERT INTO `user_browse_history` VALUES (72, 11, 132, '2025-11-27 22:42:40');
INSERT INTO `user_browse_history` VALUES (73, 11, 132, '2025-11-27 22:42:41');
INSERT INTO `user_browse_history` VALUES (74, 11, 131, '2025-11-27 22:42:42');
INSERT INTO `user_browse_history` VALUES (75, 11, 131, '2025-11-27 22:42:43');
INSERT INTO `user_browse_history` VALUES (76, 11, 132, '2025-11-27 22:42:45');
INSERT INTO `user_browse_history` VALUES (77, 11, 132, '2025-11-27 22:42:46');
INSERT INTO `user_browse_history` VALUES (78, 11, 116, '2025-11-27 22:42:54');
INSERT INTO `user_browse_history` VALUES (79, 11, 131, '2025-11-27 22:42:59');
INSERT INTO `user_browse_history` VALUES (80, 11, 129, '2025-11-27 22:43:39');
INSERT INTO `user_browse_history` VALUES (81, 11, 131, '2025-11-27 22:43:40');
INSERT INTO `user_browse_history` VALUES (82, 11, 131, '2025-11-27 22:43:42');
INSERT INTO `user_browse_history` VALUES (83, 11, 132, '2025-11-28 00:36:03');
INSERT INTO `user_browse_history` VALUES (84, 11, 131, '2025-11-28 00:36:08');
INSERT INTO `user_browse_history` VALUES (85, 11, 131, '2025-11-28 00:36:10');
INSERT INTO `user_browse_history` VALUES (86, 11, 131, '2025-11-28 00:36:11');
INSERT INTO `user_browse_history` VALUES (87, 11, 131, '2025-11-28 00:36:13');
INSERT INTO `user_browse_history` VALUES (88, 11, 131, '2025-11-28 00:36:14');
INSERT INTO `user_browse_history` VALUES (89, 11, 116, '2025-11-28 00:36:24');
INSERT INTO `user_browse_history` VALUES (90, 11, 116, '2025-11-28 00:36:29');
INSERT INTO `user_browse_history` VALUES (91, 11, 122, '2025-11-28 00:36:31');
INSERT INTO `user_browse_history` VALUES (92, 11, 122, '2025-11-28 00:36:33');
INSERT INTO `user_browse_history` VALUES (93, 11, 115, '2025-11-28 00:36:40');
INSERT INTO `user_browse_history` VALUES (94, 11, 131, '2025-11-28 00:49:38');
INSERT INTO `user_browse_history` VALUES (95, 11, 118, '2025-11-28 01:17:00');
INSERT INTO `user_browse_history` VALUES (96, 11, 121, '2025-11-28 11:19:29');
INSERT INTO `user_browse_history` VALUES (97, 11, 120, '2025-11-28 11:19:31');
INSERT INTO `user_browse_history` VALUES (98, 11, 131, '2025-11-28 11:19:33');
INSERT INTO `user_browse_history` VALUES (99, 11, 129, '2025-11-28 11:19:35');
INSERT INTO `user_browse_history` VALUES (100, 11, 128, '2025-11-28 11:19:42');
INSERT INTO `user_browse_history` VALUES (101, 11, 120, '2025-11-28 11:19:44');
INSERT INTO `user_browse_history` VALUES (102, 11, 129, '2025-11-28 11:19:47');
INSERT INTO `user_browse_history` VALUES (103, 11, 121, '2025-11-28 11:19:50');
INSERT INTO `user_browse_history` VALUES (104, 11, 121, '2025-11-28 11:44:20');
INSERT INTO `user_browse_history` VALUES (105, 11, 120, '2025-11-28 11:44:22');
INSERT INTO `user_browse_history` VALUES (106, 11, 131, '2025-11-28 11:44:27');

-- ----------------------------
-- Table structure for user_preference
-- ----------------------------
DROP TABLE IF EXISTS `user_preference`;
CREATE TABLE `user_preference`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `label_id` int NOT NULL COMMENT '商品标签ID',
  `preference_score` double NOT NULL DEFAULT 0 COMMENT '偏好分数',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_label`(`user_id` ASC, `label_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_label_id`(`label_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 106 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户偏好表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_preference
-- ----------------------------
INSERT INTO `user_preference` VALUES (1, 11, 1, 43.8, '2025-11-28 11:44:27');
INSERT INTO `user_preference` VALUES (2, 11, 2, 0.2, '2025-11-26 14:18:31');
INSERT INTO `user_preference` VALUES (3, 12, 5, 1.9, '2025-11-26 16:06:25');
INSERT INTO `user_preference` VALUES (4, 12, 3, 1.1, '2025-11-26 16:07:24');
INSERT INTO `user_preference` VALUES (7, 11, 4, 2, '2025-11-28 01:17:00');
INSERT INTO `user_preference` VALUES (8, 11, 5, 46, '2025-11-28 11:44:22');
INSERT INTO `user_preference` VALUES (9, 12, 1, 4, '2025-11-26 16:06:34');
INSERT INTO `user_preference` VALUES (15, 12, 4, 1, '2025-11-26 16:07:49');
INSERT INTO `user_preference` VALUES (21, 11, 3, 3, '2025-11-26 17:44:02');

-- ----------------------------
-- Table structure for user_search_history
-- ----------------------------
DROP TABLE IF EXISTS `user_search_history`;
CREATE TABLE `user_search_history`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `search_keyword` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '搜索关键词',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '搜索时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_keyword`(`search_keyword` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户搜索记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_search_history
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
