import "mirador"; // This works because "mirador" is pinned to "mirador.min.js" in importmap.rb

if (typeof window.Mirador === "undefined" && typeof Mirador !== "undefined") {
  window.Mirador = Mirador;
}