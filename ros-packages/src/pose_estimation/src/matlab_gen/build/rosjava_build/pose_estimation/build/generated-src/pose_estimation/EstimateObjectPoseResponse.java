package pose_estimation;

public interface EstimateObjectPoseResponse extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "pose_estimation/EstimateObjectPoseResponse";
  static final java.lang.String _DEFINITION = "\n# Detection information for each candidate object\nObjectPose[] Objects";
  java.util.List<pose_estimation.ObjectPose> getObjects();
  void setObjects(java.util.List<pose_estimation.ObjectPose> value);
}
