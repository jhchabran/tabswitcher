(ns tabswitcher.utils)

(defn format-result [url]
  (clojure.string/replace url #"(^https?://(www\.)?)|(\?.+)" ""))
