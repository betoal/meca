#include <ros/ros.h>

#include <iostream>
#include <std_msgs/Int32.h>

#define RATE_HZ 2

using namespace std;
int num = -1;

void get_msg(const std_msgs::Int32& msg) {
	num = msg.data;
	ROS_INFO_STREAM("Valor recibido: " << num);
}

int main(int argc, char **argv)
{
	ros::init(argc,argv,"ejemplo_sub_node");
	ros::NodeHandle nh;
	ROS_INFO_STREAM("ejemplo_sub_node initialized");																																							
	ROS_INFO_STREAM(ros::this_node::getName());

	ros::Subscriber sub_vel = nh.subscribe("/msg_ejemplo", 1000, &get_msg);

	ros::Rate rate(RATE_HZ);
		
	while (ros::ok())
	{

		ROS_INFO_STREAM(".");

		ros::spinOnce();
		// ros::spin();
		rate.sleep();
	}

    return 0;
}
