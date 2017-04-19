{
    "id": "hipchat_cheat_sheet",
    "name": "HipChat",
    "description":"Commands for HipChat, an online group and private chat service for teams.",
    "metadata": {
        "sourceName": "Atlassian",
        "sourceUrl": "https://confluence.atlassian.com/hipchat/keyboard-shortcuts-and-slash-commands-749385232.html"
    },
    "template_type": "terminal",
    "section_order": [
        "Room actions",
        "Setting your status",
        "Formatting messages"
    ],
    "aliases": [
        "hipchat commands",
        "hipchat command",
        "hipchat slash commands",
        "hipchat slash command"
    ],
    "sections": {
        "Room actions": [
            {
                "val": "Enter an existing HipChat room (HipChat web app only).",
                "key": "/join [room-name]"
            },
            {
                "val": "Leave the room you're currently in.",
                "key": "/part"
            },
            {
                "val": "Change the topic of the room you're currently in.",
                "key": "/topic [new-topic]"
            }
        ],
        "Setting your status": [
            {
                "val": "Set your status as available (green) and optionally includes a message.",
                "key": "/available [message]"
            },
            {
                "val": "Set your status as away (yellow) and optionally includes a message.",
                "key": "/away [message]"
            },
            {
                "val": "Set your status as Do Not Disturb (red) and optionally includes a message.",
                "key": "/dnd [message]"
            }
        ],
        "Formatting messages": [
            {
                "val": "Display the message with code syntax highlighting.",
                "key": "/code [code-block]"
            },
            {
                "val": "Use special message formatting when you quote someone.",
                "key": "/quote [message]"
            },
            {
                "val": "Clear chat history in the current room or 1-1 chat. (History comes back when you reopen the room or chat.)",
                "key": "/clear"
            },
            {
                "val": "Chat about yourself in the third person.",
                "key": "/me [message]"
            },
            {
                "val": "Fix your typos. Use regular expression syntax.",
                "key": "s/[wrong word]/[right word]"
            },
            {
                "val": "Show hexadecimal web colors within HipChat.",
                "key": "/#[color-hex]"
            }
        ]
    }
}
