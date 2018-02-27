const MongoClient = require('mongodb').MongoClient;
const uri = "mongodb://dragonball-backend:dr4g0nB4ll42@dragonball-radar-shard-00-00-hmqug.mongodb.net:27017,dragonball-radar-shard-00-01-hmqug.mongodb.net:27017,dragonball-radar-shard-00-02-hmqug.mongodb.net:27017/gameStatusDb?ssl=true&replicaSet=dragonball-radar-shard-0&authSource=admin";


const initialStats = {}
const initialMap = {
  map: {
    spheres: [
      {
        id: 1,
        latitude: 45.4669624,
        longitude: 9.1962209
      },
      {
        id: 2,
        latitude: 45.4665411,
        longitude: 9.1993967
      }
    ],
    boundingBox: {
      min: {
        latitude: 45.4665411,
        longitude: 9.1962209
      },
      max: {
        latitude: 45.4669624,
        longitude: 9.1993967
      }
    }
  },
 time: {
    start: 1500000000,
    end: 1500024449
}
};

var map = initialMap;
var currentStats = initialStats;

function getCurrentMap(callback) {
  MongoClient.connect(uri, function(err, db) {
    if(err) { return console.dir(err); }
    console.log('finding one')
    db.collection('map').findOne({_id:1}).then(callback);
  });
}

function saveNewMap(newMap, callback) {
  MongoClient.connect(uri, function(err, db) {
    if(err) { return console.dir(err); }
    var collection = db.collection('map');
    newMap._id = 1;
    newMap.boundingBox = calculateBoundingBox(newMap.map.spheres);
    collection.remove({_id:1});
    collection.insert(newMap, {w:1}, callback);
  });
}

function getCurrentStats(callback) {
  MongoClient.connect(uri, function(err, db) {
    if(err) { return console.dir(err); }
    console.log('finding stats')
    db.collection('players').find().toArray(callback);
  });
}
function getPlayer(playerName, callback) {
  MongoClient.connect(uri, function(err, db) {
    if(err) { return console.dir(err); }
    console.log('finding player ' + playerName);
    db.collection('players').findOne({playerName: playerName}).then(callback);
  });
}
function addPlayer(playerName, callback) {
  MongoClient.connect(uri, function(err, db) {
    if(err) { return console.dir(err); }
    console.log('adding player ' + playerName)
    db.collection('players').insert({playerName: playerName, spheres:{}}, {w:1}, callback);
  })

}
function collectSphereForPlayer(playerName, sphereId, callback) {
  MongoClient.connect(uri, function(err, db) {
    if(err) { return console.dir(err); }
    console.log('adding player ' + playerName)
    db.collection('players').update({playerName: playerName}, {$addToSet: {spheres: {sphereId: (new Date).getTime()}}}, {w:1}, callback);
  });
}
function min(a, b) {
  return Math.min(a,b)
}
function max(a,b) {
  return Math.max(a,b)
}
function calculateBoundingBox(spheres) {
  var minLatitude = spheres.map(function(s) {return s.latitude}).reduce(min);
  var minLongitude = spheres.map(function(s) {return s.longitude}).reduce(min);
  var maxLatitude = spheres.map(function(s) {return s.latitude}).reduce(max);
  var maxLongitude = spheres.map(function(s) {return s.longitude}).reduce(max);
  return {
      min: {
        latitude: minLatitude,
        longitude: minLongitude
      },
      max: {
        latitude: maxLatitude,
        longitude: maxLongitude
      }
  }
}
module.exports = {
  getCurrentMap: getCurrentMap,
  saveNewMap: saveNewMap,
  getCurrentStats: getCurrentStats,
  getPlayer: getPlayer,
  addPlayer: addPlayer,
  collectSphereForPlayer: collectSphereForPlayer
}
