
(cl:in-package :asdf)

(defsystem "pose_estimation-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :pose_estimation-msg
)
  :components ((:file "_package")
    (:file "EstimateObjectPose" :depends-on ("_package_EstimateObjectPose"))
    (:file "_package_EstimateObjectPose" :depends-on ("_package"))
  ))