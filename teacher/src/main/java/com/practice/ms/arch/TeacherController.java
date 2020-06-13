package com.practice.ms.arch;

import com.practice.ms.arch.model.Teacher;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.List;

@RestController
@RequestMapping("/teachers")
public class TeacherController {

    @RequestMapping("/{courseId}")
    public List<Teacher> getTeachers(@PathVariable("courseId") String courseId) {
        return Arrays.asList(new Teacher(courseId, "201", "Kaushik"),
                                new Teacher(courseId, "202", "Vimal"));
    }
}
