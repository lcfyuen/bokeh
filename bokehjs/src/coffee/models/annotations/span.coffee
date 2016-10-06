import * as _ from "underscore"

import * as Annotation from "./annotation"
import * as p from "../../core/properties"

class SpanView extends Annotation.View

  initialize: (options) ->
    super(options)
    @$el.appendTo(@plot_view.$el.find('div.bk-canvas-overlays'))
    @$el.css({position: 'absolute'})
    @$el.hide()

  bind_bokeh_events: () ->
    if @model.for_hover
      @listenTo(@model, 'change:computed_location', @_draw_span)
    else
      if @model.render_mode == 'canvas'
        @listenTo(@model, 'change:location', @plot_view.request_render)
      else
        @listenTo(@model, 'change:location', @_draw_span)

  render: () ->
    @_draw_span()

  _draw_span: () ->
    if @model.for_hover
      loc = @model.computed_location
    else
      loc = @model.location

    if not loc?
      @$el.hide()
      return

    frame = @plot_model.frame
    canvas = @plot_model.canvas
    xmapper = @plot_view.frame.x_mappers[@model.x_range_name]
    ymapper = @plot_view.frame.y_mappers[@model.y_range_name]

    if @model.dimension == 'width'
      stop = canvas.vy_to_sy(@_calc_dim(loc, ymapper))
      sleft = canvas.vx_to_sx(frame.left)
      width = frame.width
      height = @model.properties.line_width.value()
    else
      stop = canvas.vy_to_sy(frame.top)
      sleft = canvas.vx_to_sx(@_calc_dim(loc, xmapper))
      width = @model.properties.line_width.value()
      height = frame.height

    if @model.render_mode == "css"
      @$el.css({
        'top': stop,
        'left': sleft,
        'width': "#{width}px",
        'height': "#{height}px"
        'z-index': 1000
        'background-color': @model.properties.line_color.value()
        'opacity': @model.properties.line_alpha.value()
      })
      @$el.show()

    else if @model.render_mode == "canvas"
      ctx = @plot_view.canvas_view.ctx
      ctx.save()

      ctx.beginPath()
      @visuals.line.set_value(ctx)
      ctx.moveTo(sleft, stop)
      if @model.dimension == "width"
        ctx.lineTo(sleft + width, stop)
      else
        ctx.lineTo(sleft, stop + height)
      ctx.stroke()

      ctx.restore()

  _calc_dim: (location, mapper) ->
      if @model.location_units == 'data'
        vdim = mapper.map_to_target(location)
      else
        vdim = location
      return vdim

class Span extends Annotation.Model
  default_view: SpanView

  type: 'Span'

  @mixins ['line']

  @define {
      render_mode:    [ p.RenderMode,   'canvas'  ]
      x_range_name:   [ p.String,       'default' ]
      y_range_name:   [ p.String,       'default' ]
      location:       [ p.Number,       null      ]
      location_units: [ p.SpatialUnits, 'data'    ]
      dimension:      [ p.Dimension,    'width'   ]
  }

  @override {
    line_color: 'black'
  }

  @internal {
    for_hover: [ p.Boolean, false ]
    computed_location: [ p.Number, null ]
  }

export {
  Span as Model
  SpanView as View
}
