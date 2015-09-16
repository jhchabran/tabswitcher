(ns tabswitcher.background
  (:require [khroma.log :as console]
            [khroma.runtime :as runtime]
            [cljs.core.async :refer [>! <!] :as async])
  (:require-macros [cljs.core.async.macros :refer [go go-loop]]))

; See https://github.com/jhchabran/khroma 
(defn messages []
  (let [ch (async/chan)]    
    (.addListener js/chrome.runtime.onMessage 
      (fn [message sender reply-fn]
        (go
          (>! ch (runtime/message-event message sender reply-fn)))
        true))
    ch))

(defn init []
  (let [messages (messages)]
    (go-loop []
             (when-let [{:keys [message sender response-fn]} (<! messages)]
               (console/log "popup script said: " message)
               ; keywords ends as a string there, 
               ; see khroma.runtime/connect, (.postMessage port (clj->js message))
               (condp = (first message)
                 "tabs"
                 (.query js/chrome.tabs 
                         #js {:currentWindow true}
                         (fn [result]
                           (response-fn result)))

                 "jump"
                 (let [[tab-id tab-ids] (rest message)]
                   ; Jump onto targeted tab
                   (.update js/chrome.tabs tab-id #js {:highlighted true})
                   ; Deselect everyone
                   (doseq [id tab-ids]
                     (.update js/chrome.tabs id #js {:highlighted false})))))
             (recur))))

