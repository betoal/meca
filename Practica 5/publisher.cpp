#include <ros/ros.h>

#include <iostream>
#include <std_msgs/Int32.h>

using namespace std;

int main(int argc, char **argv)
{
	ros::init(argc,argv,"ejemplo_pub_node");
	ros::NodeHandle nh;
	ROS_INFO_STREAM("ejemplo_pub_node initialized");																																							
	ROS_INFO_STREAM(ros::this_node::getName());

	ros::Publisher pub = nh.advertise<std_msgs::Int32> ("/msg_ejemplo", 1);

	std_msgs::Int32 msg;
	int num; 
		
	while (ros::ok())
	{
		cout << "Introduce un numero entero:" << endl;
		cin >> num;

		msg.data = num;
		pub.publish(msg);
	}

    return 0;
}
