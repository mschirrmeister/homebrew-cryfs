# mschirrmeister/cryfs

CryFS patched for **macFUSE** on macOS Big Sur.

## How do I install a formula?

```sh
brew tap mschirrmeister/cryfs
brew install cryfs
```

or

```sh
brew install mschirrmeister/cryfs/<formula>
```

## Notes

macOS Big Sur requires macFUSE `4.0.0+`. You need to install it manually or you install it via a cask from the tap above.

The **cask** name in the tap is called `mschirrmeister-macfuse`. You can intall it via the following command, if the tap above is enabled.

    brew install --cask mschirrmeister-macfuse

## Troubleshooting

First read the [Troubleshooting Checklist](http://docs.brew.sh/Troubleshooting.html).

Use `brew gist-logs FORMULA` to create a [Gist](https://gist.github.com/) and post the link in your issue.

Search the [issues](https://github.com/brewsci/homebrew-bio/issues?q=). See also Homebrew's [Common Issues](https://docs.brew.sh/Common-Issues.html) and [FAQ](https://docs.brew.sh/FAQ.html).

## Documentation

`brew help`, `man brew`, or check [Homebrew's documentation](https://docs.brew.sh).

## Contributing

Please see the [contributing guide](https://github.com/brewsci/homebrew-bio/blob/master/CONTRIBUTING.md).