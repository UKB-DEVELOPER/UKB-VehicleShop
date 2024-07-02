Create TABLE IF NOT EXISTS `ukb_vehicles` (
  `model` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` int(10) NOT NULL DEFAULT 0,
  `category` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stock` int(5) NOT NULL DEFAULT -1,
  `job` varchar(20) COLLATE utf8mb4_unicode_ci,
  `grade` int(1) DEFAULT 0,
  PRIMARY KEY (`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


REPLACE INTO `ukb_vehicles` (`model`, `label`, `price`, `category`, `stock`, `job`, `grade`) VALUES
    ('t20', 't20', 100000, 'Sports', 10, NULL, 0),
    ('sultan2', 'sultan2', 100000, 'Sports', -1, NULL, 0),
    ('bmx', 'bmx', 1000, 'SUV', -1, NULL, 0),
    ('huntley', 'huntley', 50000, 'SUV', 10, NULL, 0);