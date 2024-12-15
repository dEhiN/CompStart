# Dependency to store the Enum classes for creating properly structured JSON data and any other enum data structures

from enum import Enum


class JsonSchemaStructure(Enum):
    """Enum class based on startup_data.schema.json

    This class will be used to create valid JSON data to use for the startup_data.json file.

    Args:
        Enum: This class extends the Enum class from the enum module

    Members:
        An empty Python dictionary and list to correspond to a JSON object and array
    """

    OBJECT = {}
    ARRAY = []


class JsonSchemaKeys(Enum):
    """Enum class based on startup_data.schema.json

    This class will be used to create valid JSON data to use for the startup_data.json file.

    Args:
        Enum: This class extends the Enum class from the enum module

    Members:
        The legally valid keys based on startup_data.schema.json
    """

    TOTALITEMS = "TotalItems"
    ITEMS = "Items"
    ITEMNUMBER = "ItemNumber"
    NAME = "Name"
    FILEPATH = "FilePath"
    DESCRIPTION = "Description"
    BROWSER = "Browser"
    ARGUMENTCOUNT = "ArgumentCount"
    ARGUMENTLIST = "ArgumentList"


class ItemTypeVals(Enum):
    """Enum class for valid values for the item_type variable

    This class will be used to define valid values for the item_type variable. This variable is a parameter used by the function generate_user_edited_data in the module data_generate. It currently only accepts certain values, but rather than hardcode that in all the time, an enum class will allow for class members to be used instead.

    Args:
        Enum: This class extends the Enum class from the enum module

    Members:
        The legally valid keys for the item_type variable:

        A = add a startup item
        D = delete a startup item
        R = replace a startup item
        F = full startup data is being passed in
    """

    ADD = "A"
    DELETE = "D"
    REPLACE = "R"
    FULL = "F"
