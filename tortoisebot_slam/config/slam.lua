-- include orijinaller
include "map_builder.lua"
include "trajectory_builder.lua"

options = {
  -- Temel çerçeve ayarları
  map_builder                    = MAP_BUILDER,
  trajectory_builder             = TRAJECTORY_BUILDER,
  map_frame                      = "map",
  tracking_frame                 = "base_link",
  published_frame                = "base_link",
  odom_frame                     = "odom",
  provide_odom_frame             = true,
  publish_frame_projected_to_2d  = true,

  -- Sensör kullanımı
  use_odometry                   = true,   -- wheel odometry ile drift azalt
  use_nav_sat                    = false,
  use_landmarks                  = false,

  -- Lidar / point cloud sayıları
  num_laser_scans                = 1,
  num_multi_echo_laser_scans     = 0,
  num_subdivisions_per_laser_scan= 1,
  num_point_clouds               = 0,

  -- Zamanlama
  lookup_transform_timeout_sec   = 0.2,
  submap_publish_period_sec      = 0.5,    -- submap oluşturma periyodu
  pose_publish_period_sec        = 0.01,   -- çok sık pose yayını
  trajectory_publish_period_sec  = 0.02,

  -- Örnekleme oranları
  rangefinder_sampling_ratio     = 1.0,
  odometry_sampling_ratio        = 1.0,
  fixed_frame_pose_sampling_ratio= 1.0,
  imu_sampling_ratio             = 1.0,
  landmarks_sampling_ratio       = 1.0,
}

-- 2D SLAM kullan
MAP_BUILDER.use_trajectory_builder_2d = true

-- TRAJECTORY_BUILDER_2D ince ayarlar
TRAJECTORY_BUILDER_2D.min_range                              = 0.1       -- yakın gürültüyü at
TRAJECTORY_BUILDER_2D.max_range                              = 6.0       -- güvenilir maksimum mesafe
TRAJECTORY_BUILDER_2D.missing_data_ray_length                = 6.5
TRAJECTORY_BUILDER_2D.use_imu_data                           = true      -- IMU varsa kullan
TRAJECTORY_BUILDER_2D.use_online_correlative_scan_matching   = true

-- Correlative scan matcher
TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.linear_search_window          = 0.15
TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.translation_delta_cost_weight = 20.0
TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.rotation_delta_cost_weight    = 0.01

-- Motion filtresi (gereksiz küçük hareketleri filtrele)
TRAJECTORY_BUILDER_2D.motion_filter.max_angle_radians      = math.rad(0.1)
TRAJECTORY_BUILDER_2D.motion_filter.max_distance_meters    = 0.1

-- Submap başına tarama sayısı
TRAJECTORY_BUILDER_2D.num_accumulated_range_data           = 35

-- POSE_GRAPH (loop closure & optimizasyon)
POSE_GRAPH.constraint_builder.sampling_ratio                = 0.3
POSE_GRAPH.constraint_builder.min_score                     = 0.7     -- eşleşme güven eşiği
POSE_GRAPH.constraint_builder.global_localization_min_score = 0.7
POSE_GRAPH.constraint_builder.max_constraint_distance       = 15.0

POSE_GRAPH.optimization_problem.huber_scale                 = 1e2
POSE_GRAPH.optimize_every_n_nodes                           = 15

return options
