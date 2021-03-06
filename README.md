# University staff & structure import

Coffeescript scripts to import UoN staff and strucutre data into Pure.

## Data source preparation

Data source is CSV derived from HR spreadsheet.
Remove empty first line, but leave header row.

## Data source processing

In case of duplicate ResID values, ```create-staff``` will overwrite existing value only if the 'Main position' field is set to 1. This works for data in 170918 export (only current duplicate is 22437) - check future export files to makes sure additional duplicates follow this pattern (a single record where 'Main position' is set to 1).

Main position can't be relied upon solely as at least one person only exists with a MP of 0. However, they're a visiting prof and should eventually be ignored.

## Folders

```data``` contains source files with staff details, and should not be synced with git.
```out``` contains output files (json and xml) and should not be synced
```lib``` contains local utility node modules

## Scripts

Run ```csv-to-json``` to convert CSV to main JSON file (writes direct to console).
Run ```create-faculties``` to create top-level uni & faculty structure.
Run ```create-depts``` to create strucutre within faculties.
Run ```create-staff``` to create staff.
Import in the following order to correctly create structure in Pure:
- Faculties
- Depts
- Staff

```create-staff``` will also generate an ```email-lookup``` file in the output folder, which can be used to look up person IDs by email address.

## Outstanding issues

- An accurate staff start date for their department is required (as opposed to their general employment start date).
- Need to specify any entries to be ignored.