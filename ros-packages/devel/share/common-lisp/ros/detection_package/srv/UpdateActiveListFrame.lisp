; Auto-generated. Do not edit!


(cl:in-package detection_package-srv)


;//! \htmlinclude UpdateActiveListFrame-request.msg.html

(cl:defclass <UpdateActiveListFrame-request> (roslisp-msg-protocol:ros-message)
  ((active_list
    :reader active_list
    :initarg :active_list
    :type (cl:vector cl:integer)
   :initform (cl:make-array 0 :element-type 'cl:integer :initial-element 0))
   (active_frame
    :reader active_frame
    :initarg :active_frame
    :type cl:string
    :initform ""))
)

(cl:defclass UpdateActiveListFrame-request (<UpdateActiveListFrame-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <UpdateActiveListFrame-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'UpdateActiveListFrame-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name detection_package-srv:<UpdateActiveListFrame-request> is deprecated: use detection_package-srv:UpdateActiveListFrame-request instead.")))

(cl:ensure-generic-function 'active_list-val :lambda-list '(m))
(cl:defmethod active_list-val ((m <UpdateActiveListFrame-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader detection_package-srv:active_list-val is deprecated.  Use detection_package-srv:active_list instead.")
  (active_list m))

(cl:ensure-generic-function 'active_frame-val :lambda-list '(m))
(cl:defmethod active_frame-val ((m <UpdateActiveListFrame-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader detection_package-srv:active_frame-val is deprecated.  Use detection_package-srv:active_frame instead.")
  (active_frame m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <UpdateActiveListFrame-request>) ostream)
  "Serializes a message object of type '<UpdateActiveListFrame-request>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'active_list))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let* ((signed ele) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 18446744073709551616) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) unsigned) ostream)
    ))
   (cl:slot-value msg 'active_list))
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'active_frame))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'active_frame))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <UpdateActiveListFrame-request>) istream)
  "Deserializes a message object of type '<UpdateActiveListFrame-request>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'active_list) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'active_list)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) unsigned) (cl:read-byte istream))
      (cl:setf (cl:aref vals i) (cl:if (cl:< unsigned 9223372036854775808) unsigned (cl:- unsigned 18446744073709551616)))))))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'active_frame) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'active_frame) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<UpdateActiveListFrame-request>)))
  "Returns string type for a service object of type '<UpdateActiveListFrame-request>"
  "detection_package/UpdateActiveListFrameRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'UpdateActiveListFrame-request)))
  "Returns string type for a service object of type 'UpdateActiveListFrame-request"
  "detection_package/UpdateActiveListFrameRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<UpdateActiveListFrame-request>)))
  "Returns md5sum for a message object of type '<UpdateActiveListFrame-request>"
  "5a8fae94bc9f5cfafa76e73536e515b5")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'UpdateActiveListFrame-request)))
  "Returns md5sum for a message object of type 'UpdateActiveListFrame-request"
  "5a8fae94bc9f5cfafa76e73536e515b5")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<UpdateActiveListFrame-request>)))
  "Returns full string definition for message of type '<UpdateActiveListFrame-request>"
  (cl:format cl:nil "int64[] active_list~%string active_frame~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'UpdateActiveListFrame-request)))
  "Returns full string definition for message of type 'UpdateActiveListFrame-request"
  (cl:format cl:nil "int64[] active_list~%string active_frame~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <UpdateActiveListFrame-request>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'active_list) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     4 (cl:length (cl:slot-value msg 'active_frame))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <UpdateActiveListFrame-request>))
  "Converts a ROS message object to a list"
  (cl:list 'UpdateActiveListFrame-request
    (cl:cons ':active_list (active_list msg))
    (cl:cons ':active_frame (active_frame msg))
))
;//! \htmlinclude UpdateActiveListFrame-response.msg.html

(cl:defclass <UpdateActiveListFrame-response> (roslisp-msg-protocol:ros-message)
  ((result
    :reader result
    :initarg :result
    :type cl:boolean
    :initform cl:nil))
)

(cl:defclass UpdateActiveListFrame-response (<UpdateActiveListFrame-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <UpdateActiveListFrame-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'UpdateActiveListFrame-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name detection_package-srv:<UpdateActiveListFrame-response> is deprecated: use detection_package-srv:UpdateActiveListFrame-response instead.")))

(cl:ensure-generic-function 'result-val :lambda-list '(m))
(cl:defmethod result-val ((m <UpdateActiveListFrame-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader detection_package-srv:result-val is deprecated.  Use detection_package-srv:result instead.")
  (result m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <UpdateActiveListFrame-response>) ostream)
  "Serializes a message object of type '<UpdateActiveListFrame-response>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'result) 1 0)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <UpdateActiveListFrame-response>) istream)
  "Deserializes a message object of type '<UpdateActiveListFrame-response>"
    (cl:setf (cl:slot-value msg 'result) (cl:not (cl:zerop (cl:read-byte istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<UpdateActiveListFrame-response>)))
  "Returns string type for a service object of type '<UpdateActiveListFrame-response>"
  "detection_package/UpdateActiveListFrameResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'UpdateActiveListFrame-response)))
  "Returns string type for a service object of type 'UpdateActiveListFrame-response"
  "detection_package/UpdateActiveListFrameResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<UpdateActiveListFrame-response>)))
  "Returns md5sum for a message object of type '<UpdateActiveListFrame-response>"
  "5a8fae94bc9f5cfafa76e73536e515b5")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'UpdateActiveListFrame-response)))
  "Returns md5sum for a message object of type 'UpdateActiveListFrame-response"
  "5a8fae94bc9f5cfafa76e73536e515b5")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<UpdateActiveListFrame-response>)))
  "Returns full string definition for message of type '<UpdateActiveListFrame-response>"
  (cl:format cl:nil "bool result~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'UpdateActiveListFrame-response)))
  "Returns full string definition for message of type 'UpdateActiveListFrame-response"
  (cl:format cl:nil "bool result~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <UpdateActiveListFrame-response>))
  (cl:+ 0
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <UpdateActiveListFrame-response>))
  "Converts a ROS message object to a list"
  (cl:list 'UpdateActiveListFrame-response
    (cl:cons ':result (result msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'UpdateActiveListFrame)))
  'UpdateActiveListFrame-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'UpdateActiveListFrame)))
  'UpdateActiveListFrame-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'UpdateActiveListFrame)))
  "Returns string type for a service object of type '<UpdateActiveListFrame>"
  "detection_package/UpdateActiveListFrame")