'use strict'

_         = require('lodash')
Pikaday   = require('pikaday')

module.exports = class CalendarMgmt
  Pikaday:Pikaday

  constructor:()->
    @field   = arguments[0] if _.isElement(arguments[0])
    @trigger = arguments[1] if _.isElement(arguments[1])
    @select  = arguments[2] if _.isFunction(arguments[2])
    @draw    = arguments[3] if _.isFunction(arguments[3])

  createPikaday:()->
    that = @
    # Calendar = @Pikaday()
    @calendar = new @Pikaday({
      field:@field,
      trigger:@trigger,
      position: 'bottom right',
      firstDay:1,
      onSelect:(date)->
        that.onSelect.call(that, date)
      onDraw:()->
        d = new Date(@._y, (@._m), 1)
        that.onSelect.call(that, d)

      })

    @calendar

  formatDate:(d)->
    "#{d.getFullYear()}-#{@fixDate(d.getMonth()+1)}-#{@fixDate(d.getDate())}"

  formatCalendar:(hols)->
    current = _.filter(
      document.getElementsByClassName('pika-single'),
      (el)->
        _.isNull el.className.match(/is-hidden/)
    )

    cal = _.first(current)

    if cal
      dates = cal.querySelectorAll('td')
      _.forEach dates, (d)->
        day = d.getAttribute('data-day')
        hol = _.find hols, (h)->
          parseInt(day) == h.day

        unless _.isUndefined(hol)
          d.className += " #{hol.css}"

  fixDate:(m)->
    if String(m).length < 2
      return "0"+m
    else
      return String(m)

  onDraw:(date)->
     @draw(@formatDate(date)) if _.isFunction(@draw)

  onSelect:(date)->
    @select(@formatDate(date)) if _.isFunction(@select)