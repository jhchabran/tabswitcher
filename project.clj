(defproject tabswitcher "0.1.0-SNAPSHOT"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}

  :dependencies [[org.clojure/clojure "1.7.0"]
                 [org.clojure/clojurescript "0.0-3297"]
                 [org.clojure/core.async "0.1.346.0-17112a-alpha"]
                 [clj-fuzzy "0.3.1"]
                 [khroma "0.0.2"]
                 [reagent "0.5.0"]
                 [re-frame "0.4.1"]]

  :source-paths ["src"]

  :profiles {:dev {:plugins [[com.cemerick/austin "0.1.3"]
                             [lein-cljsbuild "1.0.5"]
                             [lein-chromebuild "0.2.1"]]

                   :cljsbuild {:builds {:main
                                        {:source-paths ["src"]
                                         :compiler {:output-to "target/unpacked/tabswitcher.js"
                                                    :output-dir "target/js"
                                                    :optimizations :whitespace
                                                    :pretty-print true}}}}
                   }}) 
