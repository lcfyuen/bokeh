import * as _ from "underscore"

import * as p from "../../core/properties"

import * as AbstractIcon from "./abstract_icon"
import * as Widget from "./widget"

class IconView extends Widget.View
  tagName: "i"

  initialize: (options) ->
    super(options)
    @render()
    @listenTo(@model, 'change', @render)

  render: () ->
    @$el.empty()
    @$el.addClass("bk-fa")
    @$el.addClass("bk-fa-" + @model.icon_name)
    size = @model.size
    if size? then @$el.css("font-size": size + "em")
    flip = @model.flip
    if flip? then @$el.addClass("bk-fa-flip-" + flip)
    if @model.spin
      @$el.addClass("bk-fa-spin")
    return @

  update_constraints: () ->
    null


class Icon extends AbstractIcon.Model
  type: "Icon"
  default_view: IconView

  @define {
      icon_name: [ p.String, "check" ] # TODO (bev) enum?
      size:      [ p.Number          ]
      flip:      [ p.Any             ] # TODO (bev)
      spin:      [ p.Bool,   false   ]
    }

export {
  Icon as Model
  IconView as View
}
