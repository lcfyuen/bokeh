import * as Box from "./box"

class RowView extends Box.View
  className: "bk-grid-row"

class Row extends Box.Model
  type: 'Row'
  default_view: RowView

  constructor: (attrs, options) ->
    super(attrs, options)
    @_horizontal = true

export {
  RowView as View
  Row as Model
}
