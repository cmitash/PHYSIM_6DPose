package marvin_convnet;

public interface DetectObjectsResponse extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "marvin_convnet/DetectObjectsResponse";
  static final java.lang.String _DEFINITION = "\nint32 FrameId           # Return the index of the frame in a sequence";
  int getFrameId();
  void setFrameId(int value);
}
