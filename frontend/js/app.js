// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

// Initialize Elm program
var app = Elm.Main.init({
  flags: {
    locationHref: location.href
  },
  node: document.getElementById("elm-main")
});

// Inform app of browser navigation (the BACK and FORWARD buttons)
document.addEventListener("popstate", function() {
  app.ports.onUrlChange.send(location.href);
});

// TODO: Change the URL upon request, inform app of the change.
// app.ports.pushUrl.subscribe(function(url) {
//   history.pushState({}, "", url);
//   app.ports.onUrlChange.send(location.href);
// });
