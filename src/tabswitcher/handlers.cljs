(ns tabswitcher.handlers
  (:require [clojure.walk :as w]
            [re-frame.core :refer [register-handler dispatch]]
            [cljs.core.async :as async]
            [tabswitcher.fuzzy :as f]
            [tabswitcher.messaging :refer [send-background]]
            [tabswitcher.db :as db]))

(register-handler
  :initialize-db
  (fn [_ _]
    db/default-db))

; TODO may be merged with initialise db since we can't really do 
; anything without this.
(register-handler
  :assign-bg-chan
  (fn [db [_ bg-chan]]
    (assoc db :background-chan bg-chan)))

(register-handler
  :update
  (fn [db [_ tabs]]
    ; Display tabs for the first run
    (if (nil? (:query db))
      (dispatch [:filter ""]))

    (assoc db :tabs (w/keywordize-keys (js->clj tabs)))))

(register-handler
  :jump
  (fn [db [_ tab]]
    (let [bg  (:background-chan db)
          tab-id (:id (nth (:results db) (:selection db)))
          other-ids (remove #(= tab-id %1) (map :id (:tabs db)))]
      (send-background [:jump tab-id other-ids] #()))
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

(register-handler
  :filter
  (fn [db [_ query]]
    (let [sorted-tabs (sort-by :score 
                               #(compare %2 %1) 
                               (map #(f/matcher (:title %1) query) 
                                    (:tabs db)))]
      (merge db {:query query :results sorted-tabs :selection 0}))))
