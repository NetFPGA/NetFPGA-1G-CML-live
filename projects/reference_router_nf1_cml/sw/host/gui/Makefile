####################################################
# Makefile to compile java source code for the GUI
#
# Author: Jad Naous
#


# Directories
SRC := src
BIN := bin
LIB := lib

COMMON_C := ../common
REG_C := ../../../projects/router_buffer_sizing/lib/C

NF10LIB_NAME := libnf10.so

JAVAC := javac
JAVA := java
JAR := jar

JAVA_SRC_FILES := $(wildcard $(SRC)/org/netfpga/backend/*.java)
JAVA_SRC_FILES += $(wildcard $(SRC)/org/netfpga/graphics/*.java)
JAVA_SRC_FILES += $(wildcard $(SRC)/org/netfpga/mdi/*.java)
JAVA_SRC_FILES += $(wildcard $(SRC)/org/netfpga/router/*.java)

CONSTANTS_JAVA := $(SRC)/org/netfpga/backend/NFDeviceConsts.java

NF10LIB := $(LIB)/$(NF10LIB_NAME)

# utils
EMPTY =
SPACE = $(EMPTY) $(EMPTY)

# setup the classpath
CLASSPATH := $(subst $(SPACE),:,$(wildcard $(LIB)/*.jar))

# compiler options
JAVAC_OPTIONS := -d $(BIN) -classpath $(CLASSPATH) -sourcepath $(SRC)

# The following three variables should be reassinged if reg_defines.h
# uses a different name (e.g. XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_1)

# Router output lookup IP name
IP_NAME := XPAR_NF10_ROUTER_OUTPUT_PORT_LOOKUP_0

# Router output lookup IP name BAR0
BAR0_NAME := $(IP_NAME)_BAR0

# Router output lookup IP name BAR1
BAR1_NAME := $(IP_NAME)_BAR1

# rules
all: $(NF10LIB) $(CONSTANTS_JAVA) router.sh 

$(NF10LIB): $(COMMON_C)/$(NF10LIB_NAME)
	@cp $< $@

$(COMMON_C)/$(NF10LIB_NAME):
	@$(MAKE) -C $(dir $@) $(notdir $@)

java: $(CONSTANTS_JAVA) $(JAVA_SRC_FILES)
	@echo Building java...
	@echo $(wildcard $(JARS)/*.jar)
	@$(JAVAC) $(JAVAC_OPTIONS) $(JAVA_SRC_FILES)
	@echo Done

# use reg_defines.h generated during "make regs" from hw/ directory instead of manually created
# one
#
# Also, reassign the constants generated from reg_defines.h to those expected by the code (ROUTER_OP_LUT...)
# so we don't have to modify all the Java sources
#
# TODO: Update the source files so they use the parameter names in reg_defines.h generated from
# "make regs" instead of from the manually created reg_defines.h that was present in the original
# reference_router project.
#
$(CONSTANTS_JAVA): ../reg_defines.h
	@echo "/**********************************************************************" > $@
	@echo " * File generated using the Makefile from $<." >> $@
	@echo " * Author: Jad Naous" >> $@
	@echo " */" >> $@
	@echo "" >> $@
	@echo "package $(patsubst %.,%;,$(subst /,.,$(subst $(SRC)/,$(EMPTY),$(dir $@))))" >> $@
	@echo "" >> $@
	@echo "public class $(notdir $(basename $@)) {" >> $@
	@awk '{if ((NF == 3) && ($$1 == "#define") && (length($$3) < 11) && (substr($$3,0,1) ~ /[0-9]/)) {printf "   public static final int %-50s = %s;\n", $$2, $$3}}' $< >> $@
	@echo "   public static final int ROUTER_OP_LUT_ROUTE_TABLE_DEPTH = $(IP_NAME)_ROUTE_TABLE_DEPTH;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_ARP_TABLE_DEPTH = $(IP_NAME)_ARP_TABLE_DEPTH;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_DST_IP_FILTER_TABLE_DEPTH = $(IP_NAME)_DST_IP_FILTER_TABLE_DEPTH;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_RESET_CNTRS = $(BAR0_NAME)_RESET_CNTRS;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_ARP_NUM_MISSES_REG = $(BAR0_NAME)_PKT_SENT_CPU_ARP_MISS;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_LPM_NUM_MISSES_REG = $(BAR0_NAME)_PKT_SENT_CPU_LPM_MISS;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_NUM_CPU_PKTS_SENT_REG = $(BAR0_NAME)_PKT_SENT_FROM_CPU;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_NUM_BAD_OPTS_VER_REG = $(BAR0_NAME)_PKT_SENT_CPU_OPTION_VER;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_NUM_BAD_CHKSUMS_REG = $(BAR0_NAME)_PKT_DROPPED_CHECKSUM;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_NUM_BAD_TTLS_REG = $(BAR0_NAME)_PKT_SENT_TO_CPU_BAD_TTL;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_NUM_NON_IP_RCVD_REG = $(BAR0_NAME)_PKT_SENT_CPU_NON_IP;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_NUM_PKTS_FORWARDED_REG = $(BAR0_NAME)_PKT_FORWARDED;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_NUM_WRONG_DEST_REG = $(BAR0_NAME)_PKT_DROPPED_WRONG_DST_MAC;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_NUM_FILTERED_PKTS_REG = $(BAR0_NAME)_PKT_SENT_CPU_DEST_IP_HIT;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_MAC_0_HI_REG = $(BAR0_NAME)_MAC_0_HIGH;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_MAC_0_LO_REG = $(BAR0_NAME)_MAC_0_LOW;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_MAC_1_HI_REG = $(BAR0_NAME)_MAC_1_HIGH;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_MAC_1_LO_REG = $(BAR0_NAME)_MAC_1_LOW;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_MAC_2_HI_REG = $(BAR0_NAME)_MAC_2_HIGH;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_MAC_2_LO_REG = $(BAR0_NAME)_MAC_2_LOW;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_MAC_3_HI_REG = $(BAR0_NAME)_MAC_3_HIGH;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_MAC_3_LO_REG = $(BAR0_NAME)_MAC_3_LOW;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_ARP_TABLE_ENTRY_MAC_HI_REG = $(BAR1_NAME)_ARP_MAC_HIGH;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_ARP_TABLE_ENTRY_MAC_LO_REG = $(BAR1_NAME)_ARP_MAC_LOW;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_ARP_TABLE_ENTRY_NEXT_HOP_IP_REG = $(BAR1_NAME)_ARP_IP;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_ARP_TABLE_RD_ADDR_REG = $(BAR1_NAME)_ARP_RD_ADDR;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_ARP_TABLE_WR_ADDR_REG = $(BAR1_NAME)_ARP_WR_ADDR;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_ROUTE_TABLE_ENTRY_IP_REG = $(BAR1_NAME)_LPM_IP;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_ROUTE_TABLE_ENTRY_MASK_REG = $(BAR1_NAME)_LPM_IP_MASK;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_ROUTE_TABLE_ENTRY_NEXT_HOP_IP_REG = $(BAR1_NAME)_LPM_NEXT_HOP_IP;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_ROUTE_TABLE_ENTRY_OUTPUT_PORT_REG = $(BAR1_NAME)_LPM_OQ;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_ROUTE_TABLE_RD_ADDR_REG = $(BAR1_NAME)_LPM_RD_ADDR;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_ROUTE_TABLE_WR_ADDR_REG = $(BAR1_NAME)_LPM_WR_ADDR;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_DST_IP_FILTER_TABLE_ENTRY_IP_REG = $(BAR1_NAME)_FILTER_IP;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_DST_IP_FILTER_TABLE_RD_ADDR_REG = $(BAR1_NAME)_FILTER_RD_ADDR;" >> $@
	@echo "   public static final int ROUTER_OP_LUT_DST_IP_FILTER_TABLE_WR_ADDR_REG = $(BAR1_NAME)_FILTER_WR_ADDR;" >> $@
	@echo "}" >> $@
	@echo "" >> $@

$(BIN)/router-manifest.mf:
	@echo "Writing router gui manifest..."
	@echo "Main-Class: org.netfpga.router.RouterMainFrame" > $@
	@echo "Class-Path: $(wildcard $(LIB)/*.jar)" >> $@
	@echo >> $@

router_gui.jar: $(NF10LIB) java $(BIN)/router-manifest.mf
	@echo "Building router jar..."
	@cd $(BIN); $(JAR) cfm ../$@ router-manifest.mf org
	@rm -f $(BIN)/router-manifest.mf

router.sh: router_gui.jar
	@echo "Writing script to start router gui..."
	@echo "$(JAVA) -Djava.library.path=$(LIB) -Djna.library.path=$(LIB) -jar router_gui.jar --no_download" > $@
	@echo >> $@
	@chmod +x $@

#$(BIN)/eventcap-manifest.mf:
#	@echo "Writing event capturing router gui manifest..."
#	@echo "Main-Class: org.netfpga.eventcap.EventCaptureMainFrame" > $@
#	@echo "Class-Path: $(wildcard $(LIB)/*.jar)" >> $@
#	@echo >> $@
#
#eventcap_gui.jar: $(NF10LIB) java $(BIN)/eventcap-manifest.mf
#	@echo "Building event capturing router jar..."
#	@cd $(BIN); $(JAR) cfm ../$@ eventcap-manifest.mf org
#	@rm -f $(BIN)/eventcap-manifest.mf
#
#eventcap.sh: eventcap_gui.jar
#	@echo "Writing script to start event capturing router gui..."
#	@echo "$(JAVA) -Djava.library.path=$(LIB) -Djna.library.path=$(LIB) -jar eventcap_gui.jar --no_download" > $@
#	@echo >> $@
#	@chmod +x $@

install:

clean:
	rm -rf $(COMMON_C)/$(NF10LIB_NAME)
	rm -rf $(BIN)/* router_gui.jar router.sh eventcap.sh eventcap_gui.jar
	rm -rf $(CONSTANTS_JAVA)
	rm -rf $(NF10LIB)
