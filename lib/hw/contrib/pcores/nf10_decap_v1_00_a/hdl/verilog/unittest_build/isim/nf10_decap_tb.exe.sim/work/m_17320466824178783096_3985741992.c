/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x8ddf5b5d */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/gengyl08/workSpace/NetFPGA-10G-live/lib/hw/std/pcores/nf10_decap_v1_00_a/hdl/verilog/nf10_decap.v";
static int ng1[] = {0, 0};
static int ng2[] = {2, 0};
static int ng3[] = {1, 0};
static int ng4[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng5[] = {0, 0, 0, 0, 0, 0, 0, 0};
static int ng6[] = {767, 0};
static int ng7[] = {512, 0};
static int ng8[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng9[] = {511, 0};
static int ng10[] = {95, 0};
static int ng11[] = {64, 0};
static int ng12[] = {0, 0, 0, 0};
static int ng13[] = {63, 0};
static int ng14[] = {34, 0};
static int ng15[] = {15, 0};
static int ng16[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng17[] = {0, 0, 0, 0, 0, 0};



static int sp_log2(char *t1, char *t2)
{
    char t7[8];
    char t11[8];
    char t22[8];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t8;
    char *t9;
    char *t10;
    char *t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t23;

LAB0:    t0 = 1;
    xsi_set_current_line(101, ng0);

LAB2:    xsi_set_current_line(102, ng0);
    t3 = ((char*)((ng1)));
    t4 = (t1 + 13016);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 32);
    xsi_set_current_line(103, ng0);

LAB3:    t3 = ((char*)((ng2)));
    t4 = (t1 + 13016);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memset(t7, 0, 8);
    xsi_vlog_signed_power(t7, 32, t3, 32, t6, 32, 1);
    t8 = (t1 + 13176);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memset(t11, 0, 8);
    xsi_vlog_signed_less(t11, 32, t7, 32, t10, 32);
    t12 = (t11 + 4);
    t13 = *((unsigned int *)t12);
    t14 = (~(t13));
    t15 = *((unsigned int *)t11);
    t16 = (t15 & t14);
    t17 = (t16 != 0);
    if (t17 > 0)
        goto LAB4;

LAB5:    t0 = 0;

LAB1:    return t0;
LAB4:    xsi_set_current_line(103, ng0);

LAB6:    xsi_set_current_line(104, ng0);
    t18 = (t1 + 13016);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    t21 = ((char*)((ng3)));
    memset(t22, 0, 8);
    xsi_vlog_signed_add(t22, 32, t20, 32, t21, 32);
    t23 = (t1 + 13016);
    xsi_vlogvar_assign_value(t23, t22, 0, 0, 32);
    goto LAB3;

}

static void Cont_199_0(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    unsigned int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    unsigned int t16;
    unsigned int t17;
    char *t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    unsigned int t22;
    unsigned int t23;
    char *t24;

LAB0:    t1 = (t0 + 14088U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(199, ng0);
    t2 = (t0 + 9256U);
    t4 = *((char **)t2);
    memset(t3, 0, 8);
    t2 = (t4 + 4);
    t5 = *((unsigned int *)t2);
    t6 = (~(t5));
    t7 = *((unsigned int *)t4);
    t8 = (t7 & t6);
    t9 = (t8 & 1U);
    if (t9 != 0)
        goto LAB7;

LAB5:    if (*((unsigned int *)t2) == 0)
        goto LAB4;

LAB6:    t10 = (t3 + 4);
    *((unsigned int *)t3) = 1;
    *((unsigned int *)t10) = 1;

LAB7:    t11 = (t0 + 15808);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    memset(t15, 0, 8);
    t16 = 1U;
    t17 = t16;
    t18 = (t3 + 4);
    t19 = *((unsigned int *)t3);
    t16 = (t16 & t19);
    t20 = *((unsigned int *)t18);
    t17 = (t17 & t20);
    t21 = (t15 + 4);
    t22 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t22 | t16);
    t23 = *((unsigned int *)t21);
    *((unsigned int *)t21) = (t23 | t17);
    xsi_driver_vfirst_trans(t11, 0, 0);
    t24 = (t0 + 15648);
    *((int *)t24) = 1;

LAB1:    return;
LAB4:    *((unsigned int *)t3) = 1;
    goto LAB7;

}

static void Always_201_1(char *t0)
{
    char t8[8];
    char t41[8];
    char t42[8];
    char t53[128];
    char t54[16];
    char t60[8];
    char t83[8];
    char t84[64];
    char t95[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    int t7;
    char *t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    char *t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    char *t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    char *t32;
    char *t33;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    char *t39;
    char *t40;
    int t43;
    int t44;
    int t45;
    int t46;
    int t47;
    int t48;
    int t49;
    char *t50;
    char *t51;
    int t52;
    char *t55;
    char *t56;
    char *t57;
    char *t58;
    char *t59;
    char *t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    unsigned int t66;
    unsigned int t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    unsigned int t73;
    char *t74;
    char *t75;
    unsigned int t76;
    unsigned int t77;
    unsigned int t78;
    unsigned int t79;
    unsigned int t80;
    char *t81;
    char *t82;
    unsigned int t85;
    unsigned int t86;
    unsigned int t87;
    unsigned int t88;
    unsigned int t89;
    unsigned int t90;
    unsigned int t91;
    unsigned int t92;
    unsigned int t93;
    unsigned int t94;
    unsigned int t96;
    unsigned int t97;
    unsigned int t98;
    unsigned int t99;
    unsigned int t100;
    unsigned int t101;
    unsigned int t102;
    unsigned int t103;
    unsigned int t104;
    unsigned int t105;
    char *t106;
    char *t107;
    unsigned int t108;
    unsigned int t109;
    unsigned int t110;
    unsigned int t111;
    unsigned int t112;
    unsigned int t113;
    unsigned int t114;
    unsigned int t115;
    unsigned int t116;
    unsigned int t117;
    unsigned int t118;
    unsigned int t119;
    unsigned int t120;
    unsigned int t121;
    char *t122;
    unsigned int t123;
    unsigned int t124;
    unsigned int t125;
    unsigned int t126;
    unsigned int t127;
    char *t128;
    char *t129;

LAB0:    t1 = (t0 + 14336U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(201, ng0);
    t2 = (t0 + 15664);
    *((int *)t2) = 1;
    t3 = (t0 + 14368);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(201, ng0);

LAB5:    xsi_set_current_line(202, ng0);
    t4 = ((char*)((ng1)));
    t5 = (t0 + 12536);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(204, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 10136);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 256);
    xsi_set_current_line(205, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 10296);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(206, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 10456);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 128);
    xsi_set_current_line(207, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 10616);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(208, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 10776);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(210, ng0);
    t2 = (t0 + 10936);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 11256);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 768);
    xsi_set_current_line(211, ng0);
    t2 = (t0 + 11096);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 11416);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 96);
    xsi_set_current_line(212, ng0);
    t2 = (t0 + 11576);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 11736);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 128);
    xsi_set_current_line(213, ng0);
    t2 = (t0 + 11896);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 12056);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(214, ng0);
    t2 = (t0 + 12216);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 12376);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(216, ng0);
    t2 = (t0 + 12696);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 12856);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 3);
    xsi_set_current_line(218, ng0);
    t2 = (t0 + 12696);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);

LAB6:    t5 = (t0 + 1696);
    t6 = *((char **)t5);
    t7 = xsi_vlog_unsigned_case_compare(t4, 3, t6, 32);
    if (t7 == 1)
        goto LAB7;

LAB8:    t2 = (t0 + 1832);
    t3 = *((char **)t2);
    t7 = xsi_vlog_unsigned_case_compare(t4, 3, t3, 32);
    if (t7 == 1)
        goto LAB9;

LAB10:    t2 = (t0 + 1968);
    t3 = *((char **)t2);
    t7 = xsi_vlog_unsigned_case_compare(t4, 3, t3, 32);
    if (t7 == 1)
        goto LAB11;

LAB12:    t2 = (t0 + 2104);
    t3 = *((char **)t2);
    t7 = xsi_vlog_unsigned_case_compare(t4, 3, t3, 32);
    if (t7 == 1)
        goto LAB13;

LAB14:    t2 = (t0 + 2240);
    t3 = *((char **)t2);
    t7 = xsi_vlog_unsigned_case_compare(t4, 3, t3, 32);
    if (t7 == 1)
        goto LAB15;

LAB16:
LAB17:    goto LAB2;

LAB7:    xsi_set_current_line(219, ng0);

LAB18:    xsi_set_current_line(220, ng0);
    t5 = (t0 + 8456U);
    t9 = *((char **)t5);
    memset(t8, 0, 8);
    t5 = (t9 + 4);
    t10 = *((unsigned int *)t5);
    t11 = (~(t10));
    t12 = *((unsigned int *)t9);
    t13 = (t12 & t11);
    t14 = (t13 & 1U);
    if (t14 != 0)
        goto LAB22;

LAB20:    if (*((unsigned int *)t5) == 0)
        goto LAB19;

LAB21:    t15 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t15) = 1;

LAB22:    t16 = (t8 + 4);
    t17 = (t9 + 4);
    t18 = *((unsigned int *)t9);
    t19 = (~(t18));
    *((unsigned int *)t8) = t19;
    *((unsigned int *)t16) = 0;
    if (*((unsigned int *)t17) != 0)
        goto LAB24;

LAB23:    t24 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t24 & 1U);
    t25 = *((unsigned int *)t16);
    *((unsigned int *)t16) = (t25 & 1U);
    t26 = (t8 + 4);
    t27 = *((unsigned int *)t26);
    t28 = (~(t27));
    t29 = *((unsigned int *)t8);
    t30 = (t29 & t28);
    t31 = (t30 != 0);
    if (t31 > 0)
        goto LAB25;

LAB26:
LAB27:    goto LAB17;

LAB9:    xsi_set_current_line(237, ng0);

LAB42:    xsi_set_current_line(238, ng0);
    t2 = (t0 + 12216);
    t5 = (t2 + 56U);
    t6 = *((char **)t5);
    t9 = (t6 + 4);
    t10 = *((unsigned int *)t9);
    t11 = (~(t10));
    t12 = *((unsigned int *)t6);
    t13 = (t12 & t11);
    t14 = (t13 != 0);
    if (t14 > 0)
        goto LAB43;

LAB44:    xsi_set_current_line(244, ng0);

LAB55:    xsi_set_current_line(245, ng0);
    t2 = (t0 + 8456U);
    t3 = *((char **)t2);
    memset(t8, 0, 8);
    t2 = (t3 + 4);
    t10 = *((unsigned int *)t2);
    t11 = (~(t10));
    t12 = *((unsigned int *)t3);
    t13 = (t12 & t11);
    t14 = (t13 & 1U);
    if (t14 != 0)
        goto LAB59;

LAB57:    if (*((unsigned int *)t2) == 0)
        goto LAB56;

LAB58:    t5 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t5) = 1;

LAB59:    t6 = (t8 + 4);
    t18 = *((unsigned int *)t6);
    t19 = (~(t18));
    t20 = *((unsigned int *)t8);
    t21 = (t20 & t19);
    t22 = (t21 != 0);
    if (t22 > 0)
        goto LAB60;

LAB61:
LAB62:
LAB45:    xsi_set_current_line(256, ng0);
    t2 = (t0 + 11416);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 11416);
    t9 = (t6 + 72U);
    t15 = *((char **)t9);
    t16 = ((char*)((ng1)));
    xsi_vlog_generic_get_index_select_value(t8, 32, t5, t15, 2, t16, 32, 1);
    t17 = ((char*)((ng3)));
    memset(t41, 0, 8);
    t26 = (t8 + 4);
    t32 = (t17 + 4);
    t10 = *((unsigned int *)t8);
    t11 = *((unsigned int *)t17);
    t12 = (t10 ^ t11);
    t13 = *((unsigned int *)t26);
    t14 = *((unsigned int *)t32);
    t18 = (t13 ^ t14);
    t19 = (t12 | t18);
    t20 = *((unsigned int *)t26);
    t21 = *((unsigned int *)t32);
    t22 = (t20 | t21);
    t23 = (~(t22));
    t24 = (t19 & t23);
    if (t24 != 0)
        goto LAB79;

LAB76:    if (t22 != 0)
        goto LAB78;

LAB77:    *((unsigned int *)t41) = 1;

LAB79:    t39 = (t41 + 4);
    t25 = *((unsigned int *)t39);
    t27 = (~(t25));
    t28 = *((unsigned int *)t41);
    t29 = (t28 & t27);
    t30 = (t29 != 0);
    if (t30 > 0)
        goto LAB80;

LAB81:
LAB82:    goto LAB17;

LAB11:    xsi_set_current_line(273, ng0);

LAB106:    xsi_set_current_line(274, ng0);
    t2 = (t0 + 8456U);
    t5 = *((char **)t2);
    memset(t8, 0, 8);
    t2 = (t5 + 4);
    t10 = *((unsigned int *)t2);
    t11 = (~(t10));
    t12 = *((unsigned int *)t5);
    t13 = (t12 & t11);
    t14 = (t13 & 1U);
    if (t14 != 0)
        goto LAB110;

LAB108:    if (*((unsigned int *)t2) == 0)
        goto LAB107;

LAB109:    t6 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t6) = 1;

LAB110:    t9 = (t0 + 10616);
    xsi_vlogvar_assign_value(t9, t8, 0, 0, 1);
    xsi_set_current_line(275, ng0);
    t2 = (t0 + 11896);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = ((char*)((ng3)));
    memset(t8, 0, 8);
    t9 = (t5 + 4);
    t15 = (t6 + 4);
    t10 = *((unsigned int *)t5);
    t11 = *((unsigned int *)t6);
    t12 = (t10 ^ t11);
    t13 = *((unsigned int *)t9);
    t14 = *((unsigned int *)t15);
    t18 = (t13 ^ t14);
    t19 = (t12 | t18);
    t20 = *((unsigned int *)t9);
    t21 = *((unsigned int *)t15);
    t22 = (t20 | t21);
    t23 = (~(t22));
    t24 = (t19 & t23);
    if (t24 != 0)
        goto LAB114;

LAB111:    if (t22 != 0)
        goto LAB113;

LAB112:    *((unsigned int *)t8) = 1;

LAB114:    t17 = (t8 + 4);
    t25 = *((unsigned int *)t17);
    t27 = (~(t25));
    t28 = *((unsigned int *)t8);
    t29 = (t28 & t27);
    t30 = (t29 != 0);
    if (t30 > 0)
        goto LAB115;

LAB116:    xsi_set_current_line(280, ng0);

LAB119:    xsi_set_current_line(281, ng0);
    t2 = (t0 + 10936);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    xsi_vlog_get_part_select_value(t84, 256, t5, 255, 0);
    t6 = (t0 + 10136);
    xsi_vlogvar_assign_value(t6, t84, 0, 0, 256);
    xsi_set_current_line(282, ng0);
    t2 = (t0 + 11096);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t8, 0, 8);
    t6 = (t8 + 4);
    t9 = (t5 + 4);
    t10 = *((unsigned int *)t5);
    t11 = (t10 >> 0);
    *((unsigned int *)t8) = t11;
    t12 = *((unsigned int *)t9);
    t13 = (t12 >> 0);
    *((unsigned int *)t6) = t13;
    t14 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t14 & 4294967295U);
    t18 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t18 & 4294967295U);
    t15 = (t0 + 10296);
    xsi_vlogvar_assign_value(t15, t8, 0, 0, 32);
    xsi_set_current_line(283, ng0);
    t2 = (t0 + 11576);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 10456);
    xsi_vlogvar_assign_value(t6, t5, 0, 0, 128);

LAB117:    xsi_set_current_line(286, ng0);
    t2 = (t0 + 10616);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t8, 0, 8);
    t6 = (t5 + 4);
    t10 = *((unsigned int *)t6);
    t11 = (~(t10));
    t12 = *((unsigned int *)t5);
    t13 = (t12 & t11);
    t14 = (t13 & 1U);
    if (t14 != 0)
        goto LAB120;

LAB121:    if (*((unsigned int *)t6) != 0)
        goto LAB122;

LAB123:    t15 = (t8 + 4);
    t18 = *((unsigned int *)t8);
    t19 = *((unsigned int *)t15);
    t20 = (t18 || t19);
    if (t20 > 0)
        goto LAB124;

LAB125:    memcpy(t42, t8, 8);

LAB126:    t51 = (t42 + 4);
    t78 = *((unsigned int *)t51);
    t79 = (~(t78));
    t80 = *((unsigned int *)t42);
    t85 = (t80 & t79);
    t86 = (t85 != 0);
    if (t86 > 0)
        goto LAB134;

LAB135:
LAB136:    goto LAB17;

LAB13:    xsi_set_current_line(299, ng0);

LAB150:    xsi_set_current_line(300, ng0);
    t2 = ((char*)((ng3)));
    t5 = (t0 + 10616);
    xsi_vlogvar_assign_value(t5, t2, 0, 0, 1);
    xsi_set_current_line(301, ng0);
    t2 = (t0 + 11896);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = ((char*)((ng3)));
    memset(t8, 0, 8);
    t9 = (t5 + 4);
    t15 = (t6 + 4);
    t10 = *((unsigned int *)t5);
    t11 = *((unsigned int *)t6);
    t12 = (t10 ^ t11);
    t13 = *((unsigned int *)t9);
    t14 = *((unsigned int *)t15);
    t18 = (t13 ^ t14);
    t19 = (t12 | t18);
    t20 = *((unsigned int *)t9);
    t21 = *((unsigned int *)t15);
    t22 = (t20 | t21);
    t23 = (~(t22));
    t24 = (t19 & t23);
    if (t24 != 0)
        goto LAB154;

LAB151:    if (t22 != 0)
        goto LAB153;

LAB152:    *((unsigned int *)t8) = 1;

LAB154:    t17 = (t8 + 4);
    t25 = *((unsigned int *)t17);
    t27 = (~(t25));
    t28 = *((unsigned int *)t8);
    t29 = (t28 & t27);
    t30 = (t29 != 0);
    if (t30 > 0)
        goto LAB155;

LAB156:    xsi_set_current_line(306, ng0);

LAB159:    xsi_set_current_line(307, ng0);
    t2 = (t0 + 10936);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    xsi_vlog_get_part_select_value(t84, 256, t5, 255, 0);
    t6 = (t0 + 10136);
    xsi_vlogvar_assign_value(t6, t84, 0, 0, 256);
    xsi_set_current_line(308, ng0);
    t2 = (t0 + 11096);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t8, 0, 8);
    t6 = (t8 + 4);
    t9 = (t5 + 4);
    t10 = *((unsigned int *)t5);
    t11 = (t10 >> 0);
    *((unsigned int *)t8) = t11;
    t12 = *((unsigned int *)t9);
    t13 = (t12 >> 0);
    *((unsigned int *)t6) = t13;
    t14 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t14 & 4294967295U);
    t18 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t18 & 4294967295U);
    t15 = (t0 + 10296);
    xsi_vlogvar_assign_value(t15, t8, 0, 0, 32);
    xsi_set_current_line(309, ng0);
    t2 = (t0 + 11576);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 10456);
    xsi_vlogvar_assign_value(t6, t5, 0, 0, 128);

LAB157:    xsi_set_current_line(312, ng0);
    t2 = (t0 + 3976U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t10 = *((unsigned int *)t2);
    t11 = (~(t10));
    t12 = *((unsigned int *)t3);
    t13 = (t12 & t11);
    t14 = (t13 != 0);
    if (t14 > 0)
        goto LAB160;

LAB161:
LAB162:    goto LAB17;

LAB15:    xsi_set_current_line(336, ng0);

LAB201:    xsi_set_current_line(337, ng0);
    t2 = (t0 + 8456U);
    t5 = *((char **)t2);
    memset(t8, 0, 8);
    t2 = (t5 + 4);
    t10 = *((unsigned int *)t2);
    t11 = (~(t10));
    t12 = *((unsigned int *)t5);
    t13 = (t12 & t11);
    t14 = (t13 & 1U);
    if (t14 != 0)
        goto LAB205;

LAB203:    if (*((unsigned int *)t2) == 0)
        goto LAB202;

LAB204:    t6 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t6) = 1;

LAB205:    t9 = (t0 + 10616);
    xsi_vlogvar_assign_value(t9, t8, 0, 0, 1);
    xsi_set_current_line(338, ng0);
    t2 = (t0 + 8616U);
    t3 = *((char **)t2);
    t2 = (t0 + 10136);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 256);
    xsi_set_current_line(339, ng0);
    t2 = (t0 + 8936U);
    t3 = *((char **)t2);
    t2 = (t0 + 10456);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 128);
    xsi_set_current_line(340, ng0);
    t2 = (t0 + 8776U);
    t3 = *((char **)t2);
    t2 = (t0 + 10296);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(341, ng0);
    t2 = (t0 + 9096U);
    t3 = *((char **)t2);
    t2 = (t0 + 10776);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(342, ng0);
    t2 = (t0 + 10616);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t8, 0, 8);
    t6 = (t5 + 4);
    t10 = *((unsigned int *)t6);
    t11 = (~(t10));
    t12 = *((unsigned int *)t5);
    t13 = (t12 & t11);
    t14 = (t13 & 1U);
    if (t14 != 0)
        goto LAB206;

LAB207:    if (*((unsigned int *)t6) != 0)
        goto LAB208;

LAB209:    t15 = (t8 + 4);
    t18 = *((unsigned int *)t8);
    t19 = *((unsigned int *)t15);
    t20 = (t18 || t19);
    if (t20 > 0)
        goto LAB210;

LAB211:    memcpy(t42, t8, 8);

LAB212:    t51 = (t0 + 12536);
    xsi_vlogvar_assign_value(t51, t42, 0, 0, 1);
    xsi_set_current_line(343, ng0);
    t2 = (t0 + 10616);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t8, 0, 8);
    t6 = (t5 + 4);
    t10 = *((unsigned int *)t6);
    t11 = (~(t10));
    t12 = *((unsigned int *)t5);
    t13 = (t12 & t11);
    t14 = (t13 & 1U);
    if (t14 != 0)
        goto LAB220;

LAB221:    if (*((unsigned int *)t6) != 0)
        goto LAB222;

LAB223:    t15 = (t8 + 4);
    t18 = *((unsigned int *)t8);
    t19 = *((unsigned int *)t15);
    t20 = (t18 || t19);
    if (t20 > 0)
        goto LAB224;

LAB225:    memcpy(t42, t8, 8);

LAB226:    memset(t60, 0, 8);
    t56 = (t42 + 4);
    t78 = *((unsigned int *)t56);
    t79 = (~(t78));
    t80 = *((unsigned int *)t42);
    t85 = (t80 & t79);
    t86 = (t85 & 1U);
    if (t86 != 0)
        goto LAB234;

LAB235:    if (*((unsigned int *)t56) != 0)
        goto LAB236;

LAB237:    t58 = (t60 + 4);
    t87 = *((unsigned int *)t60);
    t88 = *((unsigned int *)t58);
    t89 = (t87 || t88);
    if (t89 > 0)
        goto LAB238;

LAB239:    memcpy(t95, t60, 8);

LAB240:    t122 = (t95 + 4);
    t123 = *((unsigned int *)t122);
    t124 = (~(t123));
    t125 = *((unsigned int *)t95);
    t126 = (t125 & t124);
    t127 = (t126 != 0);
    if (t127 > 0)
        goto LAB248;

LAB249:
LAB250:    goto LAB17;

LAB19:    *((unsigned int *)t8) = 1;
    goto LAB22;

LAB24:    t20 = *((unsigned int *)t8);
    t21 = *((unsigned int *)t17);
    *((unsigned int *)t8) = (t20 | t21);
    t22 = *((unsigned int *)t16);
    t23 = *((unsigned int *)t17);
    *((unsigned int *)t16) = (t22 | t23);
    goto LAB23;

LAB25:    xsi_set_current_line(220, ng0);

LAB28:    xsi_set_current_line(221, ng0);
    t32 = (t0 + 8136U);
    t33 = *((char **)t32);
    t32 = (t33 + 4);
    t34 = *((unsigned int *)t32);
    t35 = (~(t34));
    t36 = *((unsigned int *)t33);
    t37 = (t36 & t35);
    t38 = (t37 != 0);
    if (t38 > 0)
        goto LAB29;

LAB30:    xsi_set_current_line(231, ng0);

LAB41:    xsi_set_current_line(232, ng0);
    t2 = (t0 + 2240);
    t3 = *((char **)t2);
    t2 = (t0 + 12856);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 3);

LAB31:    goto LAB27;

LAB29:    xsi_set_current_line(221, ng0);

LAB32:    xsi_set_current_line(222, ng0);
    t39 = ((char*)((ng3)));
    t40 = (t0 + 12536);
    xsi_vlogvar_assign_value(t40, t39, 0, 0, 1);
    xsi_set_current_line(223, ng0);
    t2 = (t0 + 8616U);
    t3 = *((char **)t2);
    t2 = (t0 + 11256);
    t5 = (t0 + 11256);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng6)));
    t16 = ((char*)((ng7)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t41 + 4);
    t11 = *((unsigned int *)t26);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t32 = (t42 + 4);
    t12 = *((unsigned int *)t32);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB33;

LAB34:    xsi_set_current_line(224, ng0);
    t2 = ((char*)((ng8)));
    t3 = (t0 + 11256);
    t5 = (t0 + 11256);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng9)));
    t16 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t41 + 4);
    t11 = *((unsigned int *)t26);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t32 = (t42 + 4);
    t12 = *((unsigned int *)t32);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB35;

LAB36:    xsi_set_current_line(225, ng0);
    t2 = (t0 + 8776U);
    t3 = *((char **)t2);
    t2 = (t0 + 11416);
    t5 = (t0 + 11416);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng10)));
    t16 = ((char*)((ng11)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t41 + 4);
    t11 = *((unsigned int *)t26);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t32 = (t42 + 4);
    t12 = *((unsigned int *)t32);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB37;

LAB38:    xsi_set_current_line(226, ng0);
    t2 = ((char*)((ng12)));
    t3 = (t0 + 11416);
    t5 = (t0 + 11416);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng13)));
    t16 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t41 + 4);
    t11 = *((unsigned int *)t26);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t32 = (t42 + 4);
    t12 = *((unsigned int *)t32);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB39;

LAB40:    xsi_set_current_line(227, ng0);
    t2 = (t0 + 8936U);
    t3 = *((char **)t2);
    t2 = (t0 + 11736);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 128);
    xsi_set_current_line(228, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 12376);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(229, ng0);
    t2 = (t0 + 1832);
    t3 = *((char **)t2);
    t2 = (t0 + 12856);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 3);
    goto LAB31;

LAB33:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t2, t3, t47, *((unsigned int *)t41), t49);
    goto LAB34;

LAB35:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t3, t2, t47, *((unsigned int *)t41), t49);
    goto LAB36;

LAB37:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t2, t3, t47, *((unsigned int *)t41), t49);
    goto LAB38;

LAB39:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t3, t2, t47, *((unsigned int *)t41), t49);
    goto LAB40;

LAB43:    xsi_set_current_line(238, ng0);

LAB46:    xsi_set_current_line(239, ng0);
    t15 = ((char*)((ng4)));
    t16 = (t0 + 11256);
    t17 = (t0 + 11256);
    t26 = (t17 + 72U);
    t32 = *((char **)t26);
    t33 = ((char*)((ng6)));
    t39 = ((char*)((ng7)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t32)), 2, t33, 32, 1, t39, 32, 1);
    t40 = (t8 + 4);
    t18 = *((unsigned int *)t40);
    t43 = (!(t18));
    t50 = (t41 + 4);
    t19 = *((unsigned int *)t50);
    t44 = (!(t19));
    t45 = (t43 && t44);
    t51 = (t42 + 4);
    t20 = *((unsigned int *)t51);
    t46 = (!(t20));
    t47 = (t45 && t46);
    if (t47 == 1)
        goto LAB47;

LAB48:    xsi_set_current_line(240, ng0);
    t2 = (t0 + 10936);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    xsi_vlog_get_part_select_value(t53, 512, t5, 767, 256);
    t6 = (t0 + 11256);
    t9 = (t0 + 11256);
    t15 = (t9 + 72U);
    t16 = *((char **)t15);
    t17 = ((char*)((ng9)));
    t26 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t16)), 2, t17, 32, 1, t26, 32, 1);
    t32 = (t8 + 4);
    t10 = *((unsigned int *)t32);
    t7 = (!(t10));
    t33 = (t41 + 4);
    t11 = *((unsigned int *)t33);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t39 = (t42 + 4);
    t12 = *((unsigned int *)t39);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB49;

LAB50:    xsi_set_current_line(241, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 11416);
    t5 = (t0 + 11416);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng10)));
    t16 = ((char*)((ng11)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t41 + 4);
    t11 = *((unsigned int *)t26);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t32 = (t42 + 4);
    t12 = *((unsigned int *)t32);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB51;

LAB52:    xsi_set_current_line(242, ng0);
    t2 = (t0 + 11096);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    xsi_vlog_get_part_select_value(t54, 64, t5, 95, 32);
    t6 = (t0 + 11416);
    t9 = (t0 + 11416);
    t15 = (t9 + 72U);
    t16 = *((char **)t15);
    t17 = ((char*)((ng13)));
    t26 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t16)), 2, t17, 32, 1, t26, 32, 1);
    t32 = (t8 + 4);
    t10 = *((unsigned int *)t32);
    t7 = (!(t10));
    t33 = (t41 + 4);
    t11 = *((unsigned int *)t33);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t39 = (t42 + 4);
    t12 = *((unsigned int *)t39);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB53;

LAB54:    goto LAB45;

LAB47:    t21 = *((unsigned int *)t42);
    t48 = (t21 + 0);
    t22 = *((unsigned int *)t8);
    t23 = *((unsigned int *)t41);
    t49 = (t22 - t23);
    t52 = (t49 + 1);
    xsi_vlogvar_assign_value(t16, t15, t48, *((unsigned int *)t41), t52);
    goto LAB48;

LAB49:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t6, t53, t47, *((unsigned int *)t41), t49);
    goto LAB50;

LAB51:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t3, t2, t47, *((unsigned int *)t41), t49);
    goto LAB52;

LAB53:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t6, t54, t47, *((unsigned int *)t41), t49);
    goto LAB54;

LAB56:    *((unsigned int *)t8) = 1;
    goto LAB59;

LAB60:    xsi_set_current_line(245, ng0);

LAB63:    xsi_set_current_line(246, ng0);
    t9 = ((char*)((ng3)));
    t15 = (t0 + 12536);
    xsi_vlogvar_assign_value(t15, t9, 0, 0, 1);
    xsi_set_current_line(247, ng0);
    t2 = (t0 + 8616U);
    t3 = *((char **)t2);
    t2 = (t0 + 11256);
    t5 = (t0 + 11256);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng6)));
    t16 = ((char*)((ng7)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t41 + 4);
    t11 = *((unsigned int *)t26);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t32 = (t42 + 4);
    t12 = *((unsigned int *)t32);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB64;

LAB65:    xsi_set_current_line(248, ng0);
    t2 = (t0 + 10936);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    xsi_vlog_get_part_select_value(t53, 512, t5, 767, 256);
    t6 = (t0 + 11256);
    t9 = (t0 + 11256);
    t15 = (t9 + 72U);
    t16 = *((char **)t15);
    t17 = ((char*)((ng9)));
    t26 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t16)), 2, t17, 32, 1, t26, 32, 1);
    t32 = (t8 + 4);
    t10 = *((unsigned int *)t32);
    t7 = (!(t10));
    t33 = (t41 + 4);
    t11 = *((unsigned int *)t33);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t39 = (t42 + 4);
    t12 = *((unsigned int *)t39);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB66;

LAB67:    xsi_set_current_line(249, ng0);
    t2 = (t0 + 8776U);
    t3 = *((char **)t2);
    t2 = (t0 + 11416);
    t5 = (t0 + 11416);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng10)));
    t16 = ((char*)((ng11)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t41 + 4);
    t11 = *((unsigned int *)t26);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t32 = (t42 + 4);
    t12 = *((unsigned int *)t32);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB68;

LAB69:    xsi_set_current_line(250, ng0);
    t2 = (t0 + 11096);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    xsi_vlog_get_part_select_value(t54, 64, t5, 95, 32);
    t6 = (t0 + 11416);
    t9 = (t0 + 11416);
    t15 = (t9 + 72U);
    t16 = *((char **)t15);
    t17 = ((char*)((ng13)));
    t26 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t16)), 2, t17, 32, 1, t26, 32, 1);
    t32 = (t8 + 4);
    t10 = *((unsigned int *)t32);
    t7 = (!(t10));
    t33 = (t41 + 4);
    t11 = *((unsigned int *)t33);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t39 = (t42 + 4);
    t12 = *((unsigned int *)t39);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB70;

LAB71:    xsi_set_current_line(251, ng0);
    t2 = (t0 + 9096U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t10 = *((unsigned int *)t2);
    t11 = (~(t10));
    t12 = *((unsigned int *)t3);
    t13 = (t12 & t11);
    t14 = (t13 != 0);
    if (t14 > 0)
        goto LAB72;

LAB73:
LAB74:    goto LAB62;

LAB64:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t2, t3, t47, *((unsigned int *)t41), t49);
    goto LAB65;

LAB66:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t6, t53, t47, *((unsigned int *)t41), t49);
    goto LAB67;

LAB68:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t2, t3, t47, *((unsigned int *)t41), t49);
    goto LAB69;

LAB70:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t6, t54, t47, *((unsigned int *)t41), t49);
    goto LAB71;

LAB72:    xsi_set_current_line(251, ng0);

LAB75:    xsi_set_current_line(252, ng0);
    t5 = ((char*)((ng3)));
    t6 = (t0 + 12376);
    xsi_vlogvar_assign_value(t6, t5, 0, 0, 1);
    goto LAB74;

LAB78:    t33 = (t41 + 4);
    *((unsigned int *)t41) = 1;
    *((unsigned int *)t33) = 1;
    goto LAB79;

LAB80:    xsi_set_current_line(256, ng0);

LAB83:    xsi_set_current_line(257, ng0);
    t40 = (t0 + 11256);
    t50 = (t40 + 56U);
    t51 = *((char **)t50);
    memset(t42, 0, 8);
    t55 = (t42 + 4);
    t56 = (t51 + 40);
    t57 = (t51 + 44);
    t31 = *((unsigned int *)t56);
    t34 = (t31 >> 24);
    *((unsigned int *)t42) = t34;
    t35 = *((unsigned int *)t57);
    t36 = (t35 >> 24);
    *((unsigned int *)t55) = t36;
    t37 = *((unsigned int *)t42);
    *((unsigned int *)t42) = (t37 & 255U);
    t38 = *((unsigned int *)t55);
    *((unsigned int *)t55) = (t38 & 255U);
    t58 = (t0 + 8296U);
    t59 = *((char **)t58);
    memset(t60, 0, 8);
    t58 = (t42 + 4);
    t61 = (t59 + 4);
    t62 = *((unsigned int *)t42);
    t63 = *((unsigned int *)t59);
    t64 = (t62 ^ t63);
    t65 = *((unsigned int *)t58);
    t66 = *((unsigned int *)t61);
    t67 = (t65 ^ t66);
    t68 = (t64 | t67);
    t69 = *((unsigned int *)t58);
    t70 = *((unsigned int *)t61);
    t71 = (t69 | t70);
    t72 = (~(t71));
    t73 = (t68 & t72);
    if (t73 != 0)
        goto LAB87;

LAB84:    if (t71 != 0)
        goto LAB86;

LAB85:    *((unsigned int *)t60) = 1;

LAB87:    t75 = (t60 + 4);
    t76 = *((unsigned int *)t75);
    t77 = (~(t76));
    t78 = *((unsigned int *)t60);
    t79 = (t78 & t77);
    t80 = (t79 != 0);
    if (t80 > 0)
        goto LAB88;

LAB89:    xsi_set_current_line(261, ng0);

LAB94:    xsi_set_current_line(262, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 12056);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);

LAB90:    xsi_set_current_line(264, ng0);
    t2 = (t0 + 12216);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t8, 0, 8);
    t6 = (t5 + 4);
    t10 = *((unsigned int *)t6);
    t11 = (~(t10));
    t12 = *((unsigned int *)t5);
    t13 = (t12 & t11);
    t14 = (t13 & 1U);
    if (t14 != 0)
        goto LAB98;

LAB96:    if (*((unsigned int *)t6) == 0)
        goto LAB95;

LAB97:    t9 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t9) = 1;

LAB98:    t15 = (t8 + 4);
    t16 = (t5 + 4);
    t18 = *((unsigned int *)t5);
    t19 = (~(t18));
    *((unsigned int *)t8) = t19;
    *((unsigned int *)t15) = 0;
    if (*((unsigned int *)t16) != 0)
        goto LAB100;

LAB99:    t24 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t24 & 1U);
    t25 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t25 & 1U);
    t17 = (t8 + 4);
    t27 = *((unsigned int *)t17);
    t28 = (~(t27));
    t29 = *((unsigned int *)t8);
    t30 = (t29 & t28);
    t31 = (t30 != 0);
    if (t31 > 0)
        goto LAB101;

LAB102:    xsi_set_current_line(267, ng0);

LAB105:    xsi_set_current_line(268, ng0);
    t2 = (t0 + 2104);
    t3 = *((char **)t2);
    t2 = (t0 + 12856);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 3);

LAB103:    goto LAB82;

LAB86:    t74 = (t60 + 4);
    *((unsigned int *)t60) = 1;
    *((unsigned int *)t74) = 1;
    goto LAB87;

LAB88:    xsi_set_current_line(257, ng0);

LAB91:    xsi_set_current_line(258, ng0);
    t81 = ((char*)((ng3)));
    t82 = (t0 + 12056);
    xsi_vlogvar_assign_value(t82, t81, 0, 0, 1);
    xsi_set_current_line(259, ng0);
    t2 = (t0 + 11576);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t8, 0, 8);
    t6 = (t8 + 4);
    t9 = (t5 + 4);
    t10 = *((unsigned int *)t5);
    t11 = (t10 >> 0);
    *((unsigned int *)t8) = t11;
    t12 = *((unsigned int *)t9);
    t13 = (t12 >> 0);
    *((unsigned int *)t6) = t13;
    t14 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t14 & 65535U);
    t18 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t18 & 65535U);
    t15 = ((char*)((ng14)));
    memset(t41, 0, 8);
    xsi_vlog_unsigned_minus(t41, 32, t8, 32, t15, 32);
    t16 = (t0 + 11736);
    t17 = (t0 + 11736);
    t26 = (t17 + 72U);
    t32 = *((char **)t26);
    t33 = ((char*)((ng15)));
    t39 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t42, t60, t83, ((int*)(t32)), 2, t33, 32, 1, t39, 32, 1);
    t40 = (t42 + 4);
    t19 = *((unsigned int *)t40);
    t7 = (!(t19));
    t50 = (t60 + 4);
    t20 = *((unsigned int *)t50);
    t43 = (!(t20));
    t44 = (t7 && t43);
    t51 = (t83 + 4);
    t21 = *((unsigned int *)t51);
    t45 = (!(t21));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB92;

LAB93:    goto LAB90;

LAB92:    t22 = *((unsigned int *)t83);
    t47 = (t22 + 0);
    t23 = *((unsigned int *)t42);
    t24 = *((unsigned int *)t60);
    t48 = (t23 - t24);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t16, t41, t47, *((unsigned int *)t60), t49);
    goto LAB93;

LAB95:    *((unsigned int *)t8) = 1;
    goto LAB98;

LAB100:    t20 = *((unsigned int *)t8);
    t21 = *((unsigned int *)t16);
    *((unsigned int *)t8) = (t20 | t21);
    t22 = *((unsigned int *)t15);
    t23 = *((unsigned int *)t16);
    *((unsigned int *)t15) = (t22 | t23);
    goto LAB99;

LAB101:    xsi_set_current_line(264, ng0);

LAB104:    xsi_set_current_line(265, ng0);
    t26 = (t0 + 1968);
    t32 = *((char **)t26);
    t26 = (t0 + 12856);
    xsi_vlogvar_assign_value(t26, t32, 0, 0, 3);
    goto LAB103;

LAB107:    *((unsigned int *)t8) = 1;
    goto LAB110;

LAB113:    t16 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t16) = 1;
    goto LAB114;

LAB115:    xsi_set_current_line(275, ng0);

LAB118:    xsi_set_current_line(276, ng0);
    t26 = (t0 + 10936);
    t32 = (t26 + 56U);
    t33 = *((char **)t32);
    xsi_vlog_get_part_select_value(t84, 256, t33, 527, 272);
    t39 = (t0 + 10136);
    xsi_vlogvar_assign_value(t39, t84, 0, 0, 256);
    xsi_set_current_line(277, ng0);
    t2 = (t0 + 11096);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t8, 0, 8);
    t6 = (t8 + 4);
    t9 = (t5 + 8);
    t15 = (t5 + 12);
    t10 = *((unsigned int *)t9);
    t11 = (t10 >> 2);
    *((unsigned int *)t8) = t11;
    t12 = *((unsigned int *)t15);
    t13 = (t12 >> 2);
    *((unsigned int *)t6) = t13;
    t16 = (t5 + 16);
    t17 = (t5 + 20);
    t14 = *((unsigned int *)t16);
    t18 = (t14 << 30);
    t19 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t19 | t18);
    t20 = *((unsigned int *)t17);
    t21 = (t20 << 30);
    t22 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t22 | t21);
    t23 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t23 & 4294967295U);
    t24 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t24 & 4294967295U);
    t26 = (t0 + 10296);
    xsi_vlogvar_assign_value(t26, t8, 0, 0, 32);
    xsi_set_current_line(278, ng0);
    t2 = (t0 + 11576);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 10456);
    xsi_vlogvar_assign_value(t6, t5, 0, 0, 128);
    goto LAB117;

LAB120:    *((unsigned int *)t8) = 1;
    goto LAB123;

LAB122:    t9 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t9) = 1;
    goto LAB123;

LAB124:    t16 = (t0 + 3976U);
    t17 = *((char **)t16);
    memset(t41, 0, 8);
    t16 = (t17 + 4);
    t21 = *((unsigned int *)t16);
    t22 = (~(t21));
    t23 = *((unsigned int *)t17);
    t24 = (t23 & t22);
    t25 = (t24 & 1U);
    if (t25 != 0)
        goto LAB127;

LAB128:    if (*((unsigned int *)t16) != 0)
        goto LAB129;

LAB130:    t27 = *((unsigned int *)t8);
    t28 = *((unsigned int *)t41);
    t29 = (t27 & t28);
    *((unsigned int *)t42) = t29;
    t32 = (t8 + 4);
    t33 = (t41 + 4);
    t39 = (t42 + 4);
    t30 = *((unsigned int *)t32);
    t31 = *((unsigned int *)t33);
    t34 = (t30 | t31);
    *((unsigned int *)t39) = t34;
    t35 = *((unsigned int *)t39);
    t36 = (t35 != 0);
    if (t36 == 1)
        goto LAB131;

LAB132:
LAB133:    goto LAB126;

LAB127:    *((unsigned int *)t41) = 1;
    goto LAB130;

LAB129:    t26 = (t41 + 4);
    *((unsigned int *)t41) = 1;
    *((unsigned int *)t26) = 1;
    goto LAB130;

LAB131:    t37 = *((unsigned int *)t42);
    t38 = *((unsigned int *)t39);
    *((unsigned int *)t42) = (t37 | t38);
    t40 = (t8 + 4);
    t50 = (t41 + 4);
    t62 = *((unsigned int *)t8);
    t63 = (~(t62));
    t64 = *((unsigned int *)t40);
    t65 = (~(t64));
    t66 = *((unsigned int *)t41);
    t67 = (~(t66));
    t68 = *((unsigned int *)t50);
    t69 = (~(t68));
    t7 = (t63 & t65);
    t43 = (t67 & t69);
    t70 = (~(t7));
    t71 = (~(t43));
    t72 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t72 & t70);
    t73 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t73 & t71);
    t76 = *((unsigned int *)t42);
    *((unsigned int *)t42) = (t76 & t70);
    t77 = *((unsigned int *)t42);
    *((unsigned int *)t42) = (t77 & t71);
    goto LAB133;

LAB134:    xsi_set_current_line(286, ng0);

LAB137:    xsi_set_current_line(287, ng0);
    t55 = ((char*)((ng3)));
    t56 = (t0 + 12536);
    xsi_vlogvar_assign_value(t56, t55, 0, 0, 1);
    xsi_set_current_line(288, ng0);
    t2 = (t0 + 8616U);
    t3 = *((char **)t2);
    t2 = (t0 + 11256);
    t5 = (t0 + 11256);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng6)));
    t16 = ((char*)((ng7)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t41 + 4);
    t11 = *((unsigned int *)t26);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t32 = (t42 + 4);
    t12 = *((unsigned int *)t32);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB138;

LAB139:    xsi_set_current_line(289, ng0);
    t2 = (t0 + 10936);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    xsi_vlog_get_part_select_value(t53, 512, t5, 767, 256);
    t6 = (t0 + 11256);
    t9 = (t0 + 11256);
    t15 = (t9 + 72U);
    t16 = *((char **)t15);
    t17 = ((char*)((ng9)));
    t26 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t16)), 2, t17, 32, 1, t26, 32, 1);
    t32 = (t8 + 4);
    t10 = *((unsigned int *)t32);
    t7 = (!(t10));
    t33 = (t41 + 4);
    t11 = *((unsigned int *)t33);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t39 = (t42 + 4);
    t12 = *((unsigned int *)t39);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB140;

LAB141:    xsi_set_current_line(290, ng0);
    t2 = (t0 + 8776U);
    t3 = *((char **)t2);
    t2 = (t0 + 11416);
    t5 = (t0 + 11416);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng10)));
    t16 = ((char*)((ng11)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t41 + 4);
    t11 = *((unsigned int *)t26);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t32 = (t42 + 4);
    t12 = *((unsigned int *)t32);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB142;

LAB143:    xsi_set_current_line(291, ng0);
    t2 = (t0 + 11096);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    xsi_vlog_get_part_select_value(t54, 64, t5, 95, 32);
    t6 = (t0 + 11416);
    t9 = (t0 + 11416);
    t15 = (t9 + 72U);
    t16 = *((char **)t15);
    t17 = ((char*)((ng13)));
    t26 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t16)), 2, t17, 32, 1, t26, 32, 1);
    t32 = (t8 + 4);
    t10 = *((unsigned int *)t32);
    t7 = (!(t10));
    t33 = (t41 + 4);
    t11 = *((unsigned int *)t33);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t39 = (t42 + 4);
    t12 = *((unsigned int *)t39);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB144;

LAB145:    xsi_set_current_line(292, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 11736);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 128);
    xsi_set_current_line(293, ng0);
    t2 = (t0 + 9096U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t10 = *((unsigned int *)t2);
    t11 = (~(t10));
    t12 = *((unsigned int *)t3);
    t13 = (t12 & t11);
    t14 = (t13 != 0);
    if (t14 > 0)
        goto LAB146;

LAB147:
LAB148:    goto LAB136;

LAB138:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t2, t3, t47, *((unsigned int *)t41), t49);
    goto LAB139;

LAB140:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t6, t53, t47, *((unsigned int *)t41), t49);
    goto LAB141;

LAB142:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t2, t3, t47, *((unsigned int *)t41), t49);
    goto LAB143;

LAB144:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t6, t54, t47, *((unsigned int *)t41), t49);
    goto LAB145;

LAB146:    xsi_set_current_line(293, ng0);

LAB149:    xsi_set_current_line(294, ng0);
    t5 = (t0 + 2104);
    t6 = *((char **)t5);
    t5 = (t0 + 12856);
    xsi_vlogvar_assign_value(t5, t6, 0, 0, 3);
    goto LAB148;

LAB153:    t16 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t16) = 1;
    goto LAB154;

LAB155:    xsi_set_current_line(301, ng0);

LAB158:    xsi_set_current_line(302, ng0);
    t26 = (t0 + 10936);
    t32 = (t26 + 56U);
    t33 = *((char **)t32);
    xsi_vlog_get_part_select_value(t84, 256, t33, 527, 272);
    t39 = (t0 + 10136);
    xsi_vlogvar_assign_value(t39, t84, 0, 0, 256);
    xsi_set_current_line(303, ng0);
    t2 = (t0 + 11096);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t8, 0, 8);
    t6 = (t8 + 4);
    t9 = (t5 + 8);
    t15 = (t5 + 12);
    t10 = *((unsigned int *)t9);
    t11 = (t10 >> 2);
    *((unsigned int *)t8) = t11;
    t12 = *((unsigned int *)t15);
    t13 = (t12 >> 2);
    *((unsigned int *)t6) = t13;
    t16 = (t5 + 16);
    t17 = (t5 + 20);
    t14 = *((unsigned int *)t16);
    t18 = (t14 << 30);
    t19 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t19 | t18);
    t20 = *((unsigned int *)t17);
    t21 = (t20 << 30);
    t22 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t22 | t21);
    t23 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t23 & 4294967295U);
    t24 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t24 & 4294967295U);
    t26 = (t0 + 10296);
    xsi_vlogvar_assign_value(t26, t8, 0, 0, 32);
    xsi_set_current_line(304, ng0);
    t2 = (t0 + 11576);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 10456);
    xsi_vlogvar_assign_value(t6, t5, 0, 0, 128);
    goto LAB157;

LAB160:    xsi_set_current_line(312, ng0);

LAB163:    xsi_set_current_line(314, ng0);
    t5 = ((char*)((ng4)));
    t6 = (t0 + 11256);
    t9 = (t0 + 11256);
    t15 = (t9 + 72U);
    t16 = *((char **)t15);
    t17 = ((char*)((ng6)));
    t26 = ((char*)((ng7)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t16)), 2, t17, 32, 1, t26, 32, 1);
    t32 = (t8 + 4);
    t18 = *((unsigned int *)t32);
    t7 = (!(t18));
    t33 = (t41 + 4);
    t19 = *((unsigned int *)t33);
    t43 = (!(t19));
    t44 = (t7 && t43);
    t39 = (t42 + 4);
    t20 = *((unsigned int *)t39);
    t45 = (!(t20));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB164;

LAB165:    xsi_set_current_line(315, ng0);
    t2 = (t0 + 10936);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    xsi_vlog_get_part_select_value(t53, 512, t5, 767, 256);
    t6 = (t0 + 11256);
    t9 = (t0 + 11256);
    t15 = (t9 + 72U);
    t16 = *((char **)t15);
    t17 = ((char*)((ng9)));
    t26 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t16)), 2, t17, 32, 1, t26, 32, 1);
    t32 = (t8 + 4);
    t10 = *((unsigned int *)t32);
    t7 = (!(t10));
    t33 = (t41 + 4);
    t11 = *((unsigned int *)t33);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t39 = (t42 + 4);
    t12 = *((unsigned int *)t39);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB166;

LAB167:    xsi_set_current_line(316, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 11416);
    t5 = (t0 + 11416);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng10)));
    t16 = ((char*)((ng11)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t41 + 4);
    t11 = *((unsigned int *)t26);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t32 = (t42 + 4);
    t12 = *((unsigned int *)t32);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB168;

LAB169:    xsi_set_current_line(317, ng0);
    t2 = (t0 + 11096);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    xsi_vlog_get_part_select_value(t54, 64, t5, 95, 32);
    t6 = (t0 + 11416);
    t9 = (t0 + 11416);
    t15 = (t9 + 72U);
    t16 = *((char **)t15);
    t17 = ((char*)((ng13)));
    t26 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t8, t41, t42, ((int*)(t16)), 2, t17, 32, 1, t26, 32, 1);
    t32 = (t8 + 4);
    t10 = *((unsigned int *)t32);
    t7 = (!(t10));
    t33 = (t41 + 4);
    t11 = *((unsigned int *)t33);
    t43 = (!(t11));
    t44 = (t7 && t43);
    t39 = (t42 + 4);
    t12 = *((unsigned int *)t39);
    t45 = (!(t12));
    t46 = (t44 && t45);
    if (t46 == 1)
        goto LAB170;

LAB171:    xsi_set_current_line(318, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 11736);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 128);
    xsi_set_current_line(320, ng0);
    t2 = (t0 + 11896);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = ((char*)((ng3)));
    memset(t8, 0, 8);
    t9 = (t5 + 4);
    t15 = (t6 + 4);
    t10 = *((unsigned int *)t5);
    t11 = *((unsigned int *)t6);
    t12 = (t10 ^ t11);
    t13 = *((unsigned int *)t9);
    t14 = *((unsigned int *)t15);
    t18 = (t13 ^ t14);
    t19 = (t12 | t18);
    t20 = *((unsigned int *)t9);
    t21 = *((unsigned int *)t15);
    t22 = (t20 | t21);
    t23 = (~(t22));
    t24 = (t19 & t23);
    if (t24 != 0)
        goto LAB175;

LAB172:    if (t22 != 0)
        goto LAB174;

LAB173:    *((unsigned int *)t8) = 1;

LAB175:    t17 = (t8 + 4);
    t25 = *((unsigned int *)t17);
    t27 = (~(t25));
    t28 = *((unsigned int *)t8);
    t29 = (t28 & t27);
    t30 = (t29 != 0);
    if (t30 > 0)
        goto LAB176;

LAB177:    xsi_set_current_line(326, ng0);

LAB190:    xsi_set_current_line(327, ng0);
    t2 = (t0 + 11416);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t41, 0, 8);
    t6 = (t41 + 4);
    t9 = (t5 + 4);
    t10 = *((unsigned int *)t5);
    t11 = (t10 >> 0);
    t12 = (t11 & 1);
    *((unsigned int *)t41) = t12;
    t13 = *((unsigned int *)t9);
    t14 = (t13 >> 0);
    t18 = (t14 & 1);
    *((unsigned int *)t6) = t18;
    memset(t8, 0, 8);
    t15 = (t41 + 4);
    t19 = *((unsigned int *)t15);
    t20 = (~(t19));
    t21 = *((unsigned int *)t41);
    t22 = (t21 & t20);
    t23 = (t22 & 1U);
    if (t23 != 0)
        goto LAB194;

LAB192:    if (*((unsigned int *)t15) == 0)
        goto LAB191;

LAB193:    t16 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t16) = 1;

LAB194:    t17 = (t8 + 4);
    t26 = (t41 + 4);
    t24 = *((unsigned int *)t41);
    t25 = (~(t24));
    *((unsigned int *)t8) = t25;
    *((unsigned int *)t17) = 0;
    if (*((unsigned int *)t26) != 0)
        goto LAB196;

LAB195:    t31 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t31 & 1U);
    t34 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t34 & 1U);
    t32 = (t8 + 4);
    t35 = *((unsigned int *)t32);
    t36 = (~(t35));
    t37 = *((unsigned int *)t8);
    t38 = (t37 & t36);
    t62 = (t38 != 0);
    if (t62 > 0)
        goto LAB197;

LAB198:
LAB199:
LAB178:    goto LAB162;

LAB164:    t21 = *((unsigned int *)t42);
    t47 = (t21 + 0);
    t22 = *((unsigned int *)t8);
    t23 = *((unsigned int *)t41);
    t48 = (t22 - t23);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t6, t5, t47, *((unsigned int *)t41), t49);
    goto LAB165;

LAB166:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t6, t53, t47, *((unsigned int *)t41), t49);
    goto LAB167;

LAB168:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t3, t2, t47, *((unsigned int *)t41), t49);
    goto LAB169;

LAB170:    t13 = *((unsigned int *)t42);
    t47 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t41);
    t48 = (t14 - t18);
    t49 = (t48 + 1);
    xsi_vlogvar_assign_value(t6, t54, t47, *((unsigned int *)t41), t49);
    goto LAB171;

LAB174:    t16 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t16) = 1;
    goto LAB175;

LAB176:    xsi_set_current_line(320, ng0);

LAB179:    xsi_set_current_line(321, ng0);
    t26 = (t0 + 11416);
    t32 = (t26 + 56U);
    t33 = *((char **)t32);
    memset(t42, 0, 8);
    t39 = (t42 + 4);
    t40 = (t33 + 8);
    t50 = (t33 + 12);
    t31 = *((unsigned int *)t40);
    t34 = (t31 >> 2);
    t35 = (t34 & 1);
    *((unsigned int *)t42) = t35;
    t36 = *((unsigned int *)t50);
    t37 = (t36 >> 2);
    t38 = (t37 & 1);
    *((unsigned int *)t39) = t38;
    memset(t41, 0, 8);
    t51 = (t42 + 4);
    t62 = *((unsigned int *)t51);
    t63 = (~(t62));
    t64 = *((unsigned int *)t42);
    t65 = (t64 & t63);
    t66 = (t65 & 1U);
    if (t66 != 0)
        goto LAB183;

LAB181:    if (*((unsigned int *)t51) == 0)
        goto LAB180;

LAB182:    t55 = (t41 + 4);
    *((unsigned int *)t41) = 1;
    *((unsigned int *)t55) = 1;

LAB183:    t56 = (t41 + 4);
    t57 = (t42 + 4);
    t67 = *((unsigned int *)t42);
    t68 = (~(t67));
    *((unsigned int *)t41) = t68;
    *((unsigned int *)t56) = 0;
    if (*((unsigned int *)t57) != 0)
        goto LAB185;

LAB184:    t73 = *((unsigned int *)t41);
    *((unsigned int *)t41) = (t73 & 1U);
    t76 = *((unsigned int *)t56);
    *((unsigned int *)t56) = (t76 & 1U);
    t58 = (t41 + 4);
    t77 = *((unsigned int *)t58);
    t78 = (~(t77));
    t79 = *((unsigned int *)t41);
    t80 = (t79 & t78);
    t85 = (t80 != 0);
    if (t85 > 0)
        goto LAB186;

LAB187:
LAB188:    goto LAB178;

LAB180:    *((unsigned int *)t41) = 1;
    goto LAB183;

LAB185:    t69 = *((unsigned int *)t41);
    t70 = *((unsigned int *)t57);
    *((unsigned int *)t41) = (t69 | t70);
    t71 = *((unsigned int *)t56);
    t72 = *((unsigned int *)t57);
    *((unsigned int *)t56) = (t71 | t72);
    goto LAB184;

LAB186:    xsi_set_current_line(321, ng0);

LAB189:    xsi_set_current_line(322, ng0);
    t59 = ((char*)((ng3)));
    t61 = (t0 + 10776);
    xsi_vlogvar_assign_value(t61, t59, 0, 0, 1);
    xsi_set_current_line(323, ng0);
    t2 = (t0 + 1696);
    t3 = *((char **)t2);
    t2 = (t0 + 12856);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 3);
    goto LAB188;

LAB191:    *((unsigned int *)t8) = 1;
    goto LAB194;

LAB196:    t27 = *((unsigned int *)t8);
    t28 = *((unsigned int *)t26);
    *((unsigned int *)t8) = (t27 | t28);
    t29 = *((unsigned int *)t17);
    t30 = *((unsigned int *)t26);
    *((unsigned int *)t17) = (t29 | t30);
    goto LAB195;

LAB197:    xsi_set_current_line(327, ng0);

LAB200:    xsi_set_current_line(328, ng0);
    t33 = ((char*)((ng3)));
    t39 = (t0 + 10776);
    xsi_vlogvar_assign_value(t39, t33, 0, 0, 1);
    xsi_set_current_line(329, ng0);
    t2 = (t0 + 1696);
    t3 = *((char **)t2);
    t2 = (t0 + 12856);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 3);
    goto LAB199;

LAB202:    *((unsigned int *)t8) = 1;
    goto LAB205;

LAB206:    *((unsigned int *)t8) = 1;
    goto LAB209;

LAB208:    t9 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t9) = 1;
    goto LAB209;

LAB210:    t16 = (t0 + 3976U);
    t17 = *((char **)t16);
    memset(t41, 0, 8);
    t16 = (t17 + 4);
    t21 = *((unsigned int *)t16);
    t22 = (~(t21));
    t23 = *((unsigned int *)t17);
    t24 = (t23 & t22);
    t25 = (t24 & 1U);
    if (t25 != 0)
        goto LAB213;

LAB214:    if (*((unsigned int *)t16) != 0)
        goto LAB215;

LAB216:    t27 = *((unsigned int *)t8);
    t28 = *((unsigned int *)t41);
    t29 = (t27 & t28);
    *((unsigned int *)t42) = t29;
    t32 = (t8 + 4);
    t33 = (t41 + 4);
    t39 = (t42 + 4);
    t30 = *((unsigned int *)t32);
    t31 = *((unsigned int *)t33);
    t34 = (t30 | t31);
    *((unsigned int *)t39) = t34;
    t35 = *((unsigned int *)t39);
    t36 = (t35 != 0);
    if (t36 == 1)
        goto LAB217;

LAB218:
LAB219:    goto LAB212;

LAB213:    *((unsigned int *)t41) = 1;
    goto LAB216;

LAB215:    t26 = (t41 + 4);
    *((unsigned int *)t41) = 1;
    *((unsigned int *)t26) = 1;
    goto LAB216;

LAB217:    t37 = *((unsigned int *)t42);
    t38 = *((unsigned int *)t39);
    *((unsigned int *)t42) = (t37 | t38);
    t40 = (t8 + 4);
    t50 = (t41 + 4);
    t62 = *((unsigned int *)t8);
    t63 = (~(t62));
    t64 = *((unsigned int *)t40);
    t65 = (~(t64));
    t66 = *((unsigned int *)t41);
    t67 = (~(t66));
    t68 = *((unsigned int *)t50);
    t69 = (~(t68));
    t7 = (t63 & t65);
    t43 = (t67 & t69);
    t70 = (~(t7));
    t71 = (~(t43));
    t72 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t72 & t70);
    t73 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t73 & t71);
    t76 = *((unsigned int *)t42);
    *((unsigned int *)t42) = (t76 & t70);
    t77 = *((unsigned int *)t42);
    *((unsigned int *)t42) = (t77 & t71);
    goto LAB219;

LAB220:    *((unsigned int *)t8) = 1;
    goto LAB223;

LAB222:    t9 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t9) = 1;
    goto LAB223;

LAB224:    t16 = (t0 + 10776);
    t17 = (t16 + 56U);
    t26 = *((char **)t17);
    memset(t41, 0, 8);
    t32 = (t26 + 4);
    t21 = *((unsigned int *)t32);
    t22 = (~(t21));
    t23 = *((unsigned int *)t26);
    t24 = (t23 & t22);
    t25 = (t24 & 1U);
    if (t25 != 0)
        goto LAB227;

LAB228:    if (*((unsigned int *)t32) != 0)
        goto LAB229;

LAB230:    t27 = *((unsigned int *)t8);
    t28 = *((unsigned int *)t41);
    t29 = (t27 & t28);
    *((unsigned int *)t42) = t29;
    t39 = (t8 + 4);
    t40 = (t41 + 4);
    t50 = (t42 + 4);
    t30 = *((unsigned int *)t39);
    t31 = *((unsigned int *)t40);
    t34 = (t30 | t31);
    *((unsigned int *)t50) = t34;
    t35 = *((unsigned int *)t50);
    t36 = (t35 != 0);
    if (t36 == 1)
        goto LAB231;

LAB232:
LAB233:    goto LAB226;

LAB227:    *((unsigned int *)t41) = 1;
    goto LAB230;

LAB229:    t33 = (t41 + 4);
    *((unsigned int *)t41) = 1;
    *((unsigned int *)t33) = 1;
    goto LAB230;

LAB231:    t37 = *((unsigned int *)t42);
    t38 = *((unsigned int *)t50);
    *((unsigned int *)t42) = (t37 | t38);
    t51 = (t8 + 4);
    t55 = (t41 + 4);
    t62 = *((unsigned int *)t8);
    t63 = (~(t62));
    t64 = *((unsigned int *)t51);
    t65 = (~(t64));
    t66 = *((unsigned int *)t41);
    t67 = (~(t66));
    t68 = *((unsigned int *)t55);
    t69 = (~(t68));
    t7 = (t63 & t65);
    t43 = (t67 & t69);
    t70 = (~(t7));
    t71 = (~(t43));
    t72 = *((unsigned int *)t50);
    *((unsigned int *)t50) = (t72 & t70);
    t73 = *((unsigned int *)t50);
    *((unsigned int *)t50) = (t73 & t71);
    t76 = *((unsigned int *)t42);
    *((unsigned int *)t42) = (t76 & t70);
    t77 = *((unsigned int *)t42);
    *((unsigned int *)t42) = (t77 & t71);
    goto LAB233;

LAB234:    *((unsigned int *)t60) = 1;
    goto LAB237;

LAB236:    t57 = (t60 + 4);
    *((unsigned int *)t60) = 1;
    *((unsigned int *)t57) = 1;
    goto LAB237;

LAB238:    t59 = (t0 + 3976U);
    t61 = *((char **)t59);
    memset(t83, 0, 8);
    t59 = (t61 + 4);
    t90 = *((unsigned int *)t59);
    t91 = (~(t90));
    t92 = *((unsigned int *)t61);
    t93 = (t92 & t91);
    t94 = (t93 & 1U);
    if (t94 != 0)
        goto LAB241;

LAB242:    if (*((unsigned int *)t59) != 0)
        goto LAB243;

LAB244:    t96 = *((unsigned int *)t60);
    t97 = *((unsigned int *)t83);
    t98 = (t96 & t97);
    *((unsigned int *)t95) = t98;
    t75 = (t60 + 4);
    t81 = (t83 + 4);
    t82 = (t95 + 4);
    t99 = *((unsigned int *)t75);
    t100 = *((unsigned int *)t81);
    t101 = (t99 | t100);
    *((unsigned int *)t82) = t101;
    t102 = *((unsigned int *)t82);
    t103 = (t102 != 0);
    if (t103 == 1)
        goto LAB245;

LAB246:
LAB247:    goto LAB240;

LAB241:    *((unsigned int *)t83) = 1;
    goto LAB244;

LAB243:    t74 = (t83 + 4);
    *((unsigned int *)t83) = 1;
    *((unsigned int *)t74) = 1;
    goto LAB244;

LAB245:    t104 = *((unsigned int *)t95);
    t105 = *((unsigned int *)t82);
    *((unsigned int *)t95) = (t104 | t105);
    t106 = (t60 + 4);
    t107 = (t83 + 4);
    t108 = *((unsigned int *)t60);
    t109 = (~(t108));
    t110 = *((unsigned int *)t106);
    t111 = (~(t110));
    t112 = *((unsigned int *)t83);
    t113 = (~(t112));
    t114 = *((unsigned int *)t107);
    t115 = (~(t114));
    t44 = (t109 & t111);
    t45 = (t113 & t115);
    t116 = (~(t44));
    t117 = (~(t45));
    t118 = *((unsigned int *)t82);
    *((unsigned int *)t82) = (t118 & t116);
    t119 = *((unsigned int *)t82);
    *((unsigned int *)t82) = (t119 & t117);
    t120 = *((unsigned int *)t95);
    *((unsigned int *)t95) = (t120 & t116);
    t121 = *((unsigned int *)t95);
    *((unsigned int *)t95) = (t121 & t117);
    goto LAB247;

LAB248:    xsi_set_current_line(343, ng0);

LAB251:    xsi_set_current_line(344, ng0);
    t128 = (t0 + 1696);
    t129 = *((char **)t128);
    t128 = (t0 + 12856);
    xsi_vlogvar_assign_value(t128, t129, 0, 0, 3);
    goto LAB250;

}

static void Always_350_2(char *t0)
{
    char t4[8];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    char *t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    char *t13;
    char *t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    char *t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    char *t29;
    char *t30;

LAB0:    t1 = (t0 + 14584U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(350, ng0);
    t2 = (t0 + 15680);
    *((int *)t2) = 1;
    t3 = (t0 + 14616);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(350, ng0);

LAB5:    xsi_set_current_line(351, ng0);
    t5 = (t0 + 3816U);
    t6 = *((char **)t5);
    memset(t4, 0, 8);
    t5 = (t6 + 4);
    t7 = *((unsigned int *)t5);
    t8 = (~(t7));
    t9 = *((unsigned int *)t6);
    t10 = (t9 & t8);
    t11 = (t10 & 1U);
    if (t11 != 0)
        goto LAB9;

LAB7:    if (*((unsigned int *)t5) == 0)
        goto LAB6;

LAB8:    t12 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t12) = 1;

LAB9:    t13 = (t4 + 4);
    t14 = (t6 + 4);
    t15 = *((unsigned int *)t6);
    t16 = (~(t15));
    *((unsigned int *)t4) = t16;
    *((unsigned int *)t13) = 0;
    if (*((unsigned int *)t14) != 0)
        goto LAB11;

LAB10:    t21 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t21 & 1U);
    t22 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t22 & 1U);
    t23 = (t4 + 4);
    t24 = *((unsigned int *)t23);
    t25 = (~(t24));
    t26 = *((unsigned int *)t4);
    t27 = (t26 & t25);
    t28 = (t27 != 0);
    if (t28 > 0)
        goto LAB12;

LAB13:    xsi_set_current_line(359, ng0);

LAB16:    xsi_set_current_line(360, ng0);
    t2 = (t0 + 12856);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 12696);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 3, 0LL);
    xsi_set_current_line(361, ng0);
    t2 = (t0 + 11256);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 10936);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 768, 0LL);
    xsi_set_current_line(362, ng0);
    t2 = (t0 + 11416);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 11096);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 96, 0LL);
    xsi_set_current_line(363, ng0);
    t2 = (t0 + 11736);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 11576);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 128, 0LL);
    xsi_set_current_line(364, ng0);
    t2 = (t0 + 12056);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 11896);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 1, 0LL);
    xsi_set_current_line(365, ng0);
    t2 = (t0 + 12376);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 12216);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 1, 0LL);

LAB14:    goto LAB2;

LAB6:    *((unsigned int *)t4) = 1;
    goto LAB9;

LAB11:    t17 = *((unsigned int *)t4);
    t18 = *((unsigned int *)t14);
    *((unsigned int *)t4) = (t17 | t18);
    t19 = *((unsigned int *)t13);
    t20 = *((unsigned int *)t14);
    *((unsigned int *)t13) = (t19 | t20);
    goto LAB10;

LAB12:    xsi_set_current_line(351, ng0);

LAB15:    xsi_set_current_line(352, ng0);
    t29 = (t0 + 1696);
    t30 = *((char **)t29);
    t29 = (t0 + 12696);
    xsi_vlogvar_wait_assign_value(t29, t30, 0, 0, 3, 0LL);
    xsi_set_current_line(353, ng0);
    t2 = ((char*)((ng16)));
    t3 = (t0 + 10936);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 768, 0LL);
    xsi_set_current_line(354, ng0);
    t2 = ((char*)((ng17)));
    t3 = (t0 + 11096);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 96, 0LL);
    xsi_set_current_line(355, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 11576);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 128, 0LL);
    xsi_set_current_line(356, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 11896);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(357, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 12216);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB14;

}

static void implSig1_execute(char *t0)
{
    char t3[112];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    t1 = (t0 + 14832U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 4136U);
    t4 = *((char **)t2);
    t2 = (t0 + 4296U);
    t5 = *((char **)t2);
    t2 = (t0 + 4456U);
    t6 = *((char **)t2);
    t2 = (t0 + 4936U);
    t7 = *((char **)t2);
    xsi_vlogtype_concat(t3, 417, 417, 4U, t7, 1, t6, 128, t5, 32, t4, 256);
    t2 = (t0 + 15872);
    t8 = (t2 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    xsi_vlog_bit_copy(t11, 0, t3, 0, 417);
    xsi_driver_vfirst_trans(t2, 0, 416);
    t12 = (t0 + 15696);
    *((int *)t12) = 1;

LAB1:    return;
}

static void implSig2_execute(char *t0)
{
    char t4[8];
    char t22[8];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    char *t26;
    char *t27;
    char *t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    char *t36;
    char *t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    int t46;
    int t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    char *t54;
    char *t55;
    char *t56;
    char *t57;
    char *t58;
    unsigned int t59;
    unsigned int t60;
    char *t61;
    unsigned int t62;
    unsigned int t63;
    char *t64;
    unsigned int t65;
    unsigned int t66;
    char *t67;

LAB0:    t1 = (t0 + 15080U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 4616U);
    t3 = *((char **)t2);
    t2 = (t0 + 9256U);
    t5 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t5 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 & 1U);
    if (t10 != 0)
        goto LAB7;

LAB5:    if (*((unsigned int *)t2) == 0)
        goto LAB4;

LAB6:    t11 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t11) = 1;

LAB7:    t12 = (t4 + 4);
    t13 = (t5 + 4);
    t14 = *((unsigned int *)t5);
    t15 = (~(t14));
    *((unsigned int *)t4) = t15;
    *((unsigned int *)t12) = 0;
    if (*((unsigned int *)t13) != 0)
        goto LAB9;

LAB8:    t20 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t20 & 1U);
    t21 = *((unsigned int *)t12);
    *((unsigned int *)t12) = (t21 & 1U);
    t23 = *((unsigned int *)t3);
    t24 = *((unsigned int *)t4);
    t25 = (t23 & t24);
    *((unsigned int *)t22) = t25;
    t26 = (t3 + 4);
    t27 = (t4 + 4);
    t28 = (t22 + 4);
    t29 = *((unsigned int *)t26);
    t30 = *((unsigned int *)t27);
    t31 = (t29 | t30);
    *((unsigned int *)t28) = t31;
    t32 = *((unsigned int *)t28);
    t33 = (t32 != 0);
    if (t33 == 1)
        goto LAB10;

LAB11:
LAB12:    t54 = (t0 + 15936);
    t55 = (t54 + 56U);
    t56 = *((char **)t55);
    t57 = (t56 + 56U);
    t58 = *((char **)t57);
    memset(t58, 0, 8);
    t59 = 1U;
    t60 = t59;
    t61 = (t22 + 4);
    t62 = *((unsigned int *)t22);
    t59 = (t59 & t62);
    t63 = *((unsigned int *)t61);
    t60 = (t60 & t63);
    t64 = (t58 + 4);
    t65 = *((unsigned int *)t58);
    *((unsigned int *)t58) = (t65 | t59);
    t66 = *((unsigned int *)t64);
    *((unsigned int *)t64) = (t66 | t60);
    xsi_driver_vfirst_trans(t54, 0, 0);
    t67 = (t0 + 15712);
    *((int *)t67) = 1;

LAB1:    return;
LAB4:    *((unsigned int *)t4) = 1;
    goto LAB7;

LAB9:    t16 = *((unsigned int *)t4);
    t17 = *((unsigned int *)t13);
    *((unsigned int *)t4) = (t16 | t17);
    t18 = *((unsigned int *)t12);
    t19 = *((unsigned int *)t13);
    *((unsigned int *)t12) = (t18 | t19);
    goto LAB8;

LAB10:    t34 = *((unsigned int *)t22);
    t35 = *((unsigned int *)t28);
    *((unsigned int *)t22) = (t34 | t35);
    t36 = (t3 + 4);
    t37 = (t4 + 4);
    t38 = *((unsigned int *)t3);
    t39 = (~(t38));
    t40 = *((unsigned int *)t36);
    t41 = (~(t40));
    t42 = *((unsigned int *)t4);
    t43 = (~(t42));
    t44 = *((unsigned int *)t37);
    t45 = (~(t44));
    t46 = (t39 & t41);
    t47 = (t43 & t45);
    t48 = (~(t46));
    t49 = (~(t47));
    t50 = *((unsigned int *)t28);
    *((unsigned int *)t28) = (t50 & t48);
    t51 = *((unsigned int *)t28);
    *((unsigned int *)t28) = (t51 & t49);
    t52 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t52 & t48);
    t53 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t53 & t49);
    goto LAB12;

}

static void implSig3_execute(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    unsigned int t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    char *t10;
    char *t11;
    char *t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    unsigned int t26;
    unsigned int t27;
    char *t28;
    unsigned int t29;
    unsigned int t30;
    char *t31;
    unsigned int t32;
    unsigned int t33;
    char *t34;

LAB0:    t1 = (t0 + 15328U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 3816U);
    t4 = *((char **)t2);
    memset(t3, 0, 8);
    t2 = (t4 + 4);
    t5 = *((unsigned int *)t2);
    t6 = (~(t5));
    t7 = *((unsigned int *)t4);
    t8 = (t7 & t6);
    t9 = (t8 & 1U);
    if (t9 != 0)
        goto LAB7;

LAB5:    if (*((unsigned int *)t2) == 0)
        goto LAB4;

LAB6:    t10 = (t3 + 4);
    *((unsigned int *)t3) = 1;
    *((unsigned int *)t10) = 1;

LAB7:    t11 = (t3 + 4);
    t12 = (t4 + 4);
    t13 = *((unsigned int *)t4);
    t14 = (~(t13));
    *((unsigned int *)t3) = t14;
    *((unsigned int *)t11) = 0;
    if (*((unsigned int *)t12) != 0)
        goto LAB9;

LAB8:    t19 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t19 & 1U);
    t20 = *((unsigned int *)t11);
    *((unsigned int *)t11) = (t20 & 1U);
    t21 = (t0 + 16000);
    t22 = (t21 + 56U);
    t23 = *((char **)t22);
    t24 = (t23 + 56U);
    t25 = *((char **)t24);
    memset(t25, 0, 8);
    t26 = 1U;
    t27 = t26;
    t28 = (t3 + 4);
    t29 = *((unsigned int *)t3);
    t26 = (t26 & t29);
    t30 = *((unsigned int *)t28);
    t27 = (t27 & t30);
    t31 = (t25 + 4);
    t32 = *((unsigned int *)t25);
    *((unsigned int *)t25) = (t32 | t26);
    t33 = *((unsigned int *)t31);
    *((unsigned int *)t31) = (t33 | t27);
    xsi_driver_vfirst_trans(t21, 0, 0);
    t34 = (t0 + 15728);
    *((int *)t34) = 1;

LAB1:    return;
LAB4:    *((unsigned int *)t3) = 1;
    goto LAB7;

LAB9:    t15 = *((unsigned int *)t3);
    t16 = *((unsigned int *)t12);
    *((unsigned int *)t3) = (t15 | t16);
    t17 = *((unsigned int *)t11);
    t18 = *((unsigned int *)t12);
    *((unsigned int *)t11) = (t17 | t18);
    goto LAB8;

}


extern void work_m_17320466824178783096_3985741992_init()
{
	static char *pe[] = {(void *)Cont_199_0,(void *)Always_201_1,(void *)Always_350_2,(void *)implSig1_execute,(void *)implSig2_execute,(void *)implSig3_execute};
	static char *se[] = {(void *)sp_log2};
	xsi_register_didat("work_m_17320466824178783096_3985741992", "isim/nf10_decap_tb.exe.sim/work/m_17320466824178783096_3985741992.didat");
	xsi_register_executes(pe);
	xsi_register_subprogram_executes(se);
}
