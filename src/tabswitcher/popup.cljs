(ns tabswitcher.popup
  (:require [khroma.runtime :as runtime]
            [khroma.log :as console]
            [cljs.core.async :refer [>! <!]]
            [reagent.core :as r]
            [re-frame.core :refer [dispatch dispatch-sync]]

            [tabswitcher.messaging :refer [send-background]]
            [tabswitcher.handlers]
            [tabswitcher.views :as views]
            [tabswitcher.subs])

  (:require-macros [cljs.core.async.macros :refer [go]]
                   [reagent.ratom :refer [reaction]]))

(defn init []
  (dispatch-sync [:initialize-db])
  (send-background [:tabs] #(dispatch [:update %1]))
  (r/render-component [views/app]
                      (.getElementById js/document "app")))

