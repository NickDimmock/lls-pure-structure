# Create University and faculty structure.
# Areas in HR code = faculties in Pure
# UON is included so we can manually set the ID

fs = require 'fs'
config = require 'local-config'
convert = require 'xml-js'
areaData = require("#{config.dataJSON}").areas
jsonOutFile = "#{config.outputDir}/faculties.json"
xmlOutFile = "#{config.outputDir}/faculties.xml"

universityID = 'UON'

#facultyStartDate = '2016-07-14'

faculties =
    organisations:
        _attributes:
            xmlns: 'v1.organisation-sync.pure.atira.dk'
            'xmlns:v3': 'v3.commons.pure.atira.dk'
        organisation: [
            {
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
        organisationId: key
        type: 'faculty'
        name:
            'v3:text':
                _text: val.name
        startDate: config.uonStartDate
        visibility: 'Public'
        parentOrganisationId: universityID
    faculties.organisations.organisation.push(faculty)


jsonOut = JSON.stringify(faculties, null, 4)
xmlOut = convert.json2xml faculties, { compact: true, spaces: 4 }

if fs.existsSync jsonOutFile
    fs.copyFileSync jsonOutFile, "#{jsonOutFile}.bak"

if fs.existsSync xmlOutFile
    fs.copyFileSync xmlOutFile, "#{xmlOutFile}.bak"

fs.writeFileSync jsonOutFile, jsonOut
fs.writeFileSync xmlOutFile, xmlOut