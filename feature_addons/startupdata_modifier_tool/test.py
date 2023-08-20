# Import the main python file to test
import os
import startupdata_editor as my_app

# 'GLobal variables'
JSON_PATH = ["feature_addons", "startupdata_modifier_tool"]
JSON_FILENAME = "test_data.json"
JSON_FILE = (
    os.getcwd()
    + os.sep
    + "feature_addons"
    + os.sep
    + "startupdata_modifier_tool"
    + os.sep
    + "test_data.json"
)


def test_parse_full_path():
    expected_message = "Expected: " + JSON_FILE
    assert (
        my_app.parse_full_path(JSON_PATH, JSON_FILENAME) == JSON_FILE
    ), expected_message


# Run each test one by one
if __name__ == "__main__":
    test_parse_full_path()
    print("Test of function 'parse_full_path': Passed!")
