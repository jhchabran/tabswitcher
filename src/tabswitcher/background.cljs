(ns tabswitcher.background
  (:require [khroma.log :as console]
            [khroma.runtime :as runtime]
            [cljs.core.async :refer [>! <!] :as async])
  (:require-macros [cljs.core.async.macros :refer [go-loop]]))

(defn init []
  (go-loop
    []
    (let [conns (runtime/connections)
          content (<! conns)
          message (<! content)]
      (condp message
        :tabs
        (.query js/chrome.tabs #js {:currentWindow true}
                (fn [result]
                  ( async/put! content result))))

      (console/log "Content script said: " message)
      (recur))))
