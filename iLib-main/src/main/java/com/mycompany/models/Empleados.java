
package com.mycompany.models;

import java.util.Date;


public class Empleados {
    
    private int ID;
    private String LNAME;
    private String FNAME;
    private String MNAME;
    private Date BIRTH_DATE;
    private String USER_ROLE;
    private String USER_NAME;
    private String USER_PASSWORD;

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getLNAME() {
        return LNAME;
    }

    public void setLNAME(String LNAME) {
        this.LNAME = LNAME;
    }

    public String getFNAME() {
        return FNAME;
    }

    public void setFNAME(String FNAME) {
        this.FNAME = FNAME;
    }

    public String getMNAME() {
        return MNAME;
    }

    public void setMNAME(String MNAME) {
        this.MNAME = MNAME;
    }

    public Date getBIRTH_DATE() {
        return BIRTH_DATE;
    }

    public void setBIRTH_DATE(Date BIRTH_DATE) {
        this.BIRTH_DATE = BIRTH_DATE;
    }

    public String getUSER_ROLE() {
        return USER_ROLE;
    }

    public void setUSER_ROLE(String USER_ROLE) {
        this.USER_ROLE = USER_ROLE;
    }

    public String getUSER_NAME() {
        return USER_NAME;
    }

    public void setUSER_NAME(String USER_NAME) {
        this.USER_NAME = USER_NAME;
    }

    public String getUSER_PASSWORD() {
        return USER_PASSWORD;
    }

    public void setUSER_PASSWORD(String USER_PASSWORD) {
        this.USER_PASSWORD = USER_PASSWORD;
    }
}
