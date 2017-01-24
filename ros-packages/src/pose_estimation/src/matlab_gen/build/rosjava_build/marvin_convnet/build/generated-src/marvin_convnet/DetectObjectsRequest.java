package marvin_convnet;

public interface DetectObjectsRequest extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "marvin_convnet/DetectObjectsRequest";
  static final java.lang.String _DEFINITION = "string[] ObjectNames    # List of object names in the scene\nint32 BinId             # Set depending the environment of the scene: -1 for tote, 0-11 for shelf \nint32 FrameId           # Set the index of the frame in a sequence\n\n";
  java.util.List<java.lang.String> getObjectNames();
  void setObjectNames(java.util.List<java.lang.String> value);
  int getBinId();
  void setBinId(int value);
  int getFrameId();
  void setFrameId(int value);
}
