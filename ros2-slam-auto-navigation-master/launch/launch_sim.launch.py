import os

from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription
from launch.substitutions import PathJoinSubstitution
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch_ros.actions import Node
from launch_ros.substitutions import FindPackageShare


def generate_launch_description():
    package_name = 'ros2_slam_auto_navigation'

    rsp = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory(package_name), 'launch', 'rsp.launch.py'
        )]),
        launch_arguments={'use_sim_time': 'true', 'use_ros2_control': 'true'}.items()
    )

    twist_mux_params = os.path.join(
        get_package_share_directory(package_name), 'config', 'twist_mux.yaml'
    )
    twist_mux = Node(
        package="twist_mux",
        executable="twist_mux",
        parameters=[twist_mux_params, {'use_sim_time': True}],
        remappings=[('/cmd_vel_out', '/cmd_vel')]
    )

    rplidar_node = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([os.path.join(
            get_package_share_directory('rplidar_ros'), 'launch', 'view_rplidar_s2_launch.py'
        )]),
        launch_arguments={
            'serial_port': '/dev/ttyUSB1',
            'serial_baudrate': '1000000',
            'frame_id': 'lidar'
        }.items()
    )

    differential_drive_node = Node(
        package='zlac8015d_serial',
        executable='zlac_run',
        name='differential_drive',
        output='screen',
        respawn=True,
        respawn_delay=1.0
    )
    odom_node = Node(
        package='odometry_calculator',
        executable='odometry_calculator',
        name='odom_calculate',
        output='screen',
        respawn=True,
        respawn_delay=1.0
    )
    

    return LaunchDescription([
        rsp,
        twist_mux,
        differential_drive_node,
        rplidar_node
        #odom_node
    ])
