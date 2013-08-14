package org.netfpga.router;
/*
 * MACRxQInternalFrame.java
 *
 * Created on May 7, 2007, 7:57 PM
 */

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.AbstractButton;
import javax.swing.Timer;

import org.netfpga.backend.NFDevice;
import org.netfpga.backend.NFDeviceConsts;

/**
 *
 * @author  jnaous
 */
@SuppressWarnings("serial")
public class MACRxQInternalFrame extends javax.swing.JInternalFrame {


    private int index;
    private StatsRegTableModel statsRegTableModel;
    private ControlRegGroup ctrlRegGrp;

    private static final int STATS_NUM_REGS_USED = 4;

    private ActionListener timerActionListener;
    private Timer timer;

    /** Creates new form MACRxQInternalFrame
     * @param nf2 the device to connect to
     * @param index has to be between 0 and 3 inclusive
     */
    public MACRxQInternalFrame(NFDevice nf2, Timer timer, int index) {
        this.index = index;
        initComponents();

        this.timer = timer;
        setupStatsTable(nf2, index);
        this.statsRegTable.setModel(statsRegTableModel);
        ((StatsRegTable)this.statsRegTable).setDefaults();

        AbstractButton[] buttons = new AbstractButton[32];
        boolean[] invert = new boolean[32];
        for(int i=0; i<32; i++){
            invert[i] = false;
        }

//        /* setup the register hooks for each button */
//        buttons[NFDeviceConsts.MAC_GRP_RESET_MAC_BIT_NUM] = this.resetMacButton;
//        buttons[NFDeviceConsts.MAC_GRP_MAC_DIS_JUMBO_RX_BIT_NUM] = this.enableJumboCheckBox;
//        buttons[NFDeviceConsts.MAC_GRP_MAC_DISABLE_RX_BIT_NUM] = this.enabledCheckbox;
//        invert[NFDeviceConsts.MAC_GRP_MAC_DISABLE_RX_BIT_NUM] = true;
//
//        int indexDif = NFDeviceConsts.MAC_GRP_1_CONTROL_REG - NFDeviceConsts.MAC_GRP_0_CONTROL_REG;
//        ctrlRegGrp = new ControlRegGroup(nf2, NFDeviceConsts.MAC_GRP_0_CONTROL_REG+indexDif*index,
//                                          buttons, invert);
//
//        /* add listeners to the update the tables */
//        timerActionListener = new ActionListener() {
//            public void actionPerformed(ActionEvent e) {
//                statsRegTableModel.updateTable();
//                ctrlRegGrp.updateFromRegs();
//            }
//        };

        /* add action listener to the timer */
        timer.addActionListener(timerActionListener);
    }

    private void setupStatsTable(NFDevice nf2, int index) {
        /* add the addresses to monitor through statsRegTableModel */
//        long[] aAddresses = new long[STATS_NUM_REGS_USED];
//        /* get the difference between two MAC blocks of aAddresses */
//        long indexDif = NFDeviceConsts.MAC_GRP_1_CONTROL_REG - NFDeviceConsts.MAC_GRP_0_CONTROL_REG;
//        aAddresses[0] = NFDeviceConsts.MAC_GRP_0_RX_QUEUE_NUM_PKTS_STORED_REG;
//        aAddresses[1] = NFDeviceConsts.MAC_GRP_0_RX_QUEUE_NUM_BYTES_PUSHED_REG;
//        aAddresses[2] = NFDeviceConsts.MAC_GRP_0_RX_QUEUE_NUM_PKTS_DROPPED_BAD_REG;
//        aAddresses[3] = NFDeviceConsts.MAC_GRP_0_RX_QUEUE_NUM_PKTS_DROPPED_FULL_REG;
//
//        /* add the difference between address blocks */
//        for(int i=0; i<STATS_NUM_REGS_USED; i++){
//            aAddresses[i] += indexDif*index;
//        }
//
//        String[] descriptions = new String[STATS_NUM_REGS_USED];
//        descriptions[0] = "Total packets received";
//        descriptions[1] = "Total bytes received";
//        descriptions[2] = "Total packet drops due to CRC failure";
//        descriptions[3] = "Total packet drops due to input queue overflow";
//
//        /* create the register table model which we want to monitor */
//        statsRegTableModel = new StatsRegTableModel(nf2, aAddresses, descriptions);
//
//        statsRegTableModel.setGraph(0, (GraphPanel)this.pktThroughputPanel);
//        statsRegTableModel.setDifferentialGraph(0, true);
//
//        statsRegTableModel.setGraph(1, (GraphPanel)this.byteThroughputPanel);
//        statsRegTableModel.setDifferentialGraph(1, true);
//        statsRegTableModel.setDivider(1, 1024);
//        statsRegTableModel.setUnits(1, "kB");
//
//        statsRegTableModel.setGraph(2, (GraphPanel)this.pktDropsCRCPanel);
//        statsRegTableModel.setDifferentialGraph(2, true);
//
//        statsRegTableModel.setGraph(3, (GraphPanel)this.pktDropsIQFullPanel);
//        statsRegTableModel.setDifferentialGraph(3, true);
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc=" Generated Code ">//GEN-BEGIN:initComponents
    private void initComponents() {
        MACRxQScrollPane = new javax.swing.JScrollPane();
        MACRxQPanel = new javax.swing.JPanel();
        pageTitleLabel = new javax.swing.JLabel();
        enableJumboCheckBox = new ControlCheckBox();
        resetMacButton = new ControlButton();
        pktThroughputPanel = new BarGraphPanel("Rx Throughput", "Received Packets", "time", "Number of Received Packets", 2000);
        byteThroughputPanel = new BarGraphPanel("Rx Throughput", "Received Bytes", "time", "Number of received bytes (kB)", 2000);
        pktDropsCRCPanel = new BarGraphPanel("CRC Failure Packet Drops", "Packets dropped", "time", "Number of Packets Dropped", 2000);
        pktDropsIQFullPanel = new BarGraphPanel("Full Input Qs Packet Drops", "Packets dropped", "time", "Number of packets dropped", 2000);
        jScrollPane1 = new javax.swing.JScrollPane();
        statsRegTable = new StatsRegTable();
        jSeparator1 = new javax.swing.JSeparator();
        enabledCheckbox = new ControlCheckBox();

        setClosable(true);
        setIconifiable(true);
        setMaximizable(true);
        setResizable(true);
        setTitle("MAC Rx Queue "+this.index);
        setToolTipText("Control and displays information on the MAC Rx queue");
        setVisible(true);
        addInternalFrameListener(new javax.swing.event.InternalFrameListener() {
            public void internalFrameActivated(javax.swing.event.InternalFrameEvent evt) {
            }
            public void internalFrameClosed(javax.swing.event.InternalFrameEvent evt) {
                formInternalFrameClosed(evt);
            }
            public void internalFrameClosing(javax.swing.event.InternalFrameEvent evt) {
            }
            public void internalFrameDeactivated(javax.swing.event.InternalFrameEvent evt) {
            }
            public void internalFrameDeiconified(javax.swing.event.InternalFrameEvent evt) {
            }
            public void internalFrameIconified(javax.swing.event.InternalFrameEvent evt) {
            }
            public void internalFrameOpened(javax.swing.event.InternalFrameEvent evt) {
            }
        });

        pageTitleLabel.setFont(new java.awt.Font("Dialog", 1, 18));
        pageTitleLabel.setText("MAC Rx Queue " + this.index);

        enableJumboCheckBox.setText("Enable Jumbo Frames");
        enableJumboCheckBox.setToolTipText("Check to enable receiving jumbo packets");
        enableJumboCheckBox.setBorder(javax.swing.BorderFactory.createEmptyBorder(0, 0, 0, 0));
        enableJumboCheckBox.setMargin(new java.awt.Insets(0, 0, 0, 0));

        resetMacButton.setText("Reset MAC");
        resetMacButton.setToolTipText("Click to reset the Ethernet MAC Port");

        pktThroughputPanel.setPreferredSize(new java.awt.Dimension(230, 230));
        org.jdesktop.layout.GroupLayout pktThroughputPanelLayout = new org.jdesktop.layout.GroupLayout(pktThroughputPanel);
        pktThroughputPanel.setLayout(pktThroughputPanelLayout);
        pktThroughputPanelLayout.setHorizontalGroup(
            pktThroughputPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(0, 230, Short.MAX_VALUE)
        );
        pktThroughputPanelLayout.setVerticalGroup(
            pktThroughputPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(0, 230, Short.MAX_VALUE)
        );

        byteThroughputPanel.setPreferredSize(new java.awt.Dimension(230, 230));
        org.jdesktop.layout.GroupLayout byteThroughputPanelLayout = new org.jdesktop.layout.GroupLayout(byteThroughputPanel);
        byteThroughputPanel.setLayout(byteThroughputPanelLayout);
        byteThroughputPanelLayout.setHorizontalGroup(
            byteThroughputPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(0, 230, Short.MAX_VALUE)
        );
        byteThroughputPanelLayout.setVerticalGroup(
            byteThroughputPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(0, 230, Short.MAX_VALUE)
        );

        pktDropsCRCPanel.setPreferredSize(new java.awt.Dimension(230, 230));
        org.jdesktop.layout.GroupLayout pktDropsCRCPanelLayout = new org.jdesktop.layout.GroupLayout(pktDropsCRCPanel);
        pktDropsCRCPanel.setLayout(pktDropsCRCPanelLayout);
        pktDropsCRCPanelLayout.setHorizontalGroup(
            pktDropsCRCPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(0, 230, Short.MAX_VALUE)
        );
        pktDropsCRCPanelLayout.setVerticalGroup(
            pktDropsCRCPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(0, 230, Short.MAX_VALUE)
        );

        pktDropsIQFullPanel.setPreferredSize(new java.awt.Dimension(230, 230));
        org.jdesktop.layout.GroupLayout pktDropsIQFullPanelLayout = new org.jdesktop.layout.GroupLayout(pktDropsIQFullPanel);
        pktDropsIQFullPanel.setLayout(pktDropsIQFullPanelLayout);
        pktDropsIQFullPanelLayout.setHorizontalGroup(
            pktDropsIQFullPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(0, 230, Short.MAX_VALUE)
        );
        pktDropsIQFullPanelLayout.setVerticalGroup(
            pktDropsIQFullPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(0, 230, Short.MAX_VALUE)
        );

        jScrollPane1.setBorder(javax.swing.BorderFactory.createBevelBorder(javax.swing.border.BevelBorder.RAISED));
        statsRegTable.setBackground(javax.swing.UIManager.getDefaults().getColor("Label.background"));
        statsRegTable.setFont(new java.awt.Font("Dialog", 1, 12));
        statsRegTable.setGridColor(javax.swing.UIManager.getDefaults().getColor("Label.background"));
        statsRegTable.setRowSelectionAllowed(false);
        statsRegTable.setShowHorizontalLines(false);
        statsRegTable.setShowVerticalLines(false);
        jScrollPane1.setViewportView(statsRegTable);

        enabledCheckbox.setText("Enable");
        enabledCheckbox.setBorder(javax.swing.BorderFactory.createEmptyBorder(0, 0, 0, 0));
        enabledCheckbox.setMargin(new java.awt.Insets(0, 0, 0, 0));

        org.jdesktop.layout.GroupLayout MACRxQPanelLayout = new org.jdesktop.layout.GroupLayout(MACRxQPanel);
        MACRxQPanel.setLayout(MACRxQPanelLayout);
        MACRxQPanelLayout.setHorizontalGroup(
            MACRxQPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(MACRxQPanelLayout.createSequentialGroup()
                .add(10, 10, 10)
                .add(pageTitleLabel))
            .add(org.jdesktop.layout.GroupLayout.TRAILING, MACRxQPanelLayout.createSequentialGroup()
                .addContainerGap()
                .add(enableJumboCheckBox)
                .addContainerGap(326, Short.MAX_VALUE))
            .add(MACRxQPanelLayout.createSequentialGroup()
                .add(10, 10, 10)
                .add(byteThroughputPanel, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .add(10, 10, 10)
                .add(pktThroughputPanel, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .add(10, 10, 10))
            .add(MACRxQPanelLayout.createSequentialGroup()
                .add(10, 10, 10)
                .add(pktDropsIQFullPanel, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .add(10, 10, 10)
                .add(pktDropsCRCPanel, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .add(10, 10, 10))
            .add(jSeparator1, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 490, Short.MAX_VALUE)
            .add(MACRxQPanelLayout.createSequentialGroup()
                .addContainerGap()
                .add(jScrollPane1, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 466, Short.MAX_VALUE)
                .addContainerGap())
            .add(MACRxQPanelLayout.createSequentialGroup()
                .addContainerGap()
                .add(resetMacButton)
                .addContainerGap(377, Short.MAX_VALUE))
            .add(MACRxQPanelLayout.createSequentialGroup()
                .addContainerGap()
                .add(enabledCheckbox)
                .addContainerGap(420, Short.MAX_VALUE))
        );
        MACRxQPanelLayout.setVerticalGroup(
            MACRxQPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(MACRxQPanelLayout.createSequentialGroup()
                .add(10, 10, 10)
                .add(pageTitleLabel)
                .add(8, 8, 8)
                .add(jSeparator1, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 10, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                .add(5, 5, 5)
                .add(enabledCheckbox)
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(enableJumboCheckBox)
                .add(15, 15, 15)
                .add(resetMacButton)
                .add(19, 19, 19)
                .add(jScrollPane1, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 100, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                .add(MACRxQPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                    .add(byteThroughputPanel, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .add(pktThroughputPanel, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .add(10, 10, 10)
                .add(MACRxQPanelLayout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                    .add(pktDropsIQFullPanel, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .add(pktDropsCRCPanel, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .add(26, 26, 26))
        );
        MACRxQScrollPane.setViewportView(MACRxQPanel);

        org.jdesktop.layout.GroupLayout layout = new org.jdesktop.layout.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(MACRxQScrollPane, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 493, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(org.jdesktop.layout.GroupLayout.TRAILING, MACRxQScrollPane, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 733, Short.MAX_VALUE)
        );
        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void formInternalFrameClosed(javax.swing.event.InternalFrameEvent evt) {//GEN-FIRST:event_formInternalFrameClosed
        this.timer.removeActionListener(this.timerActionListener);
    }//GEN-LAST:event_formInternalFrameClosed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel MACRxQPanel;
    private javax.swing.JScrollPane MACRxQScrollPane;
    private javax.swing.JPanel byteThroughputPanel;
    private javax.swing.JCheckBox enableJumboCheckBox;
    private javax.swing.JCheckBox enabledCheckbox;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JSeparator jSeparator1;
    private javax.swing.JLabel pageTitleLabel;
    private javax.swing.JPanel pktDropsCRCPanel;
    private javax.swing.JPanel pktDropsIQFullPanel;
    private javax.swing.JPanel pktThroughputPanel;
    private javax.swing.JButton resetMacButton;
    private javax.swing.JTable statsRegTable;
    // End of variables declaration//GEN-END:variables

}
