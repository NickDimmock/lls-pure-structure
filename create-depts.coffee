# Create departmental structure

fs = require 'fs'
config = require 'local-config'
convert = require 'xml-js'
deptsData = require("#{config.dataJSON}").depts
jsonOutFile = "#{config.outputDir}/depts.json"
xmlOutFile = "#{config.outputDir}/depts.xml"

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
        organisationId: key
        type: 'department'
        name:
            'v3:text':
                _text: val.name
        startDate: startDate
        visibility: 'Public'
        parentOrganisationId: val.areaCode
    depts.organisations.organisation.push dept

jsonOut = JSON.stringify(depts, null, 4)
xmlOut = convert.json2xml depts, { compact: true, spaces: 4 }

if fs.existsSync jsonOutFile
    fs.copyFileSync jsonOutFile, "#{jsonOutFile}.bak"

if fs.existsSync xmlOutFile
    fs.copyFileSync xmlOutFile, "#{xmlOutFile}.bak"

fs.writeFileSync jsonOutFile, jsonOut
fs.writeFileSync xmlOutFile, xmlOut