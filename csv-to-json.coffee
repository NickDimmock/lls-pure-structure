config = require 'local-config'
parse = require 'csv-parse'
fs = require 'fs'

csvData = fs.readFileSync(config.dataCSV)

data =
    staff: {}
    areas: {}
    depts: {}
    alerts: []

parse csvData, { columns: true }, (err, csv) ->
    if err
        throw err
    for row in csv
        # processStaff flag will tell us whether to add this record
        processStaff = true
        if data.staff[row['ResID']]
            data.alerts.push "Duplicate staff entry: #{row['ResID']} (#{row['Known As']})"
            # If a duplicate record exists, don't process this version if the
            # main position is set to zero.
            # We can't just ignore all zero value records, because in some cases they
            # may be the only ones. This way we'll overwrite any existing zero value
            # records if we get a positive value, but we won't overwrite positive
            # value records with zero values.
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