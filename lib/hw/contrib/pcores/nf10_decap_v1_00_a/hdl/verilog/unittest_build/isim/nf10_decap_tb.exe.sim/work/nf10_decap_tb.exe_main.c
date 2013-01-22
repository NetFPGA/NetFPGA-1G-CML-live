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

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_07986287324637435083_0531582123_init();
    work_m_01146174188320170278_2456261162_init();
    work_m_15534165607771245836_3715216071_init();
    work_m_17320466824178783096_3985741992_init();
    work_m_16555195100722982063_1949178628_init();


    xsi_register_tops("work_m_16555195100722982063_1949178628");


    return xsi_run_simulation(argc, argv);

}
