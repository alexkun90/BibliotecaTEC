/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */
package com.mycompany.views;

import com.mycompany.ilib.*;
import com.formdev.flatlaf.FlatLightLaf;
import com.formdev.flatlaf.intellijthemes.materialthemeuilite.FlatMaterialLighterIJTheme;
import com.mycompany.views.DashboardAdmin;
import static com.mycompany.views.DashboardAdmin.ShowJPanel;
import java.awt.Color;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.swing.JOptionPane;
import java.awt.BorderLayout;
import java.awt.Insets;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import javax.swing.JPanel;
import javax.swing.UIManager;
import org.netbeans.lib.awtextra.AbsoluteConstraints;

/**
 *
 * @author alexa
 */
public class UserLoginAdmin extends javax.swing.JFrame {

    /**
     * Creates new form UserLogin
     */
    public UserLoginAdmin() {
        initComponents();
        InitStyles();
        // InitContent();

    }

    private void InitStyles() {
        lbl_pass.putClientProperty("FlatLaf.style", "font: 14 $light.font");
        lbl_pass.setForeground(Color.black);

    }

    //private void InitContent() {
      DashboardAdmin venta = new DashboardAdmin();
    //venta.setVisible(true);
    //}
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        lbl_user = new javax.swing.JLabel();
        txt_uname = new javax.swing.JTextField();
        lbl_pass = new javax.swing.JLabel();
        txt_upass = new javax.swing.JPasswordField();
        btn_login = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jPanel1.setBorder(javax.swing.BorderFactory.createTitledBorder("USERLOGIN"));

        lbl_user.setFont(new java.awt.Font("Segoe UI", 0, 18)); // NOI18N
        lbl_user.setText("User");

        txt_uname.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                txt_unameActionPerformed(evt);
            }
        });

        lbl_pass.setFont(new java.awt.Font("Segoe UI", 0, 18)); // NOI18N
        lbl_pass.setText("Password");

        txt_upass.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                txt_upassActionPerformed(evt);
            }
        });

        btn_login.setBackground(new java.awt.Color(246, 233, 206));
        btn_login.setFont(new java.awt.Font("Segoe UI", 2, 18)); // NOI18N
        btn_login.setText("Login");
        btn_login.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btn_loginActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(24, 24, 24)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(lbl_pass)
                    .addComponent(lbl_user, javax.swing.GroupLayout.PREFERRED_SIZE, 37, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(26, 26, 26)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(btn_login, javax.swing.GroupLayout.DEFAULT_SIZE, 212, Short.MAX_VALUE)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(txt_upass, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 212, Short.MAX_VALUE)
                        .addComponent(txt_uname, javax.swing.GroupLayout.Alignment.LEADING)))
                .addContainerGap(52, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(lbl_user)
                    .addComponent(txt_uname, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(35, 35, 35)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(txt_upass, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(lbl_pass))
                .addGap(39, 39, 39)
                .addComponent(btn_login)
                .addContainerGap(59, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        pack();
        setLocationRelativeTo(null);
    }// </editor-fold>//GEN-END:initComponents

    private void txt_unameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_txt_unameActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_txt_unameActionPerformed

    private void txt_upassActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_txt_upassActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_txt_upassActionPerformed

    private void btn_loginActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btn_loginActionPerformed
        String uname = txt_uname.getText();
        char[] upass = txt_upass.getPassword();
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            String url = "jdbc:oracle:thin:@localhost:1521:orcl";
            String username = "C##admin";
            String password = "123";

            Connection conn = DriverManager.getConnection(url, username, password);
            String sqlquery = "SELECT * FROM USERLOGIN WHERE \"USER_NAME\" =? AND \"USER_PASSWORD\" = ?";

            PreparedStatement pst = conn.prepareStatement(sqlquery);
            pst.setString(1, uname);
            pst.setString(2, String.valueOf(upass));
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {

                String tiporol = rs.getString("USER_ROLE");
                if (tiporol.equalsIgnoreCase("Admin")) {
                    dispose();
                    DashboardAdmin adminlog = new DashboardAdmin();
                    adminlog.setDato(txt_uname.getText());
                    adminlog.setVisible(true);
                    JOptionPane.showMessageDialog(null, "Login Successful Admin");

                } else if (tiporol.equalsIgnoreCase("Regular")) {
                    dispose();
                    DashboardAdmin venta = new DashboardAdmin();
                    venta.setDato(txt_uname.getText());
                    venta.setVisible(true);
                    JOptionPane.showMessageDialog(null, "Login Successful");
                }
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, e);
        }    }//GEN-LAST:event_btn_loginActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        FlatMaterialLighterIJTheme.setup();


        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new UserLoginAdmin().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btn_login;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JLabel lbl_pass;
    private javax.swing.JLabel lbl_user;
    private javax.swing.JTextField txt_uname;
    private javax.swing.JPasswordField txt_upass;
    // End of variables declaration//GEN-END:variables
}
