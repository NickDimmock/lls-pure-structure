# Ignoring sub-areas to avoid ID / name clashes and redundancy

config = require 'local-config'
parse = require 'csv-parse'
fs = require 'fs'

dataFile = "#{config.dataCSV}"

csvData = fs.readFileSync(dataFile)

data =
    staff: {}
    areas: {}
    depts: {}
    alerts: []

parse csvData, { columns: true }, (err, csv) ->
    if err
        throw err
    for row in csv
        # Process will tell us whether to add this record
        processStaff = true
        if data.staff[row['ResID']]
            data.alerts.push "Duplicate staff entry: #{row['ResID']} (#{row['Known As']})"
            # If a duplicate record exists, don't process this version if the
            # main position is set to zero:
            if row['Main position'] == '0'
                processStaff = false
        if processStaff
            data.staff[row['ResID']] =
                firstName: row['First name']
                surname: row['Surname']
                knownAs: row['Known As']
                email: row['E-mail'].toLowerCase()
                role: row['Position(T)']
                startDate: row['Start Date']
                areaCode: row['Area']
                area: row['Area(T)']
                deptCode: row['Department']
                dept: row['Department(T)']
                fte: row['FTE']
        if(!data.areas[row['Area']])
            data.areas[row['Area']] =
                'name': row['Area(T)']
        if !data.depts[row['Department']]
            data.depts[row['Department']] =
                'areaCode': row['Area']
                'area': row['Area(T)']
                'name': row['Department(T)']

    console.log JSON.stringify(data, null, 4)