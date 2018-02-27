const express = require('express')
const app = express()
const router = express.Router({mergeParams: true});
const port = process.env.PORT || 3000;
const cors = require('cors');

app.use(cors());

app.use('/info', require('./routers/info'))
app.use('/map', require('./routers/map'))
app.use('/stats', require('./routers/stats'))
app.use('/player', require('./routers/player'))

app.get('/', function (req, res) {
  res.send('Hello World!')
})

app.listen(port, function () {
  console.log('Example app listening on port ' + port)
})
