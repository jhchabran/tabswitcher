(ns tabswitcher.handlers
  (:require [clojure.walk :as w]
            [re-frame.core :refer [register-handler dispatch]]
            [clj-fuzzy.metrics :as f]
            [tabswitcher.db :as db]))

(register-handler
  :initialize-db
  (fn [_ _]
    db/default-db))

(register-handler
  :update
  (fn [db [_ tabs]]
    (assoc db :tabs (w/keywordize-keys (js->clj tabs)))))

(register-handler
  :jump
  (fn [db [_ tab]]
    
    db))

(register-handler
  :next-result
  (fn [db _]
    (let [boundary  (count (:results db))
          selection (:selection db)]
      (if (< selection (- boundary 1))
        (update db :selection inc)
        db))))

(register-handler
  :previous-result
  (fn [db _]
    (let [selection (:selection db)]
      (if (> selection 0)
        (update db :selection dec)
        db))))

(defn fuzzy-find [tabs query]
  (reverse (sort-by #(f/dice (:title %) query) tabs)))

(register-handler
  :filter
  (fn [db [_ query]]
    (let [sorted-tabs (fuzzy-find (:tabs db) query)]
      (merge db {:query query :results sorted-tabs :selection 0}))))
