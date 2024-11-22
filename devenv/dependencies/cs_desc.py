# File to store the description of the CompStart program for use when the user selects option 1 from the main menu

CS_DESCRIPTION = """
What is CompStart?

CompStart is a computer startup tool designed to make your life easier.
--
What does that mean?

Have you ever wished to be able to log into your laptop at work and have all of your programs automatically start up? Or, maybe you are working on some personal project at home and don't want to keep reopening the file or program you're using every time you turn on your computer.

With CompStart, you can have the following automatically open when you log in:

- any program on your computer
- any website you desire using your browser of choice
- any file using the appropriate program

There is no limit to how many programs, sites, and files you can have automatically open. Of course, the more you open at startup, the slower your startup might be after you log into Windows.
--
How does it work?

CompStart uses a file to store the programs, sites, and files to automatically open. This file is referred to throughout as the startup file. Each item or entry is referred to as a startup item. Startup items can have arguments. The contents of the startup file is sometimes called the startup data.

This text-based tool will let you modify that startup file. For example, if you want to have Microsoft Word open to a document that you are currently working on, you could use this tool to add a new startup item. You would have the new item open Microsoft Word and pass in the document you want to open as an argument. As another example, if you want your favourite browser to open and show a specific site that you visit often, or are using for work, you would add a new startup item. This time, the startup item would be set to open your favourite browser, and the argument given would be the site you want opened.
--
Is there a graphical way to modify the startup file?

At this time, there is not. The only other way to modify the startup file is to do so manually and that can be complicated. This text-based tool was created to allow for a an easier way to modify the startup file. It's not as easy as a graphical tool, but it is easier than manual modification.
--
How do I use this tool?

As you saw when you first started this tool, a menu was displayed asking you to make a choice. The first option brought you here to this description. Since the tool is text-based, it uses menus and prompts throughout, just like that first or main menu. From that main menu, you can create a new startup file, view the existing one, or edit the existing one. Some of the options have further menus.

This tool comes with a default startup file to get you started. It opens up Windows Calculator, Google Chrome (if installed) to the Google Homepage, and Windows Notepad. The edit option in the main menu will let you delete all those defaults and add ones of your own. The create a new file option has a choice where you can create a new startup file with all of your own choices, but that functionality hasn't been added yet. You can currently only create a new default startup file.
--
What if I need help with this tool?

If you need help with this tool, please go to https://github.com/dEhiN/CompStart/issues and click the New issue button. Try to give us as much information as you can about what you were trying to do and what happened.
--
What if I encounter an error?

If you encounter an error, please create a new issue using the same steps above. There should be one or more error messages that are printed out. We will need that information, so either copy the messages or take a screenshot of it. Again, try to give us as much information as you can about what you were trying to do.
--
Do I need to install anything?

CompStart works by using special Windows scripts that read the startup file and open each startup item. While an installer is planned, for now, a shortcut to those scripts needs to be created and placed where Windows will see and run the shortcut after you log in. There are step by step directions in the instructions text file, which might be one folder up from where you are now. 
"""
