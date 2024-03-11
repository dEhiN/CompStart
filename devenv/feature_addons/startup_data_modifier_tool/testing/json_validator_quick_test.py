import os
import dependencies.helper as dh

print(dh.json_data_validator(dh.DEFAULT_JSON))
print(
    dh.json_data_validator(
        {
            "ItemNumber": 2,
            "Name": "Google",
            "FilePath": "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
            "Description": "The Google Homepage",
            "Browser": True,
            "ArgumentCount": 3,
            "ArgumentList": [
                "--profile-directory=Default",
                "--new-window",
                "https://www.google.com/",
            ],
        },
        True,
    )
)
