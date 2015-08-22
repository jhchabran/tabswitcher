(ns tabswitcher.views
  (:require [reagent.core :as r]
            [re-frame.core :refer [subscribe dispatch]]))

(defn query-input []
  [:div#query
   [:input {:type "text"
            :on-key-up (fn [event]
                         (dispatch [:filter
                                    (-> event .-target .-value)]))}]])

(defn results-list [results]
  (into [:ul]
        (map (fn [r]
               [:li (get r "title")]) results)))

(defn app []
  (let [results (subscribe [:results])]
    [:div
     [:h3 "Tabswitcher"]
     [query-input]
     [:p "Found " (count @results) " tabs"]
     [results-list @results]]))
