package detection_package;

public interface UpdateBbox extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "detection_package/UpdateBbox";
  static final java.lang.String _DEFINITION = "bool request\n---\nint64[] object_num\nint64[] tl_x\nint64[] tl_y\nint64[] br_x\nint64[] br_y\nfloat64[] scores\n";
}
