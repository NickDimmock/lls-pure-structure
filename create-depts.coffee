# Create departmental structure

config = require 'local-config'
convert = require 'xml-js'
deptsData = require("#{config.dataJSON}").depts

# Initial start date for all depts will be the creation of the uni
startDate = config.uonStartDate

depts =
    organisations:
        _attributes:
            'xmlns:v3': 'v3.commons.pure.atira.dk'
            xmlns: 'v1.organisation-sync.pure.atira.dk'
        organisation: []

for key, val of deptsData
    dept =
        # _attributes:
            # managedInPure: 'false'
        organisationId: key
        type: 'department'
        name:
            'v3:text':
                _text: val.name
        startDate: startDate
        visibility: 'Public'
        parentOrganisationId: val.areaCode
    depts.organisations.organisation.push dept

xmlOut = convert.json2xml depts, { compact: true, spaces: 4 }

console.log xmlOut