_ = require 'underscore'
{ fabricate } = require 'antigravity'
sd = require('sharify').data
should = require 'should'
Backbone = require 'backbone'
PartnerShow = require '../../models/partner_show'
PartnerShows = require '../../collections/partner_shows'

describe 'PartnerShows', ->

  beforeEach ->
    @partnerShows = new PartnerShows([
                                                                                # featured | currrent | upcoming | past
      fabricate('show', { name: 'show1' }),                                     #                                    x
      fabricate('show', { name: 'show2', status: 'running', featured: true }),  #   x          x
      fabricate('show', { name: 'show3', status: 'running' }),                  #              x
      fabricate('show', { name: 'show4', status: 'upcoming' }),                 #                         x
      fabricate('show', { name: 'show5', status: 'upcoming' }),                 #                         x
      fabricate('show', { name: 'show6' })                                      #                                    x
    ])

  describe '#current', ->

    it 'gets the featured show', ->
      @partnerShows.featured().get('name').should.equal 'show2'

    it 'gets current shows', ->
      @partnerShows.current().should.have.lengthOf 2
      @partnerShows.current().at(0).get('name').should.equal 'show2'
      @partnerShows.current().at(1).get('name').should.equal 'show3'

    it 'gets current shows without featured show', ->
      featured = @partnerShows.featured()
      @partnerShows.current([featured]).should.have.lengthOf 1
      @partnerShows.current([featured]).at(0).get('name').should.equal 'show3'

    it 'gets upcoming shows', ->
      @partnerShows.upcoming().should.have.lengthOf 2
      @partnerShows.upcoming().at(0).get('name').should.equal 'show4'
      @partnerShows.upcoming().at(1).get('name').should.equal 'show5'

    it 'gets past shows', ->
      @partnerShows.past().should.have.lengthOf 2
      @partnerShows.past().at(0).get('name').should.equal 'show1'
      @partnerShows.past().at(1).get('name').should.equal 'show6'
