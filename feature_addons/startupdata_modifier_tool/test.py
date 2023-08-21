import os
import unittest
import startupdata_editor


class TestStartupDataEditor(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.COMP_START = startupdata_editor
        cls.JSON_FILENAME = "test_data.json"
        cls.JSON_PATH = ["feature_addons", "startupdata_modifier_tool"]
        cls.JSON_FILE = (
            os.getcwd()
            + os.sep
            + "feature_addons"
            + os.sep
            + "startupdata_modifier_tool"
            + os.sep
            + "test_data.json"
        )
        cls.EXAMPLE_JSON = cls.COMP_START.EXAMPLE_JSON

    def test_parse_full_path(self):
        print("Testing parse_full_path...")
        expected_message = "Expected: " + self.JSON_FILE
        self.assertEqual(
            self.COMP_START.parse_full_path(self.JSON_PATH, self.JSON_FILENAME),
            self.JSON_FILE,
            expected_message,
        )
        print("Passed!")

    def test_generate_default(self):
        print("Testing generate_default...")
        expected_message = "Expected:\n" + str(self.EXAMPLE_JSON)
        self.assertEqual(
            self.COMP_START.generate_default(), self.EXAMPLE_JSON, expected_message
        )
        print("Passed!")

    def test_create_json_data_true(self):
        print("Testing create_json_data with parameter 'default' as True...")
        expected_message = "Expected:\n" + str(self.EXAMPLE_JSON)
        self.assertEqual(
            self.COMP_START.create_json_data(True), self.EXAMPLE_JSON, expected_message
        )
        print("Passed!")

    def test_json_writer_case_zero(self):
        print("Testing json_writer with parameter 'file_state' as 0...")
        expected_message = (True, "")
        self.assertEqual(
            self.COMP_START.json_writer(self.JSON_FILE, 0, self.EXAMPLE_JSON),
            expected_message,
        )
        print("Passed!")

    def test_json_writer_case_two(self):
        print("Testing json_writer with parameter 'file_state' as 2...")
        expected_message = (True, "")
        self.assertEqual(
            self.COMP_START.json_writer(self.JSON_FILE, 0, self.EXAMPLE_JSON),
            expected_message,
        )
        print("Passed!")


if __name__ == "__main__":
    unittest.main()
