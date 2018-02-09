// imports
const express = require('express')
const app = express()
const morgan = require('morgan')
const rfs = require('rotating-file-stream')
const path = require('path')
const serveIndex = require('serve-index')

// constants
const port = 80
const commonLogDirectory = path.join('/', 'var', 'log', 'common-log')
const logDirectory = path.join(commonLogDirectory, 'logging')

// setup the logger
const logStream = rfs('access.log', { interval: '1d', path: logDirectory })

app.use(morgan('dev', { stream: logStream }))

// display logs
app.use('/', express.static(commonLogDirectory), serveIndex(commonLogDirectory, {'icons': true}))

// start server
app.listen(port, (err) => {  
  if (err) {
    return console.log(`something bad happened ${err}`)
  } else {
    console.log(`server is listening on ${port}`)
  }
})
