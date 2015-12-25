# Tabswitcher 

Tabswitcher is a chrome extension that allow to easily jump between
opened tabs. It is intended to be used from the keyboard (while still
remaining mouse friendly). 

> OSX Spotlight but for Google Chrome

When opened the extension displays a list of opened tabs and
allow to filter them by typing some characters that matches the url of
the wanted chrome tab and jump by typing enter.

To fully enable a keyboard driven experience, you need to manually add a
global shortcut. Set it at the [bottom of Chrome's exension
page](chrome//extensions). Can't find it? [See
here](http://i.imgur.com/mwOrF6i.png).

Find it on [Google Chrome
store](https://chrome.google.com/webstore/detail/tabswitcher/gkdkligmcadfbagoeggeohelmgalchcn).

## Privacy and performances

No Javascript is injected in pages themselves. Everything is done
through the extension's popup and nothing else, ie the extension is just 
running once, whether there are two tabs opened or thirty.

In clear, all it does is asking Chrome to list all opened tabs and jump
from one to another based on some characters.

## Usage 

It is required to manually assign a global shortcut to open Tabswitcher
from they keyboard instead of clicking on the extension's icon. It's a
constraint from Google Chrome, it can't be done in any other way.

The recommended combination is `alt+Space`. 

Available keybindings when the extension is opened:

- `arrow-down` or `alt-j` to move toward the next result
- `arrow-up` or `alt-k` to move toward the previous result
- `enter` to jump the highlighted result

## Bug reporting

In case of something being wrong or encountering a bug, please open up
an issue here.

## Contributing 

Tabswitcher is written in
[Clojurescript](https://github.com/clojure/clojurescript). 


To develop locally, two profiles are provided: 

- `chrome` that compiles and packages it for Google Chrome and is
  can be installed locally through the button _Load unpacked extension_.
  - `lein with-profile +chrome chromebuild once`

- `live` that fires a figwheel server, allowing to live edit its code
  and opening a REPL. Chrome callbacks will be disabled and will just print logs.
  - `lein with-profile +live figwheel`

Feel free to fork and open a pull-request !

## License 

[This project is licensed under the terms of the MIT license](LICENSE.md)

