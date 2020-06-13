package com.practice.ms.arch.model;

public class Teacher {
    private String studentId;
    private String teacherId;
    private String teacherName;

    public Teacher(String studentId, String teacherId, String teacherName) {
        this.studentId = studentId;
        this.teacherId = teacherId;
        this.teacherName = teacherName;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(String teacherId) {
        this.teacherId = teacherId;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }
}
