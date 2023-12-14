package com.mycompany.views;

import com.mycompany.ilib.DAOUsersImpl;
import com.mycompany.interfaces.DAOUsers;
import java.awt.Color;

public class UpUsersAdmin extends javax.swing.JPanel {

    boolean isEdition = false;
    com.mycompany.models.Users userEdition;

    public UpUsersAdmin() {
        initComponents();
        InitStyles();
    }

    public UpUsersAdmin(com.mycompany.models.Users user) {
        initComponents();
        isEdition = true;
        userEdition = user;
        InitStyles();
    }

    private void InitStyles() {
        title.putClientProperty("FlatLaf.styleClass", "h1");
        title.setForeground(Color.black);
        nameTxt.putClientProperty("JTextField.placeholderText", "Ingrese el nombre del usuario.");
        apPTxt.putClientProperty("JTextField.placeholderText", "Ingrese el apellido paterno del usuario.");
        apMTxt.putClientProperty("JTextField.placeholderText", "Ingrese el apellido materno del usuario.");
        domTxt.putClientProperty("JTextField.placeholderText", "Ingrese el domicilio del usuario.");
        phoneTxt.putClientProperty("JTextField.placeholderText", "Ingrese el teléfono del usuario.");

        if (isEdition) {
            title.setText("Editar Usuario");
            button.setText("Guardar");

            if (userEdition != null) {
                nameTxt.setText(userEdition.getName());
                apPTxt.setText(userEdition.getLast_name_p());
                apMTxt.setText(userEdition.getLast_name_m());
                domTxt.setText(userEdition.getDomicilio());
                phoneTxt.setText(userEdition.getTel());
            }
        }
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        bg = new javax.swing.JPanel();
        title = new javax.swing.JLabel();
        nameLbl = new javax.swing.JLabel();
        nameTxt = new javax.swing.JTextField();
        apPLbl = new javax.swing.JLabel();
        apPTxt = new javax.swing.JTextField();
        apMLbl = new javax.swing.JLabel();
        apMTxt = new javax.swing.JTextField();
        jSeparator1 = new javax.swing.JSeparator();
        domLbl = new javax.swing.JLabel();
        domTxt = new javax.swing.JTextField();
        button = new javax.swing.JButton();
        phoneLbl = new javax.swing.JLabel();
        phoneTxt = new javax.swing.JTextField();

        setBackground(new java.awt.Color(255, 255, 255));

        bg.setBackground(new java.awt.Color(255, 255, 255));

        title.setText("Registrar nuevo Usuario");

        nameLbl.setText("Nombre");

        apPLbl.setText("Apellido Paterno");

        apMLbl.setText("Apellido Materno");

        jSeparator1.setForeground(new java.awt.Color(204, 204, 204));
        jSeparator1.setOrientation(javax.swing.SwingConstants.VERTICAL);
        jSeparator1.setPreferredSize(new java.awt.Dimension(200, 10));

        domLbl.setText("Domicilio");

        domTxt.setToolTipText("");

        button.setBackground(new java.awt.Color(204, 153, 0));
        button.setFont(new java.awt.Font("Segoe UI", 1, 18)); // NOI18N
        button.setForeground(new java.awt.Color(255, 255, 255));
        button.setText("Registrar");
        button.setBorderPainted(false);
        button.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        button.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                buttonActionPerformed(evt);
            }
        });

        phoneLbl.setText("Teléfono");

        phoneTxt.setToolTipText("");

        javax.swing.GroupLayout bgLayout = new javax.swing.GroupLayout(bg);
        bg.setLayout(bgLayout);
        bgLayout.setHorizontalGroup(
            bgLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(bgLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(bgLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(bgLayout.createSequentialGroup()
                        .addGroup(bgLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(bgLayout.createSequentialGroup()
                                .addComponent(nameLbl, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addGap(223, 223, 223))
                            .addComponent(nameTxt)
                            .addGroup(bgLayout.createSequentialGroup()
                                .addComponent(apPLbl, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addGap(182, 182, 182))
                            .addComponent(apPTxt)
                            .addGroup(bgLayout.createSequentialGroup()
                                .addComponent(apMLbl, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addGap(180, 180, 180))
                            .addComponent(apMTxt))
                        .addGap(68, 68, 68)
                        .addComponent(jSeparator1, javax.swing.GroupLayout.PREFERRED_SIZE, 10, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(70, 70, 70)
                        .addGroup(bgLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(domTxt)
                            .addGroup(bgLayout.createSequentialGroup()
                                .addComponent(domLbl, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addGap(220, 220, 220))
                            .addComponent(phoneTxt)
                            .addGroup(bgLayout.createSequentialGroup()
                                .addComponent(phoneLbl, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addGap(218, 218, 218))
                            .addComponent(button, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addGap(72, 72, 72))
                    .addGroup(bgLayout.createSequentialGroup()
                        .addComponent(title, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGap(553, 553, 553))))
        );
        bgLayout.setVerticalGroup(
            bgLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(bgLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(title, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(bgLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(bgLayout.createSequentialGroup()
                        .addGroup(bgLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(bgLayout.createSequentialGroup()
                                .addComponent(nameLbl, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(nameTxt, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(18, 18, 18)
                                .addComponent(apPLbl, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(apPTxt, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(18, 18, 18)
                                .addComponent(apMLbl, javax.swing.GroupLayout.DEFAULT_SIZE, 17, Short.MAX_VALUE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(apMTxt, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(6, 6, 6))
                            .addGroup(bgLayout.createSequentialGroup()
                                .addComponent(domLbl, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(domTxt, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(18, 18, 18)
                                .addComponent(phoneLbl, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(phoneTxt, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(34, 34, 34)
                                .addComponent(button, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(164, 164, 164))
                    .addGroup(bgLayout.createSequentialGroup()
                        .addComponent(jSeparator1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGap(26, 26, 26))))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(bg, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(bg, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents

    private void buttonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_buttonActionPerformed
        String nombre = nameTxt.getText();
        String apP = apPTxt.getText();
        String apM = apMTxt.getText();
        String dom = domTxt.getText();
        String tel = phoneTxt.getText();

        // Validaciones para los campos
        if (nombre.isEmpty() || apP.isEmpty() || apM.isEmpty() || dom.isEmpty() || tel.isEmpty()) {
            javax.swing.JOptionPane.showMessageDialog(this, "Debe llenar todos los campos. \n", "AVISO", javax.swing.JOptionPane.ERROR_MESSAGE);
            nameTxt.requestFocus();
            return;
        }

        com.mycompany.models.Users user = isEdition ? userEdition : new com.mycompany.models.Users();
        user.setName(nombre);
        user.setLast_name_p(apP);
        user.setLast_name_m(apM);
        user.setDomicilio(dom);
        user.setTel(tel);

        try {
            DAOUsers dao = new DAOUsersImpl();

            if (!isEdition) {
                dao.registrar(user);
            } else {
                dao.modificar(user);
            }

            String successMsg = isEdition ? "modificado" : "registrado";

            javax.swing.JOptionPane.showMessageDialog(this, "Usuario " + successMsg + " exitosamente.\n", "AVISO", javax.swing.JOptionPane.INFORMATION_MESSAGE);

            if (!isEdition) {
                nameTxt.setText("");
                apPTxt.setText("");
                apMTxt.setText("");
                domTxt.setText("");
                phoneTxt.setText("");
            }
        } catch (Exception e) {
            String errorMsg = isEdition ? "modificar" : "registrar";
            javax.swing.JOptionPane.showMessageDialog(this, "Ocurrió un error al " + errorMsg + " el usuario. \n", "AVISO", javax.swing.JOptionPane.ERROR_MESSAGE);
            System.out.println(e.getMessage());
        }
    }//GEN-LAST:event_buttonActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel apMLbl;
    private javax.swing.JTextField apMTxt;
    private javax.swing.JLabel apPLbl;
    private javax.swing.JTextField apPTxt;
    private javax.swing.JPanel bg;
    private javax.swing.JButton button;
    private javax.swing.JLabel domLbl;
    private javax.swing.JTextField domTxt;
    private javax.swing.JSeparator jSeparator1;
    private javax.swing.JLabel nameLbl;
    private javax.swing.JTextField nameTxt;
    private javax.swing.JLabel phoneLbl;
    private javax.swing.JTextField phoneTxt;
    private javax.swing.JLabel title;
    // End of variables declaration//GEN-END:variables
}