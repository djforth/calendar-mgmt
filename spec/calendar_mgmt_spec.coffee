CalendarMgmt = require('../src/calendar_mgmt.coffee')
_ = require('lodash')

sinon = require('sinon')

createDiv = (id, path=document.body)->
  holder = document.createElement("div");
  holder.id = id
  path.appendChild(holder)

destroyDiv = (id)->
  el = document.getElementById(id)
  el.parentElement.removeChild(el)


describe "Calendar Mgmt", ->
  calFmt = field = trigger = select = draw = pikaday = cal = null
  beforeEach ->
    field   = createDiv("field")
    trigger = createDiv("trigger")
    select = jasmine.createSpy('select')
    draw = jasmine.createSpy('draw')
    calFmt = new CalendarMgmt(field, trigger, select, draw)
    pikaday = sinon.stub(calFmt , "Pikaday")
    cal = jasmine.createSpyObj('Pikaday', ['onSelect', 'onDraw'])
    pikaday.returns(cal)

  afterEach ->
    destroyDiv("field")
    destroyDiv("trigger")

  it 'It should exist', ->
    expect(calFmt).not.toBeNull()
    expect(calFmt).toBeDefined()

  it 'should set defaults', ->
    expect(calFmt.field).toEqual(field)
    expect(calFmt.trigger).toEqual(trigger)
    expect(calFmt.select).toEqual(select)
    expect(calFmt.draw).toEqual(draw)

  describe 'createPikaday', ->
    beforeEach ->
      # spyOn(calFmt, "formatDate").and.returnValue(new Date(2015,0,18))
      calFmt.createPikaday()

    it 'should create a new pikaday', ->
      expect(calFmt.calendar).toEqual(cal)

  describe 'formatDate', ->
    date = null
    beforeEach ->
      date = new Date(2015,0,18)
      spyOn(calFmt, "fixDate").and.callThrough()


    it 'should return the correct formatted date', ->
      d = calFmt.formatDate(date)
      expect(d).toEqual("2015-01-18")
      expect(calFmt.fixDate).toHaveBeenCalled()
      expect(calFmt.fixDate.calls.count()).toEqual(2)

  describe 'fixDate', ->

    it "should return string of number if double digits", ->
      d = calFmt.fixDate(18)
      expect(_.isString(d)).toBeTruthy()
      expect(d).toEqual('18')

    it "should return string of number with 0 if single digits", ->
      d = calFmt.fixDate(1)
      expect(_.isString(d)).toBeTruthy()
      expect(d).toEqual('01')

  describe 'onSelect and onDraw', ->
    date = null
    beforeEach ->
      date = new Date(2015,0,18)
      spyOn(calFmt, "formatDate").and.returnValue('2015-01-18')

    it 'should not call function if not defined', ->
      calFmt.draw = calFmt.select = null
      calFmt.onDraw(date)
      expect(calFmt.formatDate).not.toHaveBeenCalled()

      calFmt.onSelect(date)
      expect(calFmt.formatDate).not.toHaveBeenCalled()

    it 'should call draw function when onDraw called', ->
      calFmt.onDraw(date)
      expect(calFmt.formatDate).toHaveBeenCalledWith(date)
      expect(draw).toHaveBeenCalledWith('2015-01-18')


    it 'should call select function when onDraw called', ->
      calFmt.onSelect(date)
      expect(calFmt.formatDate).toHaveBeenCalledWith(date)
      expect(select).toHaveBeenCalledWith('2015-01-18')















