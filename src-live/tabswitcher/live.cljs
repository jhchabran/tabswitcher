(ns tabswitcher.live
  (:require [re-frame.core :refer [register-handler dispatch dispatch-sync]]
            [reagent.core :as r]
            [tabswitcher.handlers]
            [tabswitcher.views :as views]
            [tabswitcher.subs]))

(defn init []
  (dispatch-sync [:initialize-fake-db])
  (dispatch [:filter ""])
  (r/render-component [views/app]
                      (.getElementById js/document "app")))

(def fake-db
  {:tabs [
          {:active false
           :favIconUrl "https://www.google.fr/favicon.ico"
           :height 676
           :highlighted false
           :id 337
           :incognito false
           :index 0
           :pinned false
           :selected false
           :status "complete"
           :title "New Tab"
           :url "chrome://newtab/"
           :width 1297
           :windowId 336}
          {:active false
           :favIconUrl "https://assets-cdn.github.com/favicon.ico"
           :height 676
           :highlighted false
           :id 338
           :incognito false
           :index 0
           :pinned false
           :selected false
           :status "complete"
           :title "Ruby"
           :url "https://github.com"
           :width 1297
           :windowId 336}
          {:active false
           :favIconUrl "https://assets-cdn.github.com/favicon.ico"
           :height 676
           :highlighted false
           :id 338
           :incognito false
           :index 0
           :pinned false
           :selected false
           :status "complete"
           :title "Clojure"
           :url "https://github.com"
           :width 1297
           :windowId 336}
          {:active false
           :favIconUrl "https://assets-cdn.github.com/favicon.ico"
           :height 676
           :highlighted false
           :id 339
           :incognito false
           :index 0
           :pinned false
           :selected false
           :status "complete"
           :title "Haskell"
           :url "https://github.com"
           :width 1297
           :windowId 336}]
   :results []
   :query ""
   :selection 0})

(register-handler
  :initialize-fake-db
  (fn [_ _]
    fake-db))
