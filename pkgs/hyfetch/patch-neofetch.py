#!/usr/bin/env python3
"""
Patch the neowofetch bash script to add Jester Linux distro detection and ASCII art.

Two changes:
  1. Insert a Jester Linux detection block (keyed on /etc/JESTERLINUX) immediately
     before the existing NixOS block (keyed on /etc/NIXOS).
  2. Insert a "jesterlinux" ASCII art case in get_distro_ascii, just before "nixos_small".
"""

import sys

NIXOS_DETECT = '            elif [[ -f /etc/NIXOS ]]; then'

JESTER_DETECT = '''\
            elif [[ -f /etc/JESTERLINUX ]]; then
                _jester_ver=$(nixos-version 2>/dev/null || true)
                case $distro_shorthand in
                    on|tiny) distro="Jester Linux" ;;
                    *) distro="Jester Linux ${_jester_ver}" ;;
                esac
                ascii_distro="jesterlinux"
'''

NIXOS_SMALL_CASE = '        "nixos_small")'

# Two classic theatre masks: Comedy (left, smiling) and Tragedy (right, frowning).
# set_colors 3 5 → c1=yellow, c2=magenta
JESTER_ART = r'''        "jesterlinux"*)
            set_colors 3 5
            read -rd '' ascii_data <<'EOF'
${c1}   .---------.   .---------.
${c1}  /  ${c2}*     *${c1}  \ /  ${c2}*     *${c1}  \
${c1} |    ${c2}.---.${c1}    |    ${c2}.---.${c1}    |
${c1} |   ${c2}/ \_/ \${c1}   |   ${c2}\ /_/ /${c1}   |
${c1} |    ${c2}\___/${c1}    |    ${c2}/___\${c1}    |
${c1}  \           /  \           /
${c1}   '---------'    '---------'
${c2}    Comedy  ${c1}Jester Linux${c2}  Tragedy
EOF
        ;;

'''

path = sys.argv[1]
text = open(path).read()

assert NIXOS_DETECT in text, "Could not find NixOS detection block — patch target missing"
assert NIXOS_SMALL_CASE in text, "Could not find nixos_small case — patch target missing"

text = text.replace(NIXOS_DETECT, JESTER_DETECT + NIXOS_DETECT, 1)
text = text.replace(NIXOS_SMALL_CASE, JESTER_ART + NIXOS_SMALL_CASE, 1)

open(path, 'w').write(text)
print("patch-neofetch.py: patched successfully")
