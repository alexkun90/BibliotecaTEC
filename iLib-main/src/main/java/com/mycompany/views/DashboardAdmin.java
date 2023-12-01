/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.views;

import com.mycompany.ilib.*;
import com.formdev.flatlaf.FlatLightLaf;
import com.formdev.flatlaf.intellijthemes.materialthemeuilite.FlatMaterialLighterIJTheme;
import com.mycompany.views.*;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Insets;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.UIManager;
import org.netbeans.lib.awtextra.AbsoluteConstraints;

/**
 *
 * @author Antonio
 */
public class DashboardAdmin extends javax.swing.JFrame {

    /**
     * Creates new form Dashboard
     */
    private String dato;

    public DashboardAdmin() {
        initComponents();
        InitStyles();
        SetDate();
        InitContent();
    }

    public void InitStyles() {
        lbl_user.putClientProperty("FlatLaf.style", "font: 35 $light.font");
        lbl_user.setForeground(Color.black);
        navText.putClientProperty("FlatLaf.style", "font: bold $h3.regular.font");
        navText.setForeground(Color.white);
        dateText.putClientProperty("FlatLaf.style", "font: 24 $light.font");
        dateText.setForeground(Color.white);
        appName.putClientProperty("FlatLaf.style", "font: bold $h1.regular.font");
        appName.setForeground(Color.white);
    }

    public void SetDate() {
        LocalDate now = LocalDate.now();
        Locale spanishLocale = new Locale("es", "ES");
        dateText.setText(now.format(DateTimeFormatter.ofPattern("'Hoy es' EEEE dd 'de' MMMM 'de' yyyy", spanishLocale)));
    }

    public void InitContent() {

        ShowJPanel(new Principal());

    }

    public static void ShowJPanel(JPanel p) {
        p.setSize(750, 430);
        p.setLocation(0, 0);

        content.removeAll();
        content.add(p, BorderLayout.CENTER);
        content.revalidate();
        content.repaint();
    }

    public void setDato(String dato) {
        this.dato = dato;
        lbl_user.setText(dato);
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        background = new javax.swing.JPanel();
        menu = new javax.swing.JPanel();
        appName = new javax.swing.JLabel();
        jSeparator1 = new javax.swing.JSeparator();
        btn_prin = new javax.swing.JButton();
        btn_lends = new javax.swing.JButton();
        btn_returns = new javax.swing.JButton();
        btn_exit = new javax.swing.JButton();
        btn_books = new javax.swing.JButton();
        btn_reports = new javax.swing.JButton();
        jButton1 = new javax.swing.JButton();
        btn_users = new javax.swing.JButton();
        btn_adminusers = new javax.swing.JButton();
        header = new javax.swing.JPanel();
        navText = new javax.swing.JLabel();
        dateText = new javax.swing.JLabel();
        content = new javax.swing.JPanel();
        lbl_user = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setMinimumSize(new java.awt.Dimension(1050, 660));

        background.setBackground(new java.awt.Color(255, 255, 255));

        menu.setBackground(new java.awt.Color(204, 153, 0));
        menu.setPreferredSize(new java.awt.Dimension(270, 640));
        menu.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        appName.setFont(new java.awt.Font("Segoe UI Black", 0, 18)); // NOI18N
        appName.setForeground(new java.awt.Color(255, 255, 255));
        appName.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        appName.setText("Libro Tech");
        menu.add(appName, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 52, 250, 34));

        jSeparator1.setPreferredSize(new java.awt.Dimension(50, 5));
        menu.add(jSeparator1, new org.netbeans.lib.awtextra.AbsoluteConstraints(40, 90, 190, 20));

        btn_prin.setBackground(new java.awt.Color(204, 153, 0));
        btn_prin.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        btn_prin.setForeground(new java.awt.Color(255, 255, 255));
        btn_prin.setIcon(new javax.swing.ImageIcon(getClass().getResource("/home-outline.png"))); // NOI18N
        btn_prin.setText("Principal");
        btn_prin.setBorder(javax.swing.BorderFactory.createMatteBorder(1, 13, 1, 1, new java.awt.Color(0, 0, 0)));
        btn_prin.setBorderPainted(false);
        btn_prin.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        btn_prin.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btn_prin.setIconTextGap(13);
        btn_prin.setInheritsPopupMenu(true);
        btn_prin.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btn_prinActionPerformed(evt);
            }
        });
        menu.add(btn_prin, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 130, 270, 52));

        btn_lends.setBackground(new java.awt.Color(204, 153, 0));
        btn_lends.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        btn_lends.setForeground(new java.awt.Color(255, 255, 255));
        btn_lends.setIcon(new javax.swing.ImageIcon(getClass().getResource("/calendar-plus.png"))); // NOI18N
        btn_lends.setText("Préstamos");
        btn_lends.setBorder(javax.swing.BorderFactory.createMatteBorder(1, 13, 1, 1, new java.awt.Color(0, 0, 0)));
        btn_lends.setBorderPainted(false);
        btn_lends.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        btn_lends.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btn_lends.setIconTextGap(13);
        btn_lends.setInheritsPopupMenu(true);
        btn_lends.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btn_lendsActionPerformed(evt);
            }
        });
        menu.add(btn_lends, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 180, 270, 52));

        btn_returns.setBackground(new java.awt.Color(204, 153, 0));
        btn_returns.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        btn_returns.setForeground(new java.awt.Color(255, 255, 255));
        btn_returns.setIcon(new javax.swing.ImageIcon(getClass().getResource("/calendar-multiple-check.png"))); // NOI18N
        btn_returns.setText("Devoluciones");
        btn_returns.setBorder(javax.swing.BorderFactory.createMatteBorder(1, 13, 1, 1, new java.awt.Color(0, 0, 0)));
        btn_returns.setBorderPainted(false);
        btn_returns.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        btn_returns.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btn_returns.setIconTextGap(13);
        btn_returns.setInheritsPopupMenu(true);
        btn_returns.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btn_returnsActionPerformed(evt);
            }
        });
        menu.add(btn_returns, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 230, 270, 52));

        btn_exit.setBackground(new java.awt.Color(204, 153, 0));
        btn_exit.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        btn_exit.setForeground(new java.awt.Color(255, 255, 255));
        btn_exit.setText("Cerrar Sesion");
        btn_exit.setBorder(javax.swing.BorderFactory.createMatteBorder(1, 13, 1, 1, new java.awt.Color(0, 0, 0)));
        btn_exit.setBorderPainted(false);
        btn_exit.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        btn_exit.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btn_exit.setIconTextGap(13);
        btn_exit.setInheritsPopupMenu(true);
        btn_exit.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btn_exitActionPerformed(evt);
            }
        });
        menu.add(btn_exit, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 530, 270, 52));

        btn_books.setBackground(new java.awt.Color(204, 153, 0));
        btn_books.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        btn_books.setForeground(new java.awt.Color(255, 255, 255));
        btn_books.setIcon(new javax.swing.ImageIcon(getClass().getResource("/book-open-page-variant.png"))); // NOI18N
        btn_books.setText("Libros");
        btn_books.setBorder(javax.swing.BorderFactory.createMatteBorder(1, 13, 1, 1, new java.awt.Color(0, 0, 0)));
        btn_books.setBorderPainted(false);
        btn_books.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        btn_books.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btn_books.setIconTextGap(13);
        btn_books.setInheritsPopupMenu(true);
        btn_books.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btn_booksActionPerformed(evt);
            }
        });
        menu.add(btn_books, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 330, 270, 52));

        btn_reports.setBackground(new java.awt.Color(204, 153, 0));
        btn_reports.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        btn_reports.setForeground(new java.awt.Color(255, 255, 255));
        btn_reports.setIcon(new javax.swing.ImageIcon(getClass().getResource("/file-chart.png"))); // NOI18N
        btn_reports.setText("Reportes");
        btn_reports.setBorder(javax.swing.BorderFactory.createMatteBorder(1, 13, 1, 1, new java.awt.Color(0, 0, 0)));
        btn_reports.setBorderPainted(false);
        btn_reports.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        btn_reports.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btn_reports.setIconTextGap(13);
        btn_reports.setInheritsPopupMenu(true);
        btn_reports.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btn_reportsActionPerformed(evt);
            }
        });
        menu.add(btn_reports, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 380, 270, 52));

        jButton1.setBackground(new java.awt.Color(204, 153, 0));
        jButton1.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jButton1.setForeground(new java.awt.Color(255, 255, 255));
        jButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/file-chart.png"))); // NOI18N
        jButton1.setText("Multas");
        jButton1.setBorder(javax.swing.BorderFactory.createMatteBorder(1, 13, 1, 1, new java.awt.Color(0, 0, 0)));
        jButton1.setBorderPainted(false);
        jButton1.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jButton1.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        jButton1.setIconTextGap(13);
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });
        menu.add(jButton1, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 430, 270, 50));

        btn_users.setBackground(new java.awt.Color(204, 153, 0));
        btn_users.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        btn_users.setForeground(new java.awt.Color(255, 255, 255));
        btn_users.setIcon(new javax.swing.ImageIcon(getClass().getResource("/account-multiple.png"))); // NOI18N
        btn_users.setText("Usuarios");
        btn_users.setBorder(javax.swing.BorderFactory.createMatteBorder(1, 13, 1, 1, new java.awt.Color(0, 0, 0)));
        btn_users.setBorderPainted(false);
        btn_users.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        btn_users.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btn_users.setIconTextGap(13);
        btn_users.setInheritsPopupMenu(true);
        btn_users.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btn_usersActionPerformed(evt);
            }
        });
        menu.add(btn_users, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 280, 270, 52));

        btn_adminusers.setBackground(new java.awt.Color(204, 153, 0));
        btn_adminusers.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        btn_adminusers.setForeground(new java.awt.Color(255, 255, 255));
        btn_adminusers.setIcon(new javax.swing.ImageIcon(getClass().getResource("/account-multiple.png"))); // NOI18N
        btn_adminusers.setText("Admin Control");
        btn_adminusers.setBorder(javax.swing.BorderFactory.createMatteBorder(1, 13, 1, 1, new java.awt.Color(0, 0, 0)));
        btn_adminusers.setBorderPainted(false);
        btn_adminusers.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        btn_adminusers.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btn_adminusers.setIconTextGap(13);
        btn_adminusers.setInheritsPopupMenu(true);
        btn_adminusers.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btn_adminusersActionPerformed(evt);
            }
        });
        menu.add(btn_adminusers, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 480, 270, 52));

        header.setBackground(new java.awt.Color(204, 153, 0));
        header.setPreferredSize(new java.awt.Dimension(744, 150));

        navText.setText("Administración/Control/Biblioteca");

        dateText.setText("Hoy es {dayname} {day} de {month} de {year}");

        javax.swing.GroupLayout headerLayout = new javax.swing.GroupLayout(header);
        header.setLayout(headerLayout);
        headerLayout.setHorizontalGroup(
            headerLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(headerLayout.createSequentialGroup()
                .addGap(66, 66, 66)
                .addGroup(headerLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(navText, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(dateText, javax.swing.GroupLayout.DEFAULT_SIZE, 434, Short.MAX_VALUE))
                .addContainerGap(260, Short.MAX_VALUE))
        );
        headerLayout.setVerticalGroup(
            headerLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(headerLayout.createSequentialGroup()
                .addGap(33, 33, 33)
                .addComponent(navText, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(dateText, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(30, Short.MAX_VALUE))
        );

        content.setBackground(new java.awt.Color(255, 255, 255));
        content.setLayout(new java.awt.BorderLayout());

        lbl_user.setFont(new java.awt.Font("Segoe UI", 2, 14)); // NOI18N

        javax.swing.GroupLayout backgroundLayout = new javax.swing.GroupLayout(background);
        background.setLayout(backgroundLayout);
        backgroundLayout.setHorizontalGroup(
            backgroundLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(backgroundLayout.createSequentialGroup()
                .addComponent(menu, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGroup(backgroundLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(header, javax.swing.GroupLayout.DEFAULT_SIZE, 760, Short.MAX_VALUE)
                    .addComponent(content, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(backgroundLayout.createSequentialGroup()
                        .addGap(18, 18, 18)
                        .addComponent(lbl_user, javax.swing.GroupLayout.PREFERRED_SIZE, 156, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addContainerGap())))
        );
        backgroundLayout.setVerticalGroup(
            backgroundLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(menu, javax.swing.GroupLayout.DEFAULT_SIZE, 716, Short.MAX_VALUE)
            .addGroup(backgroundLayout.createSequentialGroup()
                .addGap(15, 15, 15)
                .addComponent(lbl_user, javax.swing.GroupLayout.PREFERRED_SIZE, 26, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(header, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, 0)
                .addComponent(content, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(1, 1, 1))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(background, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(background, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        pack();
        setLocationRelativeTo(null);
    }// </editor-fold>//GEN-END:initComponents

    private void btn_prinActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btn_prinActionPerformed
        ShowJPanel(new Principal());
    }//GEN-LAST:event_btn_prinActionPerformed

    private void btn_lendsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btn_lendsActionPerformed
        ShowJPanel(new Lendings());
    }//GEN-LAST:event_btn_lendsActionPerformed

    private void btn_returnsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btn_returnsActionPerformed
        ShowJPanel(new Returns());
    }//GEN-LAST:event_btn_returnsActionPerformed

    private void btn_exitActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btn_exitActionPerformed
        dispose();
        UserLogin loginviews = new UserLogin();
        loginviews.setVisible(true);
        JOptionPane.showMessageDialog(null, "Sesion Cerrada");
    }//GEN-LAST:event_btn_exitActionPerformed

    private void btn_booksActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btn_booksActionPerformed
        ShowJPanel(new Books());
    }//GEN-LAST:event_btn_booksActionPerformed

    private void btn_reportsActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btn_reportsActionPerformed
        ShowJPanel(new Reports());
    }//GEN-LAST:event_btn_reportsActionPerformed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        ShowJPanel(new Multas());
    }//GEN-LAST:event_jButton1ActionPerformed

    private void btn_usersActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btn_usersActionPerformed
        ShowJPanel(new Users());
    }//GEN-LAST:event_btn_usersActionPerformed

    private void btn_adminusersActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btn_adminusersActionPerformed
        ShowJPanel(new UpEmple());
    }//GEN-LAST:event_btn_adminusersActionPerformed

    /**
     * @param args the command line arguments
     */

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel appName;
    private javax.swing.JPanel background;
    private javax.swing.JButton btn_adminusers;
    private javax.swing.JButton btn_books;
    private javax.swing.JButton btn_exit;
    private javax.swing.JButton btn_lends;
    private javax.swing.JButton btn_prin;
    private javax.swing.JButton btn_reports;
    private javax.swing.JButton btn_returns;
    private javax.swing.JButton btn_users;
    private static javax.swing.JPanel content;
    private javax.swing.JLabel dateText;
    private javax.swing.JPanel header;
    private javax.swing.JButton jButton1;
    private javax.swing.JSeparator jSeparator1;
    private javax.swing.JLabel lbl_user;
    private javax.swing.JPanel menu;
    private javax.swing.JLabel navText;
    // End of variables declaration//GEN-END:variables
}
