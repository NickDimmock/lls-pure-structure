# Create staff data
# Run after faculties and depts have been imported

config = require 'local-config'
convert = require 'xml-js'
fs = require 'fs'
staffData = require("#{config.dataJSON}").staff
jsonOutFile = "#{config.outputDir}/persons.json"
xmlOutFile = "#{config.outputDir}/persons.xml"
lookupOutFile = "#{config.outputDir}/email-lookup.json"
setUONDate = require 'set-uon-date'

lookupData = {}

personData =
        persons:
            _attributes:
                'xmlns:v3': 'v3.commons.pure.atira.dk'
                xmlns: 'v1.unified-person-sync.pure.atira.dk'
            person: []

foo = 'placeholder'

for key, val of staffData
    # convert start date from uni to Pure format
    # (dd/mm/yyyy to yyyy-mm-dd)
    # Need to do this *before* sending the date to the moment module via setUonDate()
    startDateArray = val.startDate.split '/'
    # employeeStartDate is the original hiring date:
    employeeStartDate = startDateArray.reverse().join '-'
    # create an int-only var from the start date to use in id values later:
    startDateInt = val.startDate.replace /\//g, ''
    # Call setUONDate to clamp start of organisational start date:
    orgStartDate = setUONDate employeeStartDate
    # Split 'known as' into name components:
    [akaFirst, akaLast] = val.knownAs.split /\s(.+)/
    person =
        _attributes:
            id: key
            # managedInPure: 'false'
        name:
            'v3:firstname': val.firstName
            'v3:lastname': val.surname
        names:
            classifiedName:
                _attributes:
                    id: "knownas-#{key}"
                name:
                    'v3:firstname': akaFirst
                    'v3:lastname': akaLast
                typeClassification: 'knownas'
        gender: 'unknown'
        employeeStartDate: employeeStartDate
        organisationAssociations:
            staffOrganisationAssociation:
                _attributes:
                    id: "#{key}-#{val.deptCode}-#{startDateInt}"
                emails:
                    'v3:classifiedEmail':
                        _attributes:
                            id: "#{key}-#{val.deptCode}-#{val.email}"
                        'v3:classification': 'email'
                        'v3:value': val.email
                primaryAssociation: 'true'
                organisation:
                    'v3:source_id': val.deptCode
                period:
                    'v3:startDate': orgStartDate
                staffType: 'academic'
                jobDescription:
                    'v3:text':
                        _attributes:
                            lang: "en"
                        _text: val.role
                fte: val.fte
        user:
            _attributes:
                id: "user-#{key}"
        personIds:
            'v3:id':
                _attributes:
                    id: key
                    type: 'employee'
                _text: "employee-#{key}"

    personData.persons.person.push person

    lookupData[val.email] = key

jsonOut = JSON.stringify(personData, null, 4)
xmlOut = convert.json2xml personData, { compact: true, spaces: 4 }

lookupOut = JSON.stringify(lookupData, null, 4)

if fs.existsSync jsonOutFile
    fs.copyFileSync jsonOutFile, "#{jsonOutFile}.bak"

if fs.existsSync xmlOutFile
    fs.copyFileSync xmlOutFile, "#{xmlOutFile}.bak"

if fs.existsSync lookupOutFile
    fs.copyFileSync lookupOutFile, "#{lookupOutFile}.bak"

fs.writeFileSync jsonOutFile, jsonOut
fs.writeFileSync xmlOutFile, xmlOut
fs.writeFileSync lookupOutFile, lookupOut