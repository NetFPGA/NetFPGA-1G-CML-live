import java.io.*;
import javax.swing.*; 
import java.awt.*; 
import java.awt.event.*; 
 
public class Encap_Configuration{

       public static void main(String args[]) {    

            MainFrame frame = new MainFrame();
        }
}

class MainFrame extends JFrame {
       
       // GUI compoents
       private JPanel mainPanel = new JPanel();
       private JButton setButton = new JButton("Set!");

       private JPanel ctrlPanel = new JPanel();
       private JLabel encapPortsLabel = new JLabel("Encap Ports:");
       private JTextField encapPortsTextField = new JTextField(20);
       private JLabel encapPortsCurrentValueLabel = new JLabel("Current Value:");
       private JLabel encapPortsRdLabel = new JLabel();
       private JLabel tosLabel = new JLabel("Type of Service:");
       private JTextField tosTextField = new JTextField(20);
       private JLabel tosCurrentValueLabel = new JLabel("Current Value:");
       private JLabel tosRdLabel = new JLabel();
       private JLabel ttlLabel = new JLabel("TTL:");
       private JTextField ttlTextField = new JTextField(20);
       private JLabel ttlCurrentValueLabel = new JLabel("Current Value:");
       private JLabel ttlRdLabel = new JLabel();
       private JLabel protocolLabel = new JLabel("Protocol:");
       private JTextField protocolTextField = new JTextField(20);
       private JLabel protocolCurrentValueLabel = new JLabel("Current Value:");
       private JLabel protocolRdLabel = new JLabel();

       private JPanel[] panels = new JPanel[4];
       private JLabel[] srcIPLabels = new JLabel[4];
       private JTextField[] srcIPTextFields = new JTextField[4];
       private JLabel[] srcIPCurrentValueLabels = new JLabel[4];
       private JLabel[] srcIPRdLabels = new JLabel[4];
       private JLabel[] dstIPLabels = new JLabel[4];
       private JTextField[] dstIPTextFields = new JTextField[4];
       private JLabel[] dstIPCurrentValueLabels = new JLabel[4];
       private JLabel[] dstIPRdLabels = new JLabel[4];
       private JLabel[] srcMACLabels = new JLabel[4];
       private JTextField[] srcMACTextFields = new JTextField[4];
       private JLabel[] srcMACCurrentValueLabels = new JLabel[4];
       private JLabel[] srcMACRdLabels = new JLabel[4];
       private JLabel[] dstMACLabels = new JLabel[4];
       private JTextField[] dstMACTextFields = new JTextField[4];
       private JLabel[] dstMACCurrentValueLabels = new JLabel[4];
       private JLabel[] dstMACRdLabels = new JLabel[4];

       // Internal variables
       private String baseAddress;
       private String hexEncapPorts;
       private String hexToS;
       private String hexTTL;
       private String hexProtocol;
       private String[] hexSrcIPs = new String[4];
       private String[] hexDstIPs = new String[4];
       private String[] hexSrcMACs = new String[4];
       private String[] hexDstMACs = new String[4];
       private String[] checksums = new String[4];

       public MainFrame() {

           setSize(800,600);
           setTitle("Encap_Configuration");
           setLocation(100,100);
           setLayout(new BorderLayout());
           addWindowListener(new Terminator());

           this.add(mainPanel, BorderLayout.CENTER);
           mainPanel.setLayout(new GridLayout(0,1));
           this.add(setButton, BorderLayout.SOUTH);

           setButton.addActionListener(new ActionListener() {

               public void actionPerformed(ActionEvent e) {
                   writeRegisters();
                   readRegisters();
                   displayConfig();
               }
           });

           mainPanel.add(ctrlPanel);
           ctrlPanel.setLayout(new GridLayout(4,4));
           ctrlPanel.setBackground(Color.lightGray);
           ctrlPanel.add(encapPortsLabel);
           ctrlPanel.add(encapPortsTextField);
           ctrlPanel.add(encapPortsCurrentValueLabel);
           ctrlPanel.add(encapPortsRdLabel);
           ctrlPanel.add(tosLabel);
           ctrlPanel.add(tosTextField);
           ctrlPanel.add(tosCurrentValueLabel);
           ctrlPanel.add(tosRdLabel);
           ctrlPanel.add(ttlLabel);
           ctrlPanel.add(ttlTextField);
           ctrlPanel.add(ttlCurrentValueLabel);
           ctrlPanel.add(ttlRdLabel);
           ctrlPanel.add(protocolLabel);
           ctrlPanel.add(protocolTextField);
           ctrlPanel.add(protocolCurrentValueLabel);
           ctrlPanel.add(protocolRdLabel);

           for(int i=0; i < 4; i++) {

               panels[i] = new JPanel();
               mainPanel.add(panels[i]);
               panels[i].setLayout(new GridLayout(4,4));

               if( i%2 == 0 )
                   panels[i].setBackground(Color.GRAY);
               else
                   panels[i].setBackground(Color.lightGray);

               srcIPLabels[i] = new JLabel("Port " + Integer.toString(i) + " Source IP:");
               srcIPTextFields[i] = new JTextField(20);
               srcIPCurrentValueLabels[i] = new JLabel("Current Value:");
               srcIPRdLabels[i] = new JLabel("");
               dstIPLabels[i] = new JLabel("Port " + Integer.toString(i) + " Destination IP:");
               dstIPTextFields[i] = new JTextField(20);
               dstIPCurrentValueLabels[i] = new JLabel("Current Value:");
               dstIPRdLabels[i] = new JLabel("");
               srcMACLabels[i] = new JLabel("Port " + Integer.toString(i) + " Source MAC:");
               srcMACTextFields[i] = new JTextField(20);
               srcMACCurrentValueLabels[i] = new JLabel("Current Value:");
               srcMACRdLabels[i] = new JLabel("");
               dstMACLabels[i] = new JLabel("Port " + Integer.toString(i) + " Destination MAC:");
               dstMACTextFields[i] = new JTextField(20);
               dstMACCurrentValueLabels[i] = new JLabel("Current Value:");
               dstMACRdLabels[i] = new JLabel("");
        
               panels[i].add(srcIPLabels[i]);
               panels[i].add(srcIPTextFields[i]);
               panels[i].add(srcIPCurrentValueLabels[i]);
               panels[i].add(srcIPRdLabels[i]);
               panels[i].add(dstIPLabels[i]);
               panels[i].add(dstIPTextFields[i]);
               panels[i].add(dstIPCurrentValueLabels[i]);
               panels[i].add(dstIPRdLabels[i]);
               panels[i].add(srcMACLabels[i]);
               panels[i].add(srcMACTextFields[i]);
               panels[i].add(srcMACCurrentValueLabels[i]);
               panels[i].add(srcMACRdLabels[i]);
               panels[i].add(dstMACLabels[i]);
               panels[i].add(dstMACTextFields[i]);
               panels[i].add(dstMACCurrentValueLabels[i]);
               panels[i].add(dstMACRdLabels[i]);

           }
           
           readBaseAddress();
           readRegisters();
           displayConfig();
           displayConfigToTextFields();
           writeRegisters();
           readRegisters();
           displayConfig();
           displayConfigToTextFields();
           this.setVisible(true);
           
       }

       private void readBaseAddress(){

           try {
               BufferedReader parameters = new BufferedReader(new FileReader("..//include//xparameters.h"));
               String line;
               while((line = parameters.readLine()) != null) {

                   if(line.lastIndexOf("XPAR_NF10_ENCAP_0_BASEADDR") != -1) {

                       baseAddress = line.substring(line.lastIndexOf("0x"));
                       return;
                   }
               }

               System.out.println("Exited: Cannot find Base Addresses!");
               System.exit(0);
           }
           catch (Exception e) {
               System.out.println("Exited: Cannot open ../include/xparameters.h!");
               System.exit(0);
           }
           
       }

       private void readRegisters() {
           String line1, line2;
           String[] strings;
           line1 = readReg(baseAddress.substring(0, baseAddress.length()-2) + "40");
           strings = splitHex(line1, 4);
           this.hexEncapPorts = strings[3];
           this.hexToS = strings[2];
           this.hexTTL = strings[1];
           this.hexProtocol = strings[0];

           for(int i=0; i < 4; i++) {
               hexSrcIPs[i] = readReg(baseAddress.substring(0, baseAddress.length()-2) + Integer.toString(i) + "0");
               hexDstIPs[i] = readReg(baseAddress.substring(0, baseAddress.length()-2) + Integer.toString(i) + "1");
               line1 = readReg(baseAddress.substring(0, baseAddress.length()-2) + Integer.toString(i) + "2");
               line2 = readReg(baseAddress.substring(0, baseAddress.length()-2) + Integer.toString(i) + "3");
               hexSrcMACs[i] = line2.substring(4) + line1;
               line1 = readReg(baseAddress.substring(0, baseAddress.length()-2) + Integer.toString(i) + "4");
               hexDstMACs[i] = line1 + line2.substring(0, 4);
           }
       }

       private void displayConfig() {
           encapPortsRdLabel.setText(toBinaryOfLength(Integer.toBinaryString(Integer.parseInt(hexEncapPorts,16)), 8));
           tosRdLabel.setText(toBinaryOfLength(Integer.toBinaryString(Integer.parseInt(hexToS,16)), 8));
           ttlRdLabel.setText(Integer.toString(Integer.parseInt(hexTTL, 16)));
           protocolRdLabel.setText(hexProtocol);

           for(int i=0; i < 4; i++) {
               srcIPRdLabels[i].setText(hex2IP(hexSrcIPs[i]));
               dstIPRdLabels[i].setText(hex2IP(hexDstIPs[i]));
               srcMACRdLabels[i].setText(hex2MAC(hexSrcMACs[i]));
               dstMACRdLabels[i].setText(hex2MAC(hexDstMACs[i]));
           }
       }

       private void displayConfigToTextFields() {
           encapPortsTextField.setText(toBinaryOfLength(Integer.toBinaryString(Integer.parseInt(hexEncapPorts,16)), 8));
           tosTextField.setText(toBinaryOfLength(Integer.toBinaryString(Integer.parseInt(hexToS,16)), 8));
           ttlTextField.setText(Integer.toString(Integer.parseInt(hexTTL, 16)));
           protocolTextField.setText(hexProtocol);

           for(int i=0; i < 4; i++) {
               srcIPTextFields[i].setText(hex2IP(hexSrcIPs[i]));
               dstIPTextFields[i].setText(hex2IP(hexDstIPs[i]));
               srcMACTextFields[i].setText(hex2MAC(hexSrcMACs[i]));
               dstMACTextFields[i].setText(hex2MAC(hexDstMACs[i]));
           }
       }

       private void writeRegisters(){
           String s, line1, line2;
           s = encapPortsTextField.getText();
           try {
               hexEncapPorts = toHexOfLength(Integer.toHexString(Integer.parseInt(s, 2)), 2);
           }
           catch(Exception e) {
               encapPortsTextField.setText(encapPortsTextField.getText() + " Illegal Input!");
           }

           s = tosTextField.getText();
           try {
               hexToS = toHexOfLength(Integer.toHexString(Integer.parseInt(s, 2)), 2);
           }
           catch(Exception e) {
               tosTextField.setText(tosTextField.getText() + " Illegal Input!");
           }

           s = ttlTextField.getText();
           try {
               hexTTL = toHexOfLength(Integer.toHexString(Integer.parseInt(s)), 2);
           }
           catch(Exception e) {
               ttlTextField.setText(ttlTextField.getText() + " Illegal Input!");
           }

           s = protocolTextField.getText();
           try {
               hexProtocol = toHexOfLength(Integer.toHexString(Integer.parseInt(s, 16)), 2);
           }
           catch(Exception e) {
               protocolTextField.setText(protocolTextField.getText() + " Illegal Input!");
           }

           writeReg(baseAddress.substring(0, baseAddress.length()-2) + "40", hexEncapPorts + hexToS + hexTTL + hexProtocol);

           for(int i=0; i < 4; i++) {

               line1 = IP2Hex(srcIPTextFields[i].getText());
               if(line1 != null) {
                   hexSrcIPs[i] = line1;
               }
               else {
                   srcIPTextFields[i].setText(srcIPTextFields[i].getText() + " Illegal Input!");
               }

               line1 = IP2Hex(dstIPTextFields[i].getText());
               if(line1 != null) {
                   hexDstIPs[i] = line1;
               }
               else {
                   dstIPTextFields[i].setText(dstIPTextFields[i].getText() + " Illegal Input!");
               }

               line1 = MAC2Hex(srcMACTextFields[i].getText());
               line2 = MAC2Hex(dstMACTextFields[i].getText());
               if(line1 != null) {
                   hexSrcMACs[i] = line1;
               }
               else {
                   srcMACTextFields[i].setText(srcMACTextFields[i].getText() + " Illegal Input!");
               }
               if(line2 != null) {
                   hexDstMACs[i] = line2;
               }
               else {
                   dstMACTextFields[i].setText(dstMACTextFields[i].getText() + " Illegal Input!");
               }

               writeReg(baseAddress.substring(0, baseAddress.length()-2) + Integer.toString(i) + "0", hexSrcIPs[i]);
               writeReg(baseAddress.substring(0, baseAddress.length()-2) + Integer.toString(i) + "1", hexDstIPs[i]);
               writeReg(baseAddress.substring(0, baseAddress.length()-2) + Integer.toString(i) + "2", hexSrcMACs[i].substring(4));
               writeReg(baseAddress.substring(0, baseAddress.length()-2) + Integer.toString(i) + "3", hexDstMACs[i].substring(8) + hexSrcMACs[i].substring(0,4));
               writeReg(baseAddress.substring(0, baseAddress.length()-2) + Integer.toString(i) + "4", hexDstMACs[i].substring(0,8));
           }
           computeChecksum();
           for(int i=0; i < 4; i++) {
               writeReg(baseAddress.substring(0, baseAddress.length()-2) + Integer.toString(i) + "5", checksums[i]);
           }
       }

       private String readReg(String addr) {
           try {
                Runtime rt = Runtime.getRuntime();
                String cmd = "sudo ./rdaxi ";
                Process pr = rt.exec(cmd.concat(addr));
                BufferedReader input = new BufferedReader(new InputStreamReader(pr.getInputStream()));
                String line=null;
 
                while((line=input.readLine()) != null) {
                    if(line.lastIndexOf("AXI") != -1) {

                        return toHexOfLength(line.substring(line.lastIndexOf("0x")), 8);
                    }
                }
 
            } catch(Exception e) {
                System.out.println("Exited: Cannot read register!");
                System.exit(0);
            }
           return null;
       }

       private void writeReg(String addr, String value) {
           try {
                if(!value.startsWith("0x")) {
                    value = "0x" + value;
                }
                Runtime rt = Runtime.getRuntime();
                String cmd = "sudo ./wraxi ";
                Process pr = rt.exec(cmd.concat(addr).concat(" ").concat(value));
            } catch(Exception e) {
                System.out.println("Exited: Cannot write register!");
                System.exit(0);
            }
       }

       private String hex2IP(String hex) {
           String[] strings;
           strings = splitHex(hex, 4);
           String IP = "";
           for(int i=0; i < 4; i++) {
           IP = IP + Integer.toString(Integer.parseInt(strings[i],16)) + ".";
           }
           IP = IP.substring(0, IP.length()-1);
           return IP;
       }

       private String IP2Hex(String IP) {
           String hexIP = "";
           String[] strings = IP.split("\\.");
           try {
               for(int i=0; i < 4; i++) {
                   hexIP = toHexOfLength(Integer.toHexString(Integer.parseInt(strings[i])), 2) + hexIP;

               }
           }
           catch(Exception e) {
               return null;
           }
           return hexIP;
       }

       private String MAC2Hex(String MAC) {
           String hexMAC = "";
           String[] strings = MAC.split(":");
           try {
               for(int i=0; i < 6; i++) {
                   hexMAC = toHexOfLength(Integer.toHexString(Integer.parseInt(strings[i], 16)), 2) + hexMAC;
               }
           }
           catch(Exception e) {
               return null;
           }
           return hexMAC;
       }

       private String hex2MAC(String hex) {
           String[] strings = splitHex(hex, 6);
           String MAC = "";
           for(int i=0; i < 6; i++) {
               MAC = MAC + strings[i] + ":";
           }
           MAC = MAC.substring(0, MAC.length()-1);
           return MAC;
       }

       private String[] splitHex(String hex, int n) {

           if(hex.startsWith("0x")) {
               hex = hex.substring(2);
           }
           int length = hex.length();
           for(int i=0; i<2*n-length; i++) {
               hex = "0" + hex;
           }

           String[] strings = new String[n];
           for(int i=0; i<n; i++) {
               strings[i] = hex.substring(hex.length()-2);
               hex = hex.substring(0, hex.length()-2);
           }
           return strings;
       }

       private String toHexOfLength(String hex, int length) {
           if(hex.startsWith("0x")) {
               hex = hex.substring(2);
           }
           int n = length - hex.length();
           if(n <= 0) {
               return hex.substring(hex.length() - length);
           }
           else {
               for(int i=0; i < n; i++) {
                   hex = "0" + hex;
               }
               return hex;
           }
       }

       private String toBinaryOfLength(String bin, int length) {
           int n = length - bin.length();
           if(n <= 0) {
               return bin.substring(bin.length() - length);
           }
           else {
               for(int i=0; i < n; i++) {
                   bin = "0" + bin;
               }
               return bin;
           }
       }

       private void computeChecksum() {
           String header;
           int sum;
           String hexSum;
           for(int i=0; i < 4; i++){
               header = hexDstIPs[i] + hexSrcIPs[i] + hexProtocol + hexTTL + hexToS + "45";
               sum = 0;
               for(int j=0; j < 6; j++) {
                   sum = sum + Integer.parseInt(header.substring(4*j+2, 4*j+4) + header.substring(4*j+0, 4*j+2), 16);
               }
               hexSum = Integer.toHexString(sum);
               hexSum = "0" + hexSum;
               sum = Integer.parseInt(hexSum.substring(0, hexSum.length()-4), 16) + Integer.parseInt(hexSum.substring(hexSum.length()-4), 16);
               sum = Integer.parseInt("ffff", 16) - sum;
               hexSum = toHexOfLength(Integer.toHexString(sum), 4);
               checksums[i] = hexSum.substring(2) + hexSum.substring(0, 2);
           }
       }

       class Terminator extends WindowAdapter{
           public void windowClosing(WindowEvent e){
               System.exit(0);
           }
       }
}
