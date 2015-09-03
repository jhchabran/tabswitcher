(ns tabswitcher.keybindings
  (:require [keybind :as kb]
            [re-frame.core :refer [dispatch]]))

(defn attach-global-bindings []
  (kb/bind! "down"   ::next-result        #(dispatch [:next-result]))
  (kb/bind! "up"     ::previous-result    #(dispatch [:previous-result]))
  (kb/bind! "alt-j"  ::vi-next-result     #(dispatch [:next-result]))
  (kb/bind! "alt-k"  ::vi-previous-result #(dispatch [:previous-result]))
  (kb/bind! "return" ::jump               #(dispatch [:jump])))
