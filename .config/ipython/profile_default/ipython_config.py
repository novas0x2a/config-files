c = get_config()

# Whether to display a banner upon starting IPython.
c.TerminalIPythonApp.display_banner = False

# lines of code to run at IPython startup.
#c.TerminalIPythonApp.exec_lines = [
#    'from see import see',
#    'import eventlet',
#    'eventlet.monkey_patch()',
#]

# Set to confirm when you try to exit IPython with an EOF (Control-D in Unix,
# Control-Z/Enter in Windows). By typing 'exit' or 'quit', you can force a
# direct exit without any confirmation.
c.TerminalInteractiveShell.confirm_exit = False
