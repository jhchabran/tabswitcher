(ns tabswitcher.popup
  (:require [khroma.runtime :as runtime]
            [khroma.log :as console]
            [cljs.core.async :refer [>! <!]]
            [reagent.core :as reagent :refer [atom]])
  (:require-macros [cljs.core.async.macros :refer [go]]))

(def app-db (atom []))

(defn init []
  (let [bg (runtime/connect)]
    (go
      (>! bg :tabs)
      (let [tabs (<! bg)]
        (reset! app-db (js->clj tabs))
        (console/log "asking for tabs")
        (console/log tabs))))

  (reagent/render-component [some-component]
                            (.getElementById js/document "app")))

(defn some-component []
  [:div
   [:h3 "I am a tabswitcher"]
   [:p.someclass 
    "I have found " [:strong (count @app-db)] " tabs"]])
