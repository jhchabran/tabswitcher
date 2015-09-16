(ns tabswitcher.messaging
  (:require [khroma.runtime :as runtime]))

(defn send-background [message callback]
  (runtime/send-message message :responseCallback callback))

