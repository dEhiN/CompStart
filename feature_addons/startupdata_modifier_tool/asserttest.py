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


def test_generate_default():
    expected_mesasge = "Expected:\n" + str(my_app.EXAMPLE_JSON)
    assert my_app.generate_default() == my_app.EXAMPLE_JSON, expected_mesasge


def test_create_json_data_true():
    expected_message = "Expected:\n" + str(my_app.EXAMPLE_JSON)
    assert my_app.create_json_data(True) == my_app.EXAMPLE_JSON, expected_message


def test_json_writer_case_zero():
    expected_message = (True, "")
    assert my_app.json_writer(JSON_FILE, 0, my_app.EXAMPLE_JSON), expected_message


def test_json_writer_case_two():
    expected_message = (True, "")
    assert my_app.json_writer(JSON_FILE, 0, my_app.EXAMPLE_JSON), expected_message


# Run each test one by one
if __name__ == "__main__":
    test_parse_full_path()
    print("Test of function 'parse_full_path': Passed!")
    test_generate_default()
    print("Test of function 'generate_default': Passed!")
    test_create_json_data_true()
    print(
        "Test of function 'create_json_data' passing in parameter 'default' as True: Passed!"
    )
    test_json_writer_case_zero()
    print(
        "Test of function 'json_writer' passing in parameter 'file_state' as 0: Passed!"
    )
    test_json_writer_case_two()
    print(
        "Test of function 'json_writer' passing in parameter 'file_state' as 2: Passed!"
    )
