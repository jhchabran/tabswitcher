(ns tabswitcher.background
  (:require [khroma.log :as console]
            [khroma.runtime :as runtime]
            [cljs.core.async :refer [>! <!] :as async])
  (:require-macros [cljs.core.async.macros :refer [go go-loop]]))

(defn init []
  (go-loop [conns (runtime/connections)
            popup (<! conns)]

    (let [[message & args] (<! popup)]
      (console/log "popup script said: " message)
      ; keywords ends as a string there, need to read khroma
      (condp = message
        "tabs"
        (.query js/chrome.tabs #js {:currentWindow true}
                (fn [result]
                  (async/put! popup result)))
        "jump"
        (let [tab-id (first args)]
          (.update js/chrome.tabs tab-id #js {:highlighted true}))
        nil
        (recur conns (<! conns)))
      (recur conns popup))))
