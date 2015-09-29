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

; Overwrite jump handler so we can see it working when
; working on popup.cljs live instead of as an extension,
(register-handler
  :jump
  (fn [db [_ tab]]
    (.log js/console "handler :jump called")
    (.log js/console tab)
    db))

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
           :url "https://github.com/ruby/ruby"
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
           :url "https://github.com/clojure/clojure"
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
           :url "https://github.com/haskell/haskell"
           :width 1297
           :windowId 336}]
   :results []
   :query ""
   :selection 0})

(register-handler
  :initialize-fake-db
  (fn [_ _]
    fake-db))
