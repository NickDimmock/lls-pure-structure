# Clamp start date to university start date or later

moment = require 'moment'
config = require 'local-config'

module.exports = (date) ->
    if moment(date).isBefore(config.uonStartDate)
        return config.uonStartDate
    else
        return date
