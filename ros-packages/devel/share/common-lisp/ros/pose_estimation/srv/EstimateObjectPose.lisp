; Auto-generated. Do not edit!


(cl:in-package pose_estimation-srv)


;//! \htmlinclude EstimateObjectPose-request.msg.html

(cl:defclass <EstimateObjectPose-request> (roslisp-msg-protocol:ros-message)
  ((SceneFiles
    :reader SceneFiles
    :initarg :SceneFiles
    :type cl:string
    :initform "")
   (CalibrationFiles
    :reader CalibrationFiles
    :initarg :CalibrationFiles
    :type cl:string
    :initform ""))
)

(cl:defclass EstimateObjectPose-request (<EstimateObjectPose-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <EstimateObjectPose-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'EstimateObjectPose-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name pose_estimation-srv:<EstimateObjectPose-request> is deprecated: use pose_estimation-srv:EstimateObjectPose-request instead.")))

(cl:ensure-generic-function 'SceneFiles-val :lambda-list '(m))
(cl:defmethod SceneFiles-val ((m <EstimateObjectPose-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader pose_estimation-srv:SceneFiles-val is deprecated.  Use pose_estimation-srv:SceneFiles instead.")
  (SceneFiles m))

(cl:ensure-generic-function 'CalibrationFiles-val :lambda-list '(m))
(cl:defmethod CalibrationFiles-val ((m <EstimateObjectPose-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader pose_estimation-srv:CalibrationFiles-val is deprecated.  Use pose_estimation-srv:CalibrationFiles instead.")
  (CalibrationFiles m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <EstimateObjectPose-request>) ostream)
  "Serializes a message object of type '<EstimateObjectPose-request>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'SceneFiles))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'SceneFiles))
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'CalibrationFiles))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'CalibrationFiles))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <EstimateObjectPose-request>) istream)
  "Deserializes a message object of type '<EstimateObjectPose-request>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'SceneFiles) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'SceneFiles) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'CalibrationFiles) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'CalibrationFiles) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<EstimateObjectPose-request>)))
  "Returns string type for a service object of type '<EstimateObjectPose-request>"
  "pose_estimation/EstimateObjectPoseRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'EstimateObjectPose-request)))
  "Returns string type for a service object of type 'EstimateObjectPose-request"
  "pose_estimation/EstimateObjectPoseRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<EstimateObjectPose-request>)))
  "Returns md5sum for a message object of type '<EstimateObjectPose-request>"
  "828b8959ca98f06115ccafe45aef2e20")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'EstimateObjectPose-request)))
  "Returns md5sum for a message object of type 'EstimateObjectPose-request"
  "828b8959ca98f06115ccafe45aef2e20")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<EstimateObjectPose-request>)))
  "Returns full string definition for message of type '<EstimateObjectPose-request>"
  (cl:format cl:nil "~%string SceneFiles~%string CalibrationFiles~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'EstimateObjectPose-request)))
  "Returns full string definition for message of type 'EstimateObjectPose-request"
  (cl:format cl:nil "~%string SceneFiles~%string CalibrationFiles~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <EstimateObjectPose-request>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'SceneFiles))
     4 (cl:length (cl:slot-value msg 'CalibrationFiles))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <EstimateObjectPose-request>))
  "Converts a ROS message object to a list"
  (cl:list 'EstimateObjectPose-request
    (cl:cons ':SceneFiles (SceneFiles msg))
    (cl:cons ':CalibrationFiles (CalibrationFiles msg))
))
;//! \htmlinclude EstimateObjectPose-response.msg.html

(cl:defclass <EstimateObjectPose-response> (roslisp-msg-protocol:ros-message)
  ((Objects
    :reader Objects
    :initarg :Objects
    :type (cl:vector pose_estimation-msg:ObjectPose)
   :initform (cl:make-array 0 :element-type 'pose_estimation-msg:ObjectPose :initial-element (cl:make-instance 'pose_estimation-msg:ObjectPose))))
)

(cl:defclass EstimateObjectPose-response (<EstimateObjectPose-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <EstimateObjectPose-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'EstimateObjectPose-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name pose_estimation-srv:<EstimateObjectPose-response> is deprecated: use pose_estimation-srv:EstimateObjectPose-response instead.")))

(cl:ensure-generic-function 'Objects-val :lambda-list '(m))
(cl:defmethod Objects-val ((m <EstimateObjectPose-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader pose_estimation-srv:Objects-val is deprecated.  Use pose_estimation-srv:Objects instead.")
  (Objects m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <EstimateObjectPose-response>) ostream)
  "Serializes a message object of type '<EstimateObjectPose-response>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'Objects))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'Objects))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <EstimateObjectPose-response>) istream)
  "Deserializes a message object of type '<EstimateObjectPose-response>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'Objects) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'Objects)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'pose_estimation-msg:ObjectPose))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<EstimateObjectPose-response>)))
  "Returns string type for a service object of type '<EstimateObjectPose-response>"
  "pose_estimation/EstimateObjectPoseResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'EstimateObjectPose-response)))
  "Returns string type for a service object of type 'EstimateObjectPose-response"
  "pose_estimation/EstimateObjectPoseResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<EstimateObjectPose-response>)))
  "Returns md5sum for a message object of type '<EstimateObjectPose-response>"
  "828b8959ca98f06115ccafe45aef2e20")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'EstimateObjectPose-response)))
  "Returns md5sum for a message object of type 'EstimateObjectPose-response"
  "828b8959ca98f06115ccafe45aef2e20")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<EstimateObjectPose-response>)))
  "Returns full string definition for message of type '<EstimateObjectPose-response>"
  (cl:format cl:nil "~%~%ObjectPose[] Objects~%~%~%================================================================================~%MSG: pose_estimation/ObjectPose~%string label~%geometry_msgs/Pose pose~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of postion and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'EstimateObjectPose-response)))
  "Returns full string definition for message of type 'EstimateObjectPose-response"
  (cl:format cl:nil "~%~%ObjectPose[] Objects~%~%~%================================================================================~%MSG: pose_estimation/ObjectPose~%string label~%geometry_msgs/Pose pose~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of postion and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <EstimateObjectPose-response>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'Objects) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <EstimateObjectPose-response>))
  "Converts a ROS message object to a list"
  (cl:list 'EstimateObjectPose-response
    (cl:cons ':Objects (Objects msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'EstimateObjectPose)))
  'EstimateObjectPose-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'EstimateObjectPose)))
  'EstimateObjectPose-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'EstimateObjectPose)))
  "Returns string type for a service object of type '<EstimateObjectPose>"
  "pose_estimation/EstimateObjectPose")