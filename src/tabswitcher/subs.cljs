(ns tabswitcher.subs
  (:require-macros [reagent.ratom :refer [reaction]])
  (:require [re-frame.core :refer [register-sub]]))

(register-sub
  :query
  (fn [db _]
    (reaction (:query @db))))

(register-sub
  :results
  (fn [db _]
    (reaction (:results @db))))
