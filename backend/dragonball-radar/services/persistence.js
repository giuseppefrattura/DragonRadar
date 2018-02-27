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

function save() {
  console.log("Saved!");
}

function getCurrentMap() {
  return map;
}

function saveNewMap(newMap) {
  newMap.boundingBox =  calculateBoundingBox(newMap.map.spheres);
  map = newMap;
  return newMap;

}
function getCurrentStats() {
  return currentStats;
}
function getPlayer(playerName) {
  return currentStats[playerName];
}
function addPlayer(playerName) {
  currentStats[playerName] = {spheres: {}};
}
function collectSphereForPlayer(playerName, sphereId) {
  currentStats[playerName]["spheres"][sphereId] = (new Date).getTime()
}
function min(a, b) {
  return Math.min(a,b)
}
function max(a,b) {
  return Math.max(a,b)
}
function calculateBoundingBox(spheres) {
  var minLatitude = spheres.map(s => s.latitude).reduce(min);
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
  save : save,
  getCurrentMap: getCurrentMap,
  saveNewMap: saveNewMap,
  getCurrentStats: getCurrentStats,
  getPlayer: getPlayer,
  addPlayer: addPlayer,
  collectSphereForPlayer: collectSphereForPlayer
}
