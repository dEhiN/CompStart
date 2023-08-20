import os
import unittest
import startupdata_editor


class TestStartupDataEditor(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        self.COMP_START = startupdata_editor
        self.JSON_FILENAME = "test_data.json"
        self.JSON_PATH = ["feature_addons", "startupdata_modifier_tool"]
        self.JSON_FILE = (
            os.getcwd()
            + os.sep
            + "feature_addons"
            + os.sep
            + "startupdata_modifier_tool"
            + os.sep
            + "test_data.json"
        )
        self.EXAMPLE_JSON = self.COMP_START.EXAMPLE_JSON

    def test_parse_full_path(self):
        print("Testing parse_full_path...")
        expected_message = "Expected: " + self.JSON_FILE
        self.assertEqual(
            self.COMP_START.parse_full_path(self.JSON_PATH, self.JSON_FILENAME),
            self.JSON_FILE,
            expected_message,
        )
        print("Function 'parse_full_path' passed!")

    def test_generate_default(self):
        print("Testing generate_default...")
        expected_message = "Expected:\n" + str(self.EXAMPLE_JSON)
        self.assertEqual(
            self.COMP_START.generate_default(), self.EXAMPLE_JSON, expected_message
        )
        print("Function 'generate_default' passed!")

    def test_create_json_data_true(self):
        print("Testing create_json_data with parameter 'default' as True...")
        expected_message = "Expected:\n" + str(self.EXAMPLE_JSON)
        self.assertEqual(
            self.COMP_START.create_json_data(True), self.EXAMPLE_JSON, expected_message
        )
        print("Function 'create_json_data' passed!")

    def test_json_writer_case_zero(self):
        print("Testing json_writer with parameter 'file_state' as 0...")
        expected_message = (True, "")
        self.assertEqual(
            self.COMP_START.json_writer(self.JSON_FILE, 0, self.EXAMPLE_JSON),
            expected_message,
        )
        print("Function 'json_writer' passed!")

    def test_json_writer_case_two(self):
        print("Testing json_writer with parameter 'file_state' as 2...")
        expected_message = (True, "")
        self.assertEqual(
            self.COMP_START.json_writer(self.JSON_FILE, 0, self.EXAMPLE_JSON),
            expected_message,
        )
        print("Function 'json_writer' passed!")


if __name__ == "__main__":
    unittest.main()
