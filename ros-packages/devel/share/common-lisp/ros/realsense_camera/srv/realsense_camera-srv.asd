
(cl:in-package :asdf)

(defsystem "realsense_camera-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "StreamSensor" :depends-on ("_package_StreamSensor"))
    (:file "_package_StreamSensor" :depends-on ("_package"))
  ))