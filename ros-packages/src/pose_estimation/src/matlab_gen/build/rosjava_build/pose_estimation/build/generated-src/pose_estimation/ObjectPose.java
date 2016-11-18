package pose_estimation;

public interface ObjectPose extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "pose_estimation/ObjectPose";
  static final java.lang.String _DEFINITION = "string label\ngeometry_msgs/Pose pose\n";
  java.lang.String getLabel();
  void setLabel(java.lang.String value);
  geometry_msgs.Pose getPose();
  void setPose(geometry_msgs.Pose value);
}
