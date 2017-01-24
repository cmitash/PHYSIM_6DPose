package marvin_convnet;

public interface DetectObjects extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "marvin_convnet/DetectObjects";
  static final java.lang.String _DEFINITION = "string[] ObjectNames    # List of object names in the scene\nint32 BinId             # Set depending the environment of the scene: -1 for tote, 0-11 for shelf \nint32 FrameId           # Set the index of the frame in a sequence\n\n---\n\nint32 FrameId           # Return the index of the frame in a sequence\n\n";
}
