(ns tabswitcher.views
  (:require [reagent.core :as r]
            [keybind :as kb]
            [re-frame.core :refer [subscribe dispatch]]))

(defn query-input []
  [:div#query
   [:input {:type "text"
            :on-key-press (fn [event]
                            (if (or (.-altKey event) (= (.-keyCode event) 13)) ; 13 = Enter
                              (.preventDefault event)
                              (dispatch [:filter
                                         (-> event .-target .-value)])))}]])

(defn result-item [idx result selection]
  [:li.result-item
   {:on-click #(dispatch [:jump result])
    :class (when (= idx selection) "selected")}
    [:img.favicon {:src "/images/icon-search.svg"}]
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
          [query-input]
          [:p.results-count "Found " (count @results) " tabs"]
          [results-list @results @selection]
          [:h3 "tabswitcher"]])
       :component-did-mount
       (fn []
         (kb/bind! "alt-j" ::next-result #(dispatch [:next-result]))
         (kb/bind! "alt-k" ::previous-result #(dispatch [:previous-result]))
         (kb/bind! "return" ::jump #(dispatch [:jump])))})))
