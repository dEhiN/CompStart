from enum import Enum


class JsonSchemaStructure(Enum):
    """Enum class based on startup_data.schema.json

    This class will be used to create valid JSON data to use for the
    startup_data.json file.

    Args:
        Enum: This class extends the Enum class from the enum module

    Members:
        An empty Python dictionary and list to correspond to a JSON object and
        array
    """

    OBJECT = {}
    ARRAY = []


class JsonSchemaKeys(Enum):
    """Enum class based on startup_data.schema.json

    This class will be used to create valid JSON data to use for the
    startup_data.json file.

    Args:
        Enum: This class extends the Enum class from the enum module

    Members:
        The legally valid keys based on startup_data.schema.json
    """

    TOTALITEMS = "TotalItems"
    ITEMS = "Items"
    ITEMNUMBER = "ItemNumber"
    FILEPATH = "FilePath"
    COMMENTS = "Comments"
    BROWSER = "Browser"
    ARGUMENTCOUNT = "ArgumentCount"
    ARGUMENTLIST = "ArgumentList"
