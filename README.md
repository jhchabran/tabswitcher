# TabSwitcher 

TabSwitcher provides a fuzzy finder to switch between tabs in Google
Chrome. It's the same thing you can find in Textmate with Command-T or
in Ctrlp.vim.

## Usage 

If you just want to install the plugin, just go to the [chrome
store](https://chrome.google.com/webstore/detail/tabswitcher/gkdkligmcadfbagoeggeohelmgalchcn). If
you want to test the latest code :

- clone this repository
- run `cake build` to output Javascript for Coffeescript files
- open Chrome's extension tab 
- click "Load unpacked extension"
- select the root of the cloned repository

## TODO

- Go to any match by clicking on it or navigating with arrows ( or ctrl-j / ctrl-k ? )
- Refactor around the fuzzy algorithm, the protocal handling isn't very
  elegant.

