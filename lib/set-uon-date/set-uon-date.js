// Clamp start date to university start date or later
var config, moment;

moment = require('moment');

config = require('local-config');

module.exports = function(date) {
  if (moment(date).isBefore(config.uonStartDate)) {
    return config.uonStartDate;
  } else {
    return date;
  }
};
