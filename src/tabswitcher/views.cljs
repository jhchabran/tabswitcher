(ns tabswitcher.views
  (:require [reagent.core :as r]
            [keybind :as kb]
            [re-frame.core :refer [subscribe dispatch]]))

(defn query-input []
  [:div#query
   [:input {:type "text"
            :on-key-press (fn [event]
                         (if (.-altKey event)
                           (.preventDefault event)
                           (dispatch [:filter
                                      (-> event .-target .-value)])))}]])

(defn result-item [idx result selection]
  [:li.result-item
   {:on-click #(dispatch [:jump-to result])
    :class (when (= idx selection) "selected")}
   (:title result)])

(defn results-list [results selection]
  (into [:ul]
        (map-indexed #(result-item %1 %2 selection) results)))

(defn app []
  (let [results   (subscribe [:results])
        selection (subscribe [:selection])]

    (r/create-class
      {:display-name
       "tabswitcher-name"
       :reagent-render
       (fn []
         [:div
          [:h3 "Tabswitcher"]
          [query-input]
          [:p "Found " (count @results) " tabs"]
          [results-list @results @selection]])
       :component-did-mount
       (fn []
         (kb/bind! "alt-j" ::next-result #(dispatch [:next-result]))
         (kb/bind! "alt-k" ::next-result #(dispatch [:previous-result]))
         )})))
