import sys

sys.path.append("../dependencies")

from dependencies import cs_helper as dh_csh
import dependencies.cs_data_generate as dh_csdg

print(dh_csh.json_data_validator(dh_csdg.generate_default_startup_data()[1]))
print(
    dh_csh.json_data_validator(
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
