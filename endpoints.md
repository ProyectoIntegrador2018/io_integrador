## Endpoint Documentation

We recommend using a tool like Postman to visualize the API's responses.

### Base URL

```
http://emmiapi.azurewebsites.net/api/
```

> **Note:** It's `emmiapi` and not `eemiapi`.

### Logging In

Method: GET

Type: JSON

URL:

```
http://emmiapi.azurewebsites.net/api/Token?username=<username>&password=<password>
```

Response:

An object with an access token and an expiration time.


```
{
    "access_token": <your_token>,
    "expires_in": <expiration_time>
}
```

### Getting Appointments

Method: GET

Type: JSON

URL:

```
http://emmiapi.azurewebsites.net/api/Agenda?GetByDate/<start_date>/<end_date>
```

> **Note**: Dates are formatted like so: monthdayyear/monthdayyear. No slashes or dashes.

Response:

An array of appointment objects.

```
[
    {
        "patientName": "Jorge",
        "patientLastName": "Elizondo",
        "patientLastName2": "Levy",
        "reason": "CONSULTA",
        "status": "Programada",
        "dateAppointment": "2019-02-19T00:00:00",
        "comments": "Cita para vacuna(s): \r\n* MMR 3\r\n",
        "consultation": [],
        "cephalicPerimeter": 0,
        "idAppointment": 1234,
        "idPatient": 4321,
        "reqImmunization": true,
        "size": 0,
        "timeAppointment": "08:00:00",
        "weight": 0,
        "ta1": 0,
        "ta2": 0,
        "ta3": 0,
        "temperature": 0
    },
    ...
]
```
