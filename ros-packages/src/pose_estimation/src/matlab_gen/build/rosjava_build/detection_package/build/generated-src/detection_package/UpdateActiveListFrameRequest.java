package detection_package;

public interface UpdateActiveListFrameRequest extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "detection_package/UpdateActiveListFrameRequest";
  static final java.lang.String _DEFINITION = "int64[] active_list\nstring active_frame\n";
  long[] getActiveList();
  void setActiveList(long[] value);
  java.lang.String getActiveFrame();
  void setActiveFrame(java.lang.String value);
}
