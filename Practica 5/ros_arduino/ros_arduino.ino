#include <ros.h>
#include <std_msgs/String.h>

void message_ros(const std_msgs::String& ros_msg) {
  String msg = ros_msg.data;
  digitalWrite(8, HIGH);
  delay(3000);
  digitalWrite(8, LOW);
  
}

ros::NodeHandle nh;
std_msgs::String str_msg;
//ros::Publisher pub("arduino_msg", &str_msg);
ros::Subscriber<std_msgs::String> sub("/arduino_msg", &message_ros);

void setup() {
  // put your setup code here, to run once:
  pinMode(8, OUTPUT);
  nh.initNode();
  //nh.advertise(pub);
  
  nh.subscribe(sub);
}


void loop() {
  // put your main code here, to run repeatedly:
  nh.spinOnce();
  delay(500);
}
