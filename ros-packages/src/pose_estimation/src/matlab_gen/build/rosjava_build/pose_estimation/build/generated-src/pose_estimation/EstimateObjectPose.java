package pose_estimation;

public interface EstimateObjectPose extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "pose_estimation/EstimateObjectPose";
  static final java.lang.String _DEFINITION = "# List of candidate objects\nstring SceneFiles # Directory containing RGB-D frames of the target scene\nstring CalibrationFiles # Directory containing calibrated camera poses\n\n---\n\n# Detection information for each candidate object\nObjectPose[] Objects\n";
}
