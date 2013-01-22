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
static const char *ng0 = "/home/gengyl08/workSpace/NetFPGA-10G-live/lib/hw/contrib/pcores/nf10_encap_v1_00_a/hdl/verilog/nf10_encap.v";
static int ng1[] = {0, 0};
static int ng2[] = {2, 0};
static int ng3[] = {1, 0};
static int ng4[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng5[] = {0, 0, 0, 0, 0, 0, 0, 0};
static unsigned int ng6[] = {4294967295U, 0U, 3U, 0U};
static int ng7[] = {127, 0};
static int ng8[] = {16, 0};
static int ng9[] = {34, 0};
static int ng10[] = {15, 0};
static int ng11[] = {271, 0};
static int ng12[] = {33, 0};
static int ng13[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
static int ng14[] = {0, 0, 0, 0};



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
    t4 = (t1 + 11784);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 32);
    xsi_set_current_line(103, ng0);

LAB3:    t3 = ((char*)((ng2)));
    t4 = (t1 + 11784);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memset(t7, 0, 8);
    xsi_vlog_signed_power(t7, 32, t3, 32, t6, 32, 1);
    t8 = (t1 + 11944);
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
    t18 = (t1 + 11784);
    t19 = (t18 + 56U);
    t20 = *((char **)t19);
    t21 = ((char*)((ng3)));
    memset(t22, 0, 8);
    xsi_vlog_signed_add(t22, 32, t20, 32, t21, 32);
    t23 = (t1 + 11784);
    xsi_vlogvar_assign_value(t23, t22, 0, 0, 32);
    goto LAB3;

}

static void Cont_188_0(char *t0)
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

LAB0:    t1 = (t0 + 12856U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(188, ng0);
    t2 = (t0 + 8984U);
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

LAB7:    t11 = (t0 + 14576);
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
    t24 = (t0 + 14416);
    *((int *)t24) = 1;

LAB1:    return;
LAB4:    *((unsigned int *)t3) = 1;
    goto LAB7;

}

static void Always_190_1(char *t0)
{
    char t8[8];
    char t41[64];
    char t42[32];
    char t43[8];
    char t44[8];
    char t52[8];
    char t53[8];
    char t90[8];
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
    int t45;
    int t46;
    int t47;
    int t48;
    int t49;
    int t50;
    int t51;
    char *t54;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    unsigned int t58;
    unsigned int t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    unsigned int t66;
    unsigned int t67;
    unsigned int t68;
    char *t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    unsigned int t73;
    unsigned int t74;
    char *t75;
    char *t76;
    char *t77;
    char *t78;
    unsigned int t79;
    unsigned int t80;
    unsigned int t81;
    char *t82;
    char *t83;
    unsigned int t84;
    unsigned int t85;
    unsigned int t86;
    unsigned int t87;
    unsigned int t88;
    char *t89;
    unsigned int t91;
    unsigned int t92;
    unsigned int t93;
    char *t94;
    char *t95;
    char *t96;
    unsigned int t97;
    unsigned int t98;
    unsigned int t99;
    unsigned int t100;
    unsigned int t101;
    unsigned int t102;
    unsigned int t103;
    char *t104;
    char *t105;
    unsigned int t106;
    unsigned int t107;
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
    char *t120;
    unsigned int t121;
    unsigned int t122;
    unsigned int t123;
    unsigned int t124;
    unsigned int t125;
    char *t126;
    char *t127;

LAB0:    t1 = (t0 + 13104U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(190, ng0);
    t2 = (t0 + 14432);
    *((int *)t2) = 1;
    t3 = (t0 + 13136);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(190, ng0);

LAB5:    xsi_set_current_line(191, ng0);
    t4 = ((char*)((ng1)));
    t5 = (t0 + 11304);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 1);
    xsi_set_current_line(193, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 9864);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 256);
    xsi_set_current_line(194, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 10024);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(195, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 10184);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 128);
    xsi_set_current_line(196, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 10344);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(197, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 10504);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(199, ng0);
    t2 = (t0 + 10664);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 10984);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 272);
    xsi_set_current_line(200, ng0);
    t2 = (t0 + 10824);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 11144);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 34);
    xsi_set_current_line(202, ng0);
    t2 = (t0 + 11464);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 11624);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 3);
    xsi_set_current_line(204, ng0);
    t2 = (t0 + 11464);
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

LAB7:    xsi_set_current_line(205, ng0);

LAB18:    xsi_set_current_line(206, ng0);
    t5 = (t0 + 8184U);
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

LAB9:    xsi_set_current_line(218, ng0);

LAB34:    xsi_set_current_line(219, ng0);
    t2 = (t0 + 8184U);
    t5 = *((char **)t2);
    memset(t8, 0, 8);
    t2 = (t5 + 4);
    t10 = *((unsigned int *)t2);
    t11 = (~(t10));
    t12 = *((unsigned int *)t5);
    t13 = (t12 & t11);
    t14 = (t13 & 1U);
    if (t14 != 0)
        goto LAB38;

LAB36:    if (*((unsigned int *)t2) == 0)
        goto LAB35;

LAB37:    t6 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t6) = 1;

LAB38:    t9 = (t0 + 10344);
    xsi_vlogvar_assign_value(t9, t8, 0, 0, 1);
    xsi_set_current_line(220, ng0);
    t2 = (t0 + 10664);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    xsi_vlog_get_part_select_value(t41, 256, t5, 255, 0);
    t6 = (t0 + 9864);
    xsi_vlogvar_assign_value(t6, t41, 0, 0, 256);
    xsi_set_current_line(221, ng0);
    t2 = (t0 + 10824);
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
    t15 = (t0 + 10024);
    xsi_vlogvar_assign_value(t15, t8, 0, 0, 32);
    xsi_set_current_line(222, ng0);
    t2 = (t0 + 8664U);
    t3 = *((char **)t2);
    xsi_vlog_get_part_select_value(t42, 112, t3, 127, 16);
    t2 = (t0 + 10184);
    t5 = (t0 + 10184);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng7)));
    t16 = ((char*)((ng8)));
    xsi_vlog_convert_partindices(t8, t43, t44, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t43 + 4);
    t11 = *((unsigned int *)t26);
    t45 = (!(t11));
    t46 = (t7 && t45);
    t32 = (t44 + 4);
    t12 = *((unsigned int *)t32);
    t47 = (!(t12));
    t48 = (t46 && t47);
    if (t48 == 1)
        goto LAB39;

LAB40:    xsi_set_current_line(223, ng0);
    t2 = (t0 + 8664U);
    t3 = *((char **)t2);
    memset(t8, 0, 8);
    t2 = (t8 + 4);
    t5 = (t3 + 4);
    t10 = *((unsigned int *)t3);
    t11 = (t10 >> 0);
    *((unsigned int *)t8) = t11;
    t12 = *((unsigned int *)t5);
    t13 = (t12 >> 0);
    *((unsigned int *)t2) = t13;
    t14 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t14 & 65535U);
    t18 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t18 & 65535U);
    t6 = ((char*)((ng9)));
    memset(t43, 0, 8);
    xsi_vlog_unsigned_add(t43, 32, t8, 32, t6, 32);
    t9 = (t0 + 10184);
    t15 = (t0 + 10184);
    t16 = (t15 + 72U);
    t17 = *((char **)t16);
    t26 = ((char*)((ng10)));
    t32 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t44, t52, t53, ((int*)(t17)), 2, t26, 32, 1, t32, 32, 1);
    t33 = (t44 + 4);
    t19 = *((unsigned int *)t33);
    t7 = (!(t19));
    t39 = (t52 + 4);
    t20 = *((unsigned int *)t39);
    t45 = (!(t20));
    t46 = (t7 && t45);
    t40 = (t53 + 4);
    t21 = *((unsigned int *)t40);
    t47 = (!(t21));
    t48 = (t46 && t47);
    if (t48 == 1)
        goto LAB41;

LAB42:    xsi_set_current_line(225, ng0);
    t2 = (t0 + 10344);
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
        goto LAB43;

LAB44:    if (*((unsigned int *)t6) != 0)
        goto LAB45;

LAB46:    t15 = (t8 + 4);
    t18 = *((unsigned int *)t8);
    t19 = *((unsigned int *)t15);
    t20 = (t18 || t19);
    if (t20 > 0)
        goto LAB47;

LAB48:    memcpy(t44, t8, 8);

LAB49:    t69 = (t44 + 4);
    t70 = *((unsigned int *)t69);
    t71 = (~(t70));
    t72 = *((unsigned int *)t44);
    t73 = (t72 & t71);
    t74 = (t73 != 0);
    if (t74 > 0)
        goto LAB57;

LAB58:
LAB59:    goto LAB17;

LAB11:    xsi_set_current_line(235, ng0);

LAB69:    xsi_set_current_line(236, ng0);
    t2 = (t0 + 8184U);
    t5 = *((char **)t2);
    memset(t8, 0, 8);
    t2 = (t5 + 4);
    t10 = *((unsigned int *)t2);
    t11 = (~(t10));
    t12 = *((unsigned int *)t5);
    t13 = (t12 & t11);
    t14 = (t13 & 1U);
    if (t14 != 0)
        goto LAB73;

LAB71:    if (*((unsigned int *)t2) == 0)
        goto LAB70;

LAB72:    t6 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t6) = 1;

LAB73:    t9 = (t0 + 10344);
    xsi_vlogvar_assign_value(t9, t8, 0, 0, 1);
    xsi_set_current_line(237, ng0);
    t2 = (t0 + 10664);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    xsi_vlog_get_part_select_value(t41, 256, t5, 255, 0);
    t6 = (t0 + 9864);
    xsi_vlogvar_assign_value(t6, t41, 0, 0, 256);
    xsi_set_current_line(238, ng0);
    t2 = (t0 + 10824);
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
    t15 = (t0 + 10024);
    xsi_vlogvar_assign_value(t15, t8, 0, 0, 32);
    xsi_set_current_line(239, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 10184);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 128);
    xsi_set_current_line(241, ng0);
    t2 = (t0 + 10344);
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
        goto LAB74;

LAB75:    if (*((unsigned int *)t6) != 0)
        goto LAB76;

LAB77:    t15 = (t8 + 4);
    t18 = *((unsigned int *)t8);
    t19 = *((unsigned int *)t15);
    t20 = (t18 || t19);
    if (t20 > 0)
        goto LAB78;

LAB79:    memcpy(t44, t8, 8);

LAB80:    t69 = (t44 + 4);
    t70 = *((unsigned int *)t69);
    t71 = (~(t70));
    t72 = *((unsigned int *)t44);
    t73 = (t72 & t71);
    t74 = (t73 != 0);
    if (t74 > 0)
        goto LAB88;

LAB89:
LAB90:    goto LAB17;

LAB13:    xsi_set_current_line(253, ng0);

LAB104:    xsi_set_current_line(254, ng0);
    t2 = ((char*)((ng3)));
    t5 = (t0 + 10344);
    xsi_vlogvar_assign_value(t5, t2, 0, 0, 1);
    xsi_set_current_line(255, ng0);
    t2 = (t0 + 10664);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    xsi_vlog_get_part_select_value(t41, 256, t5, 255, 0);
    t6 = (t0 + 9864);
    xsi_vlogvar_assign_value(t6, t41, 0, 0, 256);
    xsi_set_current_line(256, ng0);
    t2 = (t0 + 10824);
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
    t15 = (t0 + 10024);
    xsi_vlogvar_assign_value(t15, t8, 0, 0, 32);
    xsi_set_current_line(257, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 10184);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 128);
    xsi_set_current_line(259, ng0);
    t2 = (t0 + 3704U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t10 = *((unsigned int *)t2);
    t11 = (~(t10));
    t12 = *((unsigned int *)t3);
    t13 = (t12 & t11);
    t14 = (t13 != 0);
    if (t14 > 0)
        goto LAB105;

LAB106:
LAB107:    goto LAB17;

LAB15:    xsi_set_current_line(273, ng0);

LAB127:    xsi_set_current_line(274, ng0);
    t2 = (t0 + 8184U);
    t5 = *((char **)t2);
    memset(t8, 0, 8);
    t2 = (t5 + 4);
    t10 = *((unsigned int *)t2);
    t11 = (~(t10));
    t12 = *((unsigned int *)t5);
    t13 = (t12 & t11);
    t14 = (t13 & 1U);
    if (t14 != 0)
        goto LAB131;

LAB129:    if (*((unsigned int *)t2) == 0)
        goto LAB128;

LAB130:    t6 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t6) = 1;

LAB131:    t9 = (t0 + 10344);
    xsi_vlogvar_assign_value(t9, t8, 0, 0, 1);
    xsi_set_current_line(275, ng0);
    t2 = (t0 + 8344U);
    t3 = *((char **)t2);
    t2 = (t0 + 9864);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 256);
    xsi_set_current_line(276, ng0);
    t2 = (t0 + 8664U);
    t3 = *((char **)t2);
    t2 = (t0 + 10184);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 128);
    xsi_set_current_line(277, ng0);
    t2 = (t0 + 8504U);
    t3 = *((char **)t2);
    t2 = (t0 + 10024);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 32);
    xsi_set_current_line(278, ng0);
    t2 = (t0 + 8824U);
    t3 = *((char **)t2);
    t2 = (t0 + 10504);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(279, ng0);
    t2 = (t0 + 10344);
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
        goto LAB132;

LAB133:    if (*((unsigned int *)t6) != 0)
        goto LAB134;

LAB135:    t15 = (t8 + 4);
    t18 = *((unsigned int *)t8);
    t19 = *((unsigned int *)t15);
    t20 = (t18 || t19);
    if (t20 > 0)
        goto LAB136;

LAB137:    memcpy(t44, t8, 8);

LAB138:    t69 = (t0 + 11304);
    xsi_vlogvar_assign_value(t69, t44, 0, 0, 1);
    xsi_set_current_line(280, ng0);
    t2 = (t0 + 10344);
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
        goto LAB146;

LAB147:    if (*((unsigned int *)t6) != 0)
        goto LAB148;

LAB149:    t15 = (t8 + 4);
    t18 = *((unsigned int *)t8);
    t19 = *((unsigned int *)t15);
    t20 = (t18 || t19);
    if (t20 > 0)
        goto LAB150;

LAB151:    memcpy(t44, t8, 8);

LAB152:    memset(t52, 0, 8);
    t76 = (t44 + 4);
    t70 = *((unsigned int *)t76);
    t71 = (~(t70));
    t72 = *((unsigned int *)t44);
    t73 = (t72 & t71);
    t74 = (t73 & 1U);
    if (t74 != 0)
        goto LAB160;

LAB161:    if (*((unsigned int *)t76) != 0)
        goto LAB162;

LAB163:    t78 = (t52 + 4);
    t79 = *((unsigned int *)t52);
    t80 = *((unsigned int *)t78);
    t81 = (t79 || t80);
    if (t81 > 0)
        goto LAB164;

LAB165:    memcpy(t90, t52, 8);

LAB166:    t120 = (t90 + 4);
    t121 = *((unsigned int *)t120);
    t122 = (~(t121));
    t123 = *((unsigned int *)t90);
    t124 = (t123 & t122);
    t125 = (t124 != 0);
    if (t125 > 0)
        goto LAB174;

LAB175:
LAB176:    goto LAB17;

LAB19:    *((unsigned int *)t8) = 1;
    goto LAB22;

LAB24:    t20 = *((unsigned int *)t8);
    t21 = *((unsigned int *)t17);
    *((unsigned int *)t8) = (t20 | t21);
    t22 = *((unsigned int *)t16);
    t23 = *((unsigned int *)t17);
    *((unsigned int *)t16) = (t22 | t23);
    goto LAB23;

LAB25:    xsi_set_current_line(206, ng0);

LAB28:    xsi_set_current_line(207, ng0);
    t32 = (t0 + 8024U);
    t33 = *((char **)t32);
    t32 = (t33 + 4);
    t34 = *((unsigned int *)t32);
    t35 = (~(t34));
    t36 = *((unsigned int *)t33);
    t37 = (t36 & t35);
    t38 = (t37 != 0);
    if (t38 > 0)
        goto LAB29;

LAB30:    xsi_set_current_line(212, ng0);

LAB33:    xsi_set_current_line(213, ng0);
    t2 = (t0 + 2240);
    t3 = *((char **)t2);
    t2 = (t0 + 11624);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 3);

LAB31:    goto LAB27;

LAB29:    xsi_set_current_line(207, ng0);

LAB32:    xsi_set_current_line(208, ng0);
    t39 = (t0 + 7864U);
    t40 = *((char **)t39);
    t39 = (t0 + 10984);
    xsi_vlogvar_assign_value(t39, t40, 0, 0, 272);
    xsi_set_current_line(209, ng0);
    t2 = ((char*)((ng6)));
    t3 = (t0 + 11144);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 34);
    xsi_set_current_line(210, ng0);
    t2 = (t0 + 1832);
    t3 = *((char **)t2);
    t2 = (t0 + 11624);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 3);
    goto LAB31;

LAB35:    *((unsigned int *)t8) = 1;
    goto LAB38;

LAB39:    t13 = *((unsigned int *)t44);
    t49 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t43);
    t50 = (t14 - t18);
    t51 = (t50 + 1);
    xsi_vlogvar_assign_value(t2, t42, t49, *((unsigned int *)t43), t51);
    goto LAB40;

LAB41:    t22 = *((unsigned int *)t53);
    t49 = (t22 + 0);
    t23 = *((unsigned int *)t44);
    t24 = *((unsigned int *)t52);
    t50 = (t23 - t24);
    t51 = (t50 + 1);
    xsi_vlogvar_assign_value(t9, t43, t49, *((unsigned int *)t52), t51);
    goto LAB42;

LAB43:    *((unsigned int *)t8) = 1;
    goto LAB46;

LAB45:    t9 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t9) = 1;
    goto LAB46;

LAB47:    t16 = (t0 + 3704U);
    t17 = *((char **)t16);
    memset(t43, 0, 8);
    t16 = (t17 + 4);
    t21 = *((unsigned int *)t16);
    t22 = (~(t21));
    t23 = *((unsigned int *)t17);
    t24 = (t23 & t22);
    t25 = (t24 & 1U);
    if (t25 != 0)
        goto LAB50;

LAB51:    if (*((unsigned int *)t16) != 0)
        goto LAB52;

LAB53:    t27 = *((unsigned int *)t8);
    t28 = *((unsigned int *)t43);
    t29 = (t27 & t28);
    *((unsigned int *)t44) = t29;
    t32 = (t8 + 4);
    t33 = (t43 + 4);
    t39 = (t44 + 4);
    t30 = *((unsigned int *)t32);
    t31 = *((unsigned int *)t33);
    t34 = (t30 | t31);
    *((unsigned int *)t39) = t34;
    t35 = *((unsigned int *)t39);
    t36 = (t35 != 0);
    if (t36 == 1)
        goto LAB54;

LAB55:
LAB56:    goto LAB49;

LAB50:    *((unsigned int *)t43) = 1;
    goto LAB53;

LAB52:    t26 = (t43 + 4);
    *((unsigned int *)t43) = 1;
    *((unsigned int *)t26) = 1;
    goto LAB53;

LAB54:    t37 = *((unsigned int *)t44);
    t38 = *((unsigned int *)t39);
    *((unsigned int *)t44) = (t37 | t38);
    t40 = (t8 + 4);
    t54 = (t43 + 4);
    t55 = *((unsigned int *)t8);
    t56 = (~(t55));
    t57 = *((unsigned int *)t40);
    t58 = (~(t57));
    t59 = *((unsigned int *)t43);
    t60 = (~(t59));
    t61 = *((unsigned int *)t54);
    t62 = (~(t61));
    t7 = (t56 & t58);
    t45 = (t60 & t62);
    t63 = (~(t7));
    t64 = (~(t45));
    t65 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t65 & t63);
    t66 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t66 & t64);
    t67 = *((unsigned int *)t44);
    *((unsigned int *)t44) = (t67 & t63);
    t68 = *((unsigned int *)t44);
    *((unsigned int *)t44) = (t68 & t64);
    goto LAB56;

LAB57:    xsi_set_current_line(225, ng0);

LAB60:    xsi_set_current_line(226, ng0);
    t75 = ((char*)((ng3)));
    t76 = (t0 + 11304);
    xsi_vlogvar_assign_value(t76, t75, 0, 0, 1);
    xsi_set_current_line(227, ng0);
    t2 = (t0 + 10664);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t8, 0, 8);
    t6 = (t8 + 4);
    t9 = (t5 + 64);
    t15 = (t5 + 68);
    t10 = *((unsigned int *)t9);
    t11 = (t10 >> 0);
    *((unsigned int *)t8) = t11;
    t12 = *((unsigned int *)t15);
    t13 = (t12 >> 0);
    *((unsigned int *)t6) = t13;
    t14 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t14 & 65535U);
    t18 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t18 & 65535U);
    t16 = (t0 + 10984);
    t17 = (t0 + 10984);
    t26 = (t17 + 72U);
    t32 = *((char **)t26);
    t33 = ((char*)((ng10)));
    t39 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t43, t44, t52, ((int*)(t32)), 2, t33, 32, 1, t39, 32, 1);
    t40 = (t43 + 4);
    t19 = *((unsigned int *)t40);
    t7 = (!(t19));
    t54 = (t44 + 4);
    t20 = *((unsigned int *)t54);
    t45 = (!(t20));
    t46 = (t7 && t45);
    t69 = (t52 + 4);
    t21 = *((unsigned int *)t69);
    t47 = (!(t21));
    t48 = (t46 && t47);
    if (t48 == 1)
        goto LAB61;

LAB62:    xsi_set_current_line(228, ng0);
    t2 = (t0 + 8344U);
    t3 = *((char **)t2);
    t2 = (t0 + 10984);
    t5 = (t0 + 10984);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng11)));
    t16 = ((char*)((ng8)));
    xsi_vlog_convert_partindices(t8, t43, t44, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t43 + 4);
    t11 = *((unsigned int *)t26);
    t45 = (!(t11));
    t46 = (t7 && t45);
    t32 = (t44 + 4);
    t12 = *((unsigned int *)t32);
    t47 = (!(t12));
    t48 = (t46 && t47);
    if (t48 == 1)
        goto LAB63;

LAB64:    xsi_set_current_line(229, ng0);
    t2 = (t0 + 10824);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t8, 0, 8);
    t6 = (t8 + 4);
    t9 = (t5 + 8);
    t15 = (t5 + 12);
    t10 = *((unsigned int *)t9);
    t11 = (t10 >> 0);
    *((unsigned int *)t8) = t11;
    t12 = *((unsigned int *)t15);
    t13 = (t12 >> 0);
    *((unsigned int *)t6) = t13;
    t14 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t14 & 3U);
    t18 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t18 & 3U);
    t16 = (t0 + 11144);
    t17 = (t0 + 11144);
    t26 = (t17 + 72U);
    t32 = *((char **)t26);
    t33 = ((char*)((ng3)));
    t39 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t43, t44, t52, ((int*)(t32)), 2, t33, 32, 1, t39, 32, 1);
    t40 = (t43 + 4);
    t19 = *((unsigned int *)t40);
    t7 = (!(t19));
    t54 = (t44 + 4);
    t20 = *((unsigned int *)t54);
    t45 = (!(t20));
    t46 = (t7 && t45);
    t69 = (t52 + 4);
    t21 = *((unsigned int *)t69);
    t47 = (!(t21));
    t48 = (t46 && t47);
    if (t48 == 1)
        goto LAB65;

LAB66:    xsi_set_current_line(230, ng0);
    t2 = (t0 + 8504U);
    t3 = *((char **)t2);
    t2 = (t0 + 11144);
    t5 = (t0 + 11144);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng12)));
    t16 = ((char*)((ng2)));
    xsi_vlog_convert_partindices(t8, t43, t44, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t43 + 4);
    t11 = *((unsigned int *)t26);
    t45 = (!(t11));
    t46 = (t7 && t45);
    t32 = (t44 + 4);
    t12 = *((unsigned int *)t32);
    t47 = (!(t12));
    t48 = (t46 && t47);
    if (t48 == 1)
        goto LAB67;

LAB68:    xsi_set_current_line(231, ng0);
    t2 = (t0 + 1968);
    t3 = *((char **)t2);
    t2 = (t0 + 11624);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 3);
    goto LAB59;

LAB61:    t22 = *((unsigned int *)t52);
    t49 = (t22 + 0);
    t23 = *((unsigned int *)t43);
    t24 = *((unsigned int *)t44);
    t50 = (t23 - t24);
    t51 = (t50 + 1);
    xsi_vlogvar_assign_value(t16, t8, t49, *((unsigned int *)t44), t51);
    goto LAB62;

LAB63:    t13 = *((unsigned int *)t44);
    t49 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t43);
    t50 = (t14 - t18);
    t51 = (t50 + 1);
    xsi_vlogvar_assign_value(t2, t3, t49, *((unsigned int *)t43), t51);
    goto LAB64;

LAB65:    t22 = *((unsigned int *)t52);
    t49 = (t22 + 0);
    t23 = *((unsigned int *)t43);
    t24 = *((unsigned int *)t44);
    t50 = (t23 - t24);
    t51 = (t50 + 1);
    xsi_vlogvar_assign_value(t16, t8, t49, *((unsigned int *)t44), t51);
    goto LAB66;

LAB67:    t13 = *((unsigned int *)t44);
    t49 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t43);
    t50 = (t14 - t18);
    t51 = (t50 + 1);
    xsi_vlogvar_assign_value(t2, t3, t49, *((unsigned int *)t43), t51);
    goto LAB68;

LAB70:    *((unsigned int *)t8) = 1;
    goto LAB73;

LAB74:    *((unsigned int *)t8) = 1;
    goto LAB77;

LAB76:    t9 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t9) = 1;
    goto LAB77;

LAB78:    t16 = (t0 + 3704U);
    t17 = *((char **)t16);
    memset(t43, 0, 8);
    t16 = (t17 + 4);
    t21 = *((unsigned int *)t16);
    t22 = (~(t21));
    t23 = *((unsigned int *)t17);
    t24 = (t23 & t22);
    t25 = (t24 & 1U);
    if (t25 != 0)
        goto LAB81;

LAB82:    if (*((unsigned int *)t16) != 0)
        goto LAB83;

LAB84:    t27 = *((unsigned int *)t8);
    t28 = *((unsigned int *)t43);
    t29 = (t27 & t28);
    *((unsigned int *)t44) = t29;
    t32 = (t8 + 4);
    t33 = (t43 + 4);
    t39 = (t44 + 4);
    t30 = *((unsigned int *)t32);
    t31 = *((unsigned int *)t33);
    t34 = (t30 | t31);
    *((unsigned int *)t39) = t34;
    t35 = *((unsigned int *)t39);
    t36 = (t35 != 0);
    if (t36 == 1)
        goto LAB85;

LAB86:
LAB87:    goto LAB80;

LAB81:    *((unsigned int *)t43) = 1;
    goto LAB84;

LAB83:    t26 = (t43 + 4);
    *((unsigned int *)t43) = 1;
    *((unsigned int *)t26) = 1;
    goto LAB84;

LAB85:    t37 = *((unsigned int *)t44);
    t38 = *((unsigned int *)t39);
    *((unsigned int *)t44) = (t37 | t38);
    t40 = (t8 + 4);
    t54 = (t43 + 4);
    t55 = *((unsigned int *)t8);
    t56 = (~(t55));
    t57 = *((unsigned int *)t40);
    t58 = (~(t57));
    t59 = *((unsigned int *)t43);
    t60 = (~(t59));
    t61 = *((unsigned int *)t54);
    t62 = (~(t61));
    t7 = (t56 & t58);
    t45 = (t60 & t62);
    t63 = (~(t7));
    t64 = (~(t45));
    t65 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t65 & t63);
    t66 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t66 & t64);
    t67 = *((unsigned int *)t44);
    *((unsigned int *)t44) = (t67 & t63);
    t68 = *((unsigned int *)t44);
    *((unsigned int *)t44) = (t68 & t64);
    goto LAB87;

LAB88:    xsi_set_current_line(241, ng0);

LAB91:    xsi_set_current_line(242, ng0);
    t75 = ((char*)((ng3)));
    t76 = (t0 + 11304);
    xsi_vlogvar_assign_value(t76, t75, 0, 0, 1);
    xsi_set_current_line(243, ng0);
    t2 = (t0 + 10664);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t8, 0, 8);
    t6 = (t8 + 4);
    t9 = (t5 + 64);
    t15 = (t5 + 68);
    t10 = *((unsigned int *)t9);
    t11 = (t10 >> 0);
    *((unsigned int *)t8) = t11;
    t12 = *((unsigned int *)t15);
    t13 = (t12 >> 0);
    *((unsigned int *)t6) = t13;
    t14 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t14 & 65535U);
    t18 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t18 & 65535U);
    t16 = (t0 + 10984);
    t17 = (t0 + 10984);
    t26 = (t17 + 72U);
    t32 = *((char **)t26);
    t33 = ((char*)((ng10)));
    t39 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t43, t44, t52, ((int*)(t32)), 2, t33, 32, 1, t39, 32, 1);
    t40 = (t43 + 4);
    t19 = *((unsigned int *)t40);
    t7 = (!(t19));
    t54 = (t44 + 4);
    t20 = *((unsigned int *)t54);
    t45 = (!(t20));
    t46 = (t7 && t45);
    t69 = (t52 + 4);
    t21 = *((unsigned int *)t69);
    t47 = (!(t21));
    t48 = (t46 && t47);
    if (t48 == 1)
        goto LAB92;

LAB93:    xsi_set_current_line(244, ng0);
    t2 = (t0 + 8344U);
    t3 = *((char **)t2);
    t2 = (t0 + 10984);
    t5 = (t0 + 10984);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng11)));
    t16 = ((char*)((ng8)));
    xsi_vlog_convert_partindices(t8, t43, t44, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t43 + 4);
    t11 = *((unsigned int *)t26);
    t45 = (!(t11));
    t46 = (t7 && t45);
    t32 = (t44 + 4);
    t12 = *((unsigned int *)t32);
    t47 = (!(t12));
    t48 = (t46 && t47);
    if (t48 == 1)
        goto LAB94;

LAB95:    xsi_set_current_line(245, ng0);
    t2 = (t0 + 10824);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t8, 0, 8);
    t6 = (t8 + 4);
    t9 = (t5 + 8);
    t15 = (t5 + 12);
    t10 = *((unsigned int *)t9);
    t11 = (t10 >> 0);
    *((unsigned int *)t8) = t11;
    t12 = *((unsigned int *)t15);
    t13 = (t12 >> 0);
    *((unsigned int *)t6) = t13;
    t14 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t14 & 3U);
    t18 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t18 & 3U);
    t16 = (t0 + 11144);
    t17 = (t0 + 11144);
    t26 = (t17 + 72U);
    t32 = *((char **)t26);
    t33 = ((char*)((ng3)));
    t39 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t43, t44, t52, ((int*)(t32)), 2, t33, 32, 1, t39, 32, 1);
    t40 = (t43 + 4);
    t19 = *((unsigned int *)t40);
    t7 = (!(t19));
    t54 = (t44 + 4);
    t20 = *((unsigned int *)t54);
    t45 = (!(t20));
    t46 = (t7 && t45);
    t69 = (t52 + 4);
    t21 = *((unsigned int *)t69);
    t47 = (!(t21));
    t48 = (t46 && t47);
    if (t48 == 1)
        goto LAB96;

LAB97:    xsi_set_current_line(246, ng0);
    t2 = (t0 + 8504U);
    t3 = *((char **)t2);
    t2 = (t0 + 11144);
    t5 = (t0 + 11144);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng12)));
    t16 = ((char*)((ng2)));
    xsi_vlog_convert_partindices(t8, t43, t44, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t43 + 4);
    t11 = *((unsigned int *)t26);
    t45 = (!(t11));
    t46 = (t7 && t45);
    t32 = (t44 + 4);
    t12 = *((unsigned int *)t32);
    t47 = (!(t12));
    t48 = (t46 && t47);
    if (t48 == 1)
        goto LAB98;

LAB99:    xsi_set_current_line(247, ng0);
    t2 = (t0 + 8824U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t10 = *((unsigned int *)t2);
    t11 = (~(t10));
    t12 = *((unsigned int *)t3);
    t13 = (t12 & t11);
    t14 = (t13 != 0);
    if (t14 > 0)
        goto LAB100;

LAB101:
LAB102:    goto LAB90;

LAB92:    t22 = *((unsigned int *)t52);
    t49 = (t22 + 0);
    t23 = *((unsigned int *)t43);
    t24 = *((unsigned int *)t44);
    t50 = (t23 - t24);
    t51 = (t50 + 1);
    xsi_vlogvar_assign_value(t16, t8, t49, *((unsigned int *)t44), t51);
    goto LAB93;

LAB94:    t13 = *((unsigned int *)t44);
    t49 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t43);
    t50 = (t14 - t18);
    t51 = (t50 + 1);
    xsi_vlogvar_assign_value(t2, t3, t49, *((unsigned int *)t43), t51);
    goto LAB95;

LAB96:    t22 = *((unsigned int *)t52);
    t49 = (t22 + 0);
    t23 = *((unsigned int *)t43);
    t24 = *((unsigned int *)t44);
    t50 = (t23 - t24);
    t51 = (t50 + 1);
    xsi_vlogvar_assign_value(t16, t8, t49, *((unsigned int *)t44), t51);
    goto LAB97;

LAB98:    t13 = *((unsigned int *)t44);
    t49 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t43);
    t50 = (t14 - t18);
    t51 = (t50 + 1);
    xsi_vlogvar_assign_value(t2, t3, t49, *((unsigned int *)t43), t51);
    goto LAB99;

LAB100:    xsi_set_current_line(247, ng0);

LAB103:    xsi_set_current_line(248, ng0);
    t5 = (t0 + 2104);
    t6 = *((char **)t5);
    t5 = (t0 + 11624);
    xsi_vlogvar_assign_value(t5, t6, 0, 0, 3);
    goto LAB102;

LAB105:    xsi_set_current_line(259, ng0);

LAB108:    xsi_set_current_line(261, ng0);
    t5 = (t0 + 10664);
    t6 = (t5 + 56U);
    t9 = *((char **)t6);
    memset(t8, 0, 8);
    t15 = (t8 + 4);
    t16 = (t9 + 64);
    t17 = (t9 + 68);
    t18 = *((unsigned int *)t16);
    t19 = (t18 >> 0);
    *((unsigned int *)t8) = t19;
    t20 = *((unsigned int *)t17);
    t21 = (t20 >> 0);
    *((unsigned int *)t15) = t21;
    t22 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t22 & 65535U);
    t23 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t23 & 65535U);
    t26 = (t0 + 10984);
    t32 = (t0 + 10984);
    t33 = (t32 + 72U);
    t39 = *((char **)t33);
    t40 = ((char*)((ng10)));
    t54 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t43, t44, t52, ((int*)(t39)), 2, t40, 32, 1, t54, 32, 1);
    t69 = (t43 + 4);
    t24 = *((unsigned int *)t69);
    t7 = (!(t24));
    t75 = (t44 + 4);
    t25 = *((unsigned int *)t75);
    t45 = (!(t25));
    t46 = (t7 && t45);
    t76 = (t52 + 4);
    t27 = *((unsigned int *)t76);
    t47 = (!(t27));
    t48 = (t46 && t47);
    if (t48 == 1)
        goto LAB109;

LAB110:    xsi_set_current_line(262, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 10984);
    t5 = (t0 + 10984);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng11)));
    t16 = ((char*)((ng8)));
    xsi_vlog_convert_partindices(t8, t43, t44, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t43 + 4);
    t11 = *((unsigned int *)t26);
    t45 = (!(t11));
    t46 = (t7 && t45);
    t32 = (t44 + 4);
    t12 = *((unsigned int *)t32);
    t47 = (!(t12));
    t48 = (t46 && t47);
    if (t48 == 1)
        goto LAB111;

LAB112:    xsi_set_current_line(263, ng0);
    t2 = (t0 + 10824);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t8, 0, 8);
    t6 = (t8 + 4);
    t9 = (t5 + 8);
    t15 = (t5 + 12);
    t10 = *((unsigned int *)t9);
    t11 = (t10 >> 0);
    *((unsigned int *)t8) = t11;
    t12 = *((unsigned int *)t15);
    t13 = (t12 >> 0);
    *((unsigned int *)t6) = t13;
    t14 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t14 & 3U);
    t18 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t18 & 3U);
    t16 = (t0 + 11144);
    t17 = (t0 + 11144);
    t26 = (t17 + 72U);
    t32 = *((char **)t26);
    t33 = ((char*)((ng3)));
    t39 = ((char*)((ng1)));
    xsi_vlog_convert_partindices(t43, t44, t52, ((int*)(t32)), 2, t33, 32, 1, t39, 32, 1);
    t40 = (t43 + 4);
    t19 = *((unsigned int *)t40);
    t7 = (!(t19));
    t54 = (t44 + 4);
    t20 = *((unsigned int *)t54);
    t45 = (!(t20));
    t46 = (t7 && t45);
    t69 = (t52 + 4);
    t21 = *((unsigned int *)t69);
    t47 = (!(t21));
    t48 = (t46 && t47);
    if (t48 == 1)
        goto LAB113;

LAB114:    xsi_set_current_line(264, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 11144);
    t5 = (t0 + 11144);
    t6 = (t5 + 72U);
    t9 = *((char **)t6);
    t15 = ((char*)((ng12)));
    t16 = ((char*)((ng2)));
    xsi_vlog_convert_partindices(t8, t43, t44, ((int*)(t9)), 2, t15, 32, 1, t16, 32, 1);
    t17 = (t8 + 4);
    t10 = *((unsigned int *)t17);
    t7 = (!(t10));
    t26 = (t43 + 4);
    t11 = *((unsigned int *)t26);
    t45 = (!(t11));
    t46 = (t7 && t45);
    t32 = (t44 + 4);
    t12 = *((unsigned int *)t32);
    t47 = (!(t12));
    t48 = (t46 && t47);
    if (t48 == 1)
        goto LAB115;

LAB116:    xsi_set_current_line(265, ng0);
    t2 = (t0 + 11144);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    memset(t43, 0, 8);
    t6 = (t43 + 4);
    t9 = (t5 + 4);
    t10 = *((unsigned int *)t5);
    t11 = (t10 >> 0);
    t12 = (t11 & 1);
    *((unsigned int *)t43) = t12;
    t13 = *((unsigned int *)t9);
    t14 = (t13 >> 0);
    t18 = (t14 & 1);
    *((unsigned int *)t6) = t18;
    memset(t8, 0, 8);
    t15 = (t43 + 4);
    t19 = *((unsigned int *)t15);
    t20 = (~(t19));
    t21 = *((unsigned int *)t43);
    t22 = (t21 & t20);
    t23 = (t22 & 1U);
    if (t23 != 0)
        goto LAB120;

LAB118:    if (*((unsigned int *)t15) == 0)
        goto LAB117;

LAB119:    t16 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t16) = 1;

LAB120:    t17 = (t8 + 4);
    t26 = (t43 + 4);
    t24 = *((unsigned int *)t43);
    t25 = (~(t24));
    *((unsigned int *)t8) = t25;
    *((unsigned int *)t17) = 0;
    if (*((unsigned int *)t26) != 0)
        goto LAB122;

LAB121:    t31 = *((unsigned int *)t8);
    *((unsigned int *)t8) = (t31 & 1U);
    t34 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t34 & 1U);
    t32 = (t8 + 4);
    t35 = *((unsigned int *)t32);
    t36 = (~(t35));
    t37 = *((unsigned int *)t8);
    t38 = (t37 & t36);
    t55 = (t38 != 0);
    if (t55 > 0)
        goto LAB123;

LAB124:
LAB125:    goto LAB107;

LAB109:    t28 = *((unsigned int *)t52);
    t49 = (t28 + 0);
    t29 = *((unsigned int *)t43);
    t30 = *((unsigned int *)t44);
    t50 = (t29 - t30);
    t51 = (t50 + 1);
    xsi_vlogvar_assign_value(t26, t8, t49, *((unsigned int *)t44), t51);
    goto LAB110;

LAB111:    t13 = *((unsigned int *)t44);
    t49 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t43);
    t50 = (t14 - t18);
    t51 = (t50 + 1);
    xsi_vlogvar_assign_value(t3, t2, t49, *((unsigned int *)t43), t51);
    goto LAB112;

LAB113:    t22 = *((unsigned int *)t52);
    t49 = (t22 + 0);
    t23 = *((unsigned int *)t43);
    t24 = *((unsigned int *)t44);
    t50 = (t23 - t24);
    t51 = (t50 + 1);
    xsi_vlogvar_assign_value(t16, t8, t49, *((unsigned int *)t44), t51);
    goto LAB114;

LAB115:    t13 = *((unsigned int *)t44);
    t49 = (t13 + 0);
    t14 = *((unsigned int *)t8);
    t18 = *((unsigned int *)t43);
    t50 = (t14 - t18);
    t51 = (t50 + 1);
    xsi_vlogvar_assign_value(t3, t2, t49, *((unsigned int *)t43), t51);
    goto LAB116;

LAB117:    *((unsigned int *)t8) = 1;
    goto LAB120;

LAB122:    t27 = *((unsigned int *)t8);
    t28 = *((unsigned int *)t26);
    *((unsigned int *)t8) = (t27 | t28);
    t29 = *((unsigned int *)t17);
    t30 = *((unsigned int *)t26);
    *((unsigned int *)t17) = (t29 | t30);
    goto LAB121;

LAB123:    xsi_set_current_line(265, ng0);

LAB126:    xsi_set_current_line(266, ng0);
    t33 = ((char*)((ng3)));
    t39 = (t0 + 10504);
    xsi_vlogvar_assign_value(t39, t33, 0, 0, 1);
    xsi_set_current_line(267, ng0);
    t2 = (t0 + 1696);
    t3 = *((char **)t2);
    t2 = (t0 + 11624);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 3);
    goto LAB125;

LAB128:    *((unsigned int *)t8) = 1;
    goto LAB131;

LAB132:    *((unsigned int *)t8) = 1;
    goto LAB135;

LAB134:    t9 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t9) = 1;
    goto LAB135;

LAB136:    t16 = (t0 + 3704U);
    t17 = *((char **)t16);
    memset(t43, 0, 8);
    t16 = (t17 + 4);
    t21 = *((unsigned int *)t16);
    t22 = (~(t21));
    t23 = *((unsigned int *)t17);
    t24 = (t23 & t22);
    t25 = (t24 & 1U);
    if (t25 != 0)
        goto LAB139;

LAB140:    if (*((unsigned int *)t16) != 0)
        goto LAB141;

LAB142:    t27 = *((unsigned int *)t8);
    t28 = *((unsigned int *)t43);
    t29 = (t27 & t28);
    *((unsigned int *)t44) = t29;
    t32 = (t8 + 4);
    t33 = (t43 + 4);
    t39 = (t44 + 4);
    t30 = *((unsigned int *)t32);
    t31 = *((unsigned int *)t33);
    t34 = (t30 | t31);
    *((unsigned int *)t39) = t34;
    t35 = *((unsigned int *)t39);
    t36 = (t35 != 0);
    if (t36 == 1)
        goto LAB143;

LAB144:
LAB145:    goto LAB138;

LAB139:    *((unsigned int *)t43) = 1;
    goto LAB142;

LAB141:    t26 = (t43 + 4);
    *((unsigned int *)t43) = 1;
    *((unsigned int *)t26) = 1;
    goto LAB142;

LAB143:    t37 = *((unsigned int *)t44);
    t38 = *((unsigned int *)t39);
    *((unsigned int *)t44) = (t37 | t38);
    t40 = (t8 + 4);
    t54 = (t43 + 4);
    t55 = *((unsigned int *)t8);
    t56 = (~(t55));
    t57 = *((unsigned int *)t40);
    t58 = (~(t57));
    t59 = *((unsigned int *)t43);
    t60 = (~(t59));
    t61 = *((unsigned int *)t54);
    t62 = (~(t61));
    t7 = (t56 & t58);
    t45 = (t60 & t62);
    t63 = (~(t7));
    t64 = (~(t45));
    t65 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t65 & t63);
    t66 = *((unsigned int *)t39);
    *((unsigned int *)t39) = (t66 & t64);
    t67 = *((unsigned int *)t44);
    *((unsigned int *)t44) = (t67 & t63);
    t68 = *((unsigned int *)t44);
    *((unsigned int *)t44) = (t68 & t64);
    goto LAB145;

LAB146:    *((unsigned int *)t8) = 1;
    goto LAB149;

LAB148:    t9 = (t8 + 4);
    *((unsigned int *)t8) = 1;
    *((unsigned int *)t9) = 1;
    goto LAB149;

LAB150:    t16 = (t0 + 10504);
    t17 = (t16 + 56U);
    t26 = *((char **)t17);
    memset(t43, 0, 8);
    t32 = (t26 + 4);
    t21 = *((unsigned int *)t32);
    t22 = (~(t21));
    t23 = *((unsigned int *)t26);
    t24 = (t23 & t22);
    t25 = (t24 & 1U);
    if (t25 != 0)
        goto LAB153;

LAB154:    if (*((unsigned int *)t32) != 0)
        goto LAB155;

LAB156:    t27 = *((unsigned int *)t8);
    t28 = *((unsigned int *)t43);
    t29 = (t27 & t28);
    *((unsigned int *)t44) = t29;
    t39 = (t8 + 4);
    t40 = (t43 + 4);
    t54 = (t44 + 4);
    t30 = *((unsigned int *)t39);
    t31 = *((unsigned int *)t40);
    t34 = (t30 | t31);
    *((unsigned int *)t54) = t34;
    t35 = *((unsigned int *)t54);
    t36 = (t35 != 0);
    if (t36 == 1)
        goto LAB157;

LAB158:
LAB159:    goto LAB152;

LAB153:    *((unsigned int *)t43) = 1;
    goto LAB156;

LAB155:    t33 = (t43 + 4);
    *((unsigned int *)t43) = 1;
    *((unsigned int *)t33) = 1;
    goto LAB156;

LAB157:    t37 = *((unsigned int *)t44);
    t38 = *((unsigned int *)t54);
    *((unsigned int *)t44) = (t37 | t38);
    t69 = (t8 + 4);
    t75 = (t43 + 4);
    t55 = *((unsigned int *)t8);
    t56 = (~(t55));
    t57 = *((unsigned int *)t69);
    t58 = (~(t57));
    t59 = *((unsigned int *)t43);
    t60 = (~(t59));
    t61 = *((unsigned int *)t75);
    t62 = (~(t61));
    t7 = (t56 & t58);
    t45 = (t60 & t62);
    t63 = (~(t7));
    t64 = (~(t45));
    t65 = *((unsigned int *)t54);
    *((unsigned int *)t54) = (t65 & t63);
    t66 = *((unsigned int *)t54);
    *((unsigned int *)t54) = (t66 & t64);
    t67 = *((unsigned int *)t44);
    *((unsigned int *)t44) = (t67 & t63);
    t68 = *((unsigned int *)t44);
    *((unsigned int *)t44) = (t68 & t64);
    goto LAB159;

LAB160:    *((unsigned int *)t52) = 1;
    goto LAB163;

LAB162:    t77 = (t52 + 4);
    *((unsigned int *)t52) = 1;
    *((unsigned int *)t77) = 1;
    goto LAB163;

LAB164:    t82 = (t0 + 3704U);
    t83 = *((char **)t82);
    memset(t53, 0, 8);
    t82 = (t83 + 4);
    t84 = *((unsigned int *)t82);
    t85 = (~(t84));
    t86 = *((unsigned int *)t83);
    t87 = (t86 & t85);
    t88 = (t87 & 1U);
    if (t88 != 0)
        goto LAB167;

LAB168:    if (*((unsigned int *)t82) != 0)
        goto LAB169;

LAB170:    t91 = *((unsigned int *)t52);
    t92 = *((unsigned int *)t53);
    t93 = (t91 & t92);
    *((unsigned int *)t90) = t93;
    t94 = (t52 + 4);
    t95 = (t53 + 4);
    t96 = (t90 + 4);
    t97 = *((unsigned int *)t94);
    t98 = *((unsigned int *)t95);
    t99 = (t97 | t98);
    *((unsigned int *)t96) = t99;
    t100 = *((unsigned int *)t96);
    t101 = (t100 != 0);
    if (t101 == 1)
        goto LAB171;

LAB172:
LAB173:    goto LAB166;

LAB167:    *((unsigned int *)t53) = 1;
    goto LAB170;

LAB169:    t89 = (t53 + 4);
    *((unsigned int *)t53) = 1;
    *((unsigned int *)t89) = 1;
    goto LAB170;

LAB171:    t102 = *((unsigned int *)t90);
    t103 = *((unsigned int *)t96);
    *((unsigned int *)t90) = (t102 | t103);
    t104 = (t52 + 4);
    t105 = (t53 + 4);
    t106 = *((unsigned int *)t52);
    t107 = (~(t106));
    t108 = *((unsigned int *)t104);
    t109 = (~(t108));
    t110 = *((unsigned int *)t53);
    t111 = (~(t110));
    t112 = *((unsigned int *)t105);
    t113 = (~(t112));
    t46 = (t107 & t109);
    t47 = (t111 & t113);
    t114 = (~(t46));
    t115 = (~(t47));
    t116 = *((unsigned int *)t96);
    *((unsigned int *)t96) = (t116 & t114);
    t117 = *((unsigned int *)t96);
    *((unsigned int *)t96) = (t117 & t115);
    t118 = *((unsigned int *)t90);
    *((unsigned int *)t90) = (t118 & t114);
    t119 = *((unsigned int *)t90);
    *((unsigned int *)t90) = (t119 & t115);
    goto LAB173;

LAB174:    xsi_set_current_line(280, ng0);

LAB177:    xsi_set_current_line(281, ng0);
    t126 = (t0 + 1696);
    t127 = *((char **)t126);
    t126 = (t0 + 11624);
    xsi_vlogvar_assign_value(t126, t127, 0, 0, 3);
    goto LAB176;

}

static void Always_287_2(char *t0)
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

LAB0:    t1 = (t0 + 13352U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(287, ng0);
    t2 = (t0 + 14448);
    *((int *)t2) = 1;
    t3 = (t0 + 13384);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(287, ng0);

LAB5:    xsi_set_current_line(288, ng0);
    t5 = (t0 + 3544U);
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

LAB13:    xsi_set_current_line(293, ng0);

LAB16:    xsi_set_current_line(294, ng0);
    t2 = (t0 + 11624);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 11464);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 3, 0LL);
    xsi_set_current_line(295, ng0);
    t2 = (t0 + 10984);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 10664);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 272, 0LL);
    xsi_set_current_line(296, ng0);
    t2 = (t0 + 11144);
    t3 = (t2 + 56U);
    t5 = *((char **)t3);
    t6 = (t0 + 10824);
    xsi_vlogvar_wait_assign_value(t6, t5, 0, 0, 34, 0LL);

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

LAB12:    xsi_set_current_line(288, ng0);

LAB15:    xsi_set_current_line(289, ng0);
    t29 = (t0 + 1696);
    t30 = *((char **)t29);
    t29 = (t0 + 11464);
    xsi_vlogvar_wait_assign_value(t29, t30, 0, 0, 3, 0LL);
    xsi_set_current_line(290, ng0);
    t2 = ((char*)((ng13)));
    t3 = (t0 + 10664);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 272, 0LL);
    xsi_set_current_line(291, ng0);
    t2 = ((char*)((ng14)));
    t3 = (t0 + 10824);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 34, 0LL);
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

LAB0:    t1 = (t0 + 13600U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 3864U);
    t4 = *((char **)t2);
    t2 = (t0 + 4024U);
    t5 = *((char **)t2);
    t2 = (t0 + 4184U);
    t6 = *((char **)t2);
    t2 = (t0 + 4664U);
    t7 = *((char **)t2);
    xsi_vlogtype_concat(t3, 417, 417, 4U, t7, 1, t6, 128, t5, 32, t4, 256);
    t2 = (t0 + 14640);
    t8 = (t2 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    xsi_vlog_bit_copy(t11, 0, t3, 0, 417);
    xsi_driver_vfirst_trans(t2, 0, 416);
    t12 = (t0 + 14464);
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

LAB0:    t1 = (t0 + 13848U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 4344U);
    t3 = *((char **)t2);
    t2 = (t0 + 8984U);
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
LAB12:    t54 = (t0 + 14704);
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
    t67 = (t0 + 14480);
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

LAB0:    t1 = (t0 + 14096U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 3544U);
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
    t21 = (t0 + 14768);
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
    t34 = (t0 + 14496);
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


extern void work_m_01798571310903646371_0133183001_init()
{
	static char *pe[] = {(void *)Cont_188_0,(void *)Always_190_1,(void *)Always_287_2,(void *)implSig1_execute,(void *)implSig2_execute,(void *)implSig3_execute};
	static char *se[] = {(void *)sp_log2};
	xsi_register_didat("work_m_01798571310903646371_0133183001", "isim/nf10_encap_tb.exe.sim/work/m_01798571310903646371_0133183001.didat");
	xsi_register_executes(pe);
	xsi_register_subprogram_executes(se);
}
