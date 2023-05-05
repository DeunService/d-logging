## Links

Homepage > https://deun.xyz/

Discord > https://deun.xyz/discord

Store > https://store.deun.xyz

Docs > https://deun-services.gitbook.io/deun/

## Installation

1. Drag it in your resource folder
2. add this in your server.cfg ( )
   ensure d-logging

### Configuration

In the top of the log.lua you can find everything you need to configure.

### How to add this to your scripts

Add this to the fxmanifest- / resource.lua

```lua
shared_script {
  '@d-logging/log.lua',
}
```

With this you can acess all the functions

## Functions

```lua
Log.trace("trace")
Log.debug("debug")
Log.info("info")
Log.warn("warn")
Log.error("error")
Log.fatal("fatal")
Log.discord("discord")

```

Here an Image where you can see how it looks

![Screenshot 2022-11-24 at 21 38 16](https://user-images.githubusercontent.com/116830002/203861349-98dfc31a-edfa-4f8e-a493-7ce2210afab1.png)

## When to use which level

Thats something you have to decide yourself which level you think is necessary for your purpose, but here is an small guideline which could be helpful.

**Trace** - More detailed information then Debug which are not really necessary to have but still help to follow the flow of your resource e.g. which functions are triggerd.

**Debug** - Log everything you as developer need to see if your script works but is not to detailed

**Info** - Log stuff which is information based like when the script is started, or notifications or stuffe like this

**Warn** - Log stuff that doenst stuff the resource but might be dangerous so we should take a look at it, like slow querys

**Error** - Stuff which causes a function or event to work and is very dangerous.

**Fatal** - If the complete script could crash

**Discord** - You can setup an webhook for this to send logs via the webhook to your discord channel
