LUA for Foenix A2560x computers
=====================================

## Dependencies
* Calypsi cc68k compiler
* Make Build tool

## Build Instructions
* Modify Makefile and change LINK_CFG variable to a2560u+.scm or a2560k.scm to match your platform.
* Valid make targets are `lua.pgz`, `lua.hex`, and `lua.elf`
* To build executible type `make lua.pgz`

