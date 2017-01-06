; Auto-generated. Do not edit!


(cl:in-package marvin_convnet-srv)


;//! \htmlinclude DetectObjects-request.msg.html

(cl:defclass <DetectObjects-request> (roslisp-msg-protocol:ros-message)
  ((ObjectNames
    :reader ObjectNames
    :initarg :ObjectNames
    :type (cl:vector cl:string)
   :initform (cl:make-array 0 :element-type 'cl:string :initial-element ""))
   (BinId
    :reader BinId
    :initarg :BinId
    :type cl:integer
    :initform 0)
   (FrameId
    :reader FrameId
    :initarg :FrameId
    :type cl:integer
    :initform 0))
)

(cl:defclass DetectObjects-request (<DetectObjects-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <DetectObjects-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'DetectObjects-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name marvin_convnet-srv:<DetectObjects-request> is deprecated: use marvin_convnet-srv:DetectObjects-request instead.")))

(cl:ensure-generic-function 'ObjectNames-val :lambda-list '(m))
(cl:defmethod ObjectNames-val ((m <DetectObjects-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader marvin_convnet-srv:ObjectNames-val is deprecated.  Use marvin_convnet-srv:ObjectNames instead.")
  (ObjectNames m))

(cl:ensure-generic-function 'BinId-val :lambda-list '(m))
(cl:defmethod BinId-val ((m <DetectObjects-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader marvin_convnet-srv:BinId-val is deprecated.  Use marvin_convnet-srv:BinId instead.")
  (BinId m))

(cl:ensure-generic-function 'FrameId-val :lambda-list '(m))
(cl:defmethod FrameId-val ((m <DetectObjects-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader marvin_convnet-srv:FrameId-val is deprecated.  Use marvin_convnet-srv:FrameId instead.")
  (FrameId m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <DetectObjects-request>) ostream)
  "Serializes a message object of type '<DetectObjects-request>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'ObjectNames))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((__ros_str_len (cl:length ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) ele))
   (cl:slot-value msg 'ObjectNames))
  (cl:let* ((signed (cl:slot-value msg 'BinId)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'FrameId)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <DetectObjects-request>) istream)
  "Deserializes a message object of type '<DetectObjects-request>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'ObjectNames) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'ObjectNames)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:aref vals i) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:aref vals i) __ros_str_idx) (cl:code-char (cl:read-byte istream))))))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'BinId) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'FrameId) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<DetectObjects-request>)))
  "Returns string type for a service object of type '<DetectObjects-request>"
  "marvin_convnet/DetectObjectsRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'DetectObjects-request)))
  "Returns string type for a service object of type 'DetectObjects-request"
  "marvin_convnet/DetectObjectsRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<DetectObjects-request>)))
  "Returns md5sum for a message object of type '<DetectObjects-request>"
  "deaeaba672c95d5138aecb89dd9fc829")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'DetectObjects-request)))
  "Returns md5sum for a message object of type 'DetectObjects-request"
  "deaeaba672c95d5138aecb89dd9fc829")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<DetectObjects-request>)))
  "Returns full string definition for message of type '<DetectObjects-request>"
  (cl:format cl:nil "string[] ObjectNames~%int32 BinId~%int32 FrameId~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'DetectObjects-request)))
  "Returns full string definition for message of type 'DetectObjects-request"
  (cl:format cl:nil "string[] ObjectNames~%int32 BinId~%int32 FrameId~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <DetectObjects-request>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'ObjectNames) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 4 (cl:length ele))))
     4
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <DetectObjects-request>))
  "Converts a ROS message object to a list"
  (cl:list 'DetectObjects-request
    (cl:cons ':ObjectNames (ObjectNames msg))
    (cl:cons ':BinId (BinId msg))
    (cl:cons ':FrameId (FrameId msg))
))
;//! \htmlinclude DetectObjects-response.msg.html

(cl:defclass <DetectObjects-response> (roslisp-msg-protocol:ros-message)
  ((FrameId
    :reader FrameId
    :initarg :FrameId
    :type cl:integer
    :initform 0))
)

(cl:defclass DetectObjects-response (<DetectObjects-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <DetectObjects-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'DetectObjects-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name marvin_convnet-srv:<DetectObjects-response> is deprecated: use marvin_convnet-srv:DetectObjects-response instead.")))

(cl:ensure-generic-function 'FrameId-val :lambda-list '(m))
(cl:defmethod FrameId-val ((m <DetectObjects-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader marvin_convnet-srv:FrameId-val is deprecated.  Use marvin_convnet-srv:FrameId instead.")
  (FrameId m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <DetectObjects-response>) ostream)
  "Serializes a message object of type '<DetectObjects-response>"
  (cl:let* ((signed (cl:slot-value msg 'FrameId)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <DetectObjects-response>) istream)
  "Deserializes a message object of type '<DetectObjects-response>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'FrameId) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<DetectObjects-response>)))
  "Returns string type for a service object of type '<DetectObjects-response>"
  "marvin_convnet/DetectObjectsResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'DetectObjects-response)))
  "Returns string type for a service object of type 'DetectObjects-response"
  "marvin_convnet/DetectObjectsResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<DetectObjects-response>)))
  "Returns md5sum for a message object of type '<DetectObjects-response>"
  "deaeaba672c95d5138aecb89dd9fc829")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'DetectObjects-response)))
  "Returns md5sum for a message object of type 'DetectObjects-response"
  "deaeaba672c95d5138aecb89dd9fc829")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<DetectObjects-response>)))
  "Returns full string definition for message of type '<DetectObjects-response>"
  (cl:format cl:nil "~%int32 FrameId~%~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'DetectObjects-response)))
  "Returns full string definition for message of type 'DetectObjects-response"
  (cl:format cl:nil "~%int32 FrameId~%~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <DetectObjects-response>))
  (cl:+ 0
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <DetectObjects-response>))
  "Converts a ROS message object to a list"
  (cl:list 'DetectObjects-response
    (cl:cons ':FrameId (FrameId msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'DetectObjects)))
  'DetectObjects-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'DetectObjects)))
  'DetectObjects-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'DetectObjects)))
  "Returns string type for a service object of type '<DetectObjects>"
  "marvin_convnet/DetectObjects")