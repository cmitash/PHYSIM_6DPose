
(cl:in-package :asdf)

(defsystem "detection_package-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "UpdateBbox" :depends-on ("_package_UpdateBbox"))
    (:file "_package_UpdateBbox" :depends-on ("_package"))
    (:file "UpdateActiveListFrame" :depends-on ("_package_UpdateActiveListFrame"))
    (:file "_package_UpdateActiveListFrame" :depends-on ("_package"))
  ))