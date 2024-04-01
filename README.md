# xcb

A super simple yet versatile command line clipboard utility, created as a wrapper around 'xclip' for KDE Plasma, enabling a seamless cross-environment copying experience while avoiding conflicts with KDE Plasma's Klipper.

## Installation

You can install xcb by cloning the repository and copying the script to your local bin folders. Alternatively, you can use the provided installation script via curl or wget:

```bash
curl -sL https://raw.github.com/felipechierice/xcb/main/install.sh | sh
# OR
wget -qO- https://raw.github.com/felipechierice/xcb/main/install.sh | sh

```

Optionally, you can specify a custom install directory (which defaults to
`~/.local/bin`):

```bash
curl -sL https://raw.github.com/felipechierice/xcb/main/install.sh | sh /path/to/install/directory/
```

## Usage

```bash
xcb [-d|-v|--version |--help] [content]
```

- `-d, --debug`: This flag enables debug mode. If present, xcb will print out more detailed information about its operation.
- `-v, --version`: Print out the current version of xcb.
- `--help`: Display xcb command help.
- `content` is an optional argument. If provided, this content will be copied to the clipboard. If not, the tool will try to read the content from stdin.

## Examples

Copy content from a command:

```bash
ls -l | xcb
```

Copy content provided as an argument:

```bash
xcb "Sample text to be copied"
```

