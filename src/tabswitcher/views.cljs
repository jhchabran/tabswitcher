(ns tabswitcher.views
  (:require [reagent.core :as r]
            [re-frame.core :refer [subscribe dispatch]]
            [tabswitcher.keybindings :as kb]))

(defn query-input []
  [:div#query
   [:input {:type "text"
            ; KeyUp is only used to catch backspace, keyPress catch the reset 
            ; without bothering with unicode chars that gets entered while 
            ; using alt + char.
            :on-key-up    (fn [event]
                            (if (= (.-keyCode event) 8)
                              (dispatch [:filter (-> event .-target .-value)])))
            :on-key-press (fn [event]
                            (if (or (.-altKey event) 
                                    (= (.-which event) 13)) ; 13 = Enter
                              (.preventDefault event)
                              (dispatch [:filter
                                         (str (-> event .-target .-value)
                                              (.-key event))])))}]])

(defn highlighted [{:keys [matches score text]}]
  (let [indexes (mapv first matches)]
    (reduce (fn [html [i c]]
              (conj html (if (some #(= % i) indexes) [:b c] c)))
            [:span]
            (map-indexed vector text))))

(defn result-item [idx result selection]
  [:li.result-item
   {:on-click #(dispatch [:jump result])
    :class (when (= idx selection) "selected")}
    [:img.favicon {:src (:favIconUrl (:tab result))}]
   (highlighted result)])


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
       :component-did-mount kb/attach-global-bindings})))
