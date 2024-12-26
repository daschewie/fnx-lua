VPATH = src
DEPDIR := .deps

# Common source files
ASM_SRCS =
C_SRCS = lapi.c \
				 lcode.c \
				 ldblib.c \
				 ldump.c \
				 linit.c \
				 lmathlib.c \
				 lobject.c \
				 lparser.c \
				 lstrlib.c \
				 ltm.c \
				 lutf8lib.c \
				 lauxlib.c \
				 lcorolib.c \
				 ldebug.c \
				 lfunc.c \
				 liolib.c \
				 lmem.c \
				 lopcodes.c \
				 lstate.c \
				 ltable.c \
				 lua.c \
				 lvm.c \
				 lbaselib.c \
				 lctype.c \
				 ldo.c \
				 lgc.c \
				 llex.c \
				 loadlib.c \
				 loslib.c \
				 lstring.c \
				 ltablib.c \
				 lundump.c \
				 lzio.c

# LINK_CFG = a2560u+.scm
LINK_CFG = a2560k.scm
MODEL = --code-model=large --data-model=small
LIB_MODEL = lc-sd
EXE_NAME = lua
CC_FLAGS = -DLUA_COMPAT_5_3 -DLUA_USE_C89

# Object files
OBJS = $(ASM_SRCS:%.s=obj/%.o) $(C_SRCS:%.c=obj/%.o)
OBJS_DEBUG = $(ASM_SRCS:%.s=obj/%-debug.o) $(C_SRCS:%.c=obj/%-debug.o)

obj/%.o: %.s
	as68k --core=68000 $(MODEL) --target=Foenix --debug --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%.o: %.c $(DEPDIR)/%.d | $(DEPDIR)
	@cc68k $(CC_FLAGS) --core=68000 $(MODEL) --target=Foenix --debug --dependencies -MQ$@ >$(DEPDIR)/$*.d $<
	cc68k $(CC_FLAGS) --core=68000 $(MODEL) --target=Foenix --debug --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%-debug.o: %.s
	as68k --core=68000 $(MODEL) --debug --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%-debug.o: %.c $(DEPDIR)/%-debug.d | $(DEPDIR)
	@cc68k $(CC_FLAGS) --target=Foenix -core=68000 $(MODEL) --debug --dependencies -MQ$@ >$(DEPDIR)/$*-debug.d $<
	cc68k $(CC_FLAGS) --target=Foenix --core=68000 $(MODEL) --debug --list-file=$(@:%.o=%.lst) -o $@ $<

$(EXE_NAME).elf: $(OBJS_DEBUG)
	ln68k --debug -o $@ $^ $(LINK_CFG)  --list-file=$(EXE_NAME)-debug.lst --cross-reference  --semi-hosted --target=Foenix --rtattr cstartup=Foenix_user --rtattr stubs=foenix --stack-size=2000 --sstack-size=800

$(EXE_NAME).pgz:  $(OBJS)
	ln68k -o $@ $^ $(LINK_CFG) --output-format=pgz --list-file=$(EXE_NAME)-Foenix.lst --cross-reference --rtattr cstartup=Foenix_user

$(EXE_NAME).hex:  $(OBJS)
	ln68k -o $@ $^ $(LINK_CFG) --output-format=intel-hex --list-file=$(EXE_NAME)-Foenix.lst --cross-reference --rtattr cstartup=Foenix_morfe --stack-size=2000

clean:
	-rm $(DEPFILES)
	-rm $(OBJS) $(OBJS:%.o=%.lst) $(OBJS_DEBUG) $(OBJS_DEBUG:%.o=%.lst)
	-rm $(EXE_NAME).elf $(EXE_NAME).pgz $(EXE_NAME)-debug.lst $(EXE_NAME)-Foenix.lst

$(DEPDIR): ; @mkdir -p $@

DEPFILES := $(C_SRCS:%.c=$(DEPDIR)/%.d) $(C_SRCS:%.c=$(DEPDIR)/%-debug.d)
$(DEPFILES):

include $(wildcard $(DEPFILES))
