# University staff & structure import

Coffeescript scripts to import UoN staff and strucutre data into Pure.

## Data source preparation

Data source is CSV derived from HR spreadsheet.
Remove empty first line, but leave header row.

## Data source processing

In case of duplicate ResID values, script will overwrite existing value only if the 'Main position' field is set to 1. This works for data in 170918 export (only current duplicate is 22437) - check future export files to makes sure additional duplicates follow this pattern (a single record where 'Main position' is set to 1).

Main position can't be relied upon solely as at least one person only exists with a MP of 0. However, they're a visiting prof and should eventually be ignored.

## Folders

```data``` contains source files with staff details, and should not be synced with git.

## Scripts

Run csv-to-json to convert CSV to main JSON file.
Run create-faculties to create top-level uni & faculty structure.
Run create-depts to create strucutre within faculties.
Run create-staff to create staff.
Import in following order to maintain structure:
- Faculties
- Depts
- Staff
