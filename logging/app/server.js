const express = require('express');
const app = express();
const morgan = require('morgan')
var rfs = require('rotating-file-stream')
const path = require('path')

const port = 8081;

const logDirectory = path.join('/', 'var', 'log', 'common-log', 'logging')

// create a rotating write stream
const accessLogStream = rfs('access.log', {
  interval: '1d', // rotate daily
  path: logDirectory
})

// setup the logger
app.use(morgan('dev', { stream: accessLogStream }))

app.listen(port, (err) => {  
  if (err) {
    return console.log('something bad happened', err);
  }

  console.log(`server is listening on ${port}`);
});