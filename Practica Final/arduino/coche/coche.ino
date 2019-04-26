#include <SoftwareSerial.h>
#include <ros.h>
#include <std_msgs/Float32.h>

/**
 * Initializes variables.
 */

ros::NodeHandle nh;
std_msgs::Float32 ros_msg;
int bee_input = 3;
int bee_output = 2;
SoftwareSerial xbee_serial(bee_input, bee_output);
//ros::Publisher pub("arduino_msg", &str_msg);

/**
 * The subscriber.
 */

void message_ros(const std_msgs::Float32& ros_msg) {
  float msg = ros_msg.data;
  digitalWrite(8, HIGH);
  delay(3000);
  digitalWrite(8, LOW);
  
}
ros::Subscriber<std_msgs::Float32> speed_sub("/speed_msg", &message_ros);

/**
 * The setup.
 */

void setup() {
  // put your setup code here, to run once:
  pinMode(11, OUTPUT);
  
  xbee_serial.begin(9600);
  
  nh.initNode();
  //nh.advertise(pub);
  
  nh.subscribe(speed_sub);
}


void loop() {
  // put your main code here, to run repeatedly:
  int r = xbee_serial.read();
  if (r == 1)
    digitalWrite(11, HIGH);
  else digitalWrite(11, LOW);
  //nh.spinOnce();
}
