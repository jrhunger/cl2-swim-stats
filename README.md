# best-times
Input: multiple meet results in CL2 format
Output: best-times.tsv:
  - tab-delimited
  - one line per swimmer per event
  - initial columns:
    - swimmer (Last, First)
    - gender (M/F)
    - age-grp (6/708/910/1112/1314/1518)
    - event (yards stroke)
  - columns per meet for:
    - result (column header = meet date)
      - if swam - time in seconds or "DQ"
      - blank if not swam
    - firsttime:
      - yes/no - if it was the first time they swam that even this season
    - improvement:
      - improvement in seconds vs previous best
      - blank if not a best time
    - goldstroke
      - season improvement (or improvement vs previous gold stroke) in seconds if >= 10
      - blank if no improvement or < 10
  - final columns:
    - champs:
      - yes - if they have >= 2 legal swims for that event
      - blank if not
    - seed (season best time = champs seed time)
    - season improvement (difference between first and best swims)
    
## reference
CL2:
* https://swimmum.wordpress.com/2016/02/26/what-is-cl2-and-hy3/
* https://swimmum.wordpress.com/2016/02/26/cl2-individual-event-record-in-depth/

### CL2 field position notes
D0 records are individual swims

- Name: 12 to 39
- Age: 64/65
- swimmer gender: 66
- event gender: 67
- distance: 69-71
- event: 72
  - 1 = free
  - 2 = back
  - 3 = breast
  - 4 = fly
  - 5 = im
  - 6 = free relay
  - 7 = medley relay
- event number: 74-75
- age group: 76-79
  - e.g. 1314, or 15OV, or UN06 or 0708
- event date: 80-87
- result time (final): 117-124 
  - DQ / NS / DNF
