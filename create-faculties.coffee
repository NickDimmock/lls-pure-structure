# Create University and faculty structure.
# Areas in HR code = faculties in Pure
# UON is included so we can manually set the ID

config = require 'local-config'
convert = require 'xml-js'
areaData = require("#{config.dataJSON}").areas

universityID = 'UON'

#facultyStartDate = '2016-07-14'

faculties =
    organisations:
        _attributes:
            xmlns: 'v1.organisation-sync.pure.atira.dk'
            'xmlns:v3': 'v3.commons.pure.atira.dk'
        organisation: [
            {
                # _attributes:
                    # managedInPure: 'false'
                organisationId: universityID
                type: 'university'
                name:
                    'v3:text':
                        _text: 'University of Northampton'
                startDate: config.uonHistoricalStartDate
                visibility: 'Public'
            }
        ]

for key, val of areaData
    faculty =
        #_attributes:
            #managedInPure: 'true'
        organisationId: key
        type: 'faculty'
        name:
            'v3:text':
                _text: val.name
        startDate: config.uonStartDate
        visibility: 'Public'
        parentOrganisationId: universityID
    faculties.organisations.organisation.push(faculty)

xmlOut = convert.json2xml faculties, { compact: true, spaces: 4 }

console.log xmlOut