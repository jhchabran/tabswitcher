(ns tabswitcher.views
  (:require [reagent.core :as r]
            [keybind :as kb]
            [re-frame.core :refer [subscribe dispatch]]))

(defn query-input []
  [:div#query
   [:input {:type "text"
            :on-key-up (fn [event]
                         (dispatch [:filter
                                    (-> event .-target .-value)]))}]])

(defn result-item [result]
  [:li.result-item
   {:on-click #(dispatch [:jump-to result])
    :class (when (:selected result) "selected")}
   (-> result :chrome :title)])

(defn results-list [results]
  (into [:ul]
        (map result-item results)))

(defn app []
  (let [results (subscribe [:results])]
    (r/create-class
      {:display-name
       "tabswitcher-name"
       :reagent-render
       (fn []
         [:div
          [:h3 "Tabswitcher"]
          [query-input]
          [:p "Found " (count @results) " tabs"]
          [results-list @results]])
       :component-did-mount
       (fn []
         (kb/bind! "alt-j" ::next-result #(dispatch [:next-result]))
         (kb/bind! "alt-k" ::next-result #(dispatch [:previous-result]))
         )})))
