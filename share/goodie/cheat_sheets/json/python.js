{
    "id": "python_cheat_sheet",
    "name": "python",
    "description": "Complete python cheat sheet",
    "metadata": {
        "sourceName": "rgruet",
        "sourceUrl": "http://overapi.com/python/"
    },
    "template_type": "keyboard",
    "section_order": [
        "Basics",
        "General",
        "Movements",
        "Navigation",
        "Selection",
        "Fly mode",
        "Switching modes",
        "Modeling",
        "Editing curves",
        "Sculpting",
        "Animation",
        "Node editor",
        "Armatures",
        "Pose mode",
        "Timeline",
        "Video Sequence Editor",
        "Advanced"
    ],
    "sections": {
        "Basics": [{
            "key": "Prevents module import from creating a .pyc or .pyo files",
            "val": "-B"
        }, {
            "val": "-d",
            "key": "Output parser debugging information"
        }, {
            "val": "-E",
            "key": "Ignore environment variables"
        }, {
            "val": "-h",
            "key": "print a help message and exit"
        }, {
            "val": "-i",
            "key": "Inspect interactively after runnning script and force prompts even if stdin appears not to be a terminal"
        }, {
            "val": "-m module",
            "key": "Search for module on sys.path and runs the module as a script"
        }, {
            "val": "-O",
            "key": "Optimized generated bytecode ,Asserts are suppressed"
        }, {
            "val": "-OO",
            "key": "Remove doc-strings in addition to the -O optimizations."
        }, {
            "val": "-Q arg",
            "key": "Divsion options: -Qold (default), -Qwarn, -Qwarnall, -Qnew "
        }, {
            "val": "-s",
            "key": "Disables the user-specific module path"
        }, {
            "val": "-S",
            "key": "Don't perform import-site on initialization"
        }, {
            "val": "-t",
            "key": "Issues warnings on inconsistent tab usage"
        }, {
            "val": "-u",
            "key": "unbuffered binary stdout and stderr"
        }, {
            "val": "-U",
            "key": "Force python to interpret all strings literals as unicode literals"
        }, {
            "val": "-v",
            "key": "Verbose(trace import statements)"
        }, {
            "val": "-V",
            "key": "Print the python version number and exit "
        }],
        "General": [{
            "val": "-W arg",
            "key": "Warning control"
        }, {
            "val": "-x",
            "key": "Skip first line of source ,allowing use of non-unix forms of #!cmd"
        }, {
            "val": "-3",
            "key": "emit a DeprecationWarning for Python 3.x incompatibilities "
        }, {
            "val": "-c command",
            "key": "specify the command to execute"
        }, {
            "val": "scriptFile",
            "key": "The name of a python file (.py) to execute. Read from stdin. "
        }, {
            "val": "-",
            "key": "program read from stdin"
        }, {
            "val": "args",
            "key": "Passed to script or command"
        }, {
            "val": "",
            "key": "if no scriptFile or command ,Python enters interactive mode "
        }, {
            "val": "Track to",
            "key": "[Ctrl] [t]"
        }, {
            "val": "Clear track",
            "key": "[Alt] [t]"
        }, {
            "val": "Reset 3D cursor",
            "key": "[Shift] [c]"
        }, {
            "val": "Turn widget on/off",
            "key": "[Ctrl] [Spacebar]"
        }, {
            "val": "Add to group",
            "key": "[Ctrl] [g]"
        }],
        "Movements": [{
            "val": "Move",
            "key": "g"
        }, {
            "val": "Rotate",
            "key": "r"
        }, {
            "val": "Scale",
            "key": "s"
        }, {
            "val": "Precise movement",
            "key": "[\\{hold\\} Shift]"
        }, {
            "val": "Increment movement",
            "key": "[\\{hold\\} Ctrl]"
        }, {
            "val": "Lock to axis",
            "key": "[Middle click] / [x] / [y] / [z]"
        }],
        "Navigation": [{
            "val": "Top view",
            "key": "Numpad 7"
        }, {
            "val": "Front view",
            "key": "Numpad 1"
        }, {
            "val": "Side view",
            "key": "Numpad 3"
        }, {
            "val": "Camera view",
            "key": "0"
        }, {
            "val": "Zoom to object",
            "key": "Numpad ."
        }, {
            "val": "Fly mode",
            "key": "[Shift] [f]"
        }],
        "Selection": [{
            "val": "Select oblect",
            "key": "Right click"
        }, {
            "val": "Select multiple",
            "key": "[Shift] [Right click]"
        }, {
            "val": "(De-)Select all",
            "key": "a"
        }, {
            "val": "Select object behind",
            "key": "[Alt] [Right click]"
        }, {
            "val": "Select linked",
            "key": "l"
        }, {
            "val": "Select all linked",
            "key": "[Ctrl] [l]"
        }, {
            "val": "Box select",
            "key": "b"
        }, {
            "val": "Circle select",
            "key": "c"
        }, {
            "val": "Lasso tool",
            "key": "[Ctrl] [Click]"
        }, {
            "val": "Inverse selection",
            "key": "[Ctrl] [i]"
        }],
        "Fly mode": [{
            "val": "Start fly mode",
            "key": "[Shift] [f]"
        }, {
            "val": "Accelerate",
            "key": "[Mouse wheel \\{up\\}]"
        }, {
            "val": "Decelerate",
            "key": "[Mouse wheel \\{down\\}]"
        }, {
            "val": "Pan",
            "key": "Middle click"
        }, {
            "val": "Fly forward",
            "key": "w"
        }, {
            "val": "Fly backwards",
            "key": "s"
        }, {
            "val": "Fly left",
            "key": "a"
        }, {
            "val": "Fly right",
            "key": "d"
        }, {
            "val": "Fly up",
            "key": "r"
        }, {
            "val": "Fly down",
            "key": "f"
        }],
        "Switching modes": [{
            "val": "Edit/Object mode",
            "key": "Tab"
        }, {
            "val": "Vertex paint mode",
            "key": "v"
        }, {
            "val": "Weight paint mode",
            "key": "[Ctrl] [Tab]"
        }, {
            "val": "Switching workspace",
            "key": "[Ctrl] ([←]/[→])"
        }, {
            "val": "Logic editor",
            "key": "[Shift] [F2]"
        }, {
            "val": "Node editor",
            "key": "[Shift] [F3]"
        }, {
            "val": "Console",
            "key": "[Shift] [F4]"
        }, {
            "val": "3D viewport",
            "key": "[Shift] [F5]"
        }, {
            "val": "F-curve editor",
            "key": "[Shift] [F6]"
        }, {
            "val": "Properties",
            "key": "[Shift] [F7]"
        }, {
            "val": "Video sequence editor",
            "key": "[Shift] [F8]"
        }, {
            "val": "Outliner",
            "key": "[Shift] [F9]"
        }, {
            "val": "UV/Image editor",
            "key": "[Shift] [F10]"
        }, {
            "val": "Text editor",
            "key": "[Shift] [F11]"
        }],
        "Editing curves": [{
            "val": "Close path",
            "key": "[Alt] [c]"
        }, {
            "val": "Add handle",
            "key": "[Ctrl] [Click]"
        }, {
            "val": "Subdivide",
            "key": "w"
        }, {
            "val": "Tilt",
            "key": "[Ctrl] [t]"
        }, {
            "val": "Clear tilt",
            "key": "[Alt] [t]"
        }, {
            "val": "Change handle to bezier",
            "key": "h"
        }, {
            "val": "Change handle to vector",
            "key": "v"
        }, {
            "val": "Reset to default handle",
            "key": "[Shift] [h]"
        }],
        "Modeling": [{
            "val": "Make face",
            "key": "f"
        }, {
            "val": "Subdivide",
            "key": "w"
        }, {
            "val": "Extrude",
            "key": "e"
        }, {
            "val": "Seperate",
            "key": "p"
        }, {
            "val": "Rip",
            "key": "v"
        }, {
            "val": "Create loop cut",
            "key": "[Ctrl] [r]"
        }, {
            "val": "Propostional editing",
            "key": "o"
        }, {
            "val": "Select edge loop",
            "key": "[Alt] [Right click]"
        }, {
            "val": "Make seam/sharp",
            "key": "[Ctrl] [e]"
        }, {
            "val": "Merge vertices",
            "key": "[Alt] [m]"
        }, {
            "val": "Mirror",
            "key": "[Ctrl] [m]"
        }, {
            "val": "Shrink/Flatten",
            "key": "[Alt] [s]"
        }, {
            "val": "Knife",
            "key": "[k] then [Click]"
        }, {
            "val": "Fill",
            "key": "[Alt] [f]"
        }, {
            "val": "Beauty fill",
            "key": "[Shift] [Alt] [f]"
        }, {
            "val": "Add subdivision level",
            "key": "[Ctrl] ([1]/[2]/[3]/[4])"
        }],
        "Sculpting": [{
            "val": "Change brush size",
            "key": "f"
        }, {
            "val": "Change brush strength",
            "key": "[Shift] [f]"
        }, {
            "val": "Rotate brush texture",
            "key": "[Ctrl] [f]"
        }],
        "Animation": [{
            "val": "Play/Stop animation",
            "key": "[Alt] [a]"
        }, {
            "val": "Play animation in reverse",
            "key": "[Alt] [Shift] [a]"
        }, {
            "val": "Next frame",
            "key": "→"
        }, {
            "val": "Previous frame",
            "key": "←"
        }, {
            "val": "Forward 10 frames",
            "key": "↑"
        }, {
            "val": "Back 10 frames",
            "key": "↓"
        }, {
            "val": "Jump to start point",
            "key": "[Shift] [←]"
        }, {
            "val": "Jump to end point",
            "key": "[Shift] [→]"
        }, {
            "val": "Scroll through frames",
            "key": "[Alt] [Mouse wheel]"
        }, {
            "val": "Insert keyframe",
            "key": "i"
        }, {
            "val": "Remove keyframe",
            "key": "[Alt] [i]"
        }, {
            "val": "Jump to next keyframe",
            "key": "[Ctrl] [Page up]"
        }, {
            "val": "Jump to previous keyframe",
            "key": "[Ctrl] [Page down]"
        }],
        "Node editor": [{
            "val": "Add node",
            "key": "[Shift] [a]"
        }, {
            "val": "Cut links",
            "key": "[Ctrl] [Left mouse]"
        }, {
            "val": "(Un-)Hide node",
            "key": "h"
        }, {
            "val": "Make group",
            "key": "[Ctrl] [g]"
        }, {
            "val": "Ungroup",
            "key": "[Alt] [g]"
        }, {
            "val": "Edit group",
            "key": "Tab"
        }, {
            "val": "Move background",
            "key": "[Alt] [Middle mouse]"
        }, {
            "val": "Zoom in background",
            "key": "v"
        }, {
            "val": "Zoom out background",
            "key": "[Alt] [v]"
        }, {
            "val": "Properties",
            "key": "n"
        }],
        "Armatures": [{
            "val": "Add bone",
            "key": "[e] or [Ctrl] [Click]"
        }, {
            "val": "Rotate",
            "key": "[Ctrl] [r]"
        }, {
            "val": "Recalculate roll",
            "key": "[Ctrl] [n]"
        }, {
            "val": "Align bones",
            "key": "[Ctrl] [Alt] [a]"
        }, {
            "val": "Move to bone layers",
            "key": "m"
        }, {
            "val": "View bone layers",
            "key": "[Shift] [m]"
        }, {
            "val": "Set bone flag",
            "key": "[Shift] [w]"
        }, {
            "val": "Switch bone direction",
            "key": "[Alt] [f]"
        }, {
            "val": "Scroll hierachy",
            "key": "{\\]} / {\\[}"
        }, {
            "val": "Select hierarchy",
            "key": "[Shift] ({\\]} / {\\[})"
        }, {
            "val": "Select connected",
            "key": "l"
        }],
        "Pose mode": [{
            "val": "Apply pose",
            "key": "[Ctrl] [a]"
        }, {
            "val": "Clear pose rotation",
            "key": "[Alt] [r]"
        }, {
            "val": "Clear pose location",
            "key": "[Alt] [l]"
        }, {
            "val": "Clear pose scale",
            "key": "[Alt] [s]"
        }, {
            "val": "Copy pose",
            "key": "[Ctrl] [c]"
        }, {
            "val": "Paste pose",
            "key": "[Ctrl] [v]"
        }, {
            "val": "Add IK",
            "key": "[Shift] [i]"
        }, {
            "val": "Remove IK",
            "key": "[Ctrl] [Alt] [i]"
        }, {
            "val": "Add to bone group",
            "key": "[Ctrl] [g]"
        }, {
            "val": "Relax pose",
            "key": "[Alt] [e]"
        }],
        "Timeline": [{
            "val": "Set start frame",
            "key": "s"
        }, {
            "val": "Set end frame",
            "key": "e"
        }, {
            "val": "Show all frames",
            "key": "Home"
        }, {
            "val": "Add marker",
            "key": "m"
        }, {
            "val": "Move marker",
            "key": "[Right click \\{drag\\}]"
        }, {
            "val": "Toggle frames/seconds",
            "key": "[Ctrl] [t]"
        }],
        "Video Sequence Editor": [{
            "val": "Next strip",
            "key": "Page up"
        }, {
            "val": "Pervious strip",
            "key": "Page down"
        }, {
            "val": "Split strip",
            "key": "k"
        }, {
            "val": "Lock strip",
            "key": "[Shift] [l]"
        }, {
            "val": "Unlock strip",
            "key": "[Shift] [Alt] [l]"
        }, {
            "val": "Coyp strip",
            "key": "[Ctrl] [c]"
        }, {
            "val": "Paste strip",
            "key": "[Ctrl] [v]"
        }, {
            "val": "Seperate images",
            "key": "y"
        }, {
            "val": "Snap strip to scrubber",
            "key": "[Shift] [s]"
        }],
        "Advanced": [{
            "val": "Append file",
            "key": "[Shift] [F1]"
        }, {
            "val": "Fullscreen mode",
            "key": "[Alt] [F11]"
        }, {
            "val": "Maximize subwindow",
            "key": "[Ctrl] [↑]"
        }, {
            "val": "Change active camera",
            "key": "[Ctrl] [o]"
        }, {
            "val": "Use render buffer",
            "key": "j"
        }, {
            "val": "Only render selected",
            "key": "w"
        }, {
            "val": "Only render portion",
            "key": "[Shift] [b]"
        }, {
            "val": "Save over default scene",
            "key": "[Ctrl] [u]"
        }, {
            "val": "Make screen cast",
            "key": "[Ctrl] [F4]"
        }]
    }
}
