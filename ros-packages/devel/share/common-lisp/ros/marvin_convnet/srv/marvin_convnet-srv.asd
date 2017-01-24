
(cl:in-package :asdf)

(defsystem "marvin_convnet-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "DetectObjects" :depends-on ("_package_DetectObjects"))
    (:file "_package_DetectObjects" :depends-on ("_package"))
  ))