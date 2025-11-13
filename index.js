const express = require('express');
const app = express();


app.use(express.static('public', {
  setHeaders: (res, path) => {
    const origin = res.req.headers.origin;
    if (origin && origin.startsWith('http://localhost')) {
      res.setHeader('Access-Control-Allow-Origin', origin);
    }
  }
}));


require('./startup/config')();
require('./startup/routes')(app);
require('./startup/db')();

const port = process.env.PORT || 3000;

app.listen(port, console.log('listening on port ' + port));