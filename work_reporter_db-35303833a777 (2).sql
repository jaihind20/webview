-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: sdb-79.hosting.stackcp.net
-- Generation Time: Jun 13, 2025 at 04:32 PM
-- Server version: 10.11.10-MariaDB-log
-- PHP Version: 8.3.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `work_reporter_db-35303833a777`
--

-- --------------------------------------------------------

--
-- Table structure for table `daily_reports`
--

CREATE TABLE `daily_reports` (
  `report_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `report_for_date` date NOT NULL COMMENT 'यह रिपोर्ट किस तारीख के लिए है',
  `work_type` enum('Working','Leave') NOT NULL,
  `work_details` text DEFAULT NULL COMMENT 'अगर काम कर रहे हैं, तो उसका विवरण',
  `leave_end_date` date DEFAULT NULL COMMENT 'अगर छुट्टी पर हैं, तो छुट्टी की अंतिम तिथि',
  `submission_timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `daily_reports`
--

INSERT INTO `daily_reports` (`report_id`, `user_id`, `report_for_date`, `work_type`, `work_details`, `leave_end_date`, `submission_timestamp`) VALUES
(1, 2, '2025-06-10', 'Working', NULL, NULL, '2025-06-10 18:40:02'),
(2, 2, '2025-06-11', 'Working', NULL, NULL, '2025-06-10 19:02:57'),
(3, 6, '2025-06-11', 'Leave', NULL, '2025-06-13', '2025-06-11 05:49:19'),
(4, 7, '2025-06-11', 'Leave', NULL, '2025-06-11', '2025-06-11 05:50:49'),
(5, 7, '2025-06-12', 'Leave', NULL, '2025-06-12', '2025-06-11 11:21:58'),
(6, 6, '2025-06-12', 'Leave', NULL, '2025-06-13', '2025-06-11 19:14:39'),
(7, 8, '2025-06-13', 'Working', NULL, NULL, '2025-06-13 01:30:41'),
(8, 8, '2025-06-15', 'Leave', NULL, '2025-06-16', '2025-06-13 02:19:24');

-- --------------------------------------------------------

--
-- Table structure for table `demand_assignments`
--

CREATE TABLE `demand_assignments` (
  `id` int(11) NOT NULL,
  `demand_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `demand_assignments`
--

INSERT INTO `demand_assignments` (`id`, `demand_id`, `user_id`) VALUES
(1, 1, 6);

-- --------------------------------------------------------

--
-- Table structure for table `demand_responses`
--

CREATE TABLE `demand_responses` (
  `id` int(11) NOT NULL,
  `demand_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `response` enum('Yes','No') NOT NULL,
  `comment` text DEFAULT NULL,
  `responded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `demand_responses`
--

INSERT INTO `demand_responses` (`id`, `demand_id`, `user_id`, `response`, `comment`, `responded_at`) VALUES
(1, 1, 6, 'Yes', '', '2025-06-11 19:58:52');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `department_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `department_name`) VALUES
(1, 'Signal'),
(2, 'Telecom');

-- --------------------------------------------------------

--
-- Table structure for table `depots`
--

CREATE TABLE `depots` (
  `id` int(11) NOT NULL,
  `depot_name` varchar(100) NOT NULL,
  `department_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `depots`
--

INSERT INTO `depots` (`id`, `depot_name`, `department_id`) VALUES
(3, 'SSE/Sig/ML/JHS', 1),
(4, 'SSE/Sig/LAR', 1),
(5, 'SSE/Sig/GWL', 1),
(6, 'SSE/Sig/BL/JHS', 1),
(7, 'SSE/Sig/ORAI', 1),
(8, 'SSE/Sig/MBA', 1),
(9, 'SSE/Sig/BNDA', 1);

-- --------------------------------------------------------

--
-- Table structure for table `form_fields`
--

CREATE TABLE `form_fields` (
  `field_id` int(11) NOT NULL,
  `field_name` varchar(100) NOT NULL COMMENT 'e.g., station_name, work_summary',
  `field_label` varchar(255) NOT NULL COMMENT 'e.g., Station Name, Work Summary',
  `field_type` enum('text','textarea','date','number','time','select','radio') NOT NULL DEFAULT 'text',
  `field_options` text DEFAULT NULL COMMENT 'For select type, comma-separated values',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `field_order` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `form_fields`
--

INSERT INTO `form_fields` (`field_id`, `field_name`, `field_label`, `field_type`, `field_options`, `is_active`, `field_order`) VALUES
(7, 'dcm', 'DCM', 'number', NULL, 1, 0),
(8, 'stn', 'Station Name', 'text', NULL, 1, 1),
(12, 'work', 'Work', 'text', NULL, 1, 2),
(13, 'at', 'Allowed Time', 'time', NULL, 1, 3),
(14, 'rt', 'Reconnect Time', 'time', NULL, 1, 4),
(16, 'td', 'Total Duration', 'number', NULL, 1, 5),
(17, 'dt', 'Date', 'date', NULL, 1, -1),
(18, 'Ar', 'Any Remark', 'textarea', NULL, 1, 6);

-- --------------------------------------------------------

--
-- Table structure for table `form_field_roles`
--

CREATE TABLE `form_field_roles` (
  `field_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `form_field_roles`
--

INSERT INTO `form_field_roles` (`field_id`, `role_id`) VALUES
(7, 5),
(8, 5),
(12, 5),
(13, 5),
(14, 5),
(16, 5),
(17, 5),
(18, 5);

-- --------------------------------------------------------

--
-- Table structure for table `report_data`
--

CREATE TABLE `report_data` (
  `data_id` int(11) NOT NULL,
  `report_id` int(11) NOT NULL,
  `field_id` int(11) NOT NULL,
  `field_value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `report_data`
--

INSERT INTO `report_data` (`data_id`, `report_id`, `field_id`, `field_value`) VALUES
(11, 7, 17, '2025-06-13'),
(12, 7, 7, '23456788'),
(13, 7, 8, 'GWL'),
(14, 7, 12, 'Point Testing'),
(15, 7, 13, '10:04'),
(16, 7, 14, '11:04'),
(17, 7, 16, '1'),
(18, 7, 18, 'Point 201A');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `department_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `role_name`, `department_id`) VALUES
(1, 'Admin', NULL),
(2, 'Staff', 1),
(3, 'Junior Engineer', 1),
(4, 'SSE', 1),
(5, 'Technician', 1),
(6, 'ESM', 1);

-- --------------------------------------------------------

--
-- Table structure for table `staff_demands`
--

CREATE TABLE `staff_demands` (
  `id` int(11) NOT NULL,
  `sub_department` enum('Signal','Telecom') NOT NULL,
  `section_name` varchar(255) NOT NULL,
  `station_id` int(11) NOT NULL,
  `road` varchar(50) NOT NULL,
  `other_road_details` varchar(255) DEFAULT NULL,
  `work_name` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  `demand_date` date NOT NULL,
  `created_by_admin_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff_demands`
--

INSERT INTO `staff_demands` (`id`, `sub_department`, `section_name`, `station_id`, `road`, `other_road_details`, `work_name`, `location`, `demand_date`, `created_by_admin_id`, `created_at`) VALUES
(1, 'Signal', '', 4, 'Up road', NULL, 'sdgd', 'dfhd', '2025-06-13', 5, '2025-06-11 19:56:58');

-- --------------------------------------------------------

--
-- Table structure for table `stations`
--

CREATE TABLE `stations` (
  `id` int(11) NOT NULL,
  `station_name` varchar(100) NOT NULL,
  `depot_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `stations`
--

INSERT INTO `stations` (`id`, `station_name`, `depot_id`) VALUES
(4, 'GWL', 5),
(5, 'RRU', 5);

-- --------------------------------------------------------

--
-- Table structure for table `ta_claims_master`
--

CREATE TABLE `ta_claims_master` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `month_year` varchar(20) NOT NULL,
  `basic_pay` int(11) NOT NULL,
  `pay_scale` varchar(50) NOT NULL,
  `grade_pay` int(11) NOT NULL,
  `pf_number` varchar(50) NOT NULL,
  `claim_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`claim_data`)),
  `total_amount` decimal(10,2) NOT NULL,
  `amount_in_words` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ta_claims_master`
--

INSERT INTO `ta_claims_master` (`id`, `user_id`, `month_year`, `basic_pay`, `pay_scale`, `grade_pay`, `pf_number`, `claim_data`, `total_amount`, `amount_in_words`, `created_at`) VALUES
(1, 6, '2025-06', 466, '7676', 7867, '789797', '[{\"date\":\"2025-06-13\",\"train_no\":\"1450\",\"dep_time\":\"16:42\",\"arr_time\":\"17:41\",\"from_stn\":\"VGLJ\",\"to_stn\":\"NDK\",\"kms\":\"10\",\"percentage\":\"30\",\"purpose\":\"work\",\"rate\":\"300\",\"pass_no\":\"4564566\"}]', 90.00, 'Ninety Only', '2025-06-13 09:10:54'),
(2, 6, '2025-06', 466, '7676', 7867, '789797', '[{\"date\":\"2025-06-13\",\"train_no\":\"1450\",\"dep_time\":\"16:42\",\"arr_time\":\"17:41\",\"from_stn\":\"VGLJ\",\"to_stn\":\"NDK\",\"kms\":\"10\",\"percentage\":\"30\",\"purpose\":\"work\",\"rate\":\"300\",\"pass_no\":\"4564566\"}]', 90.00, 'Ninety Only', '2025-06-13 09:13:11'),
(3, 6, '2025-06', 56435, '47687', 6786, '77467', '[{\"date\":\"2025-06-13\",\"train_no\":\"75678\",\"dep_time\":\"15:45\",\"arr_time\":\"16:46\",\"from_stn\":\"VGLJ\",\"to_stn\":\"NDK\",\"kms\":\"22\",\"percentage\":\"30\",\"purpose\":\"work\",\"rate\":\"300\",\"pass_no\":\"5124684185\"}]', 90.00, 'Ninety Only', '2025-06-13 09:14:59'),
(4, 6, '2025-06', 56435, '47687', 6786, '77467', '[{\"date\":\"2025-06-13\",\"train_no\":\"75678\",\"dep_time\":\"15:45\",\"arr_time\":\"16:46\",\"from_stn\":\"VGLJ\",\"to_stn\":\"NDK\",\"kms\":\"22\",\"percentage\":\"30\",\"purpose\":\"work\",\"rate\":\"300\",\"pass_no\":\"5124684185\"}]', 90.00, 'Ninety Only', '2025-06-13 09:20:38'),
(5, 6, '2025-06', 56435, '47687', 6786, '77467', '[{\"arr_time\":\"16:46\",\"date\":\"2025-06-13\",\"dep_time\":\"15:45\",\"from_stn\":\"VGLJ\",\"kms\":\"22\",\"pass_no\":\"5124684185\",\"percentage\":\"30\",\"purpose\":\"work\",\"rate\":\"300\",\"to_stn\":\"NDK\",\"train_no\":\"75678\"}]', 90.00, 'Ninety Only', '2025-06-13 09:20:40'),
(6, 6, '2025-06', 56435, '47687', 6786, '77467', '[{\"date\":\"2025-06-13\",\"train_no\":\"75678\",\"dep_time\":\"15:45\",\"arr_time\":\"16:46\",\"from_stn\":\"VGLJ\",\"to_stn\":\"NDK\",\"kms\":\"22\",\"percentage\":\"30\",\"purpose\":\"work\",\"rate\":\"300\",\"pass_no\":\"5124684185\"}]', 90.00, 'Ninety Only', '2025-06-13 09:28:45'),
(7, 6, '2025-06', 56435, '47687', 6786, '77467', '[{\"arr_time\":\"16:46\",\"date\":\"2025-06-13\",\"dep_time\":\"15:45\",\"from_stn\":\"VGLJ\",\"kms\":\"22\",\"pass_no\":\"5124684185\",\"percentage\":\"30\",\"purpose\":\"work\",\"rate\":\"300\",\"to_stn\":\"NDK\",\"train_no\":\"75678\"}]', 90.00, 'Ninety Only', '2025-06-13 09:28:49'),
(8, 6, '2025-06', 56435, '47687', 6786, '77467', '[{\"date\":\"2025-06-13\",\"train_no\":\"75678\",\"dep_time\":\"15:45\",\"arr_time\":\"16:46\",\"from_stn\":\"VGLJ\",\"to_stn\":\"NDK\",\"kms\":\"22\",\"percentage\":\"30\",\"purpose\":\"work\",\"rate\":\"300\",\"pass_no\":\"5124684185\"}]', 90.00, 'Ninety Only', '2025-06-13 09:35:10'),
(9, 6, '2025-06', 56435, '47687', 6786, '77467', '[{\"date\":\"2025-06-13\",\"train_no\":\"75678\",\"dep_time\":\"15:45\",\"arr_time\":\"16:46\",\"from_stn\":\"VGLJ\",\"to_stn\":\"NDK\",\"kms\":\"22\",\"percentage\":\"30\",\"purpose\":\"work\",\"rate\":\"300\",\"pass_no\":\"5124684185\"}]', 90.00, 'Ninety Only', '2025-06-13 09:43:09'),
(10, 6, '2025-06', 56435, '47687', 6786, '77467', '[{\"date\":\"2025-06-13\",\"train_no\":\"75678\",\"dep_time\":\"15:45\",\"arr_time\":\"16:46\",\"from_stn\":\"VGLJ\",\"to_stn\":\"NDK\",\"kms\":\"22\",\"percentage\":\"30\",\"purpose\":\"work\",\"rate\":\"300\",\"pass_no\":\"5124684185\"}]', 90.00, 'Ninety Only', '2025-06-13 10:02:32'),
(11, 6, '2025-06', 56435, '47687', 6786, '77467', '[{\"date\":\"2025-06-13\",\"train_no\":\"75678\",\"dep_time\":\"15:45\",\"arr_time\":\"16:46\",\"from_stn\":\"VGLJ\",\"to_stn\":\"NDK\",\"kms\":\"22\",\"percentage\":\"30\",\"purpose\":\"work\",\"rate\":\"300\",\"pass_no\":\"5124684185\"}]', 90.00, 'Ninety Only', '2025-06-13 10:09:15'),
(12, 6, '2025-06', 323232, '4674676', 76876, '7568767676', '[{\"date\":\"2025-06-13\",\"train_no\":\"21321\",\"dep_time\":\"16:48\",\"arr_time\":\"16:53\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"10\",\"percentage\":\"30\",\"purpose\":\"Work\",\"rate\":\"240\",\"pass_no\":\"5456464\"}]', 240.00, 'Two Hundred Forty Only', '2025-06-13 10:18:48'),
(13, 6, '2025-06', 323232, '4674676', 76876, '7568767676', '[{\"date\":\"2025-06-13\",\"train_no\":\"21321\",\"dep_time\":\"16:48\",\"arr_time\":\"16:53\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"10\",\"percentage\":\"30\",\"purpose\":\"Work\",\"rate\":\"240\",\"pass_no\":\"5456464\"},{\"date\":\"2025-06-13\",\"train_no\":\"5256\",\"dep_time\":\"17:50\",\"arr_time\":\"18:49\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"10\",\"percentage\":\"30\",\"purpose\":\"work\",\"rate\":\"0\",\"pass_no\":\"5456464\"}]', 240.00, 'Two Hundred Forty Only', '2025-06-13 10:20:18'),
(14, 6, '2025-06', 5456456, '51456456', 2147483647, '4897987561464', '[{\"date\":\"2025-06-10\",\"train_no\":\"5455\",\"dep_time\":\"17:14\",\"arr_time\":\"17:20\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-10\",\"train_no\":\"5456\",\"dep_time\":\"19:15\",\"arr_time\":\"19:21\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"0\",\"pass_no\":\"541896456\",\"merge\":\"on\"}]', 240.00, 'Two Hundred Forty Only', '2025-06-13 10:46:16'),
(15, 6, '2025-06', 5456456, '51456456', 2147483647, '4897987561464', '[{\"date\":\"2025-06-10\",\"train_no\":\"5455\",\"dep_time\":\"17:14\",\"arr_time\":\"17:20\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-10\",\"train_no\":\"5456\",\"dep_time\":\"19:15\",\"arr_time\":\"19:21\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"0\",\"pass_no\":\"541896456\",\"merge\":\"on\"}]', 240.00, 'Two Hundred Forty Only', '2025-06-13 10:46:53'),
(16, 6, '2025-06', 5456456, '51456456', 2147483647, '4897987561464', '[{\"date\":\"2025-06-10\",\"train_no\":\"5455\",\"dep_time\":\"17:14\",\"arr_time\":\"17:20\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-10\",\"train_no\":\"5456\",\"dep_time\":\"19:15\",\"arr_time\":\"19:21\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"240\",\"pass_no\":\"541896456\",\"merge\":\"on\"}]', 480.00, 'Four Hundred Eighty Only', '2025-06-13 10:51:25'),
(17, 6, '2025-06', 5456456, '51456456', 2147483647, '4897987561464', '[{\"date\":\"2025-06-10\",\"train_no\":\"5455\",\"dep_time\":\"17:14\",\"arr_time\":\"17:20\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-10\",\"train_no\":\"5456\",\"dep_time\":\"19:15\",\"arr_time\":\"19:21\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"\",\"pass_no\":\"541896456\",\"merge\":\"on\"},{\"date\":\"2025-06-11\",\"train_no\":\"8960\",\"dep_time\":\"03:22\",\"arr_time\":\"03:55\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"For failure attending\",\"rate\":\"240\",\"pass_no\":\"541896456\",\"merge\":\"on\"},{\"date\":\"2025-06-11\",\"train_no\":\"by road\",\"dep_time\":\"07:25\",\"arr_time\":\"08:40\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"For failure attending\",\"rate\":\"0\",\"pass_no\":\"541896456\",\"merge\":\"on\"}]', 480.00, 'Four Hundred Eighty Only', '2025-06-13 10:54:25'),
(18, 6, '2025-06', 5456456, '51456456', 2147483647, '4897987561464', '[{\"date\":\"2025-06-10\",\"train_no\":\"5455\",\"dep_time\":\"17:14\",\"arr_time\":\"17:20\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-10\",\"train_no\":\"5456\",\"dep_time\":\"19:15\",\"arr_time\":\"19:21\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"\",\"pass_no\":\"541896456\",\"merge\":\"on\"},{\"date\":\"2025-06-11\",\"train_no\":\"8960\",\"dep_time\":\"03:22\",\"arr_time\":\"03:55\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"For failure attending\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-11\",\"train_no\":\"by road\",\"dep_time\":\"07:25\",\"arr_time\":\"08:40\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"For failure attending\",\"rate\":\"0\",\"pass_no\":\"541896456\"}]', 480.00, 'Four Hundred Eighty Only', '2025-06-13 10:55:28'),
(19, 6, '2025-06', 5456456, '51456456', 2147483647, '4897987561464', '[{\"date\":\"2025-06-10\",\"train_no\":\"5455\",\"dep_time\":\"17:14\",\"arr_time\":\"17:20\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-10\",\"train_no\":\"5456\",\"dep_time\":\"19:15\",\"arr_time\":\"19:21\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-11\",\"train_no\":\"8960\",\"dep_time\":\"03:22\",\"arr_time\":\"03:55\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"For failure attending\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-11\",\"train_no\":\"by road\",\"dep_time\":\"07:25\",\"arr_time\":\"08:40\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"0\",\"pass_no\":\"541896456\"}]', 480.00, 'Four Hundred Eighty Only', '2025-06-13 11:02:41'),
(20, 6, '2025-06', 5456456, '51456456', 2147483647, '4897987561464', '[{\"date\":\"2025-06-10\",\"train_no\":\"5455\",\"dep_time\":\"17:14\",\"arr_time\":\"17:20\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-10\",\"train_no\":\"5456\",\"dep_time\":\"19:15\",\"arr_time\":\"19:21\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-11\",\"train_no\":\"8960\",\"dep_time\":\"03:22\",\"arr_time\":\"03:55\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"For failure attending\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-11\",\"train_no\":\"by road\",\"dep_time\":\"07:25\",\"arr_time\":\"08:40\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"0\",\"pass_no\":\"541896456\"}]', 480.00, 'Four Hundred Eighty Only', '2025-06-13 11:03:35'),
(21, 6, '2025-06', 5456456, '51456456', 2147483647, '4897987561464', '[{\"date\":\"2025-06-10\",\"train_no\":\"5455\",\"dep_time\":\"17:14\",\"arr_time\":\"17:20\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-10\",\"train_no\":\"5456\",\"dep_time\":\"19:15\",\"arr_time\":\"19:21\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-11\",\"train_no\":\"8960\",\"dep_time\":\"03:22\",\"arr_time\":\"03:55\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"For failure attending\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-11\",\"train_no\":\"by road\",\"dep_time\":\"07:25\",\"arr_time\":\"08:40\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"0\",\"pass_no\":\"541896456\"}]', 480.00, 'Four Hundred Eighty Only', '2025-06-13 11:27:54'),
(22, 6, '2025-06', 5456456, '51456456', 2147483647, '4897987561464', '[{\"date\":\"2025-06-10\",\"train_no\":\"5455\",\"dep_time\":\"17:14\",\"arr_time\":\"17:20\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-10\",\"train_no\":\"5456\",\"dep_time\":\"19:15\",\"arr_time\":\"19:21\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-11\",\"train_no\":\"8960\",\"dep_time\":\"03:22\",\"arr_time\":\"03:55\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"For failure attending\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-11\",\"train_no\":\"by road\",\"dep_time\":\"07:25\",\"arr_time\":\"08:40\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"0\",\"pass_no\":\"541896456\"}]', 480.00, 'Four Hundred Eighty Only', '2025-06-13 11:47:16'),
(23, 6, '2025-06', 5456456, '51456456', 2147483647, '4897987561464', '[{\"date\":\"2025-06-10\",\"train_no\":\"5455\",\"dep_time\":\"17:14\",\"arr_time\":\"17:20\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-10\",\"train_no\":\"5456\",\"dep_time\":\"19:15\",\"arr_time\":\"19:21\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"\",\"pass_no\":\"541896456\",\"merge\":\"on\"},{\"date\":\"2025-06-11\",\"train_no\":\"8960\",\"dep_time\":\"03:22\",\"arr_time\":\"03:55\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"For failure attending\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-11\",\"train_no\":\"by road\",\"dep_time\":\"07:25\",\"arr_time\":\"08:40\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"0\",\"pass_no\":\"541896456\",\"merge\":\"on\"}]', 480.00, 'Four Hundred Eighty Only', '2025-06-13 11:47:35'),
(24, 6, '2025-06', 5456456, '51456456', 2147483647, '4897987561464', '[{\"date\":\"2025-06-10\",\"train_no\":\"5455\",\"dep_time\":\"17:14\",\"arr_time\":\"17:20\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-10\",\"train_no\":\"5456\",\"dep_time\":\"19:15\",\"arr_time\":\"19:21\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"\",\"pass_no\":\"541896456\",\"merge\":\"on\"},{\"date\":\"2025-06-11\",\"train_no\":\"8960\",\"dep_time\":\"03:22\",\"arr_time\":\"03:55\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"For failure attending\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-11\",\"train_no\":\"by road\",\"dep_time\":\"07:25\",\"arr_time\":\"08:40\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"0\",\"pass_no\":\"541896456\",\"merge\":\"on\"}]', 480.00, 'Four Hundred Eighty Only', '2025-06-13 11:52:21'),
(25, 6, '2025-06', 5456456, '51456456', 2147483647, '4897987561464', '[{\"date\":\"2025-06-10\",\"train_no\":\"5455\",\"dep_time\":\"17:14\",\"arr_time\":\"17:20\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-10\",\"train_no\":\"5456\",\"dep_time\":\"19:15\",\"arr_time\":\"19:21\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"\",\"pass_no\":\"541896456\",\"merge\":\"on\"},{\"date\":\"2025-06-11\",\"train_no\":\"8960\",\"dep_time\":\"03:22\",\"arr_time\":\"03:55\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"For failure attending\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-11\",\"train_no\":\"by road\",\"dep_time\":\"07:25\",\"arr_time\":\"08:40\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"0\",\"pass_no\":\"541896456\",\"merge\":\"on\"}]', 480.00, 'Four Hundred Eighty Only', '2025-06-13 12:05:03'),
(26, 6, '2025-06', 5456456, '51456456', 2147483647, '4897987561464', '[{\"date\":\"2025-06-10\",\"train_no\":\"5455\",\"dep_time\":\"17:14\",\"arr_time\":\"17:20\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"for work\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-10\",\"train_no\":\"5456\",\"dep_time\":\"19:15\",\"arr_time\":\"19:21\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"\",\"pass_no\":\"541896456\",\"merge\":\"on\"},{\"date\":\"2025-06-11\",\"train_no\":\"8960\",\"dep_time\":\"03:22\",\"arr_time\":\"03:55\",\"from_stn\":\"VGLJ\",\"to_stn\":\"ORC\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"For failure attending\",\"rate\":\"240\",\"pass_no\":\"541896456\"},{\"date\":\"2025-06-11\",\"train_no\":\"by road\",\"dep_time\":\"07:25\",\"arr_time\":\"08:40\",\"from_stn\":\"ORC\",\"to_stn\":\"VGLJ\",\"kms\":\"13\",\"percentage\":\"\",\"purpose\":\"\",\"rate\":\"0\",\"pass_no\":\"541896456\",\"merge\":\"on\"}]', 480.00, 'Four Hundred Eighty Only', '2025-06-13 12:07:36'),
(27, 6, '2025-06', 545, '5646', 767, '767', '[{\"date\":\"2025-06-10\",\"train_no\":\"2563\",\"dep_time\":\"18:56\",\"arr_time\":\"20:55\",\"from_stn\":\"vglj\",\"to_stn\":\"orc\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"Work\",\"rate\":\"240\",\"pass_no\":\"45645645\"},{\"date\":\"2025-06-10\",\"train_no\":\"6963\",\"dep_time\":\"22:56\",\"arr_time\":\"23:56\",\"from_stn\":\"orc\",\"to_stn\":\"vglj\",\"kms\":\"13\",\"percentage\":\"0\",\"purpose\":\"\",\"rate\":\"0\",\"pass_no\":\"\",\"merge\":\"\"}]', 240.00, 'Two Hundred Forty Only', '2025-06-13 12:28:18'),
(28, 6, '2025-06', 545, '5646', 767, '767', '[{\"date\":\"2025-06-10\",\"train_no\":\"2563\",\"dep_time\":\"18:56\",\"arr_time\":\"20:55\",\"from_stn\":\"vglj\",\"to_stn\":\"orc\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"Work\",\"rate\":\"240\",\"pass_no\":\"45645645\"},{\"date\":\"2025-06-10\",\"train_no\":\"6963\",\"dep_time\":\"22:56\",\"arr_time\":\"23:56\",\"from_stn\":\"orc\",\"to_stn\":\"vglj\",\"kms\":\"13\",\"percentage\":\"0\",\"purpose\":\"work\",\"rate\":\"0\",\"pass_no\":\"45645645\",\"merge\":\"\"}]', 240.00, 'Two Hundred Forty Only', '2025-06-13 12:28:48'),
(29, 6, '2025-06', 545, '5646', 767, '767', '[{\"date\":\"2025-06-10\",\"train_no\":\"2563\",\"dep_time\":\"18:56\",\"arr_time\":\"20:55\",\"from_stn\":\"vglj\",\"to_stn\":\"orc\",\"kms\":\"13\",\"percentage\":\"30\",\"purpose\":\"Work\",\"rate\":\"240\",\"pass_no\":\"45645645\"},{\"date\":\"2025-06-10\",\"train_no\":\"6963\",\"dep_time\":\"22:56\",\"arr_time\":\"23:56\",\"from_stn\":\"orc\",\"to_stn\":\"vglj\",\"kms\":\"13\",\"percentage\":\"0\",\"purpose\":\"work\",\"rate\":\"0\",\"pass_no\":\"45645645\",\"merge\":\"\"}]', 240.00, 'Two Hundred Forty Only', '2025-06-13 12:29:07'),
(30, 6, '2025-06', 545, '5646', 767, '767', '[{\"date\":\"2025-06-10\",\"train_no\":\"2563\",\"dep_time\":\"18:56\",\"arr_time\":\"20:55\",\"from_stn\":\"vglj\",\"to_stn\":\"orc\",\"kms\":\"13\",\"percentage\":\"70\",\"purpose\":\"Work\",\"rate\":\"560\",\"pass_no\":\"45645645\"},{\"date\":\"2025-06-11\",\"train_no\":\"6963\",\"dep_time\":\"03:56\",\"arr_time\":\"04:56\",\"from_stn\":\"orc\",\"to_stn\":\"vglj\",\"kms\":\"13\",\"percentage\":\"0\",\"purpose\":\"work\",\"rate\":\"0\",\"pass_no\":\"45645645\",\"merge\":\"\"}]', 560.00, 'Five Hundred Sixty Only', '2025-06-13 12:30:01'),
(31, 6, '2025-06', 455254542, '6958686', 665555555, '5678968', '[{\"date\":\"2025-06-10\",\"train_no\":\"4574\",\"dep_time\":\"19:06\",\"arr_time\":\"20:06\",\"from_stn\":\"VGLJ\",\"to_stn\":\"CGN\",\"kms\":\"25\",\"percentage\":\"30\",\"purpose\":\"Work\",\"rate\":\"240\",\"pass_no\":\"25963\"},{\"date\":\"2025-06-10\",\"train_no\":\"8965\",\"dep_time\":\"22:07\",\"arr_time\":\"23:12\",\"from_stn\":\"CGN\",\"to_stn\":\"VGLJ\",\"kms\":\"25\",\"percentage\":\"0\",\"purpose\":\"Work\",\"rate\":\"0\",\"pass_no\":\"\",\"merge\":\"\"}]', 240.00, 'Two Hundred Forty Only', '2025-06-13 12:37:36'),
(32, 6, '2025-06', 455254542, '6958686', 665555555, '5678968', '[{\"date\":\"2025-06-10\",\"train_no\":\"4574\",\"dep_time\":\"19:06\",\"arr_time\":\"20:06\",\"from_stn\":\"VGLJ\",\"to_stn\":\"CGN\",\"kms\":\"25\",\"percentage\":\"30\",\"purpose\":\"Work\",\"rate\":\"240\",\"pass_no\":\"25963\"},{\"date\":\"2025-06-10\",\"train_no\":\"8965\",\"dep_time\":\"22:07\",\"arr_time\":\"23:12\",\"from_stn\":\"CGN\",\"to_stn\":\"VGLJ\",\"kms\":\"25\",\"percentage\":\"0\",\"purpose\":\"Work\",\"rate\":\"0\",\"pass_no\":\"\",\"merge\":\"\"}]', 240.00, 'Two Hundred Forty Only', '2025-06-13 12:44:59'),
(33, 6, '2025-06', 455254542, '6958686', 665555555, '5678968', '[{\"date\":\"2025-06-10\",\"train_no\":\"4574\",\"dep_time\":\"19:06\",\"arr_time\":\"20:06\",\"from_stn\":\"VGLJ\",\"to_stn\":\"CGN\",\"kms\":\"25\",\"percentage\":\"30\",\"purpose\":\"Work\",\"rate\":\"240\",\"pass_no\":\"25963\"},{\"date\":\"2025-06-10\",\"train_no\":\"8965\",\"dep_time\":\"22:07\",\"arr_time\":\"23:12\",\"from_stn\":\"CGN\",\"to_stn\":\"VGLJ\",\"kms\":\"25\",\"percentage\":\"0\",\"purpose\":\"Work\",\"rate\":\"0\",\"pass_no\":\"\",\"merge\":\"\"}]', 240.00, 'Two Hundred Forty Only', '2025-06-13 12:45:45'),
(34, 6, '2025-06', 455254542, '6958686', 665555555, '5678968', '[{\"date\":\"2025-06-10\",\"train_no\":\"4574\",\"dep_time\":\"19:06\",\"arr_time\":\"20:06\",\"from_stn\":\"VGLJ\",\"to_stn\":\"CGN\",\"kms\":\"25\",\"percentage\":\"30\",\"purpose\":\"Work\",\"rate\":\"240\",\"pass_no\":\"25963\"},{\"date\":\"2025-06-10\",\"train_no\":\"8965\",\"dep_time\":\"22:07\",\"arr_time\":\"23:12\",\"from_stn\":\"CGN\",\"to_stn\":\"VGLJ\",\"kms\":\"25\",\"percentage\":\"0\",\"purpose\":\"Work\",\"rate\":\"0\",\"pass_no\":\"\",\"merge\":\"\"}]', 240.00, 'Two Hundred Forty Only', '2025-06-13 12:50:05'),
(35, 6, '2025-06', 455254542, '6958686', 665555555, '5678968', '[{\"date\":\"2025-06-10\",\"train_no\":\"4574\",\"dep_time\":\"19:06\",\"arr_time\":\"20:06\",\"from_stn\":\"VGLJ\",\"to_stn\":\"CGN\",\"kms\":\"25\",\"percentage\":\"30\",\"purpose\":\"Work\",\"rate\":\"240\",\"pass_no\":\"25963\"},{\"date\":\"2025-06-10\",\"train_no\":\"8965\",\"dep_time\":\"22:07\",\"arr_time\":\"23:12\",\"from_stn\":\"CGN\",\"to_stn\":\"VGLJ\",\"kms\":\"25\",\"percentage\":\"0\",\"purpose\":\"Work\",\"rate\":\"0\",\"pass_no\":\"\",\"merge\":\"\"},{\"date\":\"2025-06-11\",\"train_no\":\"8596\",\"dep_time\":\"10:23\",\"arr_time\":\"13:22\",\"from_stn\":\"VGLJ\",\"to_stn\":\"MSV\",\"kms\":\"20\",\"percentage\":\"70\",\"purpose\":\"wrook new\",\"rate\":\"560\",\"pass_no\":\"25963\"},{\"date\":\"2025-06-11\",\"train_no\":\"9632\",\"dep_time\":\"16:21\",\"arr_time\":\"17:21\",\"from_stn\":\"MSV\",\"to_stn\":\"VGLJ\",\"kms\":\"20\",\"percentage\":\"0\",\"purpose\":\"wrook new\",\"rate\":\"0\",\"pass_no\":\"\",\"merge\":\"\"}]', 800.00, 'Eight Hundred Only', '2025-06-13 12:51:51'),
(36, 6, '2025-06', 455254542, '6958686', 665555555, '5678968', '[{\"date\":\"2025-06-10\",\"train_no\":\"4574\",\"dep_time\":\"19:06\",\"arr_time\":\"20:06\",\"from_stn\":\"VGLJ\",\"to_stn\":\"CGN\",\"kms\":\"25\",\"percentage\":\"30\",\"purpose\":\"Work\",\"rate\":\"240\",\"pass_no\":\"25963\"},{\"date\":\"2025-06-10\",\"train_no\":\"8965\",\"dep_time\":\"22:07\",\"arr_time\":\"23:12\",\"from_stn\":\"CGN\",\"to_stn\":\"VGLJ\",\"kms\":\"25\",\"percentage\":\"0\",\"purpose\":\"Work\",\"rate\":\"0\",\"pass_no\":\"\",\"merge\":\"\"},{\"date\":\"2025-06-11\",\"train_no\":\"8596\",\"dep_time\":\"10:23\",\"arr_time\":\"13:22\",\"from_stn\":\"VGLJ\",\"to_stn\":\"MSV\",\"kms\":\"20\",\"percentage\":\"70\",\"purpose\":\"wrook new\",\"rate\":\"560\",\"pass_no\":\"25963\"},{\"date\":\"2025-06-11\",\"train_no\":\"9632\",\"dep_time\":\"16:21\",\"arr_time\":\"17:21\",\"from_stn\":\"MSV\",\"to_stn\":\"VGLJ\",\"kms\":\"20\",\"percentage\":\"0\",\"purpose\":\"wrook new\",\"rate\":\"0\",\"pass_no\":\"\",\"merge\":\"\"}]', 800.00, 'Eight Hundred Only', '2025-06-13 12:55:23');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL COMMENT 'हमेशा एन्क्रिप्टेड पासवर्ड स्टोर करें',
  `contact_number` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT 'default.png',
  `role_id` int(11) NOT NULL,
  `sub_department` enum('Signal','Telecom') DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `depot_id` int(11) DEFAULT NULL,
  `station_id` int(11) DEFAULT NULL,
  `alternative_staff_id` int(11) DEFAULT NULL COMMENT 'इस स्टाफ की जगह कौन काम देखेगा, उसकी ID',
  `is_approved` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0=Pending, 1=Approved'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `full_name`, `username`, `password`, `contact_number`, `email`, `profile_picture`, `role_id`, `sub_department`, `department_id`, `depot_id`, `station_id`, `alternative_staff_id`, `is_approved`) VALUES
(2, 'jaihind singh', 'jaihind20', '$2y$10$jMLLQlXB1KPBGbBIQSZspe1gYiJPMICEwNIC3.JU8.ulPQOVON8zi', NULL, NULL, NULL, 2, NULL, NULL, NULL, NULL, NULL, 1),
(5, 'Admin User', 'admin', '$2y$10$l1aE/VX94NBcRKLE8kSX8.7gIs4rcySU38./NZGvMB1dq2SKy8K/e', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 1),
(6, 'jai', 'ZFMBGK', '$2y$10$mHfCjDJgUW7gua8xltjo..fFDV.OZdIj6UN3wKexXLR9srhy0kh1W', '+919936200200', 'jaihind20@gmail.com', 'uploads/6_1749736429.jpg', 4, NULL, 1, 5, 4, 7, 1),
(7, 'singh', 'ZFMBGL', '$2y$10$0oepgeDZV3VLdKwQlcF1qejhzs3TKgh7guCFjqiehcptWHUZRNOPm', '09794838885', 'jhsssesighq@gmail.com', NULL, 3, NULL, 1, 5, 5, 6, 1),
(8, 'Tech', 'TECH', '$2y$10$8bvyBnOFDyiHbD3eblLPg.3bzsLUwDhI3sPMLRAojlMNlFMbw2J46', '9936200200', 'tech@gmail.com', 'default.png', 5, NULL, 1, 5, 4, 2, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `daily_reports`
--
ALTER TABLE `daily_reports`
  ADD PRIMARY KEY (`report_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `demand_assignments`
--
ALTER TABLE `demand_assignments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `demand_user_unique` (`demand_id`,`user_id`),
  ADD KEY `fk_assignment_user` (`user_id`);

--
-- Indexes for table `demand_responses`
--
ALTER TABLE `demand_responses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `demand_user_response_unique` (`demand_id`,`user_id`),
  ADD KEY `fk_response_user` (`user_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `department_name` (`department_name`);

--
-- Indexes for table `depots`
--
ALTER TABLE `depots`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `depot_name` (`depot_name`),
  ADD KEY `department_id` (`department_id`);

--
-- Indexes for table `form_fields`
--
ALTER TABLE `form_fields`
  ADD PRIMARY KEY (`field_id`),
  ADD UNIQUE KEY `field_name` (`field_name`);

--
-- Indexes for table `form_field_roles`
--
ALTER TABLE `form_field_roles`
  ADD PRIMARY KEY (`field_id`,`role_id`),
  ADD KEY `fk_form_field` (`field_id`),
  ADD KEY `fk_role` (`role_id`);

--
-- Indexes for table `report_data`
--
ALTER TABLE `report_data`
  ADD PRIMARY KEY (`data_id`),
  ADD KEY `report_id` (`report_id`),
  ADD KEY `field_id` (`field_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `role_name` (`role_name`),
  ADD KEY `department_id` (`department_id`);

--
-- Indexes for table `staff_demands`
--
ALTER TABLE `staff_demands`
  ADD PRIMARY KEY (`id`),
  ADD KEY `station_id` (`station_id`);

--
-- Indexes for table `stations`
--
ALTER TABLE `stations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `depot_id` (`depot_id`);

--
-- Indexes for table `ta_claims_master`
--
ALTER TABLE `ta_claims_master`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `fk_user_role` (`role_id`),
  ADD KEY `fk_user_department` (`department_id`),
  ADD KEY `fk_user_depot` (`depot_id`),
  ADD KEY `fk_user_station` (`station_id`),
  ADD KEY `is_approved` (`is_approved`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `daily_reports`
--
ALTER TABLE `daily_reports`
  MODIFY `report_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `demand_assignments`
--
ALTER TABLE `demand_assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `demand_responses`
--
ALTER TABLE `demand_responses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `depots`
--
ALTER TABLE `depots`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `form_fields`
--
ALTER TABLE `form_fields`
  MODIFY `field_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `report_data`
--
ALTER TABLE `report_data`
  MODIFY `data_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `staff_demands`
--
ALTER TABLE `staff_demands`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `stations`
--
ALTER TABLE `stations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `ta_claims_master`
--
ALTER TABLE `ta_claims_master`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `daily_reports`
--
ALTER TABLE `daily_reports`
  ADD CONSTRAINT `daily_reports_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `demand_assignments`
--
ALTER TABLE `demand_assignments`
  ADD CONSTRAINT `fk_assignment_demand` FOREIGN KEY (`demand_id`) REFERENCES `staff_demands` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_assignment_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `demand_responses`
--
ALTER TABLE `demand_responses`
  ADD CONSTRAINT `fk_response_demand` FOREIGN KEY (`demand_id`) REFERENCES `staff_demands` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_response_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `form_field_roles`
--
ALTER TABLE `form_field_roles`
  ADD CONSTRAINT `fk_form_field` FOREIGN KEY (`field_id`) REFERENCES `form_fields` (`field_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `report_data`
--
ALTER TABLE `report_data`
  ADD CONSTRAINT `report_data_ibfk_1` FOREIGN KEY (`report_id`) REFERENCES `daily_reports` (`report_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `report_data_ibfk_2` FOREIGN KEY (`field_id`) REFERENCES `form_fields` (`field_id`) ON DELETE CASCADE;

--
-- Constraints for table `roles`
--
ALTER TABLE `roles`
  ADD CONSTRAINT `fk_role_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `staff_demands`
--
ALTER TABLE `staff_demands`
  ADD CONSTRAINT `fk_demand_station` FOREIGN KEY (`station_id`) REFERENCES `stations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `stations`
--
ALTER TABLE `stations`
  ADD CONSTRAINT `fk_station_depot` FOREIGN KEY (`depot_id`) REFERENCES `depots` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ta_claims_master`
--
ALTER TABLE `ta_claims_master`
  ADD CONSTRAINT `ta_claims_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_user_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_user_depot` FOREIGN KEY (`depot_id`) REFERENCES `depots` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `fk_user_station` FOREIGN KEY (`station_id`) REFERENCES `stations` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
