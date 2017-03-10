import Auction from '../../models/auction.coffee'
import CurrentUser from '../../models/current_user.coffee'
import Artist from '../../models/artist.coffee'
import ClockView from '../../components/clock/view.coffee'
import { data as sd } from 'sharify'
import _ from 'underscore'
import MyActiveBids from '../../components/my_active_bids/view.coffee'
import Backbone from 'backbone'

// import UrlHandler from '../../components/commercial_filter/url_handler.coffee'
import JumpView from '../../components/jump/view.coffee'

// For react/redux
import React from 'react';
import { render } from 'react-dom';
import thunkMiddleware from 'redux-thunk'
import createLogger from 'redux-logger'
import { combineReducers, createStore, applyMiddleware } from 'redux'
import { Provider } from 'react-redux'
import auctions from './reducers'
import CommercialFilter from './components/commercial_filter'
import * as actions from './actions'

const myActiveBidsTemplate = require('./templates/my_active_bids.jade')

const auction = new Auction(_.pick(sd.AUCTION, 'start_at', 'live_start_at', 'end_at'))
const user = sd.CURRENT_USER ? new CurrentUser(sd.CURRENT_USER) : null

const clock = new ClockView({modelName: 'Auction', model: auction, el: $('.auction2-clock')})
clock.start()

const customSortMap = {
  "lot_number": "Lot Number (asc.)",
  "-lot_number": "Lot Number (desc.)",
  "-searchable_estimate": "Most Expensive",
  "searchable_estimate": "Least Expensive"
}

const defaultParams = {
  size: 50,
  page: 1,
  aggregations: ['TOTAL', 'MEDIUM', 'FOLLOWED_ARTISTS', 'ARTIST'],
  sale_id: sd.AUCTION.id,
  sort: 'lot_number',
  gene_ids: [],
  artist_ids: [],
  ranges: {
    estimate_range: {
      min: 50,
      max: 50000
    }
  }
}

if (sd.AUCTION && sd.AUCTION.is_live_open == false) {
  const activeBids = new MyActiveBids({
    user: user,
    el: $('.auction2-my-active-bids'),
    template: myActiveBidsTemplate,
    saleId: auction.get('_id')
  })
  activeBids.start()
}

// Commercial filtering
const loggerMiddleware = createLogger()
const store = createStore(
  auctions,
  applyMiddleware(
    thunkMiddleware, // lets us dispatch() functions
    loggerMiddleware // middleware that logs actions
  )
)

render(
  <Provider store={store}>
    <CommercialFilter />
  </Provider>,
  document.getElementById('cf-artworks')
)

store.dispatch(actions.fetchArtworks())

// 1 second delay for checkbox selections
let timer = null
function delayedScroll() {
  clearTimeout(timer)
  timer = setTimeout($('html,body').animate( { scrollTop: 0 }, 400), 1000)
}

// jump view
const jump = new JumpView({ threshold: $(window).height(), direction: 'bottom' })
$('body').append(jump.$el)

jump.scrollToPosition(0)
