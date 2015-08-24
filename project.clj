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

  :cljsbuild {:builds [{:id "live"
                        :source-paths ["src"]
                        :figwheel true
                        :compiler {:main tabswitcher.popup
                                   :asset-path "js/compiled/out"
                                   :output-to "resources/public/js/compiled/tabswitcher.js"
                                   :output-dir "resources/public/js/compiled/out"
                                   :source-map-timestamp true}}

                       {:id "dev"
                        :source-paths ["src"]
                        :compiler {:output-to "target/unpacked/tabswitcher.js"
                                   :output-dir "target/js"
                                   :optimizations :whitespace
                                   :pretty-print true}}

                       ;{:id "min"
                       ; :source-paths ["src"]
                       ; :compiler {:output-to "target/unpacked/tabswitcher.js"
                       ;            :output-dir "target/js"
                       ;            :optimizations :advanced
                       ;            :pretty-print false}}
                       ]}


  :profiles {:live  {:plugins [[lein-figwheel "0.3.5"]]}
             :dev   {:plugins [[com.cemerick/austin "0.1.3"]
                               [lein-cljsbuild "1.0.5"]
                               [lein-chromebuild "0.2.1"]]}
             :min   {:plugins [[lein-cljsbuild "1.0.5"]
                               [lein-chromebuild "0.2.1"]]}}
  :figwheel {
             ;; :http-server-root "public" ;; default and assumes "resources" 
             :server-port 3000 ;; default
             :server-ip "0.0.0.0" 

             ;:css-dirs ["resources/public/css"] ;; watch and update CSS

             ;; Start an nREPL server into the running figwheel process
             :nrepl-port 7888

             ;; Server Ring Handler (optional)
             ;; if you want to embed a ring handler into the figwheel http-kit
             ;; server, this is for simple ring servers, if this
             ;; doesn't work for you just run your own server :)
             ;; :ring-handler hello_world.server/handler

             ;; To be able to open files in your editor from the heads up display
             ;; you will need to put a script on your path.
             ;; that script will have to take a file path and a line number
             ;; ie. in  ~/bin/myfile-opener
             ;; #! /bin/sh
             ;; emacsclient -n +$2 $1
             ;;
             ;; :open-file-command "myfile-opener"

             ;; if you want to disable the REPL
             ;; :repl false

             ;; to configure a different figwheel logfile path
             ;; :server-logfile "tmp/logs/figwheel-logfile.log" 
             }) 
