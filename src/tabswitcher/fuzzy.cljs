(ns tabswitcher.fuzzy
  (:require [clojure.string :refer [lower-case]]))

(defn- find-subseq [text term]
  (let [text (map-indexed vector (lower-case text))
        term (map-indexed vector (lower-case term))]

    (loop [t text m term matches []]
      ;(prn t m)
      (let [[_ ct] (first t) 
            [_ cm] (first m)]

        (if (and ct cm)
          (if (= ct cm)
            (recur (rest t) (rest m) (conj matches (first t)))
            (recur (rest t) m matches))
          (if (nil? cm)
            matches
            []))))))

; This needs some serious work and refactoring
(defn- score [matches]
  (if (empty? matches)
    0
    (loop [m (first matches)
           r (rest matches)
           c (count matches)
           score 0]
      (let [a (first m)
            b (ffirst r)]
        (if b
          (recur (first r)
                 (rest r)
                 c
                 (+ score 
                    (if (= (+ 1 a) b)
                      (* 4 (/ 1 (- b a)))
                      (/ 1 (- b a)))))
          (+ (/ (- c (ffirst matches)) c)
             (float score)))))))

(defn matcher [text term & m]
  (let [matches (find-subseq text term)
        score   (score matches)]
    (merge {:matches matches :score score :text text} (first m))))
