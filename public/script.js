$(document).ready(function () {
  var hitStartTime = 0;
  var maxHitTime = 2000;

  Draggable.create(".ryba", {
    type: "x,y",
    onDrag: function () {
      if (this.hitTest(".siecka") && hitStartTime == 0) {
        hitStartTime = Date.now();
        TweenLite.delayedCall(0.2, startCount);
      }
    },
  });

  function startCount() {
    if (Draggable.hitTest(".ryba", ".siecka")) {
      if (Date.now() - hitStartTime > maxHitTime) {
        $.post("https://metro-fisherman/zamknij", JSON.stringify({}));
        location.reload();

        $.post("https://metro-fisherman/sukces", JSON.stringify({}));
        hitStartTime = 0;
      } else {
        TweenLite.delayedCall(0.2, startCount);
      }
    } else {
      hitStartTime = 0;
    }
  }

  window.addEventListener("message", function (event) {
    if (event.data.action == "otworz") {
      $("body").css({ display: "block" });
    } else if (event.data.action == "zamknij") {
      $("body").css({
        display: "none",
      });
    }
    document.onkeyup = function (data) {
      if (data.which == 27) {
        location.reload();
        $.post("https://metro-fisherman/zamknij", JSON.stringify({}));
      }
    };
  });
});
