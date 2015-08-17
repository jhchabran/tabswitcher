(ns tabswitcher.popup
  (:require [khroma.runtime :as runtime]
            [khroma.log :as console]
            [cljs.core.async :refer [>! <!]]
            [reagent.core :as reagent :refer [atom]])
  (:require-macros [cljs.core.async.macros :refer [go]]))

(defn init []
  (let [bg (runtime/connect)]
    (go (>! bg :lol-i-am-a-popup)
        (console/log "Background said: " (<! bg))))
  
 (reagent/render-component [some-component]
                            (.getElementById js/document "app")))

(defn some-component []
  [:div
   [:h3 "I am a component!"]
   [:p.someclass 
    "I have " [:strong "bold"]
    [:span {:style {:color "red"}} " and red"]
    " text."]])

