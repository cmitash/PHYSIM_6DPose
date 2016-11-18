package detection_package;

public interface UpdateBboxResponse extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "detection_package/UpdateBboxResponse";
  static final java.lang.String _DEFINITION = "int64[] object_num\nint64[] tl_x\nint64[] tl_y\nint64[] br_x\nint64[] br_y\nfloat64[] scores";
  long[] getObjectNum();
  void setObjectNum(long[] value);
  long[] getTlX();
  void setTlX(long[] value);
  long[] getTlY();
  void setTlY(long[] value);
  long[] getBrX();
  void setBrX(long[] value);
  long[] getBrY();
  void setBrY(long[] value);
  double[] getScores();
  void setScores(double[] value);
}
