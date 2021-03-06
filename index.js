'use strict';
var CalendarMgmt, Pikaday, _;

_ = require('lodash');

Pikaday = require('pikaday');

module.exports = CalendarMgmt = (function() {
  CalendarMgmt.prototype.Pikaday = Pikaday;

  function CalendarMgmt() {
    if (_.isElement(arguments[0])) {
      this.field = arguments[0];
    }
    if (_.isElement(arguments[1])) {
      this.trigger = arguments[1];
    }
    if (_.isFunction(arguments[2])) {
      this.select = arguments[2];
    }
    if (_.isFunction(arguments[3])) {
      this.draw = arguments[3];
    }
  }

  CalendarMgmt.prototype.createPikaday = function() {
    var that;
    that = this;
    this.calendar = new this.Pikaday({
      field: this.field,
      trigger: this.trigger,
      position: 'bottom right',
      firstDay: 1,
      onSelect: function(date) {
        return that.onSelect.call(that, date);
      },
      onDraw: function() {
        var d;
        d = new Date(this._y, this._m, 1);
        return that.onDraw.call(that, d);
      }
    });
    return this.calendar;
  };

  CalendarMgmt.prototype.formatDate = function(d) {
    return (d.getFullYear()) + "-" + (this.fixDate(d.getMonth() + 1)) + "-" + (this.fixDate(d.getDate()));
  };

  CalendarMgmt.prototype.formatCalendar = function(hols) {
    var cal, current, dates;
    current = _.filter(document.getElementsByClassName('pika-single'), function(el) {
      return _.isNull(el.className.match(/is-hidden/));
    });
    cal = _.first(current);
    if (cal) {
      dates = cal.querySelectorAll('td');
      return _.forEach(dates, function(d) {
        var day, hol;
        day = d.getAttribute('data-day');
        hol = _.find(hols, function(h) {
          return parseInt(day) === h.day;
        });
        if (!_.isUndefined(hol)) {
          return d.className += " " + hol.css;
        }
      });
    }
  };

  CalendarMgmt.prototype.fixDate = function(m) {
    if (String(m).length < 2) {
      return "0" + m;
    } else {
      return String(m);
    }
  };

  CalendarMgmt.prototype.onDraw = function(date) {
    if (_.isFunction(this.draw)) {
      return this.draw(this.formatDate(date));
    }
  };

  CalendarMgmt.prototype.onSelect = function(date) {
    if (_.isFunction(this.select)) {
      return this.select(this.formatDate(date));
    }
  };

  return CalendarMgmt;

})();
