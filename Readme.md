# Links

Homepage > https://deun.xyz/

Discord > https://deun.xyz/discord

Store > https://store.deun.xyz

---

# INSTALLATION

1. Drag it in your resource folder
2. add this in your server.cfg ( )
   ensure d-logging

## Configuration

In the top of the log.lua you can find everything you need to configure.

## How to add this to your scripts

Add this to the fxmanifest- / resource.lua

```lua
shared_script {
  '@d-logging/log.lua',
}
```

With this you can acess all the functions

---

# Functions

```lua
Log.trace("trace")
Log.debug("debug")
Log.info("info")
Log.warn("warn")
Log.error("error")
Log.fatal("fatal")

```

Here an Image where you can see how it looks
[logo]: https://cdn.discordapp.com/attachments/968045722551337020/1045438320743821413/Screenshot_2022-11-24_at_21.38.16.png
