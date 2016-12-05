import requests
import json


meta = "http://plenar.io/v1/api/datasets"
meta = requests.get(meta)
meta_output = json.loads(meta.text)
meta_json = json.dumps(meta_output)
with open('meta.json', 'w') as f:
    f.write(meta_json)
f.close()

crashes_all = "http://plenar.io/v1/api/grid/?obs_date__ge=2012-01-01&obs_date__le=2016-11-19&dataset_name=nypd_motor_vehicle_collisions&resolution=1000"
crashes_2016 = "http://plenar.io/v1/api/grid/?obs_date__ge=2016-01-01&obs_date__le=2016-11-19&dataset_name=nypd_motor_vehicle_collisions&resolution=1000"
crashes_2013 = "http://plenar.io/v1/api/grid/?obs_date__ge=2013-01-01&obs_date__le=2013-12-31&dataset_name=nypd_motor_vehicle_collisions&resolution=1000"

injury_filter = '&nypd_motor_vehicle_collisions__filter={"op":"gt", "col":"number_of_persons_injured", "val": 0}'
death_filter =  '&nypd_motor_vehicle_collisions__filter={"op":"gt", "col":"number_of_persons_killed", "val": 0}'

#total injuries
injured = requests.get(crashes_all + injury_filter)
injured_output = json.loads(injured.text)

#total deaths
deaths = requests.get(crashes_all + death_filter)
deaths_output = json.loads(deaths.text)

#2013 injuries
injured_2013 = requests.get(crashes_2013 + injury_filter)
injured_2013_output = json.loads(injured_2013.text)

#2013 deaths
deaths_2013 = requests.get(crashes_2013 + death_filter)
deaths_2013_output = json.loads(deaths_2013.text)

#2016 injuries
injured_2016 = requests.get(crashes_2016 + injury_filter)
injured_2016_output = json.loads(injured_2016.text)

#2016 deaths
deaths_2016 = requests.get(crashes_2016 + death_filter)
deaths_2016_output = json.loads(deaths_2016.text)


# save merged datasets to an output geojson file
injured_json = json.dumps(injured_output)
with open('injured_total.json', 'w') as f:
    f.write(injured_json)
f.close()

deaths_json = json.dumps(deaths_output)
with open('deaths_total.json', 'w') as f:
    f.write(deaths_json)
f.close()

#Save 2013 Datasets
injured_2013_json = json.dumps(injured_2013_output)
with open('injured_2013.json', 'w') as f:
    f.write(injured_2013_json)
f.close()

deaths_2013_json = json.dumps(deaths_2013_output)
with open('deaths_2013.json', 'w') as f:
    f.write(deaths_2013_json)
f.close()

#Save 2016 Datasets

injured_2016_json = json.dumps(injured_2016_output)
with open('injured_2016.json', 'w') as f:
    f.write(injured_2016_json)
f.close()

deaths_2016_json = json.dumps(deaths_2016_output)
with open('deaths_2016.json', 'w') as f:
    f.write(deaths_2016_json)
f.close()
