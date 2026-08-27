# Credits

These blocklet scripts are vendored from [icemodding/i3](https://github.com/icemodding/i3/tree/master/scripts).

## Status

Not wired up. `i3blocks/config` sets a single global `command=/usr/share/i3blocks/$BLOCK_NAME`, which resolves to the blocklets shipped by the distro package — nothing in this directory is referenced by it. The i3 bar itself runs `i3status`, so `i3blocks/config` is not active either. Both are kept for the Kali-era rice in the screenshots.

If you want to use these instead, point the blocks at this directory:

```ini
command=$HOME/.config/i3blocks/scripts/$BLOCK_NAME.sh
```

`weather.sh` reads its OpenWeatherMap key from `$OPENWEATHER_API_KEY`; `gmail.sh` needs credentials filled in before it will do anything.
