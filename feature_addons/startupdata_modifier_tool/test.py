# Import the main python file to test
import os
import startupdata_editor as my_app

# 'GLobal variables'
JSON_PATH = ["feature_addons", "startupdata_modifier_tool"]
JSON_FILENAME = "test_data.json"


def test_parse_full_path():
    correct_results = (
        os.getcwd()
        + os.sep
        + "feature_addons"
        + os.sep
        + "startupdata_modifier_tool"
        + os.sep
        + "test_data.json"
    )

    expected_message = "Expected: " + correct_results + "test_data.json"

    assert (
        my_app.parse_full_path(JSON_PATH, JSON_FILENAME) == correct_results
    ), expected_message


# Run each test one by one
if __name__ == "__main__":
    test_parse_full_path()
    print("Test of function 'parse_full_path': Passed!")
