include pkg/karax/prelude
# import pkg/animatecss
# export animatecss.parseClass
# from pkg/util/forhtml import genclass

func help*(
  text: string;
  position = "right";
  icon = "?",
  size = "small";
): VNode =
  if position notin ["up", "down", "left", "right", "up-left", "up-right", "down-left", "down-right"]:
    doAssert false, "Invalid help tooltip position"
  if size notin ["small", "medium", "large", "fit"]:
    doAssert false, "Invalid help tooltip size"
  buildHtml(tdiv(
    class = "help",
    aria-label = text,
    data-balloon-pos = position,
    data-balloon-length = size,
  )):
    text icon
