#
# Large fair app that does browsing, microsite, and more. /:fair.profile_id/*
#

express = require 'express'
routes = require './routes'
timeout = require 'connect-timeout'

app = module.exports = express()
app.set 'views', __dirname + '/templates'
app.set 'view engine', 'jade'
getFairData = [
  timeout('25s')
  routes.fetchFairData
  (req, res, next) -> next() unless req.timedout
]

app.get '/:id', getFairData, routes.overview
app.get '/:id/overview', getFairData, routes.overview
app.get '/:id/posts', getFairData, routes.fairPosts
app.get '/:id/info', getFairData, routes.info
app.get '/:id/for-you', getFairData, routes.forYou
app.get '/:id/search', getFairData, routes.search
app.get '/:id/browse/show/:partner_id', getFairData, routes.showRedirect
app.get '/:id/browse', getFairData, routes.browse
app.get '/:id/browse/*', getFairData, routes.browse
app.get '/:id/following/:type', getFairData, routes.follows
app.get '/:id/favorites', getFairData, routes.favorites
# Handle microgravity urls that get crawled by google
app.get '/:id/programming', getFairData, routes.overview

