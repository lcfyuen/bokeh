import * as _ from "underscore"
import * as $ from "jquery"
import "jquery-ui/datepicker"

import * as p from "../../core/properties"

import * as InputWidget from "./input_widget"


class DatePickerView extends InputWidget.View

  initialize: (options) ->
    super(options)
    @label = $('<label>').text(@model.title)
    @input = $('<input type="text">')
    @datepicker = @input.datepicker({
      defaultDate: new Date(@model.value)
      minDate: if @model.min_date? then new Date(@model.min_date) else null
      maxDate: if @model.max_date? then new Date(@model.max_date) else null
      onSelect: @onSelect
    })
    @$el.append([@label, @input])

  onSelect: (dateText, ui) =>
    d = new Date(dateText)
    @model.value = d.toString()
    @model.callback?.execute(@model)

class DatePicker extends InputWidget.Model
  type: "DatePicker"
  default_view: DatePickerView

  @define {
      # TODO (bev) types
      value:    [ p.Any, Date.now() ]
      min_date: [ p.Any             ]
      max_date: [ p.Any             ]
    }

export {
  DatePicker as Model
  DatePickerView as View
}
