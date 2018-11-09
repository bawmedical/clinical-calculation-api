## Datasets for Blood Glucose

### Random Blood Glucose data donated by Dr Julian Costello
  source: data donation via email to Dr Marcus Baw (personal communication)
  number of observations: 23
  data = [11.2,6.9,7.2,8.2,7.3,7.4,7.4,7.6,10.9,7.8,8.2,7.3,7.4,7.3,7.1,7.2,6.9,7.9,6.7,5.9,7.1,7.5,6.6]
  mean = 7.608695652173912
  standard_deviation = 1.1721081132350937
```
╰─$ irb
2.5.1 :001 > require 'descriptive_statistics'
 => true
2.5.1 :002 > arr = [11.2,6.9,7.2,8.2,7.3,7.4,7.4,7.6,10.9,7.8,8.2,7.3,7.4,7.3,7.1,7.2,6.9,7.9,6.7,5.9,7.1,7.5,6.6]
 => [11.2, 6.9, 7.2, 8.2, 7.3, 7.4, 7.4, 7.6, 10.9, 7.8, 8.2, 7.3, 7.4, 7.3, 7.1, 7.2, 6.9, 7.9, 6.7, 5.9, 7.1, 7.5, 6.6]
2.5.1 :003 > arr.mean
 => 7.608695652173912
2.5.1 :004 > arr.standard_deviation
 => 1.1721081132350937
```

### Random Blood Glucose and HbA1c data donated by Grant Vallance
  source: https://www.openhealthhub.org/t/simulating-plausible-dummy-data-for-an-average-type-2-diabetic-patient/1862/6

  > For the 50 patients for GLUCOSE I got n = 192 records. Some are from the same patient and some from different patients. All mixed up.
  > GLUCOSE: MEAN = 12.3 SD = 7.70 (calculated a/c to EXCEL STDEV.S function) 2 dp.
  > For the 50 patients for Hb1ac I got n = 398 records. Some are from the same patient and some from different patients. All mixed up.
  > Hb1ac (DCCT): MEAN = 8, SD = 1.38 (calculated a/c to EXCEL STDEV.S function) 2 dp
  > Hb1ac (IFCC): MEAN = 59, SD = 15.14 (calculated a/c to EXCEL STDEV.S function) 2 dp.
