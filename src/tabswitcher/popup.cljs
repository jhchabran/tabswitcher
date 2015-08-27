(ns tabswitcher.popup
  (:require [khroma.runtime :as runtime]
            [khroma.log :as console]
            [cljs.core.async :refer [>! <!]]
            [reagent.core :as r]
            [re-frame.core :refer [dispatch dispatch-sync]]

            [tabswitcher.handlers]
            [tabswitcher.views :as views]
            [tabswitcher.subs])

  (:require-macros [cljs.core.async.macros :refer [go]]
                   [reagent.ratom :refer [reaction]]))

(defn init []
  (let [bg (runtime/connect)]
    (dispatch-sync [:initialize-db])
    (dispatch [:filter ""])

    (go
      (>! bg [:tabs])
      (let [tabs (<! bg)]
        (dispatch [:assign-bg-chan bg])
        (dispatch [:update tabs])
        (console/log tabs))))

  (r/render-component [views/app]
                      (.getElementById js/document "app")))
