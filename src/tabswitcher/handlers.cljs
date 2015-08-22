(ns tabswitcher.handlers
  (:require [re-frame.core :refer [register-handler dispatch]]
            [clj-fuzzy.metrics :as f]
            [tabswitcher.db :as db]))

(register-handler
  :initialize-db
  (fn [_ _]
    db/default-db))

(register-handler
  :update
  (fn [db [_ tabs]]
    (assoc db :tabs (js->clj tabs))))

(defn fuzzy-find [tabs query]
  (reverse (sort-by #(f/dice (get % "title") query) tabs)))

(register-handler
  :filter
  (fn [db [_ query]]
    (merge db
           {:query query}
           {:results (fuzzy-find (:tabs db) query)})))

